;; Fractional Music Royalties NFT Contract
;; Enables artists to tokenize their music royalties into fractional NFTs

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_SONG_NOT_FOUND (err u101))
(define-constant ERR_INVALID_PERCENTAGE (err u102))
(define-constant ERR_SONG_ALREADY_EXISTS (err u103))
(define-constant ERR_INSUFFICIENT_SHARES (err u104))
(define-constant ERR_TOKEN_NOT_FOUND (err u105))

;; Data Variables
(define-data-var next-song-id uint u1)
(define-data-var next-token-id uint u1)

;; Data Maps
(define-map songs
  { song-id: uint }
  {
    artist: principal,
    title: (string-ascii 100),
    total-shares: uint,
    shares-minted: uint,
    share-percentage: uint, ;; percentage per share (in basis points, e.g., 10 = 0.1%)
    created-at: uint
  }
)

(define-map royalty-tokens
  { token-id: uint }
  {
    song-id: uint,
    owner: principal,
    shares: uint
  }
)

(define-map token-ownership
  { owner: principal, song-id: uint }
  { total-shares: uint }
)

;; Read-only functions
(define-read-only (get-song (song-id uint))
  (map-get? songs { song-id: song-id })
)

(define-read-only (get-token (token-id uint))
  (map-get? royalty-tokens { token-id: token-id })
)

(define-read-only (get-user-shares (owner principal) (song-id uint))
  (default-to 
    { total-shares: u0 }
    (map-get? token-ownership { owner: owner, song-id: song-id })
  )
)

(define-read-only (get-next-song-id)
  (var-get next-song-id)
)

(define-read-only (get-next-token-id)
  (var-get next-token-id)
)

;; Public functions

;; Register a new song for fractional ownership
(define-public (register-song (title (string-ascii 100)) (total-shares uint) (share-percentage uint))
  (let
    (
      (song-id (var-get next-song-id))
    )
    ;; Validate inputs
    (asserts! (> total-shares u0) ERR_INVALID_PERCENTAGE)
    (asserts! (and (> share-percentage u0) (<= (* total-shares share-percentage) u10000)) ERR_INVALID_PERCENTAGE)
    
    ;; Create song entry
    (map-set songs
      { song-id: song-id }
      {
        artist: tx-sender,
        title: title,
        total-shares: total-shares,
        shares-minted: u0,
        share-percentage: share-percentage,
        created-at: stacks-block-height
      }
    )
    
    ;; Increment song ID
    (var-set next-song-id (+ song-id u1))
    
    (ok song-id)
  )
)

;; Mint fractional NFTs for a song
(define-public (mint-royalty-shares (song-id uint) (recipient principal) (shares uint))
  (let
    (
      (song-data (unwrap! (get-song song-id) ERR_SONG_NOT_FOUND))
      (token-id (var-get next-token-id))
      (current-shares-minted (get shares-minted song-data))
      (total-shares (get total-shares song-data))
    )
    ;; Only artist can mint shares
    (asserts! (is-eq tx-sender (get artist song-data)) ERR_NOT_AUTHORIZED)
    
    ;; Check if enough shares available
    (asserts! (<= (+ current-shares-minted shares) total-shares) ERR_INSUFFICIENT_SHARES)
    
    ;; Create token
    (map-set royalty-tokens
      { token-id: token-id }
      {
        song-id: song-id,
        owner: recipient,
        shares: shares
      }
    )
    
    ;; Update user's total shares for this song
    (let
      (
        (current-user-shares (get total-shares (get-user-shares recipient song-id)))
      )
      (map-set token-ownership
        { owner: recipient, song-id: song-id }
        { total-shares: (+ current-user-shares shares) }
      )
    )
    
    ;; Update song's minted shares
    (map-set songs
      { song-id: song-id }
      (merge song-data { shares-minted: (+ current-shares-minted shares) })
    )
    
    ;; Increment token ID
    (var-set next-token-id (+ token-id u1))
    
    (ok token-id)
  )
)

;; Transfer royalty shares between users
(define-public (transfer-shares (token-id uint) (new-owner principal))
  (let
    (
      (token-data (unwrap! (get-token token-id) ERR_TOKEN_NOT_FOUND))
      (current-owner (get owner token-data))
      (song-id (get song-id token-data))
      (shares (get shares token-data))
    )
    ;; Only current owner can transfer
    (asserts! (is-eq tx-sender current-owner) ERR_NOT_AUTHORIZED)
    
    ;; Update token ownership
    (map-set royalty-tokens
      { token-id: token-id }
      (merge token-data { owner: new-owner })
    )
    
    ;; Update old owner's shares
    (let
      (
        (old-owner-shares (get total-shares (get-user-shares current-owner song-id)))
      )
      (map-set token-ownership
        { owner: current-owner, song-id: song-id }
        { total-shares: (- old-owner-shares shares) }
      )
    )
    
    ;; Update new owner's shares
    (let
      (
        (new-owner-shares (get total-shares (get-user-shares new-owner song-id)))
      )
      (map-set token-ownership
        { owner: new-owner, song-id: song-id }
        { total-shares: (+ new-owner-shares shares) }
      )
    )
    
    (ok true)
  )
)

;; Get ownership percentage for a user in a specific song
(define-read-only (get-ownership-percentage (owner principal) (song-id uint))
  (let
    (
      (song-data (unwrap! (get-song song-id) ERR_SONG_NOT_FOUND))
      (user-shares (get total-shares (get-user-shares owner song-id)))
      (total-shares (get total-shares song-data))
      (share-percentage (get share-percentage song-data))
    )
    (ok (* user-shares share-percentage))
  )
)
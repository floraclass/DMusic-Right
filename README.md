# Decentralized Music Rights Marketplace

A blockchain-based platform built on Stacks that revolutionizes how music royalties are managed, distributed, and traded through fractional NFT ownership and smart contract automation.

## 🎵 Project Overview

The music industry has long struggled with opaque royalty distribution, delayed payments, and complex rights management. Our decentralized marketplace solves these problems by tokenizing music royalties into fractional NFTs, enabling transparent revenue sharing and creating new investment opportunities for fans and investors.

## 🚀 Core Features

### 1. Fractional Ownership ✅ **(Currently Implemented)**
- Artists can mint up to 1000 NFTs per song, each representing a percentage of future streaming royalties
- Flexible share distribution (e.g., 1000 NFTs × 0.1% = 100% of royalties)
- Transparent ownership tracking on the blockchain
- Immediate proof of ownership and revenue rights

### 2. Oracle Integration **(Coming Soon)**
- Trusted oracle system for submitting periodic revenue reports
- Integration with major streaming platforms (Spotify, Apple Music, etc.)
- Automated revenue data validation and processing
- Multi-source revenue aggregation

### 3. Automatic Distribution **(Coming Soon)**
- Smart contract holds revenue in STX or stablecoins
- NFT holders can claim their proportional share at any time
- Gas-efficient batch distribution mechanisms
- Real-time revenue tracking and analytics

### 4. Secondary Market **(Coming Soon)**
- Full marketplace for trading royalty NFTs
- Automatic rights transfer upon sale
- Price discovery mechanisms
- Liquidity pools for fractional shares

## 🛠 Technical Architecture

### Smart Contracts (Clarity)
- **Fractional Music Royalties Contract**: Core NFT minting and ownership management
- **Oracle Integration Contract**: Revenue data ingestion and validation
- **Distribution Contract**: Automated royalty payments
- **Marketplace Contract**: Secondary trading functionality

### Technology Stack
- **Blockchain**: Stacks (Bitcoin-secured smart contracts)
- **Smart Contract Language**: Clarity
- **Development Framework**: Clarinet
- **Frontend**: Next.js + TypeScript
- **Wallet Integration**: Stacks.js
- **Testing**: Clarinet Test Framework

## 📋 Current Implementation Status

### ✅ Phase 1: Fractional Ownership (COMPLETE)
- [x] Song registration system
- [x] Fractional NFT minting (up to 1000 shares per song)
- [x] Ownership percentage calculation
- [x] Share transfer functionality
- [x] Comprehensive test suite

### 🔄 Phase 2: Oracle Integration (IN PROGRESS)
- [ ] Oracle contract development
- [ ] Revenue data schema design
- [ ] Streaming platform API integrations
- [ ] Data validation mechanisms

### 📅 Phase 3: Automatic Distribution (PLANNED)
- [ ] Revenue holding and escrow system
- [ ] Claim functionality for NFT holders
- [ ] Batch distribution optimization
- [ ] Analytics dashboard

### 📅 Phase 4: Secondary Market (PLANNED)
- [ ] NFT marketplace interface
- [ ] Trading mechanisms
- [ ] Price discovery tools
- [ ] Liquidity features

## 🏗 Getting Started

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) installed
- [Node.js](https://nodejs.org/) v16 or higher
- [Stacks Wallet](https://wallet.hiro.so/) for testing

### Installation

1. Clone the repository:
\`\`\`bash
git clone https://github.com/your-org/music-royalty-marketplace
cd music-royalty-marketplace
\`\`\`

2. Install dependencies:
\`\`\`bash
npm install
\`\`\`

3. Run tests:
\`\`\`bash
clarinet test
\`\`\`

4. Start local development:
\`\`\`bash
clarinet integrate
\`\`\`

## 📖 Smart Contract Usage

### Registering a Song
```clarity
;; Register a new song with 1000 fractional shares at 0.1% each
(contract-call? .fractional-music-royalties register-song 
  "My Amazing Song" 
  u1000  ;; total shares
  u10    ;; 0.1% per share (10 basis points)
)

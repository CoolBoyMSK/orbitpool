# OrbitPool

OrbitPool is a lightweight AMM protocol for ERC20/WETH swaps.
It uses a constant-product market making model (`x * y = k`) and mints LP tokens to liquidity providers.

## Highlights

- Permissionless pool creation for ERC20/WETH pairs
- Constant-product pricing with swap fees
- LP token mint/burn flow for liquidity providers
- On-chain quoting helpers for exact-input and exact-output swaps
- Factory-level pool registry with index-based discovery

## Contracts

- `src/OrbitPoolFactory.sol`
  - Creates and tracks pool instances
  - Supports token->pool lookup and indexed pool discovery
- `src/OrbitPool.sol`
  - Handles liquidity operations and swaps
  - Exposes reserve + quote helper views

## Quick Start

### Requirements

- [Foundry](https://getfoundry.sh/)
- Git

### Install & Build

```bash
git clone https://github.com/<your-username>/orbitpool.git
cd orbitpool
make
```

### Run Tests

```bash
forge test
```

### Coverage

```bash
forge coverage
```

## Notes

- Target compiler: `solc 0.8.20`
- This is a research/learning AMM implementation and should be independently audited before production use.

# OrbitPool - Security Review Profile

## Basic Information

| Field | Value |
| --- | --- |
| Protocol Name | OrbitPool |
| Documentation | [README.md](./README.md) |
| Website | N/A |
| Primary Contact | N/A |

## Contract Scope

```
src/OrbitPoolFactory.sol
src/OrbitPool.sol
```

## Design Summary

- OrbitPool is an ERC20/WETH AMM using a constant-product model.
- New pools are deployed from `OrbitPoolFactory`.
- Each deployed `OrbitPool` is also an LP token (ERC20) representing liquidity shares.
- Pricing uses fee-adjusted input/output quote formulas and supports exact-input and exact-output swaps.

## Assumptions

- Pools are expected to interact with standard ERC20 tokens.
- The protocol currently has no admin-only controls in core swap/liquidity paths.
- External oracle dependencies are not required for core functionality.

## Known Issues

- No known critical issues documented in this file.

## Security Process (To Complete Before Mainnet)

- Independent audit
- Invariant and differential testing expansion
- Monitoring and incident response runbook
- Bug bounty program setup

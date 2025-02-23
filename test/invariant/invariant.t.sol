// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { Test } from "forge-std/Test.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";
import { ERC20Mock } from "../invariant/mocks/erc20.sol";
import { OrbitPoolFactory } from "../../src/OrbitPoolFactory.sol";
import { OrbitPool } from "../../src/OrbitPool.sol";
import { Handler } from "./handler.t.sol";

contract Invariant is StdInvariant, Test {
    ERC20Mock poolToken;
    ERC20Mock weth;

    OrbitPoolFactory factory;
    OrbitPool pool; // poolToken, weth
    int256 public constant STARTING_X = 100e18;
    int256 public constant STARTING_Y = 50e18;

    Handler handler;

    function setUp() public {
        poolToken = new ERC20Mock();
        weth = new ERC20Mock();
        factory = new OrbitPoolFactory(address(weth));
        pool = OrbitPool(factory.createPool(address(poolToken)));

        poolToken.mint(address(this), uint256(STARTING_X));
        weth.mint(address(this), uint256(STARTING_Y));

        poolToken.approve(address(pool), type(uint256).max);
        weth.approve(address(pool), type(uint256).max);

        // Deposit Into Pool
        pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X), uint64(block.timestamp));

        handler = new Handler(pool);
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = handler.deposit.selector;
        selectors[1] = handler.swapPoolTokenForWethBasedOnOutputWeth.selector;
        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));
        targetContract(address(handler));
    }

    function statefulFuzz_constantProductFormulaStaysTheSameY() public {
        assertEq(handler.actualDeltaY(), handler.expectedDeltaY());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test } from "forge-std/Test.sol";
import { OrbitPoolFactory } from "../../src/OrbitPoolFactory.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";

contract OrbitPoolFactoryTest is Test {
    OrbitPoolFactory factory;
    ERC20Mock mockWeth;
    ERC20Mock tokenA;
    ERC20Mock tokenB;

    function setUp() public {
        mockWeth = new ERC20Mock();
        factory = new OrbitPoolFactory(address(mockWeth));
        tokenA = new ERC20Mock();
        tokenB = new ERC20Mock();
    }

    function testCreatePool() public {
        address poolAddress = factory.createPool(address(tokenA));
        assertEq(poolAddress, factory.getPool(address(tokenA)));
        assertEq(address(tokenA), factory.getToken(poolAddress));
        assertEq(factory.getPoolCount(), 1);
        assertEq(factory.getPoolAtIndex(0), poolAddress);
    }

    function testCantCreatePoolIfExists() public {
        factory.createPool(address(tokenA));
        vm.expectRevert(abi.encodeWithSelector(OrbitPoolFactory.OrbitPoolFactory__PoolAlreadyExists.selector, address(tokenA)));
        factory.createPool(address(tokenA));
    }

    function testGetPoolOrRevert() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                OrbitPoolFactory.OrbitPoolFactory__PoolDoesNotExist.selector,
                address(tokenA)
            )
        );
        factory.getPoolOrRevert(address(tokenA));
    }

    function testGetPoolAtIndexRevert() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                OrbitPoolFactory.OrbitPoolFactory__IndexOutOfBounds.selector,
                1,
                0
            )
        );
        factory.getPoolAtIndex(1);
    }
}

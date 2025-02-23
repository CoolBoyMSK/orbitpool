/**
 * /-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\
 * |                                     |
 * \ _____    ____                       /
 * -|_   _|  / ___|_      ____ _ _ __    -
 * /  | |____\___ \ \ /\ / / _` | '_ \   \
 * |  | |_____|__) \ V  V / (_| | |_) |  |
 * \  |_|    |____/ \_/\_/ \__,_| .__/   /
 * -                            |_|      -
 * /                                     \
 * |                                     |
 * \-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/|\-/
 */
// SPDX-License-Identifier: GNU General Public License v3.0
pragma solidity 0.8.20;

import { OrbitPool } from "./OrbitPool.sol";
import { IERC20 } from "forge-std/interfaces/IERC20.sol";

contract OrbitPoolFactory {
    error OrbitPoolFactory__PoolAlreadyExists(address tokenAddress);
    error OrbitPoolFactory__PoolDoesNotExist(address tokenAddress);
    error OrbitPoolFactory__IndexOutOfBounds(uint256 index, uint256 poolCount);

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    mapping(address token => address pool) private s_pools;
    mapping(address pool => address token) private s_tokens;
    address[] private s_allPools;

    address private immutable i_wethToken;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event PoolCreated(address tokenAddress, address poolAddress);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(address wethToken) {
        i_wethToken = wethToken;
    }

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function createPool(address tokenAddress) external returns (address) {
        if (s_pools[tokenAddress] != address(0)) {
            revert OrbitPoolFactory__PoolAlreadyExists(tokenAddress);
        }
        string memory liquidityTokenName = string.concat("OrbitPool ", IERC20(tokenAddress).name());
        string memory liquidityTokenSymbol = string.concat("op", IERC20(tokenAddress).symbol());
        OrbitPool pool = new OrbitPool(tokenAddress, i_wethToken, liquidityTokenName, liquidityTokenSymbol);
        s_pools[tokenAddress] = address(pool);
        s_tokens[address(pool)] = tokenAddress;
        s_allPools.push(address(pool));
        emit PoolCreated(tokenAddress, address(pool));
        return address(pool);
    }

    /*//////////////////////////////////////////////////////////////
                   EXTERNAL AND PUBLIC VIEW AND PURE
    //////////////////////////////////////////////////////////////*/
    function getPool(address tokenAddress) external view returns (address) {
        return s_pools[tokenAddress];
    }

    function getPoolOrRevert(address tokenAddress) external view returns (address poolAddress) {
        poolAddress = s_pools[tokenAddress];
        if (poolAddress == address(0)) {
            revert OrbitPoolFactory__PoolDoesNotExist(tokenAddress);
        }
    }

    function getPoolCount() external view returns (uint256) {
        return s_allPools.length;
    }

    function getPoolAtIndex(uint256 index) external view returns (address) {
        uint256 poolCount = s_allPools.length;
        if (index >= poolCount) {
            revert OrbitPoolFactory__IndexOutOfBounds(index, poolCount);
        }
        return s_allPools[index];
    }

    function getToken(address pool) external view returns (address) {
        return s_tokens[pool];
    }

    function getWethToken() external view returns (address) {
        return i_wethToken;
    }
}

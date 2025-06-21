//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from 'forge-std/Script.sol';
import {TipJar} from '../src/TipJar.sol';

contract DeployTipJar is Script {

    function run() external returns (TipJar){
        vm.startBroadcast();

        TipJar tipJar = new TipJar();

        vm.stopBroadcast();

        return tipJar;
    }
}


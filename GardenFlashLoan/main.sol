/*
To be deployed in Goerli testnet for Aave testing
WETH Gateway (mainnet): 0xEFFC18fC3b7eb8E676dac549E0c693ad50D1Ce31
LendingPool (mainnet): 0x7d2768de32b0b80b7a3454c06bdac94a69ddc7a9
*/
pragma solidity>0.8.0;//SPDX-License-Identifier:None

interface IWETHGateway {
    //amount, lending pool address, aToken receiver, referralCode (0 default)
    function depositETH(uint,address,address,uint)external;
}

interface ICurveSwap{
    //ether, index value of coin to send, to receive, amt to exchange, min amt to recv
    function exchange(uint,int128,int128,uint,uint)external;
}

contract Main{
    IWETHGateway private iwg;
    ICurveSwap private ics;

    constructor()payable{
        iwg=IWETHGateway(0x3bd3a20Ac9Ff1dda1D99C0dFCE6D65C4960B3627); //Goerli
        ics=ICurveSwap(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022); //No testnet

    }
    function swap()external payable{
        //Put into aave and get aToken
        //....Get amount to be exchanged first
        uint amt=msg.value;
        uint targetStEth=0;
        iwg.depositETH(amt,0x4bd5643ac6f66a5237E18bfA7d47cF22f1c9F210,address(this),0);

        //Exchange from curve.fi and get ETH
        //Get index number first
        (int128 stEthIndex,int128 ethIndex)=(0,0);
        //Get expected return
        uint minAmt=0;
        ics.exchange(0,stEthIndex,ethIndex,targetStEth,minAmt);

        //Transfer back to msg.sender the exchanged ETH & Deduct admin fee
        payable(address(this)).transfer(minAmt*9999/10000);
        
    }
}
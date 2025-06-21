//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TipJar {

    address public immutable i_owner;

    struct Donation {
        address donor;
        uint amount;
        uint age;
    }

    Donation[] public donations; // keep a list of donations

    //mapping (address => uint) netDonation; 
    // for creating a leaderboard, so donations are easily accessible
    //mapping(address => bool) hasDonated; 
    // for creating a leaderboard, so an address in the leaderboard has donated or not.


    constructor() {
        i_owner = msg.sender; 
    }
    //this constructor assures i_owner is whoever deploys the contract.

    modifier onlyOwner{
        require (msg.sender == i_owner);
        _;
    }
    // error NotOwner();

    event NewDonation(Donation);

    function donate() external payable {
        require(msg.value > 0); //blocking permission to call this function without sending eth

        //(bool success, ) = address(this).call{value: msg.value}("");
        //require(success);
        //this is not needed as calling the function automatically sends eth to the contract.

        Donation memory donation = Donation({
            donor: msg.sender,
            amount: msg.value,
            age: block.timestamp
        });

        donations.push(donation);
        //netDonation[msg.sender]+= msg.value;
        //hasDonated[msg.sender] = true;

        emit NewDonation(donation);
    }

    receive() external payable{
        Donation memory donation = Donation({
            donor: msg.sender,
            amount: msg.value,
            age: block.timestamp
        });

        donations.push(donation);
        //netDonation[msg.sender]+= msg.value;


        emit NewDonation(donation);
    }

    function viewBalance() public view returns (uint){
        return address(this).balance;
    }

    event Withdrawn(uint amount);
    function withdraw(uint amount) external onlyOwner{
        //require(msg.sender == i_owner); lets use a modifier for this 
        require(amount <= address(this).balance, 'amount exceeding donations');

        (bool withdrawn, ) = i_owner.call{value: amount}("");
        require (withdrawn);

        emit Withdrawn(amount);
    }

    //function createLeaderboard() external {}
}
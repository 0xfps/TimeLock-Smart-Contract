// SPDX-License-Identifier: MIT
pragma solidity >0.6.0;

/*
 * @title: 
 * @author: Anthony (fps) https://github.com/fps8k .
 * @dev: 
*/

library QuickMath
{
    function add(uint256 a, uint256 b) external pure returns(bool, uint256)
    {
        if((a + b) > ((2 ** 256) - 1))
            return(false, 0);
        else
            return(true, a + b);
    }
}


contract TimeLock
{
    using QuickMath for uint256;


    // Events.

    event Locked(address, uint256);
    event Withdraw(address, uint256);


    struct Lock
    {
        uint256 amount;
        uint256 time;
        uint256 last_lock;
    }


    mapping(address => Lock) private safe;


    modifier isValidSender()
    {
        require(msg.sender != address(0), "!Address");
        _;
    }




    function deposit() public payable isValidSender
    {
        _deposit(msg.value);
        emit Locked(msg.sender, msg.value);
    }




    function _deposit(uint256 _amount) private
    {
        uint256 current = safe[msg.sender].amount;
        (, uint256 addition) = current.add(_amount);
        safe[msg.sender].amount += addition;

        safe[msg.sender].time += 30 seconds;
        safe[msg.sender].last_lock = block.timestamp;
    }




    function withdraw() public payable isValidSender
    {
        require(((safe[msg.sender].last_lock + safe[msg.sender].time) < (block.timestamp)), "Time not up");
        require(safe[msg.sender].amount > 0, "Amount == 0");


        uint256 _amount = safe[msg.sender].amount;
        
        payable(msg.sender).transfer(_amount);

        delete safe[msg.sender];

        emit Withdraw(msg.sender, _amount);
    }




    function seeSafe(address _address) public view isValidSender returns(uint256)
    {
        require(safe[_address].time > 0, "! Exists");
        return safe[_address].amount;
    }
}
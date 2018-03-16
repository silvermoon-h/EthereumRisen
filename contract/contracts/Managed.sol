pragma solidity ^0.4.21;

import "./Owned.sol";

contract Managed is Owned {

    event NewManager(address owner, address manager);

    mapping (address => bool) public manager;

    modifier onlyManager() {
        require(manager[msg.sender] == true || msg.sender == owner);
        _;
    }

    function setManager(address _manager) public onlyOwner {
        NewManager(owner, _manager);
        manager[_manager] = true;
    }

    function superManager(address _manager) internal {
        NewManager(owner, _manager);
        manager[_manager] = true;
    }

    function delManager(address _manager) public onlyOwner {
        NewManager(owner, _manager);
        manager[_manager] = false;
    }
}

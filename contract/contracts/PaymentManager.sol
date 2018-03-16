pragma solidity ^0.4.21;

import "./MintableToken.sol";
import "./Owned.sol";

contract PaymentManager is MintableToken, Owned {

    uint256 public receivedWais;
    uint256 internal _price;
    bool internal paused = false;

    modifier isSuspended() {
        require(!paused);
        _;
    }

   function setPrice(uint256 _value) public onlyOwner returns (bool) {
        _price = _value;
        return true;
    }

    function watchPrice() public view returns (uint256 price) {
        return _price;
    }

    function rateSystem(address _to, uint256 _value) internal returns (bool) {
        uint256 _amount;
        if(_value >= (1 ether / 1000) && _value <= 1 ether) {
            _amount = _value * _price;
        } else
        if(_value >= 1 ether) {
             _amount = divsm(powsm(_value, 2), 1 ether) * _price;
        }
        issue(_to, _amount);
        if(paused == false) {
            if(totalSupply > 1 * 10e9 * 1 * 1 ether) paused = true; // if more then 10 billions stop sell
        }
        return true;
    }

    /** @dev transfer ethereum from contract */
    function transferEther(address _to, uint256 _value) public onlyOwner {
        _to.transfer(_value);
    }
}

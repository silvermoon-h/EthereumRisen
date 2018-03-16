pragma solidity ^0.4.21;

import "./SafeMath.sol";
import "./ERC20.sol";

/// Full complete implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
contract StandardToken is SafeMath, ERC20  {

    string  public name;
    string  public symbol;
    uint8   public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    /// @dev Returns number of tokens owned by given address.
    function name() public view returns (string) {
        return name;
    }

    /// @dev Returns number of tokens owned by given address.
    function symbol() public view returns (string) {
        return symbol;
    }

    /// @dev Returns number of tokens owned by given address.
    function decimals() public view returns (uint8) {
        return decimals;
    }

    /// @dev Returns number of tokens owned by given address.
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }


    /// @dev Returns number of tokens owned by given address.
    /// @param _owner Address of token owner.
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    /// @dev Transfers sender's tokens to a given address. Returns success.
    /// @param _to Address of token receiver.
    /// @param _value Number of tokens to transfer.
    function transfer(address _to, uint256 _value) public returns (bool) {
        if(_to == address(this)) revert(); //prevent direct send to contract
        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        }
        else {
            return false;
        }
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
      return allowed[_owner][_spender];
    }
}

pragma solidity ^0.4.21;

import "./ERC827Token.sol";

contract MintableToken is ERC827Token {


            uint256 constant maxSupply = 1e30; // max amount of tokens 1 trillion
            bool internal mintable = true;

            modifier isMintable() {
                require(mintable);
                _;
            }

            function stopMint() internal {
                mintable = false;
            }

            // triggered when the total supply is increased
            event Issuance(uint256 _amount);
            // triggered when the total supply is decreased
            event Destruction(uint256 _amount);

            /**
                @dev increases the token supply and sends the new tokens to an account
                can only be called by the contract owner
                @param _to         account to receive the new amount
                @param _amount     amount to increase the supply by
            */
            function issue(address _to, uint256 _amount) internal {
                assert(totalSupply + _amount <= maxSupply); // prevent overflows
                totalSupply +=  _amount;
                balances[_to] += _amount;
                emit Issuance(_amount);
                emit Transfer(this, _to, _amount);
            }

            /**
                @dev removes tokens from an account and decreases the token supply
                can only be called by the contract owner
                (if robbers detected, if will be consensus about token amount)

                @param _from       account to remove the amount from
                @param _amount     amount to decrease the supply by
            */
            /* function destroy(address _from, uint256 _amount) public onlyOwner {
                balances[_from] -= _amount;
                _totalSupply -= _amount;
                Transfer(_from, this, _amount);
                Destruction(_amount);
            } */
}

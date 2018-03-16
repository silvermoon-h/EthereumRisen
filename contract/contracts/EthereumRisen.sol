pragma solidity ^0.4.21;

import "./InvestBox.sol";

contract EthereumRisen is InvestBox {

    // devs addresess, pay for code
    address public devWallet = address(0x00FBB38c017843DFa86a97c31fECaCFF0a092F6F);
    uint256 constant public devReward = 100000 * 1e18; // 100K

    // fondation for pay by promotion this project
    address public bountyWallet = address(0x00Ed07D0170B1c5F3EeDe1fC7261719e04b15ecD);
    uint256 constant public bountyReward = 50000 * 1e18; // 50K

    // will be send for first 10k rischest wallets, if it is enough to pay the commission
    address public airdropWallet = address(0x000DdB5A903d15b2F7f7300f672d2EB9bF882143);
    uint256 constant public airdropReward = 99900 * 1e18; // 99.9K

    bool internal _airdrop_status = false;
    uint256 internal _paySize;

    /** init airdrop program if cap will reach сost price */
    function startAirdrop() public onlyOwner {
        if(address(this).balance < 5 ether && _airdrop_status == true) revert();
        issue(airdropWallet, airdropReward);
        _paySize = 999 * 1e16; // 9.99 tokens
        _airdrop_status = true;
    }

    /**
        @dev notify owners about their balances was in promo action.
        @param _holders addresses of the owners to be notified ["address_1", "address_2", ..]
     */
    function airdropper(address [] _holders, uint256 _pay_size) public onlyManager {
        if(_pay_size == 0) _pay_size = _paySize; // if empty set default
        if(_pay_size < 1 * 1e18) revert(); // limit no less then 1 token
        uint256 count = _holders.length;
        require(count <= 200);
        assert(_pay_size * count <= balanceOf(msg.sender));
        for (uint256 i = 0; i < count; i++) {
            transfer(_holders [i], _pay_size);
        }
    }

    function EthereumRisen() public {

        name = "Ethereum Risen";
        symbol = "ETR";
        decimals = 18;
        totalSupply = 0;
        _creation = now;
        _1sty = now + 365 * 1 days;
        _2ndy = now + 2 * 365 * 1 days;

        PaymentManager.setPrice(10000);
        Managed.setManager(bountyWallet);
        InvestBox.IntervalBytecodes = intervalBytecodes(
            "0x6461790000",
            "0x7765656b00",
            "0x6d6f6e7468",
            "0x7965617200"
        );
        InvestBox.setMinMaxInvestValue(1000,100000000);
        issue(bountyWallet, bountyReward);
        issue(devWallet, devReward);
    }

    function() public payable isSuspended {
        require(msg.value >= (1 ether / 100));
        if(msg.value >= 5 ether) superManager(msg.sender); // you can make airdrop from this contract
        rateSystem(msg.sender, msg.value);
        receivedWais = addsm(receivedWais, msg.value); // count ether which was spent to contract
    }
}

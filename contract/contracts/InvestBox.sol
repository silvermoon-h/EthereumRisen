pragma solidity ^0.4.21;

import "./PaymentManager.sol";
import "./Managed.sol";

contract InvestBox is PaymentManager, Managed {

    // triggered when the amount of reaward are changed
    event BonusChanged(uint256 _amount);
    // triggered when making invest
    event Invested(address _from, uint256 _value);
    // triggered when invest closed or updated
    event InvestClosed(address _who, uint256 _value);
    // triggered when counted
    event Counted(address _sender, uint256 _intervals);

    uint256 constant _day = 24 * 60 * 60 * 1 seconds;

    bytes5 internal _td = bytes5("day");
    bytes5 internal _tw = bytes5("week");
    bytes5 internal _tm = bytes5("month");
    bytes5 internal _ty = bytes5("year");

    uint256 internal _creation;
    uint256 internal _1sty;
    uint256 internal _2ndy;

    uint256 internal min_invest;
    uint256 internal max_invest;

    struct invest {
        bool exists;
        uint256 balance;
        uint256 created; // creation time
        uint256 closed;  // closing time
    }

    mapping (address => mapping (bytes5 => invest)) public investInfo;

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }

    /** @dev return in interface string encoded to bytes (max len 5 bytes) */
    function stringToBytes5(string _data) public pure returns (bytes5) {
        return bytes5(stringToBytes32(_data));
    }

    struct intervalBytecodes {
        string day;
        string week;
        string month;
        string year;
    }

    intervalBytecodes public IntervalBytecodes;

    /** @dev setter min max params for investition */
    function setMinMaxInvestValue(uint256 _min, uint256 _max) public onlyOwner {
        min_invest = _min * 10 ** uint256(decimals);
        max_invest = _max * 10 ** uint256(decimals);
    }

    /** @dev number of complete cycles d/m/w/y */
    function countPeriod(address _investor, bytes5 _t) internal view returns (uint256) {
        uint256 _period;
        uint256 _now = now; // blocking timestamp
        if (_t == _td) _period = 1 * _day;
        if (_t == _tw) _period = 7 * _day;
        if (_t == _tm) _period = 31 * _day;
        if (_t == _ty) _period = 365 * _day;
        invest storage inv = investInfo[_investor][_t];
        if (_now - inv.created < _period) return 0;
        return (_now - inv.created)/_period; // get full days
    }

    /** @dev loop 'for' wrapper, where 100,000%, 10^3 decimal */
    function loopFor(uint256 _condition, uint256 _data, uint256 _bonus) internal pure returns (uint256 r) {
        assembly {
            for { let i := 0 } lt(i, _condition) { i := add(i, 1) } {
              let m := mul(_data, _bonus)
              let d := div(m, 100000)
              _data := add(_data, d)
            }
            r := _data
        }
    }

    /** @dev invest box controller */
    function rewardController(address _investor, bytes5 _type) internal view returns (uint256) {

        uint256 _period;
        uint256 _balance;
        uint256 _created;

        invest storage inv = investInfo[msg.sender][_type];

        _period = countPeriod(_investor, _type);
        _balance = inv.balance;
        _created = inv.created;

        uint256 full_steps;
        uint256 last_step;
        uint256 _d;

        if(_type == _td) _d = 365;
        if(_type == _tw) _d = 54;
        if(_type == _tm) _d = 12;
        if(_type == _ty) _d = 1;

        full_steps = _period/_d;
        last_step = _period - (full_steps * _d);

        for(uint256 i=0; i<full_steps; i++) { // not executed if zero
            _balance = compaundIntrest(_d, _type, _balance, _created);
            _created += 1 years;
        }

        if(last_step > 0) _balance = compaundIntrest(last_step, _type, _balance, _created);

        return _balance;
    }

    /**
        @dev Compaund Intrest realization, return balance + Intrest
        @param _period - time interval dependent from invest time
    */
    function compaundIntrest(uint256 _period, bytes5 _type, uint256 _balance, uint256 _created) internal view returns (uint256) {
        uint256 full_steps;
        uint256 last_step;
        uint256 _d = 100; // safe divider
        uint256 _bonus = bonusSystem(_type, _created);

        if (_period>_d) {
            full_steps = _period/_d;
            last_step = _period - (full_steps * _d);
            for(uint256 i=0; i<full_steps; i++) {
                _balance = loopFor(_d, _balance, _bonus);
            }
            if(last_step > 0) _balance = loopFor(last_step, _balance, _bonus);
        } else
        if (_period<=_d) {
            _balance = loopFor(_period, _balance, _bonus);
        }
        return _balance;
    }

    /** @dev Bonus program */
    function bonusSystem(bytes5 _t, uint256 _now) internal view returns (uint256) {
        uint256 _b;
        if (_t == _td) {
            if (_now < _1sty) {
                _b = 600; // 0.6 %/day  // 100.6 % by day => 887.69 % by year
            } else
            if (_now >= _1sty && _now < _2ndy) {
                _b = 300; // 0.3 %/day
            } else
            if (_now >= _2ndy) {
                _b = 30; // 0.03 %/day
            }
        }
        if (_t == _tw) {
            if (_now < _1sty) {
                _b = 5370; // 0.75 %/day => 5.37 % by week => 1529.13 % by year
            } else
            if (_now >= _1sty && _now < _2ndy) {
                _b = 2650; // 0.375 %/day
            } else
            if (_now >= _2ndy) {
                _b = 270; // 0.038 %/day
            }
        }
        if (_t == _tm) {
            if (_now < _1sty) {
                _b = 30000; // 0.85 %/day // 130 % by month => 2196.36 % by year
            } else
            if (_now >= _1sty && _now < _2ndy) {

                _b = 14050; // 0.425 %/day
            } else
            if (_now >= _2ndy) {
                _b = 1340; // 0.043 %/day
            }
        }
        if (_t == _ty) {
            if (_now < _1sty) {
                _b = 3678000; // 1 %/day // 3678.34 * 1000 = 3678340 = 3678% by year
            } else
            if (_now >= _1sty && _now < _2ndy) {
                _b = 517470; // 0.5 %/day
            } else
            if (_now >= _2ndy) {
                _b = 20020; // 0.05 %/day
            }
        }
        return _b;
    }

    /** @dev make invest */
    function makeInvest(uint256 _value, bytes5 _interval) internal isMintable {
        require(min_invest <= _value && _value <= max_invest); // min max condition
        assert(balances[msg.sender] >= _value && balances[this] + _value > balances[this]);
        balances[msg.sender] -= _value;
        balances[this] += _value;
        invest storage inv = investInfo[msg.sender][_interval];
        if (inv.exists == false) { // if invest no exists
            inv.balance = _value;
            inv.created = now;
            inv.closed = 0;
            emit Transfer(msg.sender, this, _value);
        } else
        if (inv.exists == true) {
            uint256 rew = rewardController(msg.sender, _interval);
            inv.balance = _value + rew;
            inv.closed = 0;
            emit Transfer(0x0, this, rew); // fix rise total supply
        }
        inv.exists = true;
        emit Invested(msg.sender, _value);
        if(totalSupply > maxSupply) stopMint(); // stop invest
    }

    function makeDailyInvest(uint256 _value) public {
        makeInvest(_value * 10 ** uint256(decimals), _td);
    }

    function makeWeeklyInvest(uint256 _value) public {
        makeInvest(_value * 10 ** uint256(decimals), _tw);
    }

    function makeMonthlyInvest(uint256 _value) public {
        makeInvest(_value * 10 ** uint256(decimals), _tm);
    }

    function makeAnnualInvest(uint256 _value) public {
        makeInvest(_value * 10 ** uint256(decimals), _ty);
    }

    /** @dev close invest */
    function closeInvest(bytes5 _interval) internal {
        uint256 _intrest;
        address _to = msg.sender;
        uint256 _period = countPeriod(_to, _interval);
        invest storage inv = investInfo[_to][_interval];
        uint256 _value = inv.balance;
        if (_period == 0) {
            balances[this] -= _value;
            balances[_to] += _value;
            emit Transfer(this, _to, _value); // tx of begining balance
            emit InvestClosed(_to, _value);
        } else
        if (_period > 0) {
            // Destruction init
            balances[this] -= _value;
            totalSupply -= _value;
            emit Transfer(this, 0x0, _value);
            emit Destruction(_value);
            // Issue init
            _intrest = rewardController(_to, _interval);
            if(manager[msg.sender]) {
                _intrest = mulsm(divsm(_intrest, 100), 105); // addition 5% bonus for manager
            }
            issue(_to, _intrest); // tx of %
            emit InvestClosed(_to, _intrest);
        }
        inv.exists = false; // invest inv clear
        inv.balance = 0;
        inv.closed = now;
    }

    function closeDailyInvest() public {
        closeInvest(_td);
    }

    function closeWeeklyInvest() public {
        closeInvest(_tw);
    }

    function closeMonthlyInvest() public {
        closeInvest(_tm);
    }

    function closeAnnualInvest() public {
        closeInvest(_ty);
    }

    /** @dev safe closing invest, checking for complete by date. */
    function isFullInvest(address _ms, bytes5 _t) internal returns (uint256) {
        uint256 res = countPeriod(_ms, _t);
        emit Counted(msg.sender, res);
        return res;
    }

    function countDays() public returns (uint256) {
        return isFullInvest(msg.sender, _td);
    }

    function countWeeks() public returns (uint256) {
        return isFullInvest(msg.sender, _tw);
    }

    function countMonths() public returns (uint256) {
        return isFullInvest(msg.sender, _tm);
    }

    function countYears() public returns (uint256) {
        return isFullInvest(msg.sender, _ty);
    }
}

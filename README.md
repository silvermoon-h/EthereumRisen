# EthereumRisen | documentation

Autonomic mintable token, POI - Proof of Invest

## INTRO
________________________________________________________________________________

Next generation high-level qualities token;                 
Represents autonomous smart contract (ASC) concept;                  
ERC827 standard supported;                 
Managers system provide bounty interest for investors and open airdrop functional;           
You are absolutely free in your actions, you can buy how much;           
You can make an investment for as much, so much for you;        
Any payments for this contract is as charitable help, not more, not less.
Code provides as is.


## TECHNICAL SPECIFICATION
________________________________________________________________________________

```
Token name: Ethereum Risen
Ticker symbol: ETR
Decimal place: 18
Total supply: 1000 billions
Algorithm: Ethereum token on eip827 standard(supported eip20 standard)
Contract address: 0x0
ICO/TGE: none
Price: 10000 ETR by 1 ETH (price fixed)
Location: blockchain
```


## DISTRIBUTION
________________________________________________________________________________

### Factory Funds:

- Development prime cost: 100000 ETR
- Bounty program: 50000 ETR
- Airdrop program: 9.99 tokens * 10000 users = 99900 ETR    

**Distribution tokens structure:** 150K ETR + 99.9K ETR + sales(~10 billions ETR) + POI interest

![](https://raw.githubusercontent.com/pironmind/illustrations/master/etr_ecosys.png)

### Sales program:
```
10000 ETR = 1 ETH (constant);      
```
Purchase more than 1 ETH counts by geometric progression, until total supply reaches 10 billions.
```
1 ETH = 10,000 ^ 1 = 10,000,         
2 ETH = 20,000 ^ 2 = 40,000,         
3 ETH = 30,000 ^ 3 = 90,000,           
..
```

Closed when total supply reaches 10 billions    
###### **! after reaches this value new tokens cant be sold via contract**

### POI program:

Percents profit table in **percents by day** (%/day)

periods      | day           | week         | month         | year
------------ | ------------- | ------------ | ------------- | ------------  
1st year     | 0,600%        | 0,750%       | 0,850%        | 1,000%
2nd year     | 0,300%        | 0,375%       | 0,425%        | 0,500%
3rd+ year    | 0,030%        | 0,038%       | 0,043%        | 0,050%

Count profit by this scheme.

Closed when total supply reaches 1000 billions + overflow this amount for investors which not close their deposits.     
###### **! after reaches this value new deposits cant be opened**

Invest value must be between 1 thousand and 10 million

### Managers program:

If in one transaction put to the contract **5 or more ethers**, you get rights of manager

Manager privileges      

- can use airdrop function
- get additionally plus 5% to the invest box full reward


## TARGET
________________________________________________________________________________

Make mining alternative for tokens holders;
Make economic research;
Open the blockchain technology based business, start to make powerful products;


## ROADMAP
________________________________________________________________________________

- [ ] start sells
- [ ] start bounty company
- [ ] start airdrop company (if cap rise more then 5 ETH)
- [ ] placing on exchanges (at first: hitbtc, livecoin, yobit, novaexchange, ...)


## HELPER
________________________________________________________________________________

Bytecodes table provided codes for status of your invest

period       | bytecode          
-------------|--------------
day          | 0x6461790000
week         | 0x7765656b00
month        | 0x6d6f6e7468
year         | 0x7965617200


## Frequency Asked Questions (FAQ)
________________________________________________________________________________

How I can get the ETR?
- You mast send from your personal wallet some ethers and get incoming transaction with your tokens (only wallet private key you are the owner,
    if send direct from exchange you can lose your money)

What is ETR?    
- The Etherum Risen token (ETR) is an <strong>ERC20 Token</strong> based on Ethereum blockchain platform.

How to produce new tokens?
- New tokens created via sales in smart contract and via invest box program, as interest

What is POI?
- POI is a Proof Of Investment

What dose it means?
- POI is invest box program, which is alternate of POS mining mechanism

How to make invest?
- User must call in contract function "make <Time> Invest" and type in field value that you want put in Invest Box

How much investments I can made?
- At the same time every user can made four invest, one for each type (daily, monthly,..)

What's happen if I call make invest and do not close it before?
- Invest automatically closed, count your actual intrest and add new balance to the counted balance. Invest will be counted beginning with this time.
**should use it for gas economy**

How to close invest?
- User must call function "close <Time> Invest", and spend back invested tokens with interest (counted by the algorithm of compaund interest)

Where I can check the investment status?
- Сall function "count <Time>". If returns (0) - still no completed, more then (0) - can get reward, show how much times up.
- For get information about your invest you also could use function "count Info", which need two parameters address of holder and "bytecode" from helper.

What rules of invest box program?
- you must be a token holders;
- interest counting only by whole period(-s);
- you can close your invest any time, but you can lose interest if you withdraw before the end of the period;

What is ERC20 and why ERC827?
- Details about [eip20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) and [eip827](https://github.com/ethereum/EIPs/issues/827)


## MEDIA RESOURCES
________________________________________________________________________________

- Bitcointalk (Announce): [bitcointalk.org]()
- Official site (Web site): [ethereumrisen.io]()
- Telegram (Official channel): [telegram.com]()
- Telegram (Official group): [telegram.com]()
- Github (Source Code): [github.com]()

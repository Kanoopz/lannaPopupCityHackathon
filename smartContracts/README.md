# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```



- deposit ether phase 1
- deposit ether phase 2
    - change ether phase 1 for liquid ether
    - exchage ether phase 2 for liquid ether at future price
    - return assets
    - difference is the funding amount
- reestakedEther and defi asset
3/3
2/3 future value for funding
1/3 APY + using reestaked ether

LIDO staking      2.9
RENZO reestaking  7.02
GEARBOX defi      8


- Avoids funding farming thanks to limiting to just one real human without multiple addressb
- Substitudes capital donations for future staking donations
- Gives yield to funders

0x92AE8bC6691118760C7f8300DE9320A36c1E21d1
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
- reestakedEther and defi asset?

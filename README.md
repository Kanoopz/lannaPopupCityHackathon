# lannaPopupCityHackathon
Repo for the lanna pop up city hackathon project: "./Karkinos".

Karkinos ia an antiFarming funding mechanism that uses the future value accrued by liquidStaking and reestaking ether in the present moment to fund public goods.

The basic idea of the funding mechanism is that two entities swap their assets, one buying the liquidStaking and reestaking assets at their future value and use the arbitrage to fund public goods. After one year, this entity gets back the extra value that paid, making it a novel mechanism to fund projects without actually losing capital, making it a perfect model to attract new donors that contribute to build public goods. Another incentive for donors to participate and fund projects, besides not losing capital, is that they actually can earn yield by using the reestaked asset they got into an integrated defi protocol and also apply for points for airdrops.

Basic example:
-----

Other important feature for this funding mechanism is that by implementing worldID, only real people can participate, enhancing the funding of only those projects that are worth the donations. 

With these features implemented, it was possible to enable:
- Incentivize donors to fund projects by giving them the funded amount they donated in one year + yield from a defi protocol & reestaked airdrop points.
- Eliminates the need of funding matching mechanism that requires large amounts of money donated from protocols or foundation thanks to the instant staking funding mechanism, which returns funds to every donor at the end of the year.
- More honest funding rounds thanks to worldID that let just real people to participate and fund limited amount of times in order to prevent farming and avoid multiple address by the same person.

The process and phases for a successful round are:
- phase0: In this phase all projects are invited to apply to the round.
- phase1: The initial funds for native ether that will be turned into stEth liquidStakedEther and later to ezEth reestakedEther are collected.
- phase2: Funding to be used to buy at future price the reestakedEther starts in order to collect the arbitrage of the mechanism and select a project to donate it.
- phase3:
    - phaseOne initial funds can be claimed by donors.
    - Project admins can collect their funded amount.


Architecture:
----

Karkinos factory address: 0xa48BEf63E74A3995E52623f39437dd7eb219c66D.

The used protocols to achieve its mechanism for funding are: lido, renzo and gearbox, for their onchain implementations the following address where used:
- lido liquidStaking:   0xeAde2E3f4C3226f90206c0b5BFa6A689BC478BC0
- renzo reestaking:     0x646FbcfE3cFc4cADb99c4adD4C07FD7E558cfae4
- gearbox:              0x34cEC27B13197436d2ff792FEe4fFfFa4059A908
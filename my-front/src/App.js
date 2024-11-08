import logo from './logo.svg';
import './App.css';

import { IDKitWidget, VerificationLevel } from '@worldcoin/idkit';
import { ethers } from 'ethers';
import { useState } from 'react';
// import { defaultAbiCoder as abi } from '@ethers/utils';

function App() 
{
  ////////////////////////////////////////////
  //  smartContractSetUpVariables          ///
  ////////////////////////////////////////////
  let smartContractAddress = "0x6801579575dCc6d4f7Aa00F32dd2A02602ce745f";
  let smartContractAbi = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "adminParam",
          "type": "address"
        },
        {
          "internalType": "string",
          "name": "_appId",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "_actionId",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "fundingQuantityParam",
          "type": "uint256"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [],
      "name": "AvailablePhaseOneFunddedEtherInWei",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "actualPhase",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "admin",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "claimPhaseOneFunding",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "endPhase0",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "endPhase1",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "endPhase2",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "fundPhaseOne",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "root",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "nullifierHash",
          "type": "uint256"
        },
        {
          "internalType": "uint256[8]",
          "name": "proof",
          "type": "uint256[8]"
        }
      ],
      "name": "fundPhaseTwo",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "gearboxProtocolAddress",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        }
      ],
      "name": "getProjectAdmin",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        }
      ],
      "name": "getProjectData",
      "outputs": [
        {
          "components": [
            {
              "internalType": "uint256",
              "name": "projectId",
              "type": "uint256"
            },
            {
              "internalType": "string",
              "name": "projectName",
              "type": "string"
            },
            {
              "internalType": "string",
              "name": "projectDescription",
              "type": "string"
            },
            {
              "internalType": "address",
              "name": "projectAdmin",
              "type": "address"
            }
          ],
          "internalType": "struct KarkinosRound.projectData",
          "name": "",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        }
      ],
      "name": "getProjectDescription",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        }
      ],
      "name": "getProjectName",
      "outputs": [
        {
          "internalType": "string",
          "name": "",
          "type": "string"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "nullifierHashParam",
          "type": "uint256"
        }
      ],
      "name": "getWorldIdFunddedCounterForSignal",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "lidoLiquidStakingAddress",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "nextPhaseOneFundingOrder",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "nextPhaseTwoFundingOrder",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "nextProjectId",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "permmitedFundingPerAddress",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "projectIdParam",
          "type": "uint256"
        }
      ],
      "name": "projectAdminClaimProjectFunding",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "projectNameParam",
          "type": "string"
        },
        {
          "internalType": "string",
          "name": "projectDescriptionParam",
          "type": "string"
        }
      ],
      "name": "registerProject",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "renzoReestakingAddress",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "totalPhaseOneFunddedEtherInWei",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];

  let provider = new ethers.providers.Web3Provider(window.ethereum);  
  let smartContractInstance = new ethers.Contract(smartContractAddress, smartContractAbi, provider);

  ////////////////////////////////////////////
  //  onChainInteractionVariables          ///
  ////////////////////////////////////////////
  const [address, setAddress] = useState(null);
  const [signer, setSigner] = useState(null);
  const [connected, setConnected] = useState(false);
  const [phase, setPhase] = useState(null);

  ////////////////////////////////////////////
  //  onChainInteractionFuncs              ///
  ////////////////////////////////////////////
  const [rootParam, setRootParam] = useState(null);
  const [nullifierHashParam, setNullifierHashParam] = useState(null);
  const [proofParam, setProofParam] = useState(null);

  const [projectId, setProjectId] = useState(null);
  const [amountToFund, setAmountToFund] = useState(null);

  ////////////////////////////////////////////
  //  onChainInteractionFuncs              ///
  ////////////////////////////////////////////
  async function requestAccount() 
  {
    if(window.ethereum)
    {
      let accounts = await window.ethereum.request({ method: "eth_requestAccounts", });

      const _signer = await provider.getSigner();
      const _address = accounts[0];

      setAddress(_address);
      setSigner(_signer);
      setConnected(true);

      console.log("signer");
      console.log(_signer);
      console.log("address:");
      console.log(_address);
    }
    else
    {
      console.log("Metamask isnt installed.");
    }

    console.log("userObject:");
    console.log(signer);
  }

  async function getData()
  {
    let _phase = await smartContractInstance.actualPhase();
    setPhase(_phase.toString());
  }

  ////////////////////////////////////////////
  //  ethersUtils                          ///
  ////////////////////////////////////////////
  let abi = ethers.utils.defaultAbiCoder;

  ////////////////////////////////////////////
  //  worldCoinOnChainInteractionFuncs     ///
  ////////////////////////////////////////////
  const verifyProof = async (proof) => 
  {
    console.log("");

    console.log(proof);

    const root = proof.merkle_root;
    const nullifierHash = proof.nullifier_hash;
    const unpackedProof = getUnpackedProof(proof.proof);

    setRootParam(root);
    setNullifierHashParam(nullifierHash);
    setProofParam(unpackedProof);

    console.log("");

    // let signal = 1;
    let signal = address;
    
    console.log("SIGNAL:");
    console.log(typeof(signal));
    console.log(signal);

    console.log("ROOT");
    console.log(typeof(root));
    console.log(root);

    console.log("NULLIFIER_HASH");
    console.log(typeof(nullifierHash));
    console.log(nullifierHash);

    console.log("PROOF");
    console.log(typeof(unpackedProof));
    console.log(unpackedProof);

    console.log("");

    // const tx = await smartContractInstance.connect(signer).verifyAndExecute(1, root, nullifierHash, unpackedProof, {gasLimit: 5000000});

    // console.log("TX:");
    // console.log(tx);
    // const txReceipt = await tx.wait();
    // console.log("TX_RECEIPT:");
    // console.log(txReceipt);
  };

  function getUnpackedProof(proof)
  {
    return (abi.decode(['uint256[8]'], proof)[0]);
  }

  const onSuccess = async () =>
  {
    console.log("");

    console.log("Success");


    // const tx = await smartContractInstance.connect(signer).verifyAndExecute(address, rootParam, nullifierHashParam, proofParam, {gasLimit: 10000000});
    // fundPhaseTwo(uint projectIdParam, uint256 root, uint256 nullifierHash, uint256[8] calldata proof)
    const tx = await smartContractInstance.connect(signer).fundPhaseTwo(projectId, rootParam, nullifierHashParam, proofParam, { value: amountToFund })


    console.log("TX:");
    console.log(tx);
    const txReceipt = await tx.wait();
    console.log("TX_RECEIPT:");
    console.log(txReceipt);

    console.log("");
  };

  getData();

  function consoleLog()
  {
    console.log(amountToFund);
    console.log(projectId);
  }

  return (
    <div className="App">
      <header>
        <h1 style={{float: 'left', paddingLeft: '2rem'}}>KarkinosProject</h1>
      </header>

      <body>
        <div style={{paddingTop: '1rem'}}>
          {
            connected ?
            <>
              <h3 style={{float: 'right', paddingRight: '2rem'}}>Connected wallet: {address}</h3>
            </>
            :
            <>
              <h1>connectWallet:</h1>
              <button onClick={requestAccount}>connect</button>
            </>
          }
        </div>

        <div style={{paddingTop: '9rem'}}>
          <div style={{paddingLeft: '40rem'}}>
            <h2>Round phase: {phase}</h2>
          </div>

          <div style={{paddingTop: '2rem'}}>
            <h1>Fund phase 2:</h1>

            <div>
              <h3>- Project ID to fund:</h3>
              <input type='text' onChange={event => setProjectId(event.target.value)}></input>
            </div>
            <div>
              <h3>- Ether to use (in wei):</h3>
              <input type='text' onChange={event => setAmountToFund(event.target.value)}></input>
            </div>
          </div>
        </div>
        
        <div style={{paddingTop: '5rem'}}>
          <div>
            <h1>WORLD ID VALIDATION:</h1>
          </div>

          <div style={{paddingTop: '3rem'}}>
            <IDKitWidget
              app_id="app_staging_95a25cfa91863888a8b00d500786fa53"
              action="verify-humanity"
              signal={address}
              // On-chain only accepts Orb verifications
              verification_level={VerificationLevel.Orb}
              handleVerify={verifyProof}
              onSuccess={onSuccess}>
              {({ open }) => ( <button onClick={open}> Verify with World ID to fund </button> )}
            </IDKitWidget>
          </div>
        </div>
      </body>
    </div>
  );
}

export default App;

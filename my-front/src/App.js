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
  let smartContractAddress = "0x7F0A2c7f63Ea8a43298A819514da56fb5B90dA91";
  let smartContractAbi = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_worldId",
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
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "nullifierHash",
          "type": "uint256"
        }
      ],
      "name": "DuplicateNullifier",
      "type": "error"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "nullifierHash",
          "type": "uint256"
        }
      ],
      "name": "Verified",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "signal",
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
      "name": "verifyAndExecute",
      "outputs": [],
      "stateMutability": "nonpayable",
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

  ////////////////////////////////////////////
  //  onChainInteractionFuncs              ///
  ////////////////////////////////////////////
  const [rootParam, setRootParam] = useState(null);
  const [nullifierHashParam, setNullifierHashParam] = useState(null);
  const [proofParam, setProofParam] = useState(null);

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

    let signal = 1;
    
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

    const tx = await smartContractInstance.connect(signer).verifyAndExecute(1, root, nullifierHash, unpackedProof);

    console.log("TX:");
    console.log(tx);
    const txReceipt = await tx.wait();
    console.log("TX_RECEIPT:");
    console.log(txReceipt);
  };

  function getUnpackedProof(proof)
  {
    return (abi.decode(['uint256[8]'], proof)[0]);
  }

  const onSuccess = () => 
  {
    console.log("");

    console.log("Success");

    console.log("");
  };

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>

      <body>
        <div>
          {
            connected ?
            <>
              <h1>userConnected</h1>
            </>
            :
            <>
              <h1>connectWallet:</h1>
              <button onClick={requestAccount}>connect</button>
            </>
          }
        </div>
        
        <div style={{paddingTop: '5rem'}}>
          <div>
            <h1>WORLD ID VALIDATION:</h1>
          </div>

          <div style={{paddingTop: '3rem'}}>
            <IDKitWidget
              app_id="app_staging_95a25cfa91863888a8b00d500786fa53"
              action="verify-humanity"
              // On-chain only accepts Orb verifications
              verification_level={VerificationLevel.Orb}
              handleVerify={verifyProof}
              onSuccess={onSuccess}>
              {({ open }) => ( <button onClick={open}> Verify with World ID </button> )}
            </IDKitWidget>
          </div>
        </div>
      </body>
    </div>
  );
}

export default App;

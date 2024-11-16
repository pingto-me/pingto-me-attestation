const { ethers }  = require('hardhat');

async function main() {

      // Get the contract factory for HodlAttester
  const HodlAttester = await ethers.getContractFactory("HodlAttester");

  // Deploy HodlAttester contract
  console.log("Deploying HodlAttester contract...");
  const hodlAttester = await HodlAttester.deploy();
  await hodlAttester.deployed();
  console.log("HodlAttester contract deployed at:", hodlAttester.address);

  setTimeout( () => {
      console.log("============= Verify Contract =============");

  }, 2400)
    
  // Verify HodlAttester contract
  console.log("Verifying HodlAttester contract...");
  await run("verify:verify", {
    address: hodlAttester.address,
    constructorArguments: [],
    contract: 'contracts/hodlattes.sol:HodlAttester',
  });

  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
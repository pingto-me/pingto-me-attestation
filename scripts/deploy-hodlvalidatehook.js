const { ethers }  = require('hardhat');

async function main() {

  
  const NFTHodlManager = await ethers.getContractFactory("NFTHodlManager");

  // Deploy NFTHodlManager contract
  console.log("Deploying NFTHodlManager contract...");
  const nftHodlManager = await NFTHodlManager.deploy();
  await nftHodlManager.deployed();
  console.log("NFTHodlManager contract deployed at:", nftHodlManager.address);

    setTimeout( () => {
      console.log("============= Verify Contract =============");

  }, 2400)

  // Verify NFTHodlManager contract
  console.log("Verifying NFTHodlManager contract...");
  await run("verify:verify", {
    address: nftHodlManager.address,
    constructorArguments: [],
    contract: 'contracts/hodlvalidatehook.sol:NFTHodlManager',
  });

  // // Get the contract factory for HodlChallangeHook
  // const HodlChallangeHook = await ethers.getContractFactory("HodlChallangeHook");

  // // Deploy HodlChallangeHook contract
  // console.log("Deploying HodlChallangeHook contract...");
  // const hodlChallangeHook = await HodlChallangeHook.deploy();
  // await hodlChallangeHook.deployed();
  // console.log("HodlChallangeHook contract deployed at:", hodlChallangeHook.address);

  //   setTimeout( () => {
  //     console.log("============= Verify Contract =============");

  // }, 2400)

  // // Verify HodlChallangeHook contract
  // console.log("Verifying HodlChallangeHook contract...");
  // await run("verify:verify", {
  //   address: hodlChallangeHook.address,
  //   constructorArguments: [],
  //   contract: 'contracts/hodlvalidatehook.sol:NFTHodlManager',

  // });

  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
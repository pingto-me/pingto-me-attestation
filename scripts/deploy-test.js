const { ethers }  = require('hardhat');

async function main() {


    const TEST = await ethers.getContractFactory('MyContract');
    const test = await TEST.deploy();
    await test.deployed();
  
    console.log('Test Deployed to:', test.address);
  setTimeout( () => {
      console.log("============= Verify Contract =============");

  }, 1000)
    // Verify
    await hre.run("verify:verify", {
      address: test.address,
    //     constructorArguments: [USDTTestnet],
      contract: 'contracts/test.sol:MyContract',
    });

  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
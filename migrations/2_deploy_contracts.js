const Token = artifacts.require("erc20Token");

module.exports = async function(deployer) {
  await deployer.deploy(Token);
}; 
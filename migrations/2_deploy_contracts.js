var assetRegister = artifacts.require("./AssetRegister.sol");
var assetRequest = artifacts.require("./AssetRequest.sol");
var assetToken = artifacts.require("./AssetToken.sol");
var BidRequests = artifacts.require("./BidRequests.sol");
var CToken = artifacts.require("./CToken.sol");
var MPAssetRequests = artifacts.require("./MPAssetRequests.sol");
var REAssets = artifacts.require("./REAssets.sol");
var RegReceipts = artifacts.require("./RegReceipts.sol");
var TxRegister = artifacts.require("./TxRegister.sol");
var Users = artifacts.require("./Users.sol");
var AssetTypes = artifacts.require("./AssetTypes.sol");


module.exports = function(deployer) {
  deployer.deploy(assetRegister);
  deployer.deploy(assetRequest);
  deployer.link(assetRegister,assetToken);
  deployer.deploy(assetToken);
  deployer.deploy(BidRequests);
  deployer.deploy(CToken);
  deployer.deploy(MPAssetRequests);
  deployer.deploy(REAssets);
  deployer.deploy(RegReceipts);
  deployer.deploy(TxRegister);
  deployer.deploy(Users);
  deployer.deploy(AssetTypes);
};

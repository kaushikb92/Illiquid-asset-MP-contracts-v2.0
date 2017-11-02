pragma solidity ^0.4.8;


contract AssetRegister{

    uint i;
    /* This will create an array of stracures to hold asset details*/ 
    assetDetails[] public Assets;

    /* Stracture to hold each user's details*/
    mapping(bytes32=> assetDetails)  assetDetailsByAID;

    struct assetIdsByType{
        bytes32[] AID;
    }

    mapping(bytes32=> assetIdsByType)  assetDetailsByAssetType;
   
    mapping(bytes32=> uint256) public marketPricePerAssetId;

    mapping(address=> mapping(bytes32=>bool)) public assetVisibility;
   
    /* Stracture to hold traded assets ids*/
    struct assetByOwner{
        bytes32[] AID;
    }

    /* Map to link traded asset ids for separate wallet addresses*/
    mapping(address => assetByOwner) assetsByOwner;

    /* Stracture to hold asset details*/
    struct assetDetails{
        bytes32 assetName;
        bytes32 assetType;
        bytes32 assetSubType;
        bytes32 assetID;
        uint timestamp;
    }

    /* Function to register a new asset*/
    function addNewAsset(bytes32 _assetName, bytes32 _assetType, bytes32 _assetSubType, bytes32 _assetID) returns (bool addAsset_Status){

        assetDetails memory newRegdAsset;
        newRegdAsset.assetName = _assetName;
        newRegdAsset.assetType = _assetType;
        newRegdAsset.assetID = _assetID;
        newRegdAsset.assetSubType = _assetSubType;
        newRegdAsset.timestamp = block.timestamp;
        Assets.push(newRegdAsset);

        //assetVisibility[_ownerOfAsset][_assetID] = true;
        assetDetailsByAID[_assetID] = newRegdAsset;
        assetDetailsByAssetType[_assetType].AID.push(_assetID);
        //assetWalletAddress[_ownerOfAsset] = _assetID;
        //assetQuantityOfOwner[_ownerOfAsset][_assetID] = _quantity;
        //assetPrice[_assetID] = _priceOfEach;
        //assetsByOwner[_ownerOfAsset].AID.push(_assetID);

        return true;
    }

    function getAssetIdByType(bytes32 _assetType) constant returns(bytes32[]){
        return (assetDetailsByAssetType[_assetType].AID);
    }

    function getAllAssetDetails(bytes32 _assetID) constant returns(bytes32[],uint[],bytes32[],bytes32[],bytes32[]){
        uint length = Assets.length;
        bytes32[] memory assetIDs = new bytes32[](length);
        bytes32[] memory assetNames = new bytes32[](length);
        bytes32[] memory assetTypes = new bytes32[](length);
        bytes32[] memory assetSubTypes = new bytes32[](length);
        uint[] memory timestamps = new uint[](length); 

        for (i = 0; i < length; i++) {

                assetDetails memory currentAsset;
                currentAsset = Assets[i];
                assetIDs[i] = currentAsset.assetID;
                timestamps[i] = currentAsset.timestamp;
                assetTypes[i] = currentAsset.assetType;
                assetSubTypes[i] = currentAsset.assetSubType;
                assetNames[i] = currentAsset.assetName;
                
            }
            return(assetIDs,timestamps,assetTypes,assetNames,assetSubTypes);
    }


    function setMarketPrice(bytes32 _assetID,uint256 _marketPrice) returns (bool _success){
        marketPricePerAssetId[_assetID] = _marketPrice;
        return true;
    }

    function getMarketPrice(bytes32 _assetID) constant returns(uint256){
        return (marketPricePerAssetId[_assetID]);
    }

    function addAssetWithWalletInReg(address _newOwner, bytes32 _assetID) returns (bool _success){
        assetsByOwner[_newOwner].AID.push(_assetID);
        return true;
    }

    function getAsseTIdsForUser(address _owner) constant returns(bytes32[]){
        return (assetsByOwner[_owner].AID);
    }

    function getNoOfAssetsOwned(address _owner) constant returns(uint){
        return (assetsByOwner[_owner].AID.length);
    }

    /* Function to list an asset in marketplace*/
    function enableVisibility(address _owner, bytes32 _assetID) returns (bool success){
        if (!assetVisibility[_owner][_assetID])
        {
            assetVisibility[_owner][_assetID] = true;
        }
        else
        {
            throw;
        }
        return true;
    }

    /* Function to remove an asset from marketplace list by its assetid and seller's address*/
    function disableVisibility(address _owner, bytes32 _assetID) returns (bool success){
        if (assetVisibility[_owner][_assetID])
        {
            assetVisibility[_owner][_assetID] = false;
        }
        else
        {
            throw;
        }
        return true;
    }

    function addAssetWithWalletAfterSell(address _newOwner, bytes32 _assetID) returns (bool success){
        uint length = assetsByOwner[_newOwner].AID.length;
        bytes32[] memory assetIDs = new bytes32[](length);
        uint count = 0;
        assetIDs = assetsByOwner[_newOwner].AID;

        for(uint i = 0; i<length; i++){

            if (assetIDs[i] == _assetID){
                count += 1;
            }
        }

        if (count < 1)
        {
            assetsByOwner[_newOwner].AID.push(_assetID);
            return true;
        }
        else
        {
            throw;
        }
    }




}
pragma solidity ^0.4.8;
import "./AssetRegister.sol";


contract AssetToken is AssetRegister{
    /* Public variables of the token */
    address public ATOwner;

   /* This creates an array with asset balances to asset ids and wallet address */
    mapping(bytes32=>mapping(address=>uint256)) public balanceATOfUsers;
    mapping(bytes32=>mapping(address=>uint256)) public aquisitionPriceOfUsers;
    mapping(bytes32=>mapping(address=>uint256)) public offerPriceOfUsers;
    mapping(bytes32=>uint256) public highOfferPricePerAsset;
    mapping(bytes32=>uint256) public lowOfferPricePerAsset;
    mapping(bytes32=>uint256) public currentQuantityOfAsset;

    

    /* This generates a public event on the blockchain that will notify clients */
    event assetTransfer(address indexed from, address indexed to, uint256 value, bytes32 assetName);

    struct assetHolders{
        address[] holders;
    }

    mapping(bytes32=> assetHolders) mapAssetholders;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function AToken() {
             ATOwner = msg.sender; 
    }

    uint i;

    function increaseAssetCount(bytes32 _assetID, uint _count) returns (bool _success){
        uint count = currentQuantityOfAsset[_assetID];
        count =+_count;
        currentQuantityOfAsset[_assetID] = count;
        return true;
    }

    /* Function to mint tokens as per the registered asset's details with the seller's wallet address*/
    function setAssetToken(address _assetOwner, bytes32 _assetID, uint256 _tokensToMint, uint256 _aquisitionPrice, uint256 _offerPrice) returns (bool success){
        if(!(AssetRegister.checkAssetHolding(_assetOwner,_assetID))){
        balanceATOfUsers[_assetID][_assetOwner] = _tokensToMint;
        aquisitionPriceOfUsers[_assetID][_assetOwner] = _aquisitionPrice;
        AssetRegister.addAssetWithWalletInReg(_assetOwner,_assetID);
        mapAssetholders[_assetID].holders.push(_assetOwner);
        offerPriceOfUsers[_assetID][_assetOwner] = _offerPrice;
        }
        else{
            balanceATOfUsers[_assetID][_assetOwner] += _tokensToMint;
            aquisitionPriceOfUsers[_assetID][_assetOwner] = _aquisitionPrice;
            offerPriceOfUsers[_assetID][_assetOwner] = _offerPrice;
        }

        bool c = increaseAssetCount(_assetID, _tokensToMint);
        bool a = setHighAcqPrice(_assetID, _offerPrice);
        bool b = setLowAcqPrice(_assetID, _offerPrice);
        
        return true;
    }

    function checkAssetQuantity(bytes32 _assetID) constant returns(uint){
        return (currentQuantityOfAsset[_assetID]);
    }

    function setHighAcqPrice(bytes32 _assetID, uint256 _offerPrice) returns (bool _success){
        if (highOfferPricePerAsset[_assetID] <= _offerPrice ){
            highOfferPricePerAsset[_assetID] = _offerPrice;
            }
    }

    function setLowAcqPrice(bytes32 _assetID, uint256 _offerPrice) returns (bool _success){
        if (lowOfferPricePerAsset[_assetID] == 0){
            lowOfferPricePerAsset[_assetID] = _offerPrice;
        }
        
        else if (lowOfferPricePerAsset[_assetID] >= _offerPrice ){
            lowOfferPricePerAsset[_assetID] = _offerPrice;
            }
    }

    function getHighAndLowOfferPrice(bytes32 _assetID) constant returns(uint256, uint256){
        return (highOfferPricePerAsset[_assetID],lowOfferPricePerAsset[_assetID]);
    }

    function getAssetHolders(bytes32 _assetId) constant returns(address[]){
        return (mapAssetholders[_assetId].holders);
    }

    function getAssetHoldersAndDetails(bytes32 _assetID) constant returns(address[],uint256[],uint256[],uint256[]){
        uint length = mapAssetholders[_assetID].holders.length;
        address[] memory holderAddresses = new address[](length);
        uint256[] memory aquisitionPrices = new uint256[](length);
        uint256[] memory ownedQuantities = new uint256[](length);
        uint256[] memory offerPrices = new uint256[](length);
        holderAddresses = mapAssetholders[_assetID].holders;

        for (i=0;i<length;i++) {
            address holder = holderAddresses[i];
            aquisitionPrices[i] = aquisitionPriceOfUsers[_assetID][holder];
            ownedQuantities[i] = balanceATOfUsers[_assetID][holder];
            offerPrices[i] = offerPriceOfUsers[_assetID][holder];
        }
        return (holderAddresses, aquisitionPrices, ownedQuantities,offerPrices);
    }

    function getAssetHoldingsOfUser(address _owner) constant returns(bytes32[],uint256[],uint256[],uint256[]){
        uint length = AssetRegister.getNoOfAssetsOwned(_owner);
        bytes32[] memory assetIDs = new bytes32[](length);
        uint256[] memory aquisitionPrices = new uint256[](length);
        uint256[] memory ownedQuantities = new uint256[](length);
        assetIDs = AssetRegister.getAssetIDsForUser(_owner);
        uint256[] memory assetMarketPrices = new uint256[](length);

        for (i=0;i<length;i++){
            bytes32 _assetId = assetIDs[i];
            aquisitionPrices[i] = aquisitionPriceOfUsers[_assetId][_owner];
            ownedQuantities[i] = balanceATOfUsers[_assetId][_owner];
            assetMarketPrices[i] = offerPriceOfUsers[_assetId][_owner];
        }
        return (assetIDs,aquisitionPrices,ownedQuantities,assetMarketPrices);
    }

    function getAquisitionPriceOfuser(address _assetOwner,bytes32 _assetID) constant returns (uint256){
        return aquisitionPriceOfUsers[_assetID][_assetOwner];
    }

    function setAcquisitonPrice(address _assetOwner,bytes32 _assetID, uint256 _newPrice) returns (bool _success){
        aquisitionPriceOfUsers[_assetID][_assetOwner] = _newPrice;
        return true;
    }

    /* Function to get asset balance of an user by user's wallet address and asset's asset id*/
    function getAssetBalanceOfUser(address _holder, bytes32 _assetID) constant returns(uint256){
        uint256 _bal = balanceATOfUsers[_assetID][_holder];
        return _bal;
    }

    function addAssetHolders(bytes32 _assetID,address _holder) constant returns(bool success){
        uint length = mapAssetholders[_assetID].holders.length;
        address[] memory holderAddresses = new address[](length);
        uint count = 0;
        holderAddresses = mapAssetholders[_assetID].holders;

        for(uint i = 0; i<length; i++){

            if (holderAddresses[i] == _holder){
                count += 1;
            }
        }

        if (count < 1)
        {
            mapAssetholders[_assetID].holders.push(_holder);
            return true;
        }
        else
        {
            return false;
        }
        return true;
    }

    /* Function to trade asset from seller to buyer */
    function ATtransfer( bytes32 _assetID, address _from, address _to, uint256 _value, uint256 _pricePerAsset) returns (bool success) {
        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address
        if (balanceATOfUsers[_assetID][_from] < _value) throw;           // Check if the sender has enough
        if (balanceATOfUsers[_assetID][_to] + _value < balanceATOfUsers[_assetID][_to]) throw; // Check for overflows
        balanceATOfUsers[_assetID][_from] -= _value;                     // Subtract from the sender
        balanceATOfUsers[_assetID][_to] += _value;
        setAcquisitonPrice(_to,_assetID,_pricePerAsset);
        assetTransfer(_from, _to, _value, _assetID);                   // Notify anyone listening that this transfer took place
        addAssetHolders(_assetID,_to);
        AssetRegister.addAssetWithWalletAfterSell(_to,_assetID);
        return true;
    }   
}
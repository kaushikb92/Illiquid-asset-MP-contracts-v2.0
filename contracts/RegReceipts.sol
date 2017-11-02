pragma solidity ^0.4.8;

contract RegReceipts{

    struct ownerAssetReg{
        bytes8 receiptId;
        bytes32 assetId;
        uint quantity;
        uint256 acqPrice;
        uint256 marketPrice;
    }

    ownerAssetReg[] public AllAssetRegs;

    mapping (bytes8=>ownerAssetReg) assetRegsbyReceiptId;

    struct ownerRegReceipts{
        bytes8[] receiptId;
    }

    mapping(bytes32=>ownerRegReceipts) regReceiptsByUser;

    uint i;

    function addRegReceipt(bytes8 _receiptId, bytes32 _assetId, uint _quantity, uint256 _acqPrice, uint256 _mp,bytes32 _userId) returns (bool _success){
        ownerAssetReg memory newAssetReg;
        newAssetReg.receiptId = _receiptId;
        newAssetReg.assetId = _assetId;
        newAssetReg.quantity = _quantity;
        newAssetReg.acqPrice = _acqPrice;
        newAssetReg.marketPrice = _mp;

        AllAssetRegs.push(newAssetReg);

        regReceiptsByUser[_userId].receiptId.push(_receiptId);

        assetRegsbyReceiptId[_receiptId] = newAssetReg;

    }

    function getAssetRegReceiptsByUser(bytes32 _userId) constant returns(bytes8[],bytes32[],uint[],uint256[],uint256[]){
        uint length = regReceiptsByUser[_userId].receiptId.length;
        bytes8[] memory receiptIds = new bytes8[](length);
        bytes32[] memory assetIds = new bytes32[](length);
        uint[] memory quantities = new uint[](length);
        uint256[] memory acqPrices = new uint256[](length);
        uint256[] memory marketPrices = new uint256[](length); 

        receiptIds = regReceiptsByUser[_userId].receiptId;

        for (i=0;i<length;i++){
            bytes8 _receiptId = receiptIds[i];
            assetIds[i] = assetRegsbyReceiptId[_receiptId].assetId;
            quantities[i] = assetRegsbyReceiptId[_receiptId].quantity;
            acqPrices[i] = assetRegsbyReceiptId[_receiptId].acqPrice;
            marketPrices[i] = assetRegsbyReceiptId[_receiptId].marketPrice;
        }return(receiptIds,assetIds,quantities,acqPrices,marketPrices);
    }
    

}

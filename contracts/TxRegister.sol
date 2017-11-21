pragma solidity ^0.4.8;

contract TxRegister{

    /* Stracture to hold each trade's details*/
    struct receipt{
        bytes8 receiptId;
        bytes32 txid1;
        bytes32 txid2;
        bytes32 sellerId;
        bytes32 buyerId;
        bytes32 assetID;
        uint assetQuantity;
        uint256 totalAmount;
        uint256 timestamp;
    }

    /* This will create an array of stracures to hold trade details*/ 
    receipt[] public receipts; 

    struct receiptsByClientId{
        bytes8[] receiptId;
    }

    struct receiptsByAssetId{
        bytes8[] receiptId;
    }

    uint length;
    uint i;
    bytes8 currentReceiptId;

    /* Different mapping definations */
    mapping(bytes32=>receiptsByClientId) transactionsByAddress;           //Map user's associated wallet ClientId with his trade receipts 

    mapping(bytes32=>receiptsByAssetId) transactionByAssetId;

    mapping(bytes8=>receipt) receiptsByReceiptId;

    /* Function to add a new transaction*/
    function addTx (bytes8 _receiptId, bytes32 _assetTxid, bytes32 _currencyTxid, bytes32 _from, bytes32 _to, bytes32 _assetID, uint _assetQuantity, uint256 _totalAmount, uint256 _timestamp) returns (bool success){
        receipt memory newReceipt;
        newReceipt.receiptId = _receiptId;
        newReceipt.txid1 = _assetTxid;
        newReceipt.txid2 = _currencyTxid;
        newReceipt.sellerId = _to;
        newReceipt.buyerId = _from;
        newReceipt.assetID = _assetID;
        newReceipt.assetQuantity = _assetQuantity;
        newReceipt.totalAmount = _totalAmount;
        newReceipt.timestamp = _timestamp;
        receipts.push(newReceipt);

        transactionByAssetId[_assetID].receiptId.push(_receiptId);
        transactionsByAddress[_from].receiptId.push(_receiptId);
        transactionsByAddress[_to].receiptId.push(_receiptId);
        receiptsByReceiptId[_receiptId] = newReceipt;
                
        return true;
    }

    /* Function to query a transaction recept by associated wallet ClientId */
    function getReceiptIdsByClientId(bytes32 _addr) constant returns(bytes8[]){
        uint length = transactionsByAddress[_addr].receiptId.length;
        bytes8[] memory receiptId = new bytes8[](length);
        receiptId = transactionsByAddress[_addr].receiptId;
        return (receiptId);
    }

    // function getReceiptIdsByAssetId(bytes32 _assetId) constant returns(bytes8[]){
    //     uint length = transactionByAssetId[_assetId].receiptId.length;
    //     bytes8[] memory receiptId = new bytes8[](length);
    //     receiptId = transactionByAssetId[_assetId].receiptId;
    //     return (receiptId);
    // }



    function getReceiptByReceiptId(bytes8 _receiptId) constant returns(bytes32,bytes32,bytes32,bytes32,bytes32,uint,uint256){
        return (receiptsByReceiptId[_receiptId].txid1,
        receiptsByReceiptId[_receiptId].txid2,
        receiptsByReceiptId[_receiptId].sellerId,
        receiptsByReceiptId[_receiptId].buyerId,
        receiptsByReceiptId[_receiptId].assetID,
        receiptsByReceiptId[_receiptId].assetQuantity,
        receiptsByReceiptId[_receiptId].totalAmount);
    }



    function getReceiptIdsByAssetId(bytes32 _assetId) constant returns(bytes8[]){
        length = transactionByAssetId[_assetId].receiptId.length;
        bytes8[] memory receiptId = new bytes8[](length);
        receiptId = transactionByAssetId[_assetId].receiptId;
        return (receiptId);
    }

    function getAssetHistoryByAssetId(bytes32 _assetId) constant returns(bytes8[],bytes32[],bytes32[],uint256[],uint[],uint256[]){
        length = transactionByAssetId[_assetId].receiptId.length;
        bytes8[] memory receiptIds = new bytes8[](length);
        bytes32[] memory sellerIds = new bytes32[](receipts.length);
        bytes32[] memory buyerIds = new bytes32[](receipts.length);
        uint256[] memory totalAmounts = new uint256[](receipts.length);
        uint[] memory assetQuantities = new uint[](receipts.length);
        uint256[] memory timestamps = new uint256[](receipts.length);
        receiptIds = transactionByAssetId[_assetId].receiptId;
        for (i=0;i<length;i++){
            currentReceiptId = receiptIds[i];
            sellerIds[i] = receiptsByReceiptId[currentReceiptId].sellerId;
            buyerIds[i] = receiptsByReceiptId[currentReceiptId].buyerId;
            totalAmounts[i] = receiptsByReceiptId[currentReceiptId].totalAmount;
            assetQuantities [i] = receiptsByReceiptId[currentReceiptId].assetQuantity;
            timestamps[i] = receiptsByReceiptId[currentReceiptId].timestamp;
        }
        return (receiptIds,sellerIds,buyerIds,totalAmounts,assetQuantities,timestamps);
    }

    function getTimestampByReceiptid(bytes8 _receiptId) constant returns(uint256){
        return (receiptsByReceiptId[_receiptId].timestamp);
    }

    /* Function to get all transaction receipts*/
    function getAllTxDetails1() constant returns (bytes32[] , bytes32[], bytes32[] , bytes32[] , bytes32[]) {

        bytes32[] memory txids1 = new bytes32[](receipts.length);
        bytes32[] memory txids2 = new bytes32[](receipts.length);
        bytes32[] memory senders = new bytes32[](receipts.length);
        bytes32[] memory receivers = new bytes32[](receipts.length);
        bytes32[] memory receiptIds = new bytes32[](receipts.length);
        uint256[] memory totalAmounts = new uint256[](receipts.length);
        uint[] memory assetQuantities = new uint[](receipts.length);
        
        for (i = 0; i < receipts.length; i++) {
 
            receipt memory currentReceipt;
            currentReceipt = receipts[i];
            txids1[i] = currentReceipt.txid1;
            txids2[i] = currentReceipt.txid2;
            senders[i] = currentReceipt.buyerId;
            receivers[i] = currentReceipt.sellerId;
            receiptIds[i] = currentReceipt.receiptId;
        }
    return(txids1,txids2,senders, receivers, receiptIds);
    }

     function getAllTxDetails2() constant returns (bytes32[] , uint[] , uint256[],uint256[]) {

        bytes32[] memory assetIDs = new bytes32[](receipts.length);
        uint256[] memory totalAmounts = new uint256[](receipts.length);
        uint[] memory assetQuantities = new uint[](receipts.length);
        uint256[] memory timestamps = new uint256[](receipts.length);
        for (i = 0; i < receipts.length; i++) {
 
            receipt memory currentReceipt;
            currentReceipt = receipts[i];
            assetIDs[i] = currentReceipt.assetID;
            assetQuantities[i] = currentReceipt.assetQuantity;
            totalAmounts[i] = currentReceipt.totalAmount;
            timestamps[i] = currentReceipt.timestamp;
        }
    return(assetIDs, assetQuantities, totalAmounts,timestamps);
    }

}
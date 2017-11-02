pragma solidity ^0.4.8;

contract BidRequests{
    
    struct bidRequest{
        bytes32 assetId;
        bytes32 sellerId;
        bytes32 buyerId;
        uint256 bidAmount;
        uint bidQuantity;
        uint timestamp;
        bytes8 bidId;
    }

    bidRequest[] public allBidRequest;

    mapping(bytes8=>bidRequest) public bidRequestById;
    mapping(bytes8=>bool) public bidRequestStatus;

    mapping(bytes32=>uint) public mapDeadline;

    struct bidByAssetId{
        bytes8[] bidId;
    }

    mapping(bytes32=>mapping(bytes32=>bidByAssetId)) bidRequestOnAssetByAssetId;

    struct bidsByBuyer{
        bytes8[] bidId;
    }

    mapping (bytes32=>bidsByBuyer) mapBidsByBuyer;

    mapping (bytes32=>mapping(bytes32=>bytes8)) mapBidsByBuyerWithAssetId;

    function addNewBid( bytes32 _assetId, bytes32 _sellerId,bytes32 _buyerId,uint256 _bidAmount,uint _bidQuantity,bytes8 _bidId, address _requestRaiser)returns (bool _status){

        bidRequest memory currentBid;
        currentBid.assetId = _assetId;
        currentBid.sellerId = _sellerId;
        currentBid.buyerId = _buyerId;
        currentBid.bidAmount = _bidAmount;
        currentBid.bidQuantity = _bidQuantity;
        currentBid.timestamp = block.timestamp;
        currentBid.bidId = _bidId;
        allBidRequest.push(currentBid);

        mapDeadline[_bidId] = now + 2 * 24 * 60 * 1 minutes;


        mapBidsByBuyerWithAssetId[_assetId][_buyerId] = _bidId;
        bidRequestOnAssetByAssetId[_sellerId][_assetId].bidId.push(_bidId);
        mapBidsByBuyer[_buyerId].bidId.push(_bidId);
        bidRequestById[_bidId] = currentBid;
        bidRequestStatus[_bidId] = false;

        return true;
    }

    function getAllBidsByBuyer(bytes32 _buyerId) constant returns (bytes8[]){
        uint length = mapBidsByBuyer[_buyerId].bidId.length;
        bytes8[] memory requestIds = new bytes8[](length);
        requestIds = mapBidsByBuyer[_buyerId].bidId;
        return (requestIds);
    }

    function getBidsByAssetIdAndSellerId(bytes32 _assetId,bytes32 _sellerId) constant returns (bytes8[]){
        uint length = bidRequestOnAssetByAssetId[_sellerId][_assetId].bidId.length;
        bytes8[] memory requestIds = new bytes8[](length);
        requestIds = bidRequestOnAssetByAssetId[_sellerId][_assetId].bidId;
        return (requestIds);
    }

    function getBidsByBidId(bytes8 _bidId) constant returns (bytes32,bytes32,bytes32,uint256,uint,uint,bool){
        return (bidRequestById[_bidId].assetId,bidRequestById[_bidId].sellerId,bidRequestById[_bidId].buyerId,bidRequestById[_bidId].bidAmount,bidRequestById[_bidId].bidQuantity,bidRequestById[_bidId].timestamp,bidRequestStatus[_bidId]);
    }

    function approveBid(bytes8 _bidId) returns (bool success){
        if (now >= mapDeadline[_bidId]) throw;
        bidRequestStatus[_bidId] = true;
        return true;
    }

    function getBidStatus(bytes8 _bidId) constant returns (bool){
        return bidRequestStatus[_bidId];
    }


    //  function getAllBidsNotApproaved() constant returns (bytes32[],bytes32[],bytes32[],uint256[],uint[],uint[],bytes32[]){
    //     uint length = allBidRequest.length;
    //     bytes32[] memory assetIds = new bytes32[](length);
    //     bytes32[] memory sellerIds = new bytes32[](length);
    //     bytes32[] memory buyerIds = new bytes32[](length);
    //     uint256[] memory bidAmounts = new uint256[](length);
    //     uint[] memory bidQuantitys = new uint[](length);
    //     uint[] memory timestamps = new uint[](length);
    //     bytes32[] memory bidIds = new bytes32[](length);

    //         for (var i = 0; i < length; i++) {

    //             bidRequest memory currentBid;
    //             currentBid = allBidRequest[i];
                
    //             if(!bidRequestStatus[currentBid.bidId])
    //             {
    //                 assetIds[i] = currentBid.assetId;
    //                 sellerIds[i] = currentBid.sellerId;
    //                 buyerIds[i] = currentBid.buyerId;
    //                 bidAmounts[i] = currentBid.bidAmount;
    //                 bidQuantitys[i] = currentBid.bidQuantity;
    //                 timestamps[i] = currentBid.timestamp;
    //                 bidIds[i] = currentBid.bidId;
    //             }
    //         }
    //         return(assetIds,sellerIds,buyerIds,bidAmounts,bidQuantitys,timestamps,bidIds);
    // }

    // function getAllBids() constant returns (bytes32[],bytes32[],bytes32[],uint256[],uint[],uint[],bytes8[],bool[]){
    //     uint length = allBidRequest.length;
    //     bytes32[] memory assetIds = new bytes32[](length);
    //     bytes32[] memory sellerIds = new bytes32[](length);
    //     bytes32[] memory buyerIds = new bytes32[](length);
    //     uint256[] memory bidAmounts = new uint256[](length);
    //     uint[] memory bidQuantitys = new uint[](length);
    //     uint[] memory timestamps = new uint[](length);
    //     bytes8[] memory bidIds = new bytes8[](length);
    //     bool[] memory requestStatuses = new bool[](length);

    //         for (var i = 0; i < length; i++) {

    //             bidRequest memory currentBid;
    //             currentBid = allBidRequest[i];
    //             assetIds[i] = currentBid.assetId;
    //             sellerIds[i] = currentBid.sellerId;
    //             buyerIds[i] = currentBid.buyerId;
    //             bidAmounts[i] = currentBid.bidAmount;
    //             bidQuantitys[i] = currentBid.bidQuantity;
    //             timestamps[i] = currentBid.timestamp;
    //             bidIds[i] = currentBid.bidId;
    //             requestStatuses[i] = bidRequestStatus[currentBid.bidId];
    //         }
    //         return(assetIds,sellerIds,buyerIds,bidAmounts,bidQuantitys,timestamps,bidIds,requestStatuses);
    // }

    // function getBidsByWalletAddress(address _user,bytes32 _assetId) constant returns(bytes32[],bytes32[],bytes32[],uint256[],uint[],uint[],bytes8[],bool[]){
    //     uint length = bidRequestOnAssetByAddress[_user][_assetId].bidId.length;
    //     bytes32[] memory assetIds = new bytes32[](length);
    //     bytes32[] memory sellerIds = new bytes32[](length);
    //     bytes32[] memory buyerIds = new bytes32[](length);
    //     uint256[] memory bidAmounts = new uint256[](length);
    //     uint[] memory bidQuantitys = new uint[](length);
    //     uint[] memory timestamps = new uint[](length);
    //     bool[] memory requestStatuses = new bool[](length);
    //     bytes8[] memory bidIds = new bytes8[](length);
    //     bidIds =  bidRequestOnAssetByAddress[_user][_assetId].bidId;

    //     for (var i = 0; i < length; i++){
    //         bytes8 bidId = bidIds[i];
    //         assetIds[i] = bidRequestById[bidId].assetId;
    //         sellerIds[i] = bidRequestById[bidId].sellerId;
    //         buyerIds[i] = bidRequestById[bidId].buyerId;
    //         bidAmounts[i] = bidRequestById[bidId].bidAmount;
    //         bidQuantitys[i] = bidRequestById[bidId].bidQuantity;
    //         timestamps[i] = bidRequestById[bidId].timestamp;
    //         requestStatuses[i] = bidRequestStatus[bidId];
    //     }
    //     return(assetIds,sellerIds,buyerIds,bidAmounts,bidQuantitys,timestamps,bidIds,requestStatuses);
    // }

  
}
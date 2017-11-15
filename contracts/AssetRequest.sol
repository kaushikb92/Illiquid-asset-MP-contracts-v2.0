pragma solidity ^0.4.8;

contract AssetRequest{

    struct newAssetRequest{
        bytes32 requestId;
        bytes32 assetName;
        bytes32 companyName;
        bytes32 assetSubType;
        bytes32 description;
        uint timestamp;
    }
    
    newAssetRequest[] public allNewAssetRequests;

    mapping (bytes32=>newAssetRequest) public assetRequestsByRequestIds;
    mapping (bytes32=>bool) public newAssetRequestStatus;

    struct assetRequestsByAssetTypes{
        bytes32[] requestId;
    }

    mapping (bytes32=>assetRequestsByAssetTypes) mapAssetRequestsByAssetTypes;

    struct assetRequestsByUser{
        bytes32[] requestId;
    }

    mapping(address=>assetRequestsByUser) requestsByUsers;

    uint j;
    bytes32 requestID;

    function addNewAssetRequest(bytes32 _assetSubType,bytes32 _requestId, bytes32 _assetName, bytes32 _companyName, address _requestRaiser, bytes32 _assetType, bytes32 _description) returns (bool _status){

        newAssetRequest memory newRequest;
        newRequest.assetName = _assetName;
        newRequest.companyName = _companyName;
        newRequest.assetSubType = _assetSubType;
        newRequest.timestamp = block.timestamp;
        newRequest.description = _description;
        allNewAssetRequests.push(newRequest);

        requestsByUsers[_requestRaiser].requestId.push(_requestId);
        assetRequestsByRequestIds[_requestId] = newRequest;
        mapAssetRequestsByAssetTypes[_assetType].requestId.push(_requestId);
        newAssetRequestStatus[_requestId] = false;

        return true;
    }

    function getAssetRequestIdsByAddress(address _user) constant returns(bytes32[]){
        uint length = requestsByUsers[_user].requestId.length;
        bytes32[] memory requestIds = new bytes32[](length);
        requestIds = requestsByUsers[_user].requestId;
        return (requestIds);
    }

     function getAssetRequestIdsByAssetTypeForApproval(bytes32 _assetType) constant returns(bytes32[],bytes32[],bytes32[],bytes32[],bytes32[],uint[]){
        uint length = mapAssetRequestsByAssetTypes[_assetType].requestId.length;
        bytes32[] memory requestIds = new bytes32[](length);
        bytes32[] memory assetNames = new bytes32[](length);
        bytes32[] memory companyNames = new bytes32[](length);
        bytes32[] memory assetSubTypes = new bytes32[](length);
        bytes32[] memory descriptions = new bytes32[](length);
        uint[] memory timestamps = new uint[](length);
        requestIds = mapAssetRequestsByAssetTypes[_assetType].requestId;
        for (j=0;j<length;j++){
            requestID = requestIds[j];
            if(!newAssetRequestStatus[requestID]){
            assetNames[j] = assetRequestsByRequestIds[requestID].assetName;
            companyNames[j] = assetRequestsByRequestIds[requestID].companyName;
            assetSubTypes[j] = assetRequestsByRequestIds[requestID].assetSubType;
            descriptions[j] = assetRequestsByRequestIds[requestID].description;
            timestamps[j] = assetRequestsByRequestIds[requestID].timestamp;
            }
        }
        return (requestIds,assetNames,companyNames,assetSubTypes,descriptions,timestamps);
    }

    function getAssetRequestsById(bytes8 _requestId) constant returns(bytes32,bytes32,bytes32,uint,bool){
        return(assetRequestsByRequestIds[_requestId].assetName,
        assetRequestsByRequestIds[_requestId].companyName,
        assetRequestsByRequestIds[_requestId].assetSubType,
        assetRequestsByRequestIds[_requestId].timestamp,
        newAssetRequestStatus[_requestId]);
    }

    function getAllAssetRequestsForApproval() constant returns (bytes32[], bytes32[],bytes32[],uint[],bytes32[]){
        uint length = allNewAssetRequests.length;
        bytes32[] memory assetNames = new bytes32[](length);
        bytes32[] memory companyNames = new bytes32[](length);
        bytes32[] memory asseetSubTypes = new bytes32[](length);
        uint[] memory timestamps = new uint[](length);
        bytes32[] memory requestIds = new bytes32[](length);

            for (j = 0; j < length; j++) {

                newAssetRequest memory currentRequest;
                currentRequest = allNewAssetRequests[j];
                
                if(!newAssetRequestStatus[currentRequest.requestId])
                {
                    assetNames[j] = currentRequest.assetName;
                    companyNames[j] = currentRequest.companyName;
                    asseetSubTypes[j] = currentRequest.assetSubType;
                    timestamps[j] = currentRequest.timestamp;
                    requestIds[j] = currentRequest.requestId;
                }
            }
            return(assetNames,companyNames,asseetSubTypes,timestamps,requestIds);
    }

    function approveAssetRequest(bytes32 _requestId) returns (bool success){
        newAssetRequestStatus[_requestId] = true;
        return true;
    }

    function getRequestStatus(bytes32 _requestId) constant returns (bool){
        return newAssetRequestStatus[_requestId];
    }

    // function getAllAssetRequests() constant returns (bytes32[],bytes32[],bytes32[],bytes32[],uint[],bytes32[],bool[]){
    //     //uint length = allNewAssetRequests.length;
    //     bytes32[] memory assetNames = new bytes32[](allNewAssetRequests.length);
    //     bytes32[] memory assetTypes = new bytes32[](allNewAssetRequests.length);
    //     bytes32[] memory companyNames = new bytes32[](allNewAssetRequests.length);
    //     bytes32[] memory asseetSubTypes = new bytes32[](allNewAssetRequests.length);
    //     uint[] memory timestamps = new uint[](allNewAssetRequests.length);
    //     bytes32[] memory requestIds = new bytes32[](allNewAssetRequests.length);
    //     bool[] memory requestStatuses = new bool[](allNewAssetRequests.length);

    //         for (var j = 0; j < allNewAssetRequests.length; j++) {

    //             newAssetRequest memory currentRequest;
    //             currentRequest = allNewAssetRequests[j];
    //             assetNames[j] = currentRequest.assetName;
    //             assetTypes[j] = currentRequest.assetType;
    //             companyNames[j] = currentRequest.companyName;
    //             asseetSubTypes[j] = currentRequest.assetSubType;
    //             timestamps[j] = currentRequest.timestamp;
    //             requestIds[j] = currentRequest.requestId;
    //             requestStatuses[j] = newAssetRequestStatus[currentRequest.requestId];
    //         }
    //         return(assetNames,assetTypes,companyNames,asseetSubTypes,timestamps,requestIds,requestStatuses);
    // }

    // function getNewAssetRequestByWalletAddress(address _user) constant returns(bytes32[],bytes32[],bytes32[],bytes32[],bytes32[],uint[],bool[]){
    //     uint length = requestsByUsers[_user].requestId.length;
    //     bytes32[] memory assetNames = new bytes32[](length);
    //     bytes32[] memory assetTypes = new bytes32[](length);
    //     bytes32[] memory companyNames = new bytes32[](length);
    //     bytes32[] memory asseetSubTypes = new bytes32[](length);
    //     uint[] memory timestamps = new uint[](length);
    //     bytes32[] memory requestIds = new bytes32[](length);
    //     bool[] memory requestStatuses = new bool[](length);

    //     requestIds = requestsByUsers[_user].requestId;
    //     for (var j = 0; j < length; j++){
    //         bytes32 requestId = requestIds[j];
    //         assetNames[j] = assetRequestsByRequestIds[requestId].assetName;
    //         assetTypes[j] = assetRequestsByRequestIds[requestId].assetType;
    //         companyNames[j] = assetRequestsByRequestIds[requestId].companyName;
    //         asseetSubTypes[j] = assetRequestsByRequestIds[requestId].asseetSubType;
    //         timestamps[j] = assetRequestsByRequestIds[requestId].timestamp;
    //         requestStatuses[j] = newAssetRequestStatus[requestId];
    //     }
    //     return(requestIds,assetNames,assetTypes,companyNames,asseetSubTypes,timestamps,requestStatuses);
    // }

}
pragma solidity ^0.4.8;

contract Users{

    /* This will create an array of stracures to hold user details*/    
    User[] public Users;

    /* Different mapping definations */
    mapping(uint=>address) public MobilesWithUserAddresses;         //Map user wallet addresses with registered mobile number 
    mapping(address=>bytes32) public PasswordsWithAddress;          //Map user account password with associated wallet address
    mapping(address=>bytes32) public UserIDsWithAddress;            //Map user's unique ID with associated wallet address
    mapping(address=>User) public userDetails;                      //Map user details with associated wallet address
    mapping(bytes32=>address) public userlogin;                     //Map user's associated wallet address with unique ID 

    /* Stracture to hold each user's details*/
    struct User{
        bytes32 firstName;
        bytes32 lastName;
        bytes32 userID;
	    uint mobile;
        uint DBAccountNo;
    }

    /* Function to register a new user*/
    function addNewUser(bytes32 _firstName, bytes32 _lastName, address _walletAddr, bytes32 _userID, uint _DBAccountNo, bytes32 _userPwd, uint _mobile) returns (bool addUser_status){
        User memory newRegdUser;
    
        newRegdUser.firstName = _firstName;
        newRegdUser.lastName = _lastName;
        newRegdUser.userID =_userID;
        newRegdUser.mobile =_mobile; 
        newRegdUser.DBAccountNo = _DBAccountNo;
        
        Users.push(newRegdUser);

        MobilesWithUserAddresses[_mobile] = _walletAddr;
        UserIDsWithAddress[_walletAddr] = _userID;
        PasswordsWithAddress[_walletAddr] = _userPwd;
        userDetails[_walletAddr] = newRegdUser; 
        userlogin[_userID] = _walletAddr;

        return true; 
    }

    function getAdminLogin(bytes32 _userID,bytes32 _userPwd) constant returns (bool _status){
        if (_userID == "ADMIN123") {
            if (_userPwd == "12345" ){
                return true;
            }
        }
        else{
            return false;
        }
        return false;
    }

    /* Function to query user details with associated wallet address*/
    function getUserDetailsByWallet(address _walletAddr) constant returns (bytes32, bytes32, bytes32, uint, uint){
        bytes32 _firstName = userDetails[_walletAddr].firstName;
        bytes32 _lastName = userDetails[_walletAddr].lastName;
        uint _DBAccountNo = userDetails[_walletAddr].DBAccountNo;
        bytes32 _userID = userDetails[_walletAddr].userID ;
        uint _mobile = userDetails[_walletAddr].mobile;

        return (_firstName,_lastName,_userID,_DBAccountNo,_mobile);
    }

    /* Function to get all user IDs */
    function getUserIDs() constant returns ( bytes32[] ){
        uint length = Users.length;
        bytes32[] memory userIDs = new bytes32[](length);
    
        for (var i = 0; i < length; i++) {
                User memory currentUser;
                currentUser = Users[i];
                userIDs[i] = currentUser.userID;
            }
            return userIDs;
    }

     /* Function to get details of all users */
    function getUsersDetails() constant returns (bytes32[], bytes32[], bytes32[], uint[], uint[]){
        uint length = Users.length;
        bytes32[] memory firstNames = new bytes32[](length);
        bytes32[] memory lastNames = new bytes32[](length);
        uint[] memory DBAccountNos = new uint[](length);
        bytes32[] memory userIDs = new bytes32[](length);
        uint[] memory mobiles = new uint[](length);    
        for (var i = 0; i < length; i++) {
            User memory currentUser;
            currentUser = Users[i];
            firstNames[i] = currentUser.firstName;
            lastNames[i] = currentUser.lastName;
            DBAccountNos[i] = currentUser.DBAccountNo;
            userIDs[i] = currentUser.userID;
            mobiles[i] = currentUser.mobile;
        }
        return(firstNames, lastNames, userIDs, DBAccountNos, mobiles);
    }

    /* Function to query UserID by registered mobile number */                                                                                                                                                        
    function getUserIDbyMobNumber(uint _mobile) constant returns (bytes32 ){
        address _owner = MobilesWithUserAddresses[_mobile];
        return UserIDsWithAddress[_owner];
    }

    /* Function to query User Passwords by associated wallet address */                                                                                                                                                                                                                                    function getPasswordbyMobNumber(uint _mobile) constant returns (bytes32 ){
        address _owner = MobilesWithUserAddresses[_mobile];        
        return PasswordsWithAddress[_owner];      
    }

    /* Function to query UserID by associated wallet address */                                                                                                                                                                                                                                    
    function getUsernameByAddress(address _addr) constant returns (bytes32,bytes32){
        return (userDetails[_addr].firstName,userDetails[_addr].lastName);
    }

    /* Function to query associated wallet address by UserID  */
    function getWalletByUserID(bytes32 _userid) constant returns(address){
        return userlogin[_userid];
    }

    /* Function to chack user's login credentials */
    function getLogin(bytes32 _userid, bytes32 _pwd) constant returns(bool){
        address addr = userlogin[_userid];
        bytes32 pwd = PasswordsWithAddress[addr];
        if(pwd == _pwd){return true;} else {return false;}
    }                                                                                                                                                                                                                                                                                                     

     /* Function to query UserID and account password by registered mobile number */                                                                                                                                   
    function getUserIDandPasswordbyMobNumber(uint _mobile) constant returns (bytes32, bytes32){
        address _owner = MobilesWithUserAddresses[_mobile];
        return ( UserIDsWithAddress[_owner], PasswordsWithAddress[_owner] );
    }
  }
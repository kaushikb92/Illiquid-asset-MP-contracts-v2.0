pragma solidity ^0.4.8;

contract CToken {
    /* Public variables of the token */
    address public CTOwner;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOfCT;
    mapping (address => mapping (address => uint256)) public allowanceOfCT;

    /* This generates a public event on the blockchain that will notify clients */
    event currencyTransfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function CToken() {
        CTOwner = msg.sender;                             
    }

    /* Function to set a currency balance to a wallet address */
    function setCTokenBalance(address _owner,uint256 _amount) returns (bool success){
        balanceOfCT[_owner] += _amount;            
        return true; 
    }

    /* Function to reset currency balance of user*/
    function resetCTokenBalance(address _owner) returns (bool success){
        balanceOfCT[_owner] = 0;            
        return true; 
    }

    /* Function to query currency balance by wallet address*/
    function getCTBalance(address _holder) constant returns(uint256){
        uint256 _bal = balanceOfCT[_holder];
        return _bal;
    }
  
    /* Function to send currency from buyer to seller */
    function CTtransferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address
        if (balanceOfCT[_from] < _value) throw;                 // Check if the buyer has enough
        if (balanceOfCT[_to] + _value < balanceOfCT[_to]) throw;  // Check for overflows
        balanceOfCT[_from] -= _value;                           // Subtract from the buyer
        balanceOfCT[_to] += _value;                             // Add the same to the seller
        currencyTransfer(_from, _to, _value);
        return true;
    }
}
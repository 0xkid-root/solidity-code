// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract MultiSig{
    address[] public owners;
    uint public numOfConfirmationRequired;

    struct Transaction{
        address to;
        uint value;
        bool executed;
    }

    Transaction[] public Transactions;

    mapping(uint=>mapping(address=>bool)) public isConfirmed;

    event TransactionSubmitted(uint transactionId,address sender,address receiver,uint amount);
    event TransactionConfirmed(uint transactionId,address sender);
    event TransactionExecuted(uint transactionId);

    constructor(address[] memory _owner,uint _numOfConfirmationRequired){
        require(_owner.length>1,"Owners required must be greater than 1");
        require(_numOfConfirmationRequired > 1 && _numOfConfirmationRequired <=_owner.length,"number os confirmation valide");
        for(uint i=0;i<_owner.length;i++){
            require(_owner[i] != address(0),"Invalide Owners");
            owners.push(_owner[i]);
        }
        numOfConfirmationRequired=_numOfConfirmationRequired;
    }

    function SubmitTransaction(address _to) public payable{
        require(_to != address(0),"invalide receiver address");
        require(msg.value>0,"Transfer amount must be greater than zero!");
        uint transactionId = Transactions.length;
        Transactions.push(Transaction({to:_to,value:msg.value,executed:false}));
        emit TransactionSubmitted(transactionId,msg.sender,_to,msg.value);

    }


    function confirmTransaction(uint _transactionId) public{
        require(_transactionId<Transactions.length,"Invalide Trannsaction ID");
        require(!isConfirmed[_transactionId][msg.sender],"You have already confirmed this transaction!");
        require(!Transactions[_transactionId].executed,"Transaction already executed!");   

        isConfirmed[_transactionId][msg.sender] = true;
        emit  TransactionConfirmed(_transactionId,msg.sender);

        if(isTransactionConfirmed(_transactionId)){
            executeTransaction(_transactionId);
        }


    }

    function executeTransaction(uint _transactionId) public payable{
        require(_transactionId<Transactions.length,"Invalid Transaction ID!!");
        require(!Transactions[_transactionId].executed,"Transaction already executed!");
        (bool success,) = Transactions[_transactionId].to.call{value: Transactions[_transactionId].value}("");
        require(success,"Transaction Execution Failled!!");
        Transactions[_transactionId].executed= true;
        emit TransactionExecuted(_transactionId);



    }









    function isTransactionConfirmed(uint _transactionId) internal view returns(bool){
        require(_transactionId<Transactions.length,"Invalide Trannsaction ID");

        uint confirmationCount; // initial zero 

        for(uint i=0;i<owners.length;i++){
            if(isConfirmed[_transactionId][owners[i]]){
                confirmationCount++;
            }

        } 
        return confirmationCount>=numOfConfirmationRequired;



    } 
}


// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]
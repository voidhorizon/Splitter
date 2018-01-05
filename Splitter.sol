pragma solidity ^0.4.8;

contract Splitter {
 
    address public owner;
    mapping(address => uint) public  allotment;
    
    event LogSplitAllocation(address _allocationAddress, uint splitAmount);
    event LogWithdrawal(address withdrawer, uint withdrawnAmount);
    
     function Splitter(address _owner) 
        public
    {
        owner   = _owner;
    }
    
    function split( address firstReceiver, address secondReceiver )
        public
        payable
        returns (bool success)
    {
        require(msg.value != 0);
        require(msg.value > 1);
        require(firstReceiver != 0 || secondReceiver != 0);
        require(msg.sender != 0);
        
       uint amountToSplit = msg.value;
       uint splitAmount = 0;
        
        
        if (amountToSplit % 2 == 0) { 
           splitAmount = amountToSplit/2;
        }
        else {
           splitAmount = (amountToSplit - 1) /2;
            allotment[msg.sender] += 1;
            LogSplitAllocation (msg.sender, 1);
        }
        
        allotment[firstReceiver] += splitAmount;
        allotment[secondReceiver] += splitAmount;
       
       LogSplitAllocation (firstReceiver,splitAmount);
       LogSplitAllocation (secondReceiver,splitAmount); 
       
        return true;
    }
    
     function withdraw()
        public
        returns (bool success)
    {
       require(allotment[msg.sender] != 0);
       uint amountToWithdraw = allotment[msg.sender];
       
        allotment[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
      
        LogWithdrawal(msg.sender, amountToWithdraw);
       
        return true;
    }
    
    
    function killMe()
        public
    {
        if (msg.sender == owner) selfdestruct(owner);
    }

   
    function () public {}
        
}

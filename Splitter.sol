pragma solidity ^0.4.8;

contract Splitter {
 
    address public owner;
    mapping(address => uint) public  SplitterStructs;
    
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
        if(msg.value == 0) revert();
        if(msg.value < 2) revert();
        if(firstReceiver == 0 || secondReceiver == 0) revert();
        if(msg.sender == 0) revert();
        
       uint amountToSplit = msg.value;
       uint splitAmount = 0;
        
        
        if (amountToSplit % 2 == 0) { 
           splitAmount = amountToSplit/2;
        }
        else {
           splitAmount = (amountToSplit - 1) /2;
            SplitterStructs[msg.sender] += 1;
            LogSplitAllocation (msg.sender, 1);
        }
        
        SplitterStructs[firstReceiver] += splitAmount;
        SplitterStructs[secondReceiver] += splitAmount;
       
       LogSplitAllocation (firstReceiver,splitAmount);
       LogSplitAllocation (secondReceiver,splitAmount); 
       
        return true;
    }
    
     function withdraw()
        public
        returns (bool success)
    {
       if(SplitterStructs[msg.sender] == 0)  return false;
       uint amountToWithdraw = SplitterStructs[msg.sender];
       
        SplitterStructs[msg.sender] = 0;
       if(!msg.sender.send(amountToWithdraw)) revert();
       LogWithdrawal(msg.sender, amountToWithdraw);
       
        return true;
    }
    
   
    function () public {}
        
}

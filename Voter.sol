// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Vote {
    struct Voter {
        uint256 amount; 
        bool isVoted;
        address delegator;
        uint256 targetId;
    }

    struct Board {
        string name;
        uint256 totalAmount;
    }

    address public host;
    mapping(address => Voter) public voters;
    Board[] public board;

    constructor(string[] memory nameList) {
        host = msg.sender;
        voters[host].amount = 1;

        for (uint256 i = 0; i < nameList.length; i++) {
            Board memory boardItem = Board(nameList[i], 0);
            board.push(boardItem);
        }
    }

    function getBoardInfo() public view returns(Board[] memory) {
        return board;
    }

    function mandate(address[] calldata addressList) public {
        require(msg.sender == host, "Only the woner has permissions.");
        for (uint256 i = 0; i < addressList.length; i++) {
            if (!voters[addressList[i]].isVoted) {
                voters[addressList[i]].amount = 1;
            }
        }
    }

    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.isVoted, unicode"你已经投过票了！");
        require(msg.sender != to, unicode"不能委托给自己！");
        while (voters[to].delegator != address(0)) {
            to = voters[to].delegator;
            require(to == msg.sender, unicode"不能循环授权！");
        }
 
        sender.isVoted = true;
        sender.delegator = to;
        Voter storage delegator_ = voters[to];
        if (delegator_.isVoted) {
            board[delegator_.targetId].totalAmount += sender.amount;
        } else {
            delegator_.amount += sender.amount;
        }
    }

    function vote(uint256 targetId) public {
        Voter storage sender = voters[msg.sender]; 
        require(sender.amount != 0, "Has no right to vote.");
        require(!sender.isVoted, "Already voted.");
        sender.isVoted = true;
        sender.targetId = targetId;
        board[targetId].totalAmount += sender.amount;
        emit voteSuccess(unicode'投票成功');
    }
  
    event voteSuccess(string);
}

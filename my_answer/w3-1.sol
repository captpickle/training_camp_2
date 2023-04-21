//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Score {
    mapping(address => uint) public students;
    address teacher;
    address owner;
    error NotTeacher();
    modifier onlyTeacher() {
        if (msg.sender != teacher) {
            revert NotTeacher();
        }
        _;
    }
    constructor() {
         owner= msg.sender;
    }

    function setTeacher(address  t)  public {
        require(msg.sender==owner,"Only owner can set teacher");
        teacher = t;
    }
     
    function recordScore(address addr, uint score) onlyTeacher public {
            require(score <= 100, "Score must be less than 100");
            students[addr] = score;
    }
    
}

interface IScore {
    function recordScore(address addr, uint score) external;
}


contract Teacher{
    IScore score;
    constructor(address s) {
        score = IScore(s);
    }
    function recordScore(address addr, uint data) public {
        score.recordScore(addr, data);
    }
}
 
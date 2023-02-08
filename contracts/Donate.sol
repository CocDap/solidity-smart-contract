// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donate {


    struct Post {
        address creator;
        bool isClaimed;
        uint donateAmount;

    }

    mapping (address => uint) public balancesOf;

    mapping(string => Post) public posts;

    mapping(address => string[] ) public donated;

    // Content count
    uint32 public idCount;


    function createPost(string memory id, uint amount) public {
        
        Post memory newPost = Post(
            msg.sender,
            false,
            amount
        );

        posts[id] = newPost;

        idCount +=1;


    }

    function deposit(string memory id) public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0.");

        Post storage post = posts[id];

        require(msg.value == post.donateAmount, "Donate amount is equal by value sender");
        

        balancesOf[msg.sender] += msg.value;

        string[] storage allIds = donated[msg.sender];

        allIds.push(id);

        // Storage users deposit for specific id
        donated[msg.sender] = allIds;
    }


    function claim(string[] memory idPosts) public {

        uint totalAmount;
        for (uint i =0; i < idPosts.length; i++) {
            Post storage post = posts[idPosts[i]];
            if (post.creator == msg.sender) {
                totalAmount += post.donateAmount;
            }
        
        }


        require(totalAmount <= address(this).balance, "Insufficient balance to withdraw.");
        payable(msg.sender).transfer(totalAmount);

        
    }

    function getDonatedPost() public view returns (string[] memory) {
    
        string[] memory allPosts = new string[](idCount);

        for (uint i =0; i < idCount; i++) {
            allPosts[i] = donated[msg.sender][i];
        
        }   

        return allPosts; 
    }
}

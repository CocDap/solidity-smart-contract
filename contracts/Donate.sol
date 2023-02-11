// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Donate {
    struct Post {
        address creator;
        bool isClaimed;
        uint256 donateAmount;
        uint256 totalDonatedAmount;
    }

    mapping(address => uint256) public balancesOf;

    mapping(string => Post) public posts;

    //Track whether users have made a donation or not.
    mapping(address => string[]) public donated;

    // Content count
    uint32 public idCount;

    function createPost(
        string memory baseUrl,
        string memory id,
        uint256 amount
    ) public {
        Post memory newPost = Post(msg.sender, false, amount,0);
        string memory url = string(abi.encodePacked(baseUrl, id));

        posts[url] = newPost;

        idCount += 1;
    }

    function deposit(string memory baseUrl, string memory id) public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0.");

        string memory url = string(abi.encodePacked(baseUrl, id));
        Post storage post = posts[url];

        require(
            msg.value == post.donateAmount,
            "Donate amount is equal by value sender"
        );

        post.totalDonatedAmount += msg.value;
        balancesOf[msg.sender] += msg.value;

        string[] storage allIds = donated[msg.sender];

        allIds.push(url);

        // Storage users deposit for specific id
        donated[msg.sender] = allIds;
    }

    function claim(string[] memory urlPosts) public {
        uint256 totalAmount;
        for (uint256 i = 0; i < urlPosts.length; i++) {
            Post storage post = posts[urlPosts[i]];
            if (post.creator == msg.sender && !post.isClaimed) {
                totalAmount += post.totalDonatedAmount;
                post.isClaimed = true;
            }
        }

        require(totalAmount > 0, "You have no donation to claim.");
        require(
            totalAmount <= address(this).balance,
            "Insufficient balance to withdraw."
        );

        payable(msg.sender).transfer(totalAmount);
    }

    function getDonatedPost() public view returns (string[] memory) {
        string[] memory allPosts = new string[](idCount);

        for (uint256 i = 0; i < idCount; i++) {
            allPosts[i] = donated[msg.sender][i];
        }

        return allPosts;
    }

    function getBalance() public view returns (uint256) {
        return balancesOf[msg.sender];
    }

    function getPost(string memory baseUrl, string memory id)
        public
        view
        returns (Post memory)
    {
        string memory url = string(abi.encodePacked(baseUrl, id));
        return posts[url];
    }

    function hasDonateForPost(
        string memory baseUrl,
        string memory id,
        address addr
    ) public view returns (bool) {
        string memory url = string(abi.encodePacked(baseUrl, id));

        for (uint256 i = 0; i < idCount; i++) {
            if (
                keccak256(abi.encodePacked(donated[addr][i])) ==
                keccak256(abi.encodePacked(url))
            ) {
                return true;
            }
        }
        return false;
    }
}
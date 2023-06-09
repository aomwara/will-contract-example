//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.19;

import "./interfaces/IWillToken.sol";
import "./Will.sol";

contract WillFactory {
    address internal OWNER;
    address internal will_token;

    modifier onlyOwner() {
        require(msg.sender == OWNER, "Only owner can call this function.");
        _;
    }

    mapping(address => address) public will_owners;
    mapping(address => bool) public wills;
    mapping(address => uint256) public idCards;

    event CreateWill(address _will, address _owner);
    event RegisterIdCard(address _owner, uint256 _idCard);

    constructor() {
        OWNER = msg.sender;
    }

    function registerIDCard(uint256 _idCard) external onlyOwner {
        idCards[msg.sender] = _idCard;
        emit RegisterIdCard(msg.sender, _idCard);
    }

    function getIDCard(address _owner) external view returns (uint256) {
        return idCards[_owner];
    }

    function createWill(
        string memory _name,
        string memory _description
    ) external {
        require(idCards[msg.sender] != 0, "You must register ID card first.");
        IWillToken(will_token).mint(msg.sender);
        Will will = new Will(msg.sender, _name, _description);
        will_owners[msg.sender] = address(will);
        wills[address(will)] = true;
    }

    function setWillToken(address _will_token) external onlyOwner {
        will_token = _will_token;
    }
}

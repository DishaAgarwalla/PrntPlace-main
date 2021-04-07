pragma solidity ^0.5.3;
pragma experimental ABIEncoderV2;
//import { ERC20 } from '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import { SafeMath } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts/math/SafeMath.sol";
import { PrntNFT } from "./PrntNFT.sol";
import { PrntNFTTradable } from "./PrntNFTTradable.sol";
import { PrntNFTMarketplaceEvents } from "./PrntNFTMarketplaceEvents.sol";
import { PrntNFTData } from "./PrntNFTData.sol";


contract PrntNFTMarketplace is PrntNFTTradable, PrntNFTMarketplaceEvents {
    using SafeMath for uint256;
    
    // PrntNFTData.Prnt[] public _prnts;
    // mapping(address => PrntNFT[]) creations;
    mapping(address => PrntNFTData.Prnt[]) collections;
    // mapping(address => mapping(address => bool)) currentCollections;

    address payable public PRNT_NFT_MARKETPLACE;

    PrntNFTData public prntNFTData;

    constructor(PrntNFTData _prntNFTData) public PrntNFTTradable(_prntNFTData) {
        prntNFTData = _prntNFTData;
        PRNT_NFT_MARKETPLACE = address(uint160(address(this)));
    }

    /** 
     * @notice - Buy function is that buy NFT token and ownership transfer. (Reference from IERC721.sol)
     * @notice - msg.sender buy NFT with ETH (msg.value)
     * @notice - PrntID is always 1. Because each prntNFT is unique.
     */
    function buyPrntNFT(PrntNFT prntNFT) public payable returns (bool) {
        // PrntNFT prntNFT = _prntNFT;

        PrntNFTData.Prnt memory prnt = prntNFTData.getPrntByNFTAddress(prntNFT);
        uint len = prnt.ownerAddress.length;
        address _seller = prnt.ownerAddress[len-1];                     /// current owner
        address payable seller = address(uint160(_seller));  /// Convert owner address with payable
        uint buyAmount = prnt.prntPrice;
        require (msg.value >= buyAmount, "msg.value should be equal to the buyAmount");
 
        /// Bought-amount is transferred into a seller wallet
        seller.transfer(buyAmount);

        /// Approve a buyer address as a receiver before NFT's transferFrom method is executed
        address buyer = msg.sender;
        uint prntId = 1;  /// [Note]: PrntID is always 1. Because each prntNFT is unique.
        prntNFT.approve(buyer, prntId);
        
        address ownerBeforeOwnershipTransferred = prntNFT.ownerOf(prntId);
        
        
        /// Transfer Ownership of the PrntNFT from a seller to a buyer
        transferOwnershipOfPrntNFT(prntNFT, prntId, buyer);    
        prntNFTData.updateOwnerOfPrntNFT(prntNFT, buyer);
        prntNFTData.updateStatus(prntNFT, "Cancelled");

        /// Event for checking result of transferring ownership of a prntNFT
        address ownerAfterOwnershipTransferred = prntNFT.ownerOf(prntId);
        
        PrntNFTData.Prnt memory _prnt = prntNFTData.getPrntByNFTAddress(prntNFT);
        collections[buyer].push(_prnt);
        
        prntNFTData.addArtist(msg.sender);
        
        emit PrntNFTOwnershipChanged(prntNFT, prntId, ownerBeforeOwnershipTransferred, ownerAfterOwnershipTransferred);
    }
    

    function getCollections(address owner) public view returns (PrntNFTData.Prnt[] memory) {
        return collections[owner];
    }
    
    
    ///-----------------------------------------------------
    /// Methods below are pending methods
    ///-----------------------------------------------------

    /** 
     * @dev reputation function is that gives reputation to a user who has ownership of being posted prnt.
     * @dev Each user has reputation data in struct
     */
    function reputation(address from, address to, uint256 prntId) public returns (uint256, uint256) {

        // Prnt storage prnt = prnts[prntId];
        // prnt.reputation = prnt.reputation.add(1);

        // emit AddReputation(prntId, prnt.reputation);

        // return (prntId, prnt.reputation);
        return (0, 0);
    }
    

    function getReputationCount(uint256 prntId) public view returns (uint256) {
        uint256 curretReputationCount;

        // Prnt memory prnt = prnts[prntId];
        // curretReputationCount = prnt.reputation;

        return curretReputationCount;
    }    

}

pragma  solidity  ^0.4.17;

contract KittyBase {
    /// 出生事件
    event Birth(address owner, uint256 kittyId, uint256 matronId, uint256 sireId, uint256 genes);
    /// 交易事件
    event Transfer(address from, address to, uint256 tokenId);


    struct Kitty {
        uint256 genes;
        /// 母亲ID
        uint32 matronId;
        /// 父亲ID
        uint32 sireId;
        /// ？？
        uint16 generation;
    }

    Kitty[] kitties;

    /// 该Kitty映射到哪个账户下
    mapping (uint256 => address) public kittyIndexToOwner;
    /// 该账户下有多少只Kitty
    mapping (address => uint256) ownershipTokenCount;

    /// 创建Kitty
    function _createKitty(uint256 _genes,uint32 _matronId,uint32 _sireId,uint16 _generation,address _owner) internal returns (uint) {
        Kitty memory _kitty = Kitty({
            genes: _genes,
            matronId: _matronId,
            sireId: _sireId,
            generation: _generation
        });
        /// 生成新的Kitty的地址
        uint256 newKittenId = kitties.push(_kitty) - 1;

        Birth(_owner,newKittenId,_matronId,_sireId,_genes);

        _transfer(0, _owner, newKittenId);

        return newKittenId;
    }

    /// Kitty交易
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        kittyIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            //// TODO
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }
} 
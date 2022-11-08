pragma solidity >=0.4.22 <0.9.0;

contract SupplyChain {
    uint public count = 0;

    struct medicine {
        uint256 id;
        string name;
    }

    mapping(uint256 => medicine) public medicines;

    event MedicineCreated(uint count, uint256 id, string name);

    function createMedicine(uint id, string memory name) public {
        medicines[count] = medicine(id, name);
        emit MedicineCreated(count, id, name);
        count++;
    }


}

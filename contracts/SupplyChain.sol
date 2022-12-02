pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract SupplyChain {
    address owner;
    constructor() public {
        owner = msg.sender;
        // address that deploys contract will be the owner
    }

    enum Status {
        AtManufacture,
        AtTransporter1,
        AtWholesaler,
        AtTransporter2,
        AtDistributor,
        AtCustomer
    }
    struct Logs {
        string arrival_time;
        address holder_address;
    }

    struct Medicine {
        uint256 id;
        string name;
        address manufacture_address;
        string expire_date;
        Status status;
        Logs[] logs;
    }

    mapping(string => Medicine) public medicines;

    event MedicineCreated(
        string qr,
        uint256 id,
        string name);

    function createMedicine(string memory newScanHashCode, uint id, string memory name, string memory expire, string memory timeNow) public {
        medicines[newScanHashCode].id = id;
        medicines[newScanHashCode].name = name;
        medicines[newScanHashCode].status = Status(0);
        medicines[newScanHashCode].manufacture_address = msg.sender;
        medicines[newScanHashCode].expire_date = expire;
        medicines[newScanHashCode].logs.push(Logs(timeNow, msg.sender));
        emit MedicineCreated(newScanHashCode, id, name);
    }

    function transporterReceiveMedicineFromManufacture(string memory scannedId, string memory timeNow) public {
        medicines[scannedId].status = Status(1);
        Logs memory newLog = Logs(timeNow, msg.sender);
        medicines[scannedId].logs.push(newLog);
    }

    function wholesalerReceiveMedicine(string memory scannedId, string memory timeNow) public {
        medicines[scannedId].status = Status(2);
        Logs memory newLog = Logs(timeNow, msg.sender);
        medicines[scannedId].logs.push(newLog);
    }

    function transporterReceiveMedicineFromWholesaler(string memory scannedId, string memory timeNow) public {
        medicines[scannedId].status = Status(3);
        Logs memory newLog = Logs(timeNow, msg.sender);
        medicines[scannedId].logs.push(newLog);
    }

    function distributorReceiveMedicine(string memory scannedId, string memory timeNow) public {
        medicines[scannedId].status = Status(4);
        Logs memory newLog = Logs(timeNow, msg.sender);
        medicines[scannedId].logs.push(newLog);
    }

    function soldToCustomer(string memory scannedId) public {
        medicines[scannedId].status = Status(5);
    }

    function getScannedMedicineDetails(string calldata scannedId) external view returns (Medicine memory){
        return medicines[scannedId];
    }

}

pragma experimental ABIEncoderV2;
pragma solidity ^0.5.0;


import "@openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol";




contract ImmutableTest {
  address public owner;
 
  using Roles for Roles.Role;


  Roles.Role private VirusTestMachines;



    struct User {
        address account;
        string bioHash;
        uint testStatus; // 0 = untested, 1 = tested
        uint testResult; // 0 = positive, 1 = negative
        uint256 lastTestDateTime; //timestamp
        address lastVirusTestMachine;
        
    }

    struct TestResult {
      address testMachine;
      address user;
      string userBioHash;
      uint timestamp;
      uint testResult;
      string userMachineTimestamp;

    }

    mapping (address => User) Users;
    mapping (string => TestResult) TestResults; 

    address[] public UserAccounts;
    string[] public TestResultAccounts;


 

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
  	if (msg.sender == owner) _;
  }

  modifier onlyVirusTestMachine() {
  	require(isVirusTestMachine(msg.sender), "Virus Test Machine: caller is not an approved Virus Test Machine");
    _;
  }



  function addUser(address account, string memory bioHash, uint testStatus, uint testResult, uint256 lastTestDateTime, address lastVirusTestMachine) public onlyOwner { //later add Administrator role to expand on Owner
    User storage user = Users[account];
    user.bioHash = bioHash;
    user.testStatus = testStatus; 
    user.testResult = testResult; //i.e. current status of negative or positive for virus
    user.lastTestDateTime = lastTestDateTime;
    user.lastVirusTestMachine = lastVirusTestMachine;

    UserAccounts.push(account) -1;

    emit UserAdded(account);
  }

  function updateUserStatus(address account, uint testStatus, uint lastTestDateTime, uint testResult, address lastVirusTestMachine) public onlyVirusTestMachine {
    User storage user = Users[account];

     user.testStatus = testStatus; 
    user.testResult = testResult; //i.e. current status of negative or positive for virus
    user.lastTestDateTime = lastTestDateTime;
    user.lastVirusTestMachine = lastVirusTestMachine;

    emit UserUpdated(account);


  }

    function getAllUsers() view public returns (address[] memory) {
    return UserAccounts;
  }

  function getUser(address account) view public returns (string memory, uint, uint, uint256, address) {
    return (Users[account].bioHash, Users[account].testStatus, Users[account].testResult, Users[account].lastTestDateTime, Users[account].lastVirusTestMachine);
  }

  function countUsers() view public returns (uint) {
    return UserAccounts.length;
  }

   function addTestResult(address testMachineAccount, address userAccount, string memory userBioHash, uint256 timestamp, uint testResult, string memory userMachineTimestamp) public onlyOwner { //later add Administrator role to expand on Owner
    TestResult storage testresult = TestResults[userMachineTimestamp];
    testresult.testMachine = testMachineAccount;
    testresult.user = userAccount; 
    testresult.userBioHash = userBioHash; 
    testresult.timestamp = timestamp;
    testresult.testResult = testResult;

    TestResultAccounts.push(userMachineTimestamp) -1;

    emit TestResultAdded(userMachineTimestamp);
  }

   function getAllTestResults() view public returns (string[] memory) {
    return TestResultAccounts;
  }


  function getTestResult(string memory userMachineTimestamp) view public returns (address, address, string memory, uint256, uint) {
    return (TestResults[userMachineTimestamp].testMachine, TestResults[userMachineTimestamp].user, TestResults[userMachineTimestamp].userBioHash, TestResults[userMachineTimestamp].timestamp, TestResults[userMachineTimestamp].testResult);
  }

    function countTestResults() view public returns (uint) {
    return TestResultAccounts.length;
  }

  function isVirusTestMachine(address _address) public view returns (bool) {
  	
  	return VirusTestMachines.has(_address);
  }



  function addVirusTestMachine(address newVirusTestMachine) public onlyOwner {
  	
  	_addVirusTestMachine(newVirusTestMachine);
  }

  function _addVirusTestMachine(address newVirusTestMachine) internal
  {
    VirusTestMachines.add(newVirusTestMachine);
    emit VirusTestMachineAdded(newVirusTestMachine);
  }



  event UserAdded(address indexed account);

  event UserUpdated(address indexed account);

  event VirusTestMachineAdded(address indexed newVirusTestMachine);

  event TestResultAdded(string indexed userMachineTimestamp);






}

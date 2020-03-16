pragma solidity ^0.4.24;

//Contract registers patient.
contract Patient_Registration{
    
    //stores patientID with its DataID.
    mapping(address => address) patient_DataID;
    
    //registers a patient and sets DataID.
    function Deploy_patient() public{
        address newPat = new Patient_Data(msg.sender);
        
        patient_DataID[msg.sender] = newPat;
    }
    
    //Retrieve DataID.
    function get_DataID(address _patientID) public view returns(address){
        return patient_DataID[_patientID];
    }
}


//Contract that saves the data of patient.
contract Patient_Data{
    
    //providing ownership to deploying ID.
    address public owner;
    uint form_number;
    
    constructor(address _owner) public{
        owner = _owner;    
    }
    
    //data split into different level of data.
    struct Sensitive{
        string S_issue;
        string S_insurance;
        uint S_contact;
    }
    
    struct Non_sensitive{
        string NS_name;
        string NS_guardian;
        string NS_medication;
        uint NS_age;
    }
    
    //form number mapped to its issue.
    mapping(uint => string) Form_overview;
    
    //array of each dataset.
    Sensitive[] data_sen;
    Non_sensitive[] data_nonSens;
    address[] public Approved_list;
    
    //for functions that can only be used by the owner of contract.
    modifier _onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    //filling of data by the patient.
    //data being saved, split into two sets.
    function insert_data(string _name, string _issue, string _insurance, string _guardian, string _medication, uint _age, uint _contact) public _onlyOwner{
        Sensitive memory NewSensitive = Sensitive({
                                                    S_issue : _issue,
                                                    S_insurance : _insurance,
                                                    S_contact : _contact
        });
        
        Non_sensitive memory NewNon_sensitive = Non_sensitive({
                                                    NS_name : _name,
                                                    NS_guardian : _guardian,
                                                    NS_medication : _medication,
                                                    NS_age : _age
        });
        
        data_sen.push(NewSensitive);
        data_nonSens.push(NewNon_sensitive);
        
        Form_overview[form_number] = _issue;
        form_number++;
    }
    
    //Adds the Doctor's ID who can access the data.
    function add_officer(address _ID) public _onlyOwner{
        Approved_list.push(_ID);
    }
    
    //Used to check the approval check list.
    function check_list(uint _num) public view returns(address){
        return Approved_list[_num];
    }
    
    //Used to send the data from storage to other contract.
    function fetch_data_sensitive(uint _num) public view returns(string, string, uint){
        
        Sensitive storage sens_dt = data_sen[_num];
        
        string memory Issue = sens_dt.S_issue;
        string memory Insurance = sens_dt.S_insurance;
        uint Contact = sens_dt.S_contact;
        
        return (Issue, Insurance, Contact);
    }
    
    function fetch_data_Nonsensitive(uint _num) public view returns(string, string, string, uint){
        
        Non_sensitive storage nsens_dt = data_nonSens[_num];
        
        string memory Name = nsens_dt.NS_name;
        string memory Guardian = nsens_dt.NS_guardian;
        string memory Medication = nsens_dt.NS_medication;
        uint Age = nsens_dt.NS_age;  

        return(Name, Guardian, Medication, Age);
    }
}


//Contract registers hospital staff.
contract Employee_Registration{
    
    //stores patientID with its DataID.
    mapping(address => address) employee_DataID;
    
    //registers a worker and sets DataID.
    function Deploy_employee() public{
        address newEmp = new Employee_Data(msg.sender);
        
        employee_DataID[msg.sender] = newEmp;
    }
    
    //Retrieve DataID.
    function get_employeeID(address _ID) public view returns (address){
        return employee_DataID[_ID];
    }
}

//Employee inputs data through this contract.
contract Employee_Data{
    
    //adds contract owner.
    address public owner;

    constructor(address _owner) public{
        owner = _owner;    
    }
    
    //structure of employee data.
    struct Employee{
        string name;
        string institute;
        string position;
        address ID;
        bool approval;
    }
    
    //list of approved patient 
    uint index;
    address[] public Approved_list;
    
     
    mapping(address => bool) public registered_officer; //mapping for finding if ID is registered
    mapping(address => string) public level_assign; //mapping for level assigned to ID
    mapping(address => uint) public find_officer; //mapping for finding if the officers array index.
    
    Employee[] public employee_list;    //array of employees.
    
    
    //used to check the function is run by the owner.
    modifier _onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    //adds new employees.
    function add_Employee(string _name, string _institure, string _position) public{
        Employee memory NewEmployee = Employee({
                                        name : _name,
                                        institute : _institure,
                                        position : _position,
                                        ID : msg.sender,
                                        approval : false
                                    });
        
        employee_list.push(NewEmployee);
        registered_officer[msg.sender] = true;
        find_officer[msg.sender] = index;
        index++;
    }
    
    //Adds the Doctor's patient's ID who they currently manage.
    function add_patient(address _ID) public _onlyOwner{
        Approved_list.push(_ID);
    }
    
    //get patients dataID from the registration contract.
    function get_patient(address _BaseID, address _patientID) public view returns(address) {
        Patient_Registration pR = Patient_Registration(_BaseID);
        address form_id = pR.get_DataID(_patientID);
        
        return form_id;
    }
    
    //get the approval.
    function check_approval(uint _index, address _EmployeeID, address _BaseID, address _patientID) public{
        require(registered_officer[_EmployeeID] == true);
        
        uint serial = find_officer[msg.sender];
        Employee storage employee_data = employee_list[serial];
        
        address patID = get_patient(_BaseID, _patientID);
        Patient_Data pat = Patient_Data(patID);
        
        address list = pat.check_list(_index);
        
        if(_EmployeeID == list){
                employee_data.approval = true;
            }
    }

    //fetch sensitive data of the patient.
    function get_sensitive_data(uint _ID, address _BaseID, address _patientID) public view returns(string, string, uint){
        uint serial = find_officer[msg.sender];
        Employee storage officer_data = employee_list[serial];
        
        require(officer_data.approval == true);
        
        address patID = get_patient(_BaseID, _patientID);
        Patient_Data pat = Patient_Data(patID);
        
        string memory _issue_;
        string memory _insurance_;
        uint _contact_;
        
        (_issue_,_insurance_,_contact_) = pat.fetch_data_sensitive(_ID);
        
        return (_issue_,_insurance_,_contact_);
    }
    

    //get non-sensitive data of the patient.
    function get_nsensitive_data(uint _ID, address _BaseID, address _patientID) public view returns(string, string, string, uint){
        string memory _name_;
        string memory _guardian_;
        string memory _medication_;
        uint _age_;
        
        address patID = get_patient(_BaseID, _patientID);
        Patient_Data pat = Patient_Data(patID);
        
        (_name_, _guardian_, _medication_, _age_) = pat.fetch_data_Nonsensitive(_ID);
        
        return (_name_, _guardian_, _medication_, _age_);
    }
}
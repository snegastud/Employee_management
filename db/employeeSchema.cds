namespace employee.db;

entity Employees {
key ID :UUID;
@assert.unique
empNo: String(100);
empName: String(100);
@assert.format: '^[^@]+@[^@]+\\.[^@]+$'
empEmail:String(100) @mandatory @Communication.IsEmailAddress;
@assert.format: '^[0-9]{10}$'
@assert.unique
empPhone:String(100) @mandatory @Communication.IsPhoneNumber;
empHireDate:Date;
designation : String(100);
@readonly
role : Association to Roletype;
@readonly
leaveBalance:Decimal(5,1) @mandatory;
@readonly
department :Association to Departments;
manager :Association to Employees;
subordinates : Association to many Employees  on subordinates.manager = $self;
leaveRequest:Composition of  many LeaveRequest on leaveRequest.employeeLeaveRequest=$self;
travelRequest:Composition of  many TravelRequest on travelRequest.employeeTravelRequest=$self;

}
entity Roletype{
    @assert.range
    key Role:String enum{
   EMPLOYEE;
   MANAGER;
   HR;
   ADMIN;

    } default 'EMPLOYEE';
}

entity Departments{
key ID:UUID;
@assert.unique
deptCode:String(100) NOT NULL;
@assert.unique
deptName:String(100) @mandatory;
@assert.range:[1000,50000]
budgetLimit : Decimal(15,2) @mandatory;
employees:Composition of many Employees on employees.department=$self;
@assert.format: '^[^@]+@[^@]+\\.[^@]+$'
@assert.unique
departmentEmail:String(255) @mandatory;

}

entity LeaveRequest{
key ID:UUID;
@assert.unique
employeeLeaveRequest:Association to Employees ;
leaveStartDate:Date @mandatory;
leaveEndDate:Date @mandatory;
rejectionReason : String(255);
leaveType:Association to LeaveType ;
leaveStatus:Association to Status ;
@assert.range: [1,30]
@readonly
numberOfDays:Integer @mandatory;
@mandatory
leaveReason:String(255);
@readonly
leaveBalanceBefore:Integer;
@readonly
leaveBalanceAfter:Integer;
@readonly
approver:Association to Employees;
managed:Timestamp;
}

entity LeaveType{
   
    key leave:String enum{
    SICK_LEAVE;
    CASUAL_LEAVE;
    VACATION;
    PERSONAL_LEAVE;
    UNPAID;
    OTHER;
    }
}

entity Status{
    @assert.range
    key status:String enum{
    PENDING;
    APPROVED;
    REJECTED;
    CANCELLED;
    } default 'PENDING';
}

entity TravelRequest{
    key ID:UUID;
    @assert.unique
   
    employeeTravelRequest:Association to Employees;
    travelStartDate:Date @mandatory;
    travelEndDate:Date @mandatory;
    travelDestination:String(255) @mandatory;
    rejectionReason : String(255);
    travelPurpose:Association to TravelType;
    travelStatus:Association to Status ;
    @assert.range:[1,50000]
    estimatedCost:Decimal(15,2) @mandatory;
    approver:Association to Employees;
    @assert.range: [0,50000]
    actualCost:Decimal(15,2);
    managed:Timestamp;
    travelDocument:Composition of many TravelDocuments on travelDocument.travelRequest=$self;
    
}

entity TravelType{
   
    @assert.range
    Key travel:String enum{
        CLIENT_MEETING;
        TRAINING;
        CONFERENCE;
        OFFICE_VISIT;
        PROJECT_DEPLOYMENT;
        BUSINESS_MEETING;
        TEAM_EVENT;
        ONSITE_SUPPORT;
        AUDIT;
        OTHER;


    }
}

entity TravelDocuments{
    Key ID:UUID;
    travelRequest:Association to TravelRequest;
    documentName:String(100) @mandatory;
    documentURL:String(255) @mandatory;
    UploadedDate:Timestamp;
    
}

entity AuditLogs{
    key ID : UUID;
    action : String;
    performedBy : String;
   
    createdAt : Timestamp;
}
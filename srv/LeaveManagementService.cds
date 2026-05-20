using {employee.db as db} from '../db/employeeSchema';


service LeaveManagement{

    
   
   
    entity  Employees as projection on db.Employees;

    function getLeaveBalance(employeeID:String) returns Decimal(5,1);
    
   entity  Departments as projection on db.Departments;

    entity AuditLogs as projection on db.AuditLogs;

   
    @odata.draft.enabled
    entity  LeaveRequest as projection on db.LeaveRequest

    actions{

        action approveLeave() returns LeaveRequest;

        action rejectLeave(rejectionReason:String) returns LeaveRequest;
    }
   
    
   
   action submitLeaveRequest(employeeID:String,startDate:Date,endDate:Date,leaveType_leave:String,reason:String) returns LeaveRequest;
}
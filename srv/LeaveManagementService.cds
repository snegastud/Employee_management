using {employee.db as db} from '../db/employeeSchema';


service LeaveManagement{

 @restrict: [
        { grant: 'READ', to: ['Employee', 'Manager', 'Admin'] }
    ]
    entity  Employees as projection on db.Employees;

   action cancelRequest(employeeID : String) returns String;

 @restrict: [
  { grant: 'EXECUTE', to: ['Employee', 'Manager', 'Admin'] }
]
    
    function getLeaveBalance(employeeID:String) returns Decimal(5,1);

       @restrict: [
        { grant: 'READ', to: ['Employee', 'Manager', 'Admin'] }
    ]
    
    entity  Departments as projection on db.Departments;

     @restrict: [
        { grant: 'READ', to: ['Admin'] }
    ]
    entity AuditLogs as projection on db.AuditLogs;

    

    entity LeaveType as projection on db.LeaveType;
    
    

   
    @odata.draft.enabled
    
    @cds.redirection.target

   @restrict: [
  { grant: 'READ', to: ['Employee', 'Manager', 'Admin'] }
   ]
    entity  LeaveRequest as projection on db.LeaveRequest;
   


   @restrict: [
        { grant: 'READ', to: ['Manager', 'Admin'] }
    ]   
   entity PendingLeaveRequests as projection on db.LeaveRequest
        actions {
             @restrict: [
                { grant: 'EXECUTE', to: ['Manager', 'Admin'] }
            ]

            action approveLeave() returns PendingLeaveRequests;
             @restrict: [
                { grant: 'EXECUTE', to: ['Manager', 'Admin'] }
            ]

            action rejectLeave( rejectionReason:String ) returns PendingLeaveRequests;

    };

    entity States {
    key name : String;
}
   
    entity Status as projection on db.Status;

    
      //action submitLeaveRequest(employeeID:String,startDate:Date,endDate:Date,leaveType_leave:String,reason:String) returns LeaveRequest;
         @restrict: [
        { grant: 'EXECUTE', to: ['Employee', 'Admin'] }
    ]
   
      action submitLeaveRequest(

        employeeID : String,

        startDate : Date,

        endDate : Date,
       
         SeatingArrangement : String
        @Common.ValueList: {
            $Type: 'Common.ValueListType',
            CollectionPath: 'States',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: SeatingArrangement,
                    ValueListProperty: 'name'
                }
            ]
        },

        @(
            Common.ValueList : {
                $Type : 'Common.ValueListType',

                CollectionPath : 'LeaveType',

                Parameters : [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : leaveType_leave,
                        ValueListProperty : 'leave'
                    }
                ]
            }
        )
        leaveType_leave : String,

        reason : String    ) returns LeaveRequest;
}
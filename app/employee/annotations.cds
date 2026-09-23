using LeaveManagement as service from '../../srv/LeaveManagementService';
annotate service.LeaveRequest with @(

     UI.SelectionFields: [
  
      employeeLeaveRequest.empNo
    ],

UI.HeaderInfo : {
    TypeName : 'Leave Request',
    TypeNamePlural : 'Employee leave request',

    Title : {
        $Type : 'UI.DataField',
        Value : employeeLeaveRequest.empNo
    },

    Description : {
        $Type : 'UI.DataField',
        Value : employeeLeaveRequest.empName
    }
},



UI.LineItem:[

    { $Type : 'UI.DataFieldForAction',

    Action : 'LeaveManagement.EntityContainer/submitLeaveRequest',
    Label : 'Submit Leave Request', 
    Inline : false
    },

    { $Type : 'UI.DataFieldForAction',
     Action : 'LeaveManagement.EntityContainer/cancelRequest',
     Label : 'Cancel Request',
     Inline : false 
     },

      {
        $Type : 'UI.DataFieldForAction',
        Action : 'employees.rejectOnboarding',
        Label : 'Reject Onboarding',
        Inline : false
    },

   
    {

     $Type : 'UI.DataFieldForAction',
     Action :'LeaveManagement.EntityContainer/getLeaveBalance',
     Label : 'getEmployeeBalance'
   
    
    },

    {
        $Type : 'UI.DataField',
        Label : 'Employee ID',
        Value : employeeLeaveRequest.empNo,
       ![@HTML5.CssDefaults]: {width: '5rem'},
        

    },
    {
        $Type : 'UI.DataField',
        Label : 'Leave Type',
        Value : leaveType_leave,
        ![@HTML5.CssDefaults]: {width: '10rem'},
    },
    {
        $Type : 'UI.DataField',
        Label : 'Leave status',
        Value :  leaveStatus_status,
        Criticality:leaveStatusCriticality ,
        ![@HTML5.CssDefaults]: {width: '10rem'}
    },
     {
        $Type : 'UI.DataField',
        Label : 'Leave start date',
        Value :  leaveStartDate,
        ![@HTML5.CssDefaults]: {width: '10rem'},
    },
     {
        $Type : 'UI.DataField',
        Label : 'Leave end date',
        Value :  leaveEndDate,
        ![@HTML5.CssDefaults]: {width: '10rem'},
    },

     {
        $Type : 'UI.DataField',
        Label : 'Days',
        Value : numberOfDays,
       ![@HTML5.CssDefaults]: {width: '5rem'},
    },

    
     {
        $Type : 'UI.DataField',
        Label : 'SeatingArrangement',
        Value : SeatingArrangement,
       ![@HTML5.CssDefaults]: {width: '10rem'},
    }
   
],

  UI.FieldGroup #EmployeeLeaveRequestInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [

          {
    $Type : 'UI.DataFieldWithNavigationPath',
    Label : 'Employee',
    Value : employeeLeaveRequest.empName,
    Target : 'employeeLeaveRequest'
},

            {
                $Type : 'UI.DataField',
                Label : 'Leave Type',
                Value : leaveType_leave
            },

            {
                $Type : 'UI.DataField',
                Label : 'Start Date',
                Value : leaveStartDate
            },

            {
                $Type : 'UI.DataField',
                Label : 'End Date',
                Value : leaveEndDate
            },

            {
                $Type : 'UI.DataField',
                Label : 'Number Of Days',
                Value : numberOfDays
            },

            {
                $Type : 'UI.DataField',
                Label : 'Reason',
                Value : leaveReason
            },

            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : leaveStatus_status,
                Criticality:leaveStatusCriticality 
            }

        ]
    },
    UI.FieldGroup #leaveBalanceInfo : {

         $Type : 'UI.FieldGroupType',

         Data :[
            {
                $Type:'UI.DataField',
                Label:'LeaveBalanceBefore',
                Value:leaveBalanceBefore
            },
            {
                $Type:'UI.DataField',
                Label:'LeaveBalanceAfter',
                Value:leaveBalanceAfter
            }
         ]

    },
    UI.FieldGroup #ManagerRemark :{
        $Type:'UI.FieldGroupType',

        Data:[
            {
                $Type:'UI.DataField',
                Label:'Approve',
                Value: approver_ID
            },
            {
                $Type:'UI.DataField',
                Label:'Rejection Reason',
                Value:rejectionReason
            }
        ]
    },
    UI.Facets :[
          {
            $Type : 'UI.ReferenceFacet',
            ID : 'EmployeeLeaveRequestInformation',
            Label : 'General Information',
            Target : '@UI.FieldGroup#EmployeeLeaveRequestInformation'
        },

          {
            $Type : 'UI.ReferenceFacet',
            ID : 'leaveBalanceInfo',
            Label : 'LeaveBalanceInfo',
            Target : '@UI.FieldGroup#leaveBalanceInfo'
        },
          {
            $Type : 'UI.ReferenceFacet',
            ID : 'ManagerRemark',
            Label : 'ManagerRemarks',
            Target : '@UI.FieldGroup#ManagerRemark'
        },
        {
    $Type : 'UI.ReferenceFacet',
    ID : 'EmployeeDetails',
    Label : 'Employee Details',
    Target : 'employeeLeaveRequest/@UI.FieldGroup#EmployeeInfo'
}
    ]

   
);


annotate service.LeaveRequest with @(
    Capabilities.InsertRestrictions : {
        Insertable : false
    }
);

annotate service.Employees with @(

    UI.FieldGroup #EmployeeInfo : {
        $Type : 'UI.FieldGroupType',

        Data : [

            {
                $Type : 'UI.DataFieldWithNavigationPath',
                Label : 'Employee Number',
                Value : empNo,
                Target : 'employeeLeaveRequest'
            },

            {
                $Type : 'UI.DataField',
                Label : 'Employee Name',
                Value : empName
            },

            {
                $Type : 'UI.DataField',
                Label : 'Email',
                Value : empEmail
            },

            {
                $Type : 'UI.DataField',
                Label : 'Phone',
                Value : empPhone
            },

            {
                $Type : 'UI.DataField',
                Label : 'Designation',
                Value : designation
            }

        ]
    }

);

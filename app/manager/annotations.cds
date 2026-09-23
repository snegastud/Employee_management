using LeaveManagement as service from '../../srv/LeaveManagementService';


annotate service.PendingLeaveRequests with @(
    Aggregation.ApplySupported: {
    
        Transformations : [
            'aggregate',
            'topcount',
            'bottomcount',
            'identity',
            'concat',
            'groupby',
            'filter',
            'expand',
            'search'
        ],
    
        Rollup : #None,
    
        PropertyRestrictions : true,
    
        GroupableProperties : [
            leaveStatus_status,
            leaveType_leave,
            employeeLeaveRequest_empName,
            leaveStartDate,
            leaveEndDate
        ],
    
        AggregatableProperties : [
            {
                Property : numberOfDays
            }
        ],
    
    },
    Analytics.AggregatedProperty #numberOfDays_sum : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'numberOfDays_sum',
        AggregatableProperty : numberOfDays,
        AggregationMethod : 'sum',
        @Common.Label : 'numberOfDays',
    },
    UI.Chart #alpChart : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        Dimensions : [
            leaveStatus_status,
            leaveType_leave,
            employeeLeaveRequest_empName,
            leaveStartDate,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#numberOfDays_sum',
        ],
        Title : 'Pending Leave Requests',
    },
);

annotate service.PendingLeaveRequests with @(

    UI.SelectionFields: [
  
     leaveStatus_status
     
    
    
    ],
 
  
    UI.HeaderInfo: {
        TypeName: 'Pending Leave',
        TypeNamePlural: 'Pending Leave Requests',
        Title: {
            $Type: 'UI.DataField',
            Value: employeeLeaveRequest.empName
        },
        Description: {
            $Type: 'UI.DataField',
            Value: employeeLeaveRequest.empNo
        }
    },

  
    UI.LineItem: [

        {
            $Type: 'UI.DataField',
            Label: 'Employee',
            Value: employeeLeaveRequest.empName
        },
        {
            $Type: 'UI.DataField',
            Label: 'Leave Type',
            Value: leaveType_leave
        },
        {
            $Type: 'UI.DataField',
            Label: 'Start Date',
            Value: leaveStartDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'End Date',
            Value: leaveEndDate
        },
        {
            $Type: 'UI.DataField',
            Label: 'Status',
            Value: leaveStatus_status,
            Criticality:leaveStatusCriticality 
        }
    ],

 
    UI.Identification: [

        {
            $Type: 'UI.DataFieldForAction',
            Action: 'LeaveManagement.approveLeave',
            Label: 'Approve'
        },
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'LeaveManagement.rejectLeave',
            Label: 'Reject'
        }
    ],


    UI.FieldGroup #Details: {
        $Type: 'UI.FieldGroupType',
        Data: [

            {
                $Type: 'UI.DataField',
                Label: 'Employee Name',
                Value: employeeLeaveRequest.empName
            },
            {
                $Type: 'UI.DataField',
                Label: 'Employee No',
                Value: employeeLeaveRequest.empNo
            },
            {
                $Type: 'UI.DataField',
                Label: 'Leave Type',
                Value: leaveType_leave
            },
            {
                $Type: 'UI.DataField',
                Label: 'Start Date',
                Value: leaveStartDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'End Date',
                Value: leaveEndDate
            },
            {
                $Type: 'UI.DataField',
                Label: 'Reason',
                Value: leaveReason
            },
            {
                $Type: 'UI.DataField',
                Label: 'Days',
                Value: numberOfDays
            },
            {
            $Type: 'UI.DataField',
            Label: 'Status',
            Value: leaveStatus_status,
            Criticality:leaveStatusCriticality 
        }

        ]
    },

    UI.Facets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'DetailsFacet',
            Label: 'Leave Details',
            Target: '@UI.FieldGroup#Details'
        }
    ]
);

annotate service.PendingLeaveRequests with {

    leaveStatus @(
        Common.ValueList: {
            $Type: 'Common.ValueListType',
            CollectionPath: 'Status',
            Parameters: [

                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: leaveStatus,
                    ValueListProperty: 'status'
                }

            ]
        },
        Common.Label : 'leavestatus',
    );

};



annotate service.PendingLeaveRequests with {
    leaveType @Common.Label : 'Leavetype'
};

annotate service.PendingLeaveRequests with {
    leaveStartDate @Common.Label : 'leaveStartDate'
};

annotate service.PendingLeaveRequests with {
    leaveEndDate @Common.Label : 'leaveEndDate'
};


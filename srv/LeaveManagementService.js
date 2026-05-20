const cds =require('@sap/cds');

module.exports=cds.service.impl(function async(){

    const {Employees, Departments,LeaveRequest,AuditLogs } =this.entities;


    this.before('submitLeaveRequest',async(req)=>{

        console.log("User input payload:",req.data);

       

       const { employeeID, startDate, endDate,leaveType_leave,reason } = req.data;

        if(!employeeID){
            return req.error(400,"EmployeeID is required");

        }

        const empDetails = await SELECT.one.from(Employees).where({ empNo: employeeID });

        console.log("Employee details:",empDetails);

    
      
        
        if(!empDetails){
            return req.error(404,"Employee id not found");
        }
         
        if(!startDate){
            
            return req.error(400,"Please mention starting leave date");
            
        }

        if(!endDate){

            return req.error(400,"Please mention ending leave date");
        }

        if(!leaveType_leave){
            return req.error(400,"Select the type of leave");
        }
   

        if(!reason){

            return req.error(400,"Reason for the leave and please mention it ")
        }

        const start=new Date(startDate);

        const end=new Date(endDate);

        if(start>end){

            return req.error(400,"Invalid date range")
        }

        const days=Math.floor((end-start) / (1000 * 60 * 60 * 24)) + 1;

        if(empDetails.leaveBalance<days){

             return req.error(400, "Insufficient leave balance");
        }

        const existingLeaves = await SELECT.from(LeaveRequest).where({employeeLeaveRequest_ID: empDetails.ID });

        for (let lr of existingLeaves) {

        const s = new Date(lr.leaveStartDate);
        const e = new Date(lr.leaveEndDate);

        if (start <= e && end >= s) {
            return req.error(409, "Leave overlap detected");

        }
        
    }
         req.data.numberOfDays = days;

         req.data.leaveStatus_status = 'PENDING';
    })


    this.on('submitLeaveRequest',async(req)=>{

        console.log("who can enter",req.user);

        const {employeeID,startDate,endDate,leaveType_leave,reason}=req.data;

       
        
        const EmpId = await SELECT.one.from(Employees).where({ empNo: employeeID });

        const data = await INSERT.into(LeaveRequest).entries({

        employeeLeaveRequest_ID: EmpId.ID,

        leaveStartDate: startDate,

        leaveEndDate: endDate,

        leaveType_leave:leaveType_leave,

        numberOfDays: req.data.numberOfDays,
        
        leaveReason: reason

        });
    
        
      
        const value =await SELECT.one.from(LeaveRequest).where({employeeLeaveRequest_ID: EmpId.ID });;

        console.log(value);

        return value;
    })

    this.on('approveLeave',async(req)=>{

    console.log("Approve triggered");

       console.log("user", req.user)

        const leaveID=req.params[0].ID;

        console.log(req.params[0]);
        
        console.log("LeaveRequest ID",req.data);
        
        const leaveRaise=await SELECT.one.from(LeaveRequest).where({ID:leaveID});

        console.log("LeaveEmployeeID",leaveRaise)


        if(!leaveRaise){

            return req.error(404,"No leave requests");

        }
    
        if(leaveRaise.leaveStatus_status==='APPROVED'){
        
             return req.error(409,"Already Approved ")

        }

        if (leaveRaise.leaveStatus_status === 'REJECTED') {

        return req.error(409, "Already Rejected");

        }
     
        const employee = await SELECT.one.from(Employees).where({ ID:leaveRaise.employeeLeaveRequest_ID });

         console.log("Employee details",employee);

         const approver = await SELECT.one.from(Employees).where({ ID: employee.manager_ID });

         console.log("Manager Details",approver)

         if (!approver) {

          return req.error(404, "Manager not found");
       
        }

        const days = leaveRaise.numberOfDays

          if (employee.leaveBalance < days) {

          return req.error(400, "Not enough leave balance");

        }

        const newBalance = employee.leaveBalance - days;

        await UPDATE(LeaveRequest)
        .set({
            leaveStatus_status: 'APPROVED',
            approver_ID: approver.ID,
            numberOfDays: days,
            leaveBalanceBefore: employee.leaveBalance,
            leaveBalanceAfter: newBalance

        }).where({ ID: leaveID });


        await INSERT.into(AuditLogs).entries({
            action:'APPROVED',
            performedBy:approver.empName,
            createdAt:new Date() })

         const updateValue=await SELECT.one.from(LeaveRequest).where({ID:leaveID});

         console.log(updateValue);

         await UPDATE(Employees).set({leaveBalance: newBalance}).where({ ID: employee.ID });

         const newLeave=await SELECT.one.from(Employees).where({ID:employee.ID});

         console.log(newLeave);

        return { message: "Leave Approved" };

    })

    this.on('rejectLeave',async(req)=>{

        console.log(req.params[0]);

        const Rejectionreason=req.data.rejectionReason;

        const leaveID=req.params[0].ID;

        console.log("LeaveRequestId",leaveID);

        const leaveRaise=await SELECT.one.from(LeaveRequest).where({ID:leaveID});

        console.log("leaveRaise details",leaveRaise);

        if(!leaveRaise){

            return req.error(404,"No leave requests");
        }

      

        if(leaveRaise.leaveStatus_status==='REJECTED'){

            return req.error(409,"LeaveRequest is already rejected");
        }

        const employee=await SELECT.one.from(Employees).where({ID:leaveRaise.employeeLeaveRequest_ID});
 

        if(!employee){

            return req.error(404,"Employee leave id is not found")
        }


        console.log("Employee deatils:",employee);
        
        const manager = await SELECT.one.from(Employees).where({ ID: employee.manager_ID });

        if(!manager){
            return req.error(404,"Manager not found");
        }

        
        const rejectUpdate=  await UPDATE(LeaveRequest).set({

            leaveStatus_status: 'REJECTED', 
            approver_ID:manager.ID,
            leaveBalanceBefore:employee.leaveBalance,
            leaveBalanceAfter: employee.leaveBalance,
            rejectionReason:Rejectionreason

             }).where({ID:leaveID});
           
        console.log(rejectUpdate)

        await INSERT.into(AuditLogs).entries({
            action:'REJECTED',
            performedBy:manager.empName,
            createdAt:new Date()

        })

        const LeaveStatus=await SELECT.one.from(LeaveRequest).where({ID:leaveID});

        console.log("leaveStatus",LeaveStatus);

        return LeaveStatus;
    
    })

    this.on('getLeaveBalance',async(req)=>{

        console.log("User",req.user)

        const {employeeID}=req.data;

        if(!employeeID){

            return req.error(400,"Employee ID is required");
        }
       

        const empDetails=await SELECT.one.from(Employees).where({empNo:employeeID});

        if(!empDetails){

            return req.error(404,`EmployeeID ${employeeID} not found`);
        }

        const totalLeave=empDetails.leaveBalance;

        console.log(totalLeave)

        return req.notify(`Employee leaveBalance ${totalLeave}`);

    })



})
sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"employee/test/integration/pages/LeaveRequestList",
	"employee/test/integration/pages/LeaveRequestObjectPage"
], function (JourneyRunner, LeaveRequestList, LeaveRequestObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('employee') + '/test/flp.html#app-preview',
        pages: {
			onTheLeaveRequestList: LeaveRequestList,
			onTheLeaveRequestObjectPage: LeaveRequestObjectPage
        },
        async: true
    });

    return runner;
});


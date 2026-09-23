sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"manager/test/integration/pages/PendingLeaveRequestsList",
	"manager/test/integration/pages/PendingLeaveRequestsObjectPage"
], function (JourneyRunner, PendingLeaveRequestsList, PendingLeaveRequestsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('manager') + '/test/flp.html#app-preview',
        pages: {
			onThePendingLeaveRequestsList: PendingLeaveRequestsList,
			onThePendingLeaveRequestsObjectPage: PendingLeaveRequestsObjectPage
        },
        async: true
    });

    return runner;
});


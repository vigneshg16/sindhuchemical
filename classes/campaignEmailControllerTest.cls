@isTest
private class campaignEmailControllerTest
{
    @isTest static void campaignEmailMethod1()
    {
        Test.startTest();
        Campaign_Templates__c campTemp = new Campaign_Templates__c();
        campTemp.Name = 'New Email';
        campTemp.Subject__c = 'Test Sindhu Chemical';
        campTemp.Email_Body__c = '<table class="ql-table-blob" id="m_-2859846066770521812m_-6922068820178869141m_-5214561392747033966contentInner" width="600"></table>';
        insert campTemp;
        Test.stopTest();
        PageReference pageRef = Page.CampaignEmailPage;
        Test.setCurrentPage(pageRef);
        campaignEmailController campaignEmailControl = new campaignEmailController();
        campaignEmailControl.toAddressList = 'test123@gmail.com';
        campaignEmailControl.CCAddressList = 'test456@gmail.com';
        campaignEmailControl.loadTemplate();
        campaignEmailControl.loadGroupEmails();
        campaignEmailControl.sendEmailtoGroups();
        campaignEmailControl.sendMail();
    }
}
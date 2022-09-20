@isTest
private class QuoteTemplateControllerTest
{
    @isTest static void QuoteTemplateMethod1()
    {
        PageReference pageRef = Page.CampaignEmailPage;
        Test.setCurrentPage(pageRef);
        QuoteTemplateController QuoteTemplateControl = new QuoteTemplateController();
        QuoteTemplateControl.init();
    }
}
public class campaignEmailController {
    
    public Campaign_Templates__c temp{get;set;}
    public string toMail { get; set;}
    public string ccMail { get; set;}
    public string repMail { get; set;}
    public String emailsubject {get;set;}
    public Opportunity opp {get; set;}
    public boolean isShowContent{get;set;}
    public String toAddressList {get;set;}
    public String ccAddressList {get;set;}
    
    public List<SelectOption> emailGroupOptions {get;set;}
    public String selectedEmailGroup {get;set;}
    public String selectedEmailIds {get;set;}
    
    
    public campaignEmailController()
    {
        temp = new Campaign_Templates__c();
        opp = new Opportunity();
        isShowContent = false;
        emailGroupOptions = new List<SelectOption>();
        for(Email_Group_Object__c em : [Select id,name from Email_Group_Object__c Where IsActive__c =true])
        {
            emailGroupOptions.add(new SelectOption(em.Id,em.Name));
        }
        selectedEmailIds ='';
        
    }
    public pagereference loadTemplate()
    {
        isShowContent =true;
        temp =[Select id,name,Email_Body__c,Subject__c From Campaign_Templates__c where Name='New Email' limit 1];
        emailsubject = temp.Subject__c;
        return null;
    }
    public pagereference loadGroupEmails()
    {
        selectedEmailIds ='';
        for(Email_Receipient__c rec : [Select id,name,Contact_email__c from Email_Receipient__c Where Email_Group_Object__c=:selectedEmailGroup
                                      and Contact_email__c != null ])
        {
          selectedEmailIds =selectedEmailIds + rec.Contact_email__c +',';  
        }
        if(selectedEmailIds.contains(','))
        {
            selectedEmailIds =selectedEmailIds.removeEnd(',');
        }
        
        return null;
    }
    public pagereference sendEmailtoGroups()
    {
        List<String> toList = new List<String>();
        List<String> ccList = new List<String>();
        if(selectedEmailIds.contains(','))
        {
             toList= selectedEmailIds.split(',');
        }
        else
        {
            toList.add(selectedEmailIds);
        }
        if(toAddressList.contains(','))
        {
             toList= toAddressList.split(',');
        }
        else
        {
            toList.add(toAddressList);
        }
        if(CCAddressList.contains(','))
        {
             ccList= CCAddressList.split(',');
        }
        else
        {
            ccList.add(CCAddressList);
        }
        List< Messaging.SingleEmailMessage > emailList = new List< Messaging.SingleEmailMessage>();
        for(String str : toList)
        {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{str});
            if(ccList!=null &&  !ccList.isEmpty())
                email.setCcAddresses(ccList);
            if(repmail!=null && repmail!= '')
                email.setInReplyTo(repMail);
            
            email.setSubject(emailsubject);
            email.setSaveAsActivity(true);
            email.treattargetobjectasrecipient=true;
            email.setHtmlBody(temp.email_body__c);
            emailList.add(email);
        }
       
        
        
        try{
            
            Messaging.sendEmail( emailList );
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Mails are sent successfully'));
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
        
        return null;
    }
    
    public void sendMail(){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {toMail};
            string[] cc = new string[] {ccMail};
                
                email.setToAddresses(to);
        if(ccMail!=null && ccMail != '')
            email.setCcAddresses(cc);
        if(repmail!=null && repmail!= '')
            email.setInReplyTo(repMail);
        
        email.setSubject(emailsubject);
        
        email.setHtmlBody(temp.email_body__c);
        try{
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
        
        toMail = '';
        ccMail = '';
        repMail = '';
    }
}
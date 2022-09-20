public class ProposalHomeController {
    
    public Proposal__c proposal{get;set;}
    public Proposal__c proposalv2{get;set;}
    public List<Product_Items__c> productitemsList{get;set;} 
    Public Proposal_Version__c proposalversion{get;set;}
    public Product_Items__c productitems{get;set;}
    public Decimal totalProposalAmount {get;set;}
    public List<SelectOption> contactList      {get;set;}
    public String selectedContact {get;set;}
    public Boolean isNewContact {get;set;}
    public List<Supplier_Product__c>  supplierProductsList {get;set;}
    public Boolean showAddSupplier {get;set;}
    public date enquirydate{get;set;}
    
    // variables for Products Page
    // 
    public String enquiryRecordId{get;set;}
     public String enquiryVersionRecordId{get;set;}
    public Proposal__c enquiryRec {get;set;}
    public String selectedProductItemId {get;set;}
    public Product_Items__c selectedPrdItem {get;set;}
    public List<Outbound_Enquiry__c>  supplierRequests {get;set;}
    
    
    // varibles for PDF Page
    public List<String> companyAddressList {get;set;}
    public String amountInString{get;set;}
    public String todayDate{get;set;}
    public String quotationNumber {get;set;}
    
    public String searchTextSupplier{get;set;}
    
    public Boolean advanceCheck {get;set;}
    public Boolean creditCheck {get;set;}
    public Boolean pdcCheck {get;set;}
    public Boolean advanceCheckRO {get;set;}
    public Boolean creditCheckRO {get;set;}
    public Boolean pdcCheckRO {get;set;}
    
     public ProposalHomeController(ApexPages.StandardController controller)
     {
         
         enquiryRecordId = controller.getId();
         system.debug('@@@@enquiryRecordId'+enquiryRecordId);
         supplierRequests = new List<Outbound_Enquiry__c>();
         companyAddressList = new List<String>();
         this.proposalv2 = (Proposal__c)controller.getRecord();
        advanceCheck = false;
        creditCheck = false;
        pdcCheck = false;
        advanceCheckRO = true;
        creditCheckRO = true;
        pdcCheckRO = true;
         if(enquiryRecordId != null)
         {
             enquiryRec =[Select id,name,Status__c,City__c,Country__c,State__c,Street__c,Company_Website__c,Customer_Name__c,Quoted_Amount__c,Proposal_Version__c,Proposal_Version__r.Name,Proposal_Version__r.TotalAmountRollup__c,
                          Customer_Or_Supplier__c,Customer_Or_Supplier__r.Name,Customer_Or_Supplier__r.BillingStreet,Customer_Or_Supplier__r.BillingCity,
                          Customer_Or_Supplier__r.BillingState,Customer_Or_Supplier__r.BillingCountry,Customer_Or_Supplier__r.BillingPostalCode, 
                          Payment_Terms__c, Detail_Advace__c, No_of_Days_Credit__c, Phone__c,
                          Number_of_Days_of_Check__c, Shipping_Location__c, Lead_Time__c,GSTIN__c,Billed_From__c,
                          Primary_Contact_Person__c,Primary_Email__c,Customer_Or_Supplier__r.ShippingStreet,Customer_Or_Supplier__r.ShippingCity,
                          Customer_Or_Supplier__r.ShippingState,Customer_Or_Supplier__r.ShippingCountry,Customer_Or_Supplier__r.ShippingPostalCode,Place_Of_Supply__c 
                          from Proposal__c Where Id =:enquiryRecordId];
             if(enquiryRec.Proposal_Version__c != null)
             {
                 enquiryVersionRecordId = enquiryRec.Proposal_Version__c ;
                 totalProposalAmount =enquiryRec.Proposal_Version__r.TotalAmountRollup__c;
                 productitemsList =[Select id,name,Is_Custom_Product__c,Product__c,Product_Description__c,UOM__c,
                                    Product_Name__c,Product_Type__c,Proposal_Version__c,Quantity__c,Total_Price__c,Unit_Price__c 
                                    ,Margin__c, Supplier_Price__c,  Total_Price_with_GST__c,GST__c,Enquiry__c, Product__r.Name from Product_Items__c
                                    where 
                                    Proposal_Version__c =:enquiryRec.Proposal_Version__c and
                                    Is_Approved__c ='Approved' order by createddate desc 
                                   ];
                 totalProposalAmount=0;
                 for(Product_Items__c prd : productitemsList )
                 {
                     totalProposalAmount =totalProposalAmount+prd.Total_Price_with_GST__c;
                 }
                 amountInString =String.valueOf(totalProposalAmount);
             }
             List<Quotation__c> qtList = new List<Quotation__c>();
             qtList= [Select id,name from Quotation__c where Enquiry__c =:enquiryRecordId 
                                  order by CreatedDate desc limit 1];
             if(!qtList.isEmpty())
             {
                  quotationNumber =qtList[0].Name;
             }
            
             todayDate =String.valueOf(system.today());
             if(enquiryRec.Payment_Terms__c == 'Advance'){
                advanceCheckRO = false;
                advanceCheck = true;
            }
            else if(enquiryRec.Payment_Terms__c == 'Credit'){
                creditCheckRO = false;
                creditCheck = true;
            }
            else if(enquiryRec.Payment_Terms__c == 'PDC'){
                pdcCheckRO = false;
                pdcCheck = true;
            }
         }
     }
    public ProposalHomeController()
    {
        proposal = new Proposal__c();
        proposalversion = new Proposal_Version__c();
        productitems = new Product_Items__c();
        selectedPrdItem = new Product_Items__c();
        productitemsList = new List<Product_Items__c>();
     //   productitemsList.add(new Product_Items__c());
        contactList = new List<SelectOption>();
        isNewContact =false;
        totalProposalAmount=0;
        showAddSupplier = false;
        supplierProductsList = new List<Supplier_Product__c> ();
         supplierRequests = new List<Outbound_Enquiry__c>();
        enquiryRecordId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('@@@@enquiryRecordId'+enquiryRecordId);
        fetchSupplierData();
        
        advanceCheck = false;
        creditCheck = false;
        pdcCheck = false;
        advanceCheckRO = true;
        creditCheckRO = true;
        pdcCheckRO = true;
        
        if(enquiryRecordId != null)
        {
            enquiryRec =[Select id,name,Proposal_Version__c,Proposal_Version__r.Name,Proposal_Version__r.TotalAmountRollup__c,
                        Payment_Terms__c, Detail_Advace__c, No_of_Days_Credit__c, GSTIN__c,
                        Number_of_Days_of_Check__c, Shipping_Location__c, Lead_Time__c 
                        from  Proposal__c Where Id =:enquiryRecordId];
            if(enquiryRec.Proposal_Version__c != null)
            {
                enquiryVersionRecordId = enquiryRec.Proposal_Version__c ;
                totalProposalAmount =enquiryRec.Proposal_Version__r.TotalAmountRollup__c;
                productitemsList =[Select id,name,Is_Custom_Product__c,Product__c,Product_Description__c,UOM__c,Show_Supplier__c,
                                    Product_Name__c,Product_Type__c,Proposal_Version__c,Quantity__c,Total_Price__c,Unit_Price__c 
                                    ,Margin__c, Supplier_Price__c,  Total_Price_with_GST__c,GST__c,Enquiry__c, Product__r.Name from Product_Items__c
                                    where Proposal_Version__c =:enquiryRec.Proposal_Version__c order by createddate desc  ];
                
            }
            if(enquiryRec.Payment_Terms__c == 'Advance'){
                advanceCheckRO = false;
                advanceCheck = true;
            }
            else if(enquiryRec.Payment_Terms__c == 'Credit'){
                creditCheckRO = false;
                creditCheck = true;
            }
            else if(enquiryRec.Payment_Terms__c == 'PDC'){
                pdcCheckRO = false;
                pdcCheck = true;
            }
           
        }
    }
    public Pagereference saveProposal()
    {
        proposal.Enquiry_Date__c=enquirydate;
        if( proposal.Name ==null )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide Enquiry Name'));
            return null;            
        }
        /*if( proposal.Primary_Email__c ==null )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide Primary Email'));
            return null;            
        }*/
        if( proposal.Phone__c ==null )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide Phone'));
            return null;            
        }
        
        if(proposal.New_Customer__c)
        {
            Id recordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer_Account').getRecordTypeId();
            Account acct = new Account();
            acct.name = proposal.Customer_Name__c;
            acct.RecordTypeId =recordTypeId;
            acct.Phone =proposal.Phone__c;
            
            insert acct;
            proposal.Customer_Or_Supplier__c =acct.id; 
            
            Contact con = new Contact();
            con.LastName =proposal.Primary_Contact_Person__c;
            con.Email = proposal.Primary_Email__c;
            con.Phone =proposal.Phone__c;
            con.AccountId =acct.id;
            insert con;
            
        }
        else if(isNewContact)
        {
            Contact con = new Contact();
            con.LastName =proposal.Primary_Contact_Person__c;
            con.Email = proposal.Primary_Email__c;
            con.Phone =proposal.Phone__c;
            con.AccountId =proposal.Customer_Or_Supplier__c;
            insert con;
        }
        //  validateProductItem();
       
        insert proposal;
        proposalversion.Proposal__c =proposal.Id;
        insert proposalversion;
        proposal.Proposal_Version__c = proposalversion.Id;
        update proposal;
          
        
        
     /*   proposal = new Proposal__c();
        proposalversion = new Proposal_Version__c();
        productitems = new Product_Items__c();
        productitemsList = new List<Product_Items__c>();
        productitemsList.add(new Product_Items__c());
        totalProposalAmount=0;
*/
        Pagereference ref = new Pagereference('/'+proposal.Id);
        ref.setRedirect(true);
        return ref; 
    }
    public Pagereference insertProductItems()
    {        
        List<Product_Items__c> tempList = new List<Product_Items__c>();
        for(Product_Items__c item : productitemsList)
        {
            item.Proposal_Version__c =proposalversion.id;
            item.Enquiry__c =proposal.Id;
            if(item.Total_Price__c != null)
            {
                tempList.add(item);
            }
        }
        if(!tempList.isEmpty()  )
        {
            insert tempList;
        }
        return null;
    }
    
    public Pagereference validateProductItem()
    {
        
        for(Product_Items__c item : productitemsList)
        {
            if(item.Total_Price__c == null || item.Quantity__c == null || item.Unit_Price__c == null )
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide values for all product Items'));
                return null;
            }
            if(item.Is_Custom_Product__c && item.Product_Name__c ==null )
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide values for all product Items'));
                return null;
            }
            if(!item.Is_Custom_Product__c && item.Product__c == null )
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please provide values for all product Items'));
                return null;
            }
        }
        
        return null;
    }
    public Pagereference fetchContacts()
    {
        if(Proposal.Customer_Or_Supplier__c != null)
        {
            Account temp = [Select id,name,website,AccountNumber,Industry from Account Where Id =:Proposal.Customer_Or_Supplier__c];
            Proposal.Customer_Id__c =temp.AccountNumber;
            proposal.Industry__c = temp.Industry;
            proposal.Company_Website__c = temp.Website;
            proposal.Customer_Name__c = temp.name;
            Contact tempCon = new Contact();
            for(Contact con : [Select id,name,lastName,email,Phone,OtherPhone from Contact Where AccountId=:Proposal.Customer_Or_Supplier__c])
            {
                tempCon =con;
                contactList.add(new SelectOption(con.Id,con.Name));
            }
            if(tempCon != null)
            {
                proposal.Phone__c = tempcon.Phone;
                proposal.Primary_Contact_Person__c = tempcon.Name;
                proposal.Primary_Email__c = tempcon.Email;
                proposal.Alternate_Phone__c = tempcon.OtherPhone;
            }
        }
        
        return null;
    }
    public Pagereference mapContactDetails()
    {
        Contact tempCon = new Contact();
        
        if(selectedContact != null && !isNewContact)
        {
             tempCon=[Select id,name,lastName,email,Phone,OtherPhone from Contact Where Id=:selectedContact];
            proposal.Phone__c = tempcon.Phone;
            proposal.Primary_Contact_Person__c = tempcon.Name;
            proposal.Primary_Email__c = tempcon.Email;
            proposal.Alternate_Phone__c = tempcon.OtherPhone;
        }
        else
        {
            proposal.Phone__c = null;
            proposal.Primary_Contact_Person__c = null;
            proposal.Primary_Email__c = null;
            proposal.Alternate_Phone__c = null;            
        }
        return null;
    }
    public Pagereference fetchSupplierData()
    {
        String searchtext;
        searchtext ='%test%';
        if(searchTextSupplier != null)
        {
             searchtext ='%'+searchTextSupplier+'%';
        }
        
        supplierProductsList = new List<Supplier_Product__c> ();
        supplierProductsList = [Select id,name,Product__c,Product__r.Name,Supplier__c,Supplier__r.Name,
                                Last_Approved_Price__c,Last_Approved_Quantity__c,LastModifiedDate,Is_Selected__c,
                                Shipping_Location__c,Payment_Terms__c,Quotation_Received_Per_Unit__c
                                From Supplier_Product__c
                               Where name like :searchtext limit 100];
        return null;
    }
    public Pagereference saveProductItems()
    {
        Product_Items__c temp = new Product_Items__c();
        String recordId = (ApexPages.currentPage().getParameters().get('LoopId'));
        if(recordId != null)
        {
            for(Product_Items__c item : productitemsList)
            {
                if(item.Id ==recordId)
                {
                    temp = item;
                   // temp.name = item.Product_Name__c;
                }
            }
            if(temp != null)
            {
                try
                {
                    update temp;
                    selectedPrdItem =temp;
                    selectedProductItemId =recordId;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Product Items Saved Successfully'));
                    return null;
                }catch(Exception e)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                    return null;
                }
          
            }
        }
          
        return null;
    }
    
    
    public Pagereference SaveSupplierproducts()
    {
        system.debug('@@@@supplierProductsList'+supplierProductsList);
        if(!supplierProductsList.isEmpty())
        {
            List<Outbound_Enquiry__c> tempOUBList = new List<Outbound_Enquiry__c>();
            for(Supplier_Product__c supp :supplierProductsList )
            {
               system.debug('@@@supp'+supp);
                if(supp.Is_Selected__c && supp != null)
                {
                    Outbound_Enquiry__c oub = new Outbound_Enquiry__c();
                    oub.Product_Items__c =selectedPrdItem.id;
                    oub.Enquiry__c =enquiryRecordId;
                    oub.Name  =supp.Supplier__r.Name;
                    oub.Supplier_Product__c =supp.Id;
                    oub.Supplier__c =supp.Supplier__c;
                   
                    tempOUBList.add(oub);
                }
                
            }
            if(!tempOUBList.isEmpty())
            {
                insert tempOUBList;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Outbound Enquiries are created successfully'));
               // ApexPages.currentPage().getParameters().put('LoopId',selectedPrdItem.id);
             //   showSuppliers();
               
                return null;
            }
        }
        
        return null;
    }
    public Pagereference addProductItem()
    {
        Product_Items__c aTemp = new Product_Items__c();
        aTemp.Proposal_Version__c =enquiryVersionRecordId;
        aTemp.Enquiry__c =enquiryRecordId;
        insert aTemp;
        productitemsList.add(aTemp);
        return null;
    }
    public Pagereference removeProductItem()
    {
        String recordId = (ApexPages.currentPage().getParameters().get('RemoveId'));
        if(recordId != null)
        {
            try
            {
                
                Product_Items__c aTemp = new Product_Items__c();
                aTemp.Id =recordId;
                Delete aTemp;
                
                productitemsList =[Select id,name,Is_Custom_Product__c,Product__c,Product_Description__c,UOM__c,Show_Supplier__c,
                                   Product_Name__c,Product_Type__c,Proposal_Version__c,Quantity__c,Total_Price__c,Unit_Price__c 
                                   ,Margin__c, Supplier_Price__c,   Total_Price_with_GST__c,GST__c,Enquiry__c, Product__r.Name from Product_Items__c
                                   where Proposal_Version__c =:enquiryRec.Proposal_Version__c order by createddate desc  ];
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Product Item Removed Successfully '));
                return null;
            }catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                return null;
            }
        }
       
        return null;
    }
    public Pagereference calculate()
    {
        totalProposalAmount =0;
        for(Product_Items__c item : productitemsList)
        {
            if(item.Quantity__c != null && item.Unit_Price__c != null )
            {
                item.Total_Price__c = item.Quantity__c * item.Unit_Price__c;
                
            }
        }
        update productitemsList;
        productitemsList =[Select id,name,Is_Custom_Product__c,Product__c,Product_Description__c,UOM__c,Show_Supplier__c,
                           Product_Name__c,Product_Type__c,Proposal_Version__c,Quantity__c,Total_Price__c,Unit_Price__c 
                           ,Margin__c, Supplier_Price__c,Total_Price_with_GST__c,GST__c,Enquiry__c, Product__r.Name from Product_Items__c
                           where Id In :productitemsList order by createddate desc ];
        for(Product_Items__c item : productitemsList)
        {
            totalProposalAmount =  totalProposalAmount+ item.Total_Price_with_GST__c;
        }
        return null;
    }
    public Pagereference hideSuppliers()
    {
        String recordId = (ApexPages.currentPage().getParameters().get('LoopId'));
        supplierAction(recordId,false);
        return null;
    }
    public Pagereference showSuppliers()
    {
        String recordId = (ApexPages.currentPage().getParameters().get('LoopId'));
        supplierAction(recordId,true);
        return null;
    }
    public void supplierAction(String recordId,Boolean isShow)
    {
        
        supplierRequests = new List<Outbound_Enquiry__c>();
        if(recordId != null)
        {
            
            for(Product_Items__c prd : productitemsList)
            {
                if(prd.id==recordId)
                {
                    prd.Show_Supplier__c =isShow;
                }
                else
                {
                    prd.Show_Supplier__c =false;
                }
            }
            
            supplierRequests =[Select id,name,Product_Items__c,Enquiry__c,Supplier_Product__c,Supplier__r.Name,
                               Supplier_Product__r.Name,Payment_Terms__c,Shipping_Location__c,Status__c,Quotation_Received_Per_Unit__c,
                               Amount__c
                               from Outbound_Enquiry__c 
                               Where Product_Items__c =:recordId ];                       
        }
    }
    
    public void onChangePT()
    {
        system.debug('<<onChangePT>>'+proposalv2);
        advanceCheck = false;
        creditCheck = false;
        pdcCheck = false;
        advanceCheckRO = true;
        creditCheckRO = true;
        pdcCheckRO = true;
        if(proposalv2.Payment_Terms__c == 'Advance'){
            advanceCheckRO = false;
            advanceCheck = true;
        }
        else if(proposalv2.Payment_Terms__c == 'Credit'){
            creditCheckRO = false;
            creditCheck = true;
        }
        else if(proposalv2.Payment_Terms__c == 'PDC'){
            pdcCheckRO = false;
            pdcCheck = true;
        }
    }
    
   public PageReference savePDF()
    {
        system.debug('<<savePDF>>'+proposalv2);
        Update proposalv2;
        Proposal__c enquiry = new Proposal__c();
        enquiry =[Select id,name,Quoted_Amount__c,Status__c,Payment_Terms__c, Detail_Advace__c, No_of_Days_Credit__c, Number_of_Days_of_Check__c, Shipping_Location__c, Lead_Time__c, Place_Of_Supply__c  from Proposal__c Where Id=:proposalv2.Id ];
        system.debug('<<savePDFv2>>'+enquiry);
        Decimal totalApprovedAmt =0; 
        for(Product_Items__c item : [Select id,name,Total_Price_with_GST__c,Is_Approved__c from 
                                     Product_Items__c Where Is_Approved__c='Approved' and Enquiry__c =:enquiry.Id  ] )
        {
            totalApprovedAmt =  totalApprovedAmt+ item.Total_Price_with_GST__c;
        }
        Quotation__c quote =  new Quotation__c();
        quote.Enquiry__c = enquiry.Id;
        quote.Quoted_Amount__c = totalApprovedAmt;
        quote.Status__c = 'New';
        insert quote;
        system.debug('<<quote>>'+quote.Id);
        Quotation__c quoteFetch =  new Quotation__c();
        quoteFetch = [Select Id, Name from Quotation__c Where Id = :quote.Id];
        system.debug('<<quoteFetch>>'+quoteFetch.Id);
        ContentVersion cv = new ContentVersion();
        cv.Title = quoteFetch.Name+'-'+System.now();
        cv.PathOnClient = quoteFetch.Name+'-'+System.now()+'.pdf';
        PageReference pdf = Page.EnquiryPDFGeneration;
        if(test.isRunningTest())
        {
            cv.VersionData  =blob.valueOf('test');
        }
        else
        {
            cv.VersionData = pdf.getContentAsPDF();
        }
      
       
        cv.IsMajorVersion = true;
        Insert cv;
        system.debug('<<cv>>'+cv.Id);
        
        Id conDocId = [Select ContentDocumentId from ContentVersion Where Id =:cv.Id].ContentDocumentId;
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = quoteFetch.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId = enquiryRec.Id;
        cdl1.ContentDocumentId = conDocId;
        cdl1.shareType = 'V';
        Insert cdl1;
        
        system.debug('<<cdl>>'+cdl.Id);
        return new PageReference('/'+quoteFetch.Id);
    }
}
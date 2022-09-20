@isTest
private class ProposalHomeControllerTest
{
    @isTest static void ProposalHomeMethod1()
    {
        Test.startTest();
        
        Account acc1 = new Account();
        acc1.Name = 'Anthem Bio';
        acc1.Phone = '9845147714';
        insert acc1;
        
        Proposal__c prop1 = new Proposal__c();
        prop1.Name = 'New Request on July 30, 21';
        prop1.Status__c = 'New';
        prop1.Customer_Or_Supplier__c = acc1.Id;
        prop1.Customer_Id__c = acc1.Id;
        prop1.Customer_Name__c = acc1.Name;
        prop1.Primary_Contact_Person__c = 'Test Contact';
        prop1.Primary_Email__c = 'test123@gmail.com';
        prop1.New_Customer__c = true;
        prop1.Phone__c='6787676789';
        insert prop1;
        
        Proposal_Version__c propVer1 = new Proposal_Version__c();
        propVer1.Proposal__c = prop1.Id;
        propVer1.Total_Amount__c = 30000;
        insert propVer1;
        
        prop1.Proposal_Version__c = propVer1.Id;
        Update prop1;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Hydroxy ethyl cellulose';
        prod1.IsActive = true;
        prod1.Description = 'Hydroxy ethyl cellulose Description';
        insert prod1;
        
        List<Product_Items__c> prodItmList = new List<Product_Items__c>();
        Product_Items__c prodItm1 = new Product_Items__c();
        prodItm1.Proposal_Version__c = propVer1.Id;
        prodItm1.Product__c = prod1.Id;
        prodItm1.Quantity__c = 30;
        prodItm1.Unit_Price__c = 500;
        prodItm1.Total_Price__c = 30000;
        prodItm1.UOM__c = 'KG';
        prodItmList.add(prodItm1);
        Product_Items__c prodItm2 = new Product_Items__c();
        prodItm2.Proposal_Version__c = propVer1.Id;
        prodItmList.add(prodItm2);
        //insert prodItmList;
        Test.stopTest();
        
        PageReference pageRef = Page.ProposalHome;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(prop1.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(prop1);
        ProposalHomeController testAccPropStd = new ProposalHomeController(sc);
        ProposalHomeController testAccProp = new ProposalHomeController();
        PageReference testsaveProposal = testAccProp.saveProposal();
        PageReference testinsertProdProposal = testAccProp.insertProductItems();
        PageReference testvalidateProdProposal = testAccProp.validateProductItem();
        PageReference testfetchContProposal = testAccProp.fetchContacts();
        PageReference testcontDetailsProposal = testAccProp.mapContactDetails();
        PageReference testsaveProdProposal = testAccProp.saveProductItems();
        PageReference testsaveSupplierProposal = testAccProp.SaveSupplierproducts();
        PageReference testaddProdItemsProposal = testAccProp.addProductItem();
        PageReference testremoveProdProposal = testAccProp.removeProductItem();
        PageReference testcalculateProposal = testAccProp.calculate();
        pageRef.getParameters().put('LoopId', [Select id from Product_Items__c limit 1].Id);
        PageReference testshowSupplierProposal = testAccProp.showSuppliers();
        PageReference testpdf = testAccPropStd.savePDF();
        Product_Items__c testprd = new Product_Items__c();
        testprd=   [Select id,is_Approved__c from Product_Items__c limit 1];
        testprd.Is_Approved__c ='Approved';
        update testprd; 
    }
    @isTest static void ProposalHomeMethod2()
    {
        Test.startTest();
        
        Account acc1 = new Account();
        acc1.Name = 'Anthem Bio';
        acc1.Phone = '9845147714';
        insert acc1;
        
        Proposal__c prop1 = new Proposal__c();
        prop1.Name = 'New Request on July 30, 21';
        prop1.Status__c = 'New';
        prop1.Customer_Or_Supplier__c = acc1.Id;
        prop1.Customer_Id__c = acc1.Id;
        prop1.Customer_Name__c = acc1.Name;
        prop1.Primary_Contact_Person__c = 'Test Contact';
        prop1.Primary_Email__c = 'test123@gmail.com';
        prop1.New_Customer__c = true;
         prop1.Phone__c='6787676789';
        insert prop1;
        
        Proposal__c prop2 = new Proposal__c();
        prop2.Name = 'New Request on July 30, 21';
        prop2.Status__c = 'New';
        prop2.Customer_Or_Supplier__c = acc1.Id;
        prop2.Customer_Id__c = acc1.Id;
        prop2.Customer_Name__c = acc1.Name;
        prop2.Primary_Contact_Person__c = 'Test Contact';
        prop2.Primary_Email__c = 'test123@gmail.com';
        prop2.New_Customer__c = true;
        prop2.Phone__c='2314234124';
        
        Proposal_Version__c propVer1 = new Proposal_Version__c();
        propVer1.Proposal__c = prop1.Id;
        propVer1.Total_Amount__c = 30000;
        insert propVer1;
        
        prop1.Proposal_Version__c = propVer1.Id;
        Update prop1;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Hydroxy ethyl cellulose';
        prod1.IsActive = true;
        prod1.Description = 'Hydroxy ethyl cellulose Description';
        insert prod1;
        
        List<Product_Items__c> prodItmList = new List<Product_Items__c>();
        Product_Items__c prodItm1 = new Product_Items__c();
        prodItm1.Proposal_Version__c = propVer1.Id;
        prodItm1.Product__c = prod1.Id;
        prodItm1.Quantity__c = 30;
        prodItm1.Unit_Price__c = 500;
        prodItm1.Total_Price__c = 30000;
        prodItm1.UOM__c = 'KG';
        prodItmList.add(prodItm1);
        Product_Items__c prodItm2 = new Product_Items__c();
        prodItm2.Proposal_Version__c = propVer1.Id;
        prodItmList.add(prodItm2);
        //insert prodItmList;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact';
        con1.Phone = '1234456789';
        con1.AccountId = acc1.Id;
        Insert con1;
        
        Supplier_Product__c supProd1 = new Supplier_Product__c();
        supProd1.Name = 'Test Supplier Prod';
        supProd1.Supplier__c = acc1.Id;
        insert supProd1;
        Test.stopTest();
        
        PageReference pageRef = Page.ProposalHome;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(prop1.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(prop1);
        ProposalHomeController testAccPropStd = new ProposalHomeController(sc);
        ProposalHomeController testAccProp = new ProposalHomeController();
        testAccProp.proposal = prop2;
        testAccProp.selectedContact = con1.Id;
        testAccProp.isNewContact = false;
        testAccProp.productitemsList = prodItmList;
        PageReference testsaveProposal = testAccProp.saveProposal();
        PageReference testinsertProdProposal = testAccProp.insertProductItems();
        PageReference testvalidateProdProposal = testAccProp.validateProductItem();
        PageReference testfetchContProposal = testAccProp.fetchContacts();
        PageReference testcontDetailsProposal = testAccProp.mapContactDetails();
        PageReference testsaveProdProposal = testAccProp.saveProductItems();
        testAccProp.searchTextSupplier = supProd1.Name;
        PageReference testsaveSupplierProposal = testAccProp.SaveSupplierproducts();
        PageReference testaddProdItemsProposal = testAccProp.addProductItem();
        PageReference testremoveProdProposal = testAccProp.removeProductItem();
        PageReference testshowSupplierProposal = testAccProp.showSuppliers();
    }
    @isTest static void ProposalHomeMethod3()
    {
        Test.startTest();
        
        Account acc1 = new Account();
        acc1.Name = 'Anthem Bio';
        acc1.Phone = '9845147714';
        insert acc1;
        
        Proposal__c prop1 = new Proposal__c();
        prop1.Name = 'New Request on July 30, 21';
        prop1.Status__c = 'New';
        prop1.Customer_Or_Supplier__c = acc1.Id;
        prop1.Customer_Id__c = acc1.Id;
        prop1.Customer_Name__c = acc1.Name;
        prop1.Primary_Contact_Person__c = 'Test Contact';
        prop1.Primary_Email__c = 'test123@gmail.com';
        prop1.New_Customer__c = false;
        prop1.Phone__c='6787676789';
        insert prop1;
        
        Proposal__c prop2 = new Proposal__c();
        prop2.Name = 'New Request on July 30, 21';
        prop2.Status__c = 'New';
        prop2.Customer_Or_Supplier__c = acc1.Id;
        prop2.Customer_Id__c = acc1.Id;
        prop2.Customer_Name__c = acc1.Name;
        prop2.Primary_Contact_Person__c = 'Test Contact';
        prop2.Primary_Email__c = 'test123@gmail.com';
        prop2.New_Customer__c = false;
        prop2.Phone__c='2314234124';
        
        Proposal_Version__c propVer1 = new Proposal_Version__c();
        propVer1.Proposal__c = prop1.Id;
        propVer1.Total_Amount__c = 30000;
        insert propVer1;
        
        prop1.Proposal_Version__c = propVer1.Id;
        Update prop1;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Hydroxy ethyl cellulose';
        prod1.IsActive = true;
        prod1.Description = 'Hydroxy ethyl cellulose Description';
        insert prod1;
        
        List<Product_Items__c> prodItmList = new List<Product_Items__c>();
        Product_Items__c prodItm1 = new Product_Items__c();
        prodItm1.Proposal_Version__c = propVer1.Id;
        prodItm1.Product__c = prod1.Id;
        prodItm1.Quantity__c = 30;
        prodItm1.Unit_Price__c = 500;
        prodItm1.Total_Price__c = 30000;
        prodItm1.UOM__c = 'KG';
        prodItmList.add(prodItm1);
        Product_Items__c prodItm2 = new Product_Items__c();
        prodItm2.Proposal_Version__c = propVer1.Id;
        prodItmList.add(prodItm2);
        //insert prodItmList;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact';
        con1.Phone = '1234456789';
        con1.AccountId = acc1.Id;
        Insert con1;
        
        Supplier_Product__c supProd1 = new Supplier_Product__c();
        supProd1.Name = 'Test Supplier Prod';
        supProd1.Supplier__c = acc1.Id;
        supProd1.Is_Selected__c = true;
        insert supProd1;
        Test.stopTest();
        ProposalHomeController testAccProp = new ProposalHomeController();
        testAccProp.proposal = prop2;
        testAccProp.isNewContact = true;
        testAccProp.productitemsList = prodItmList;
        PageReference testsaveProposal = testAccProp.saveProposal();
        PageReference testsaveSupplierProposal = testAccProp.SaveSupplierproducts();
    }
    @isTest static void ProposalHomeMethod4()
    {
        Test.startTest();
        
        Account acc1 = new Account();
        acc1.Name = 'Anthem Bio';
        acc1.Phone = '9845147714';
        insert acc1;
        
        Proposal__c prop1 = new Proposal__c();
        prop1.Name = 'New Request on July 30, 21';
        prop1.Status__c = 'New';
        prop1.Customer_Or_Supplier__c = acc1.Id;
        prop1.Customer_Id__c = acc1.Id;
        prop1.Customer_Name__c = acc1.Name;
        prop1.Primary_Contact_Person__c = 'Test Contact';
        prop1.Primary_Email__c = 'test123@gmail.com';
        prop1.New_Customer__c = false;
         prop1.Phone__c='6787676789';
        insert prop1;
        
        Proposal__c prop2 = new Proposal__c();
        prop2.Name = 'New Request on July 30, 21';
        prop2.Status__c = 'New';
        prop2.Customer_Or_Supplier__c = acc1.Id;
        prop2.Customer_Id__c = acc1.Id;
        prop2.Customer_Name__c = acc1.Name;
        prop2.Primary_Contact_Person__c = 'Test Contact';
        prop2.Primary_Email__c = 'test123@gmail.com';
        prop2.New_Customer__c = false;
        
        Proposal_Version__c propVer1 = new Proposal_Version__c();
        propVer1.Proposal__c = prop1.Id;
        propVer1.Total_Amount__c = 30000;
        insert propVer1;
        
        prop1.Proposal_Version__c = propVer1.Id;
        Update prop1;
        
        Product2 prod1 = new Product2();
        prod1.Name = 'Hydroxy ethyl cellulose';
        prod1.IsActive = true;
        prod1.Description = 'Hydroxy ethyl cellulose Description';
        insert prod1;
        
        List<Product_Items__c> prodItmList = new List<Product_Items__c>();
        Product_Items__c prodItm1 = new Product_Items__c();
        prodItm1.Proposal_Version__c = propVer1.Id;
        prodItm1.Product__c = prod1.Id;
        prodItm1.Quantity__c = 30;
        prodItm1.Unit_Price__c = 500;
        prodItm1.Total_Price__c = 30000;
        prodItm1.UOM__c = 'KG';
        prodItmList.add(prodItm1);
        Product_Items__c prodItm2 = new Product_Items__c();
        prodItm2.Proposal_Version__c = propVer1.Id;
        prodItmList.add(prodItm2);
        insert prodItmList;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Test';
        con1.LastName = 'Contact';
        con1.Phone = '1234456789';
        con1.AccountId = acc1.Id;
        Insert con1;
        
        Supplier_Product__c supProd1 = new Supplier_Product__c();
        supProd1.Name = 'Test Supplier Prod';
        supProd1.Supplier__c = acc1.Id;
        supProd1.Is_Selected__c = true;
        insert supProd1;
        Test.stopTest();
        
        PageReference pageRef = Page.ProposalHome;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(prop1.Id));
        pageRef.getParameters().put('LoopId', prodItm1.Id);
        pageRef.getParameters().put('RemoveId', prodItm1.Id);
        ProposalHomeController testAccProp = new ProposalHomeController();
        testAccProp.saveProductItems();
        testAccProp.removeProductItem();
    }
}
trigger TriggertoCalculate on Product_Items__c (After update) {

    	if(Trigger.isUpdate && Trigger.isAfter)
        {
            List<Product_Items__c> productitemsList = new List<Product_Items__c>();
            Set<String> idSet = new Set<String>();
            for(Product_Items__c prd : [Select id,Is_Approved__c from Product_Items__c Where Id In : trigger.new])
            {
               if(prd.Is_Approved__c=='Approved' && prd.Is_Approved__c != trigger.oldMap.get(prd.Id).Is_Approved__c)
               {
                   idSet.add(prd.Id);
               }
                
            }
            productitemsList =[Select id,name,Is_Custom_Product__c,Product__c,Product_Description__c,UOM__c,Show_Supplier__c,
                           Product_Name__c,Product_Type__c,Proposal_Version__c,Quantity__c,Total_Price__c,Unit_Price__c 
                           ,Margin__c, Supplier_Price__c from Product_Items__c
                           where Id In :idSet and Is_Approved__c ='Approved' ];
            List<Product_Items__c> tempList = new List<Product_Items__c>();
            for(Product_Items__c item : productitemsList)
            {
                if(item.Quantity__c != null && item.Unit_Price__c != null )
                {
                    item.Total_Price__c = item.Quantity__c * item.Unit_Price__c;
                    tempList.add(item);
                }
            }
            if(!tempList.isEmpty())
            {
                 update tempList;
            }
           
        }
}
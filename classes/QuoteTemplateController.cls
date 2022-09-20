public class QuoteTemplateController {
    public List<DiscountTierWrapper> discountTiers {get; private set;}
    public templateDetail formatDetails {get; private set;}
    
    protected Id quoteId;
    
    public QuoteTemplateController() {
        discountTiers = new List<DiscountTierWrapper>();
        quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
    }
    public PageReference init()
    {
        formatDetails = new templateDetail();
        formatDetails.TableBorder  ='1px sold red;';
        formatDetails.TableFontFamily ='verdana;';
        formatDetails.TableFontSize  ='1em;';
        formatDetails.TableTextColor ='blue;';
        formatDetails.TierNameColumHeading  ='Quote testing';
        formatDetails.TierPriceColumnHeading  ='Total price';
        
        for(Integer c=0;c<=10;c++)
        {
            DiscountTierWrapper wrp = new DiscountTierWrapper();
            wrp.Name='Product '+c;
            wrp.calcUnitPrice = c*456.2;
            discountTiers.add(wrp);
        }
        
        return null;
    }
  /*  public PageReference init() {
        // Step #1
        formatDetails = [select TableBorder__c, TableFontFamily__c, TableFontSize__c, 
                         TableTextColor__c, TierNameColumHeading__c, TierPriceColumnHeading__c 
                         from DiscountTierTableFormatDetails__mdt limit 1];
        
        // Step #2
        try {
            Map<Id, SBQQ__QuoteLine__c> mapQlinesByDiscountSchedule = new Map<Id, SBQQ__QuoteLine__c>();
            for (SBQQ__QuoteLine__c qline :[select Id, 
                                            SBQQ__DiscountSchedule__c from SBQQ__QuoteLine__c 
                                            where SBQQ__Quote__c =:quoteId]) {
                                                mapQlinesByDiscountSchedule.put(qline.SBQQ__DiscountSchedule__c, qline); 
                                            }
            
            // now lets get our discount tiers
            // Step #3
            Map<Id, List<SBQQ__DiscountTier__c>> mapDiscountTiersByQli = new Map<Id, List<SBQQ__DiscountTier__c>>();
            for (SBQQ__DiscountTier__c discountTier : [select Name, Id, SBQQ__Price__c
                                                       from SBQQ__DiscountTier__c 
                                                       where SBQQ__Schedule__c in :mapQlinesByDiscountSchedule.keyset()]) {
                                                           // Step #4
                                                           discountTiers.add(new DiscountTierWrapper(discountTier));
                                                       } 
            return null;
        } catch (Exception exc) {
            String errorMsg = 'There was an error getting Discount Schedules for our Quote. Exception Cause = ' + 
                exc.getCause() + ', Exception Message = ' + exc.getMessage();
            System.debug('=====> ' + errorMsg);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
        }
        return null;
    }*/
    public class DiscountTierWrapper {
        public String name {get; set;}
        public Decimal calcUnitPrice {get; set;}
        
    /*    public DiscountTierWrapper(SBQQ__DiscountTier__c tier) {
            this.name = tier.Name;
            this.calcUnitPrice = tier.SBQQ__Price__c;
        } */
    }
    public class templateDetail {
        public String TableBorder {get; set;}
        public String TableFontFamily {get; set;}
        public String TableFontSize {get; set;}
        public String TableTextColor {get; set;}
        public String TierNameColumHeading {get; set;}
        public String TierPriceColumnHeading {get; set;}
        
        
    }
}
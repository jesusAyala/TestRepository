/**
 *  Test class for class Lead_triggerFunctions
 *
 @author    Juillet Yuan
 @created   2015-03-04
 @version   1.0
 @since     31.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-03-04 Juillet Yuan <Juillet.Yuan@itbconsult.com>
 * - Created
 * -test coverage--100%
 */
@isTest(seeAlldata=false)
private  class Lead_triggerFunctions_Test {
   public static testMethod void test1() {
     Lead ld_new = new Lead(lastName='test',IsConverted=true,Description__c='ABD');
     list<Lead> list_ld_new  = new list<Lead>();
     list_ld_new.add(ld_new);
     Lead ld_old = new Lead(lastName='test',IsConverted=false,Description__c='ABD');
     list<Lead> list_ld_old  = new list<Lead>();
     list_ld_old.add(ld_old);
     test.startTest();
     Lead_triggerFunctions.generatePDF(list_ld_new,list_ld_old);
     test.stopTest();
   }
     public static testMethod void test2() {
     ID Rectypeid=Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Contact Center').getRecordTypeId();//Fetching Lead Record Type Id for Contact center Record Type of Lead
     system.debug('###'+Rectypeid);
     Lead ldtest = new Lead(LastName='test2',Subject__c='Hello',Description__c='ABB',Status='Contacted',Company='P&G',Request_Type__c='Service',Division__c='DM',Country='Australia',
     city='Candotia',Street='PortB',PostalCode='123456',Budget__c='Yes',Purchasing_power__c='Yes',Positioning__c='Yes',Fit__c='Yes',Interest_need__c='abc',Timeframe__c=System.today());
     insert ldtest;
     system.debug('*****'+ldtest.id);
     //convert the lead, which will create an opportunity
     Database.LeadConvert lc = new database.LeadConvert();
     lc.setLeadId(ldtest.id);
     LeadStatus convertstatus = [select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
     lc.setConvertedStatus(convertStatus.MasterLabel);
     Database.LeadConvertResult lcr = Database.convertLead(lc);
     System.assert(lcr.isSuccess());
     System.debug('OppID'+lcr.getOpportunityId());
}
}
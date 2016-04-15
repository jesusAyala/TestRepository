/**
 * ApexClass -  Test_ClsChannelPreQualificCompController 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-15
 * @version 1.0
 * Description: 
 * Created
 
  */
@isTest
private class Test_ClsChannelPreQualificCompController { 
    static testMethod void myTest() {
        
        Test.startTest();
        
         Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', Primary_Address_Country__c = 'Germany'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', Primary_Address_Country__c = 'Germany')};
                
        insert accs;  
        
        Channel_Market_Coverage__c[] mc = new Channel_Market_Coverage__c[] {
            new Channel_Market_Coverage__c( Account__c = accs[0].Id, Name = 'Test Market Coverage', Division__c = 'DM;PA', Primary_Channel_Class__c ='Installer (INST)'),
            new Channel_Market_Coverage__c( Account__c = accs[1].Id, Name = 'Test 2', Division__c = 'PA;PG', Primary_Channel_Class__c ='Installer (INST)')
        };
        insert mc;
        
      
        Channel_Qualifications__c[] channelQualList = new Channel_Qualifications__c[] {
            new Channel_Qualifications__c ( Name = 'Test 1', Status__c = 'Draft', Account__c = accs[0].Id, Channel_Market_Coverage__c = mc[0].Id, General_Answer_1__c = '6',
            Market_Answer_1__c = '6', Approval_Date__c = Date.Today().addDays(2), Date_of_Completed__c = Date.Today().addDays(3)),
            
            new Channel_Qualifications__c ( Name = 'Test 2', Status__c = 'Draft', Account__c = accs[0].Id, Channel_Market_Coverage__c = mc[1].Id, General_Answer_1__c = '6',
            Market_Answer_1__c = '6', Approval_Date__c = Date.Today().addDays(2), Date_of_Completed__c = Date.Today().addDays(3)),
            
            new Channel_Qualifications__c ( Name = 'Test 3', Status__c = 'Draft', Account__c = accs[1].Id, Channel_Market_Coverage__c = mc[0].Id, General_Answer_1__c = '6',
            Market_Answer_1__c = '6', Approval_Date__c = Date.Today().addDays(2), Date_of_Completed__c = Date.Today().addDays(3)),
            
            new Channel_Qualifications__c ( Name = 'Test 3', Status__c = 'Draft', Account__c = accs[1].Id, Channel_Market_Coverage__c = mc[1].Id, General_Answer_1__c = '6',
            Market_Answer_1__c = '6', Approval_Date__c = Date.Today().addDays(2), Date_of_Completed__c = Date.Today().addDays(3))
        };
        
        insert channelQualList;
        
        ApexPages.currentPage().getParameters().put('Id', accs[0].Id);
        ClsChannelPreQualificCompareController channel = new ClsChannelPreQualificCompareController();
        channel.getChannelPQList();
        channel.getHasPrevious();
        channel.getHasNext();
        channel.getPageNumber();
        channel.getTotalPages();
        channel.doNext();
        channel.first();
        channel.last();
        channel.doPrevious();
        channel.getDisplayOpt();
        channel.selectedOpt = 'All';
        channel.changeDisplayingRecords();
        channel.selectedOpt = 'Selected';
        channel.changeDisplayingRecords();
        channel.selectedOpt = 'Unselected';
        channel.changeDisplayingRecords();
        channel.getDivisionList();
        channel.getprimaryCountryList();
        channel.selectedOpt = 'All';
        channel.sortRecordsByColumn();
        channel.selectedOpt = 'Selected';
        channel.sortRecordsByColumn();
        channel.selectedOpt = 'Unselected';
        channel.sortRecordsByColumn();
        channel.selectedChannelId = channelQualList[0].ID+','+ channelQualList[1].ID+','+ channelQualList[2].ID;
        channel.displaySelectedRecords();
       
        channel.SearchChannelPreQual();
        channel.goToChartPage();
        channel.cancel();
       
        channel.backToDisplay();
    }
}
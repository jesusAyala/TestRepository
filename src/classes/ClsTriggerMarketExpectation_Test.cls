/**
 * ApexClass -  Test class ClsTriggerMarketExpectation_Test
 * Release R5
 * @author  Indhu Ramalingam (Accenture)
 * @created 2016-03-22
 * @version 1.0
 * Description: Test class for - ClsTriggerMarketExpectation
 * Created 
 */
 @isTest
private class ClsTriggerMarketExpectation_Test{
    public static User createTestUser1() {
        User u = new User();
        u.FirstName ='haobo';
        u.LastName = 'song';
        u.Username = 'test123ABB1237@test123ABB1237.com';
        u.Alias = 'mtst4';
        u.Email = 'mtester1@company.com';
        u.CommunityNickname = u.Alias;
        u.ProfileId = [Select Id from Profile Where Name = 'ABB Sales Standard Profile' limit 1].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.ManagerId = UserInfo.getUserId();
        return u;
    }

    public static Account createAccount1(){
        Account a = new Account();
        a.Name = 'test';
        a.BillingStreet = 'street'; 
        a.BillingCity = 'city';
        a.BillingCountry = 'Germany';
        a.GUID__c = '1234sghf';
        return a;
    }
    
    public static Account_Plan__c createAccPlan() {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Name = 'TestAccPlan1';
        ap.Status__c = 'Planning';
        ap.Account_Plan_Year__c = '2016';
        return ap;
    }
    
    public static Account_Plan_Team__c createAccPlanTeam1(){
        Account_Plan_Team__c apT1 = new Account_Plan_Team__c();
        apT1.Access__c= 'Read/Write';
        apT1.Team_Role__c='GAM/SAM Account Manager';
        return apT1;
    }
    
    public static Market_Expectation__c createMarkExp() {
        Market_Expectation__c me = new Market_Expectation__c();
        me.Account_Plan_Year__c = '2025';
        return me;
    }
    
    static testMethod void marketExpMethod() {
        Test.startTest();
        User u1 = createTestUser1();
            insert u1;
        Account a = createAccount1();
            insert a; 
        Account_Plan__c ap = createAccPlan();
            insert ap;
        Account_Plan_Team__c  actPlanTeam1 = createAccPlanTeam1();
            actPlanTeam1.Account_Plan__c = ap.Id;
            actPlanTeam1.User__c = u1.id;
            insert actPlanTeam1 ;
        Market_Expectation__c me = createMarkExp();
            me.Account_Plan__c = ap.id;
            insert me;
            ap.Status__c = 'Closed';
            system.runAs(u1){
            try{
                update ap;
                delete me;
            }catch(exception e){}
            }
        
        Test.stopTest();
    }
}
/**
 * ApexClass -  ClsTriggerJointBusinessPlanHandler_Test
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-23
 * @version 1.0
 * Description: 
  This class will cover the ClsTriggerJointBusinessPlanHandler_Test
 * Created
 
  */
@isTest
private class ClsTriggerJointBusinessPlanHandler_Test{

    static testMethod void ClsTriggerJointBusinessTeam_Test   () {
        
        Test.startTest();
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany', Company_Description__c  = 'tessssssssssssssssssssssssssssssssssssssssssttttttttttt'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany')};
                
        insert accs;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(adminId, 'Admin1'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID)
        };
        
        insert accTeamList;
        
       
        Channel_Market_Coverage__c[] cmcList = new Channel_Market_Coverage__c[]{
            new Channel_Market_Coverage__c(Account__c = accs[0].Id, Primary_Channel_Class__c='Engineering, Procurement and Construction (EPC)', Division__c = 'EP;PA;')
        };
        
        insert cmcList;
        
        Joint_Business_Plan__c[] jbpList = new Joint_Business_Plan__c[] {
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(3), Status__c = 'Draft', CurrencyISOCode = 'USD'),
            new Joint_Business_Plan__c (Account__c = accs[0].id, Channel_Market_Coverage__c = cmcList[0].id, 
                Start_Date__c = Date.today(), End_Date__c = Date.today().addDays(4), Status__c = 'Draft', OwnerID = userList[0].Id)
        };
        insert jbpList;
        
        ID MP = Schema.SObjectType.Channel_Business_Review__c.getRecordTypeInfosByName().get('Mid-Period Business Review Detail').getRecordTypeId();
        Channel_Business_Review__c[] CBRList = new Channel_Business_Review__c[] { 
            new Channel_Business_Review__c (Account__c = accs[0].id, Joint_Business_Plan__c = jbpList[0].Id, RecordtypeId = MP, Status__c = 'Draft')
        };
        insert CBRList ;
        
        Joint_Business_Plan_Market_Coverage__c jbpMarkCov = new Joint_Business_Plan_Market_Coverage__c(Focussed_Industry1__c = 'Building - Residential Buildings', Joint_Business_Plan__c = jbpList[0].Id);  
        insert jbpMarkCov;
        
        Product_Group__c[] pgList = new Product_Group__c[]{
            new Product_Group__c (Name = '4104', Product_Group_Name__c = 'Metals', Business_Unit__c = 'PAPI',Business_Unit_Name__c = 'Process Industries',
                Division__c = 'PA', Division_Name__c ='Process Automation'),
            
            new Product_Group__c (Name = '4105', Product_Group_Name__c = 'Alumnium', Business_Unit__c = 'DMDR',Business_Unit_Name__c = 'Process Industries',
                Division__c = 'PA', Division_Name__c ='Process Automation'),
             new Product_Group__c (Name = '4130', Product_Group_Name__c = 'Large Motors & Generators', Business_Unit__c = 'DMMG',Business_Unit_Name__c = 'Motors & Generators',
                Division__c = 'DM', Division_Name__c ='Discrete Automation and Motion')
        };
        
        insert pgList;
        
        Product2[] prodList = new Product2[] {
            new Product2 (Description = 'Aluminium Solutions', Name = 'Desc Aluminium Solutions', Product_Group__c = 4104 ,CID__c = 'ABCD1234', IsActive = TRUE),
            new Product2 (Description = 'Aluminium Solutions', Name = 'Desc Aluminium Solutions', Product_Group__c = 4105 ,CID__c = 'ABCD2222', IsActive = TRUE),
            new Product2 (Description = 'Solar and Other Renewables', Name = 'Solar and Other Renewables', Product_Group__c = 4130 ,CID__c = '9AAC186896', IsActive = TRUE)
        };
        insert prodList;
            
        
        List<Joint_Business_Plan_Product_Lines__c> productLinesList = new List<Joint_Business_Plan_Product_Lines__c>();
        
        Joint_Business_Plan_Product_Lines__c jbpPlines3=  new Joint_Business_Plan_Product_Lines__c ();          
        jbpPlines3.Joint_Business_Plan__c = jbpList[0].Id; 
        jbpPlines3.Product__c = prodList[0].Id;
        jbpPlines3.Starting_Year__c =  String.valueOf(Date.Today().YEar()); 
        jbpPlines3.Forecast_Ongoing_Year__c=80;
        productLinesList.add(jbpPlines3);
        
        Joint_Business_Plan_Product_Lines__c jbpPlines4=  new Joint_Business_Plan_Product_Lines__c ();          
        jbpPlines4.Joint_Business_Plan__c = jbpList[0].Id; 
        jbpPlines4.Product__c = prodList[1].Id;
        jbpPlines4.Starting_Year__c =  String.valueOf(Date.Today().YEar()); 
        jbpPlines4.Forecast_Ongoing_Year__c= 200;
        jbpPlines4.Third_Year_Currency__c = 780;
        productLinesList.add(jbpPlines4);
        
        insert productLinesList;
        
        jbpList[0].currencyISOCode = 'EUR';
        jbpList[0].Start_Date__c= Date.today().addDays(1);
        jbpList[1].Status__c = 'Obsolete';
        update jbpList;
        
        Test.stopTest();
        
     }
     
     
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@gmail.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }
}
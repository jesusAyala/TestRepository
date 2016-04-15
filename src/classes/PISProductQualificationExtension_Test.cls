/**
 * ApexClass -  Test class PISProductQualificationExtension_Test
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-03-21
 * @version 1.0
 * Description: 
 * This is the Test class for PISProductQualificationExtensionEdit(88%), PISProductQualificationExtensionEdit(87%)
  */
@isTest
private class PISProductQualificationExtension_Test{

    
   static testMethod void testPISProductQualificationExtension() {
        Test.startTest();
        
        profile[] profileList = [ Select Id, Name FROM Profile Where Name IN ('ABB Sales Standard Profile', 'System Administrator')];
        
        ID adminId = (!profileList.IsEmpty() && profileList[0].Name == 'System Administrator') ? profileList[0].Id : profileList[1].Id;
        ID abbID = (!profileList.IsEmpty() && profileList[0].Name == 'ABB Sales Standard Profile') ? profileList[0].Id :  profileList[1].Id;
        
        Account[] accs = new List<Account> {
            new Account ( Name = 'test1',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany'),
            new Account ( Name = 'test2',
                BillingStreet = 'street', 
                BillingCity = 'city', 
                BillingCountry = 'Germany')};
                
        insert accs;
        
        List<User> userList = new List<User>();
        userList.add(createTestUser(abbID, 'TestABB1'));
        userList.add(createTestUser(abbID, 'TestABB2'));
        insert userList;
        
        AccountTeamMember[] accTeamList = new AccountTeamMember[] {
            new AccountTeamMember(AccountId = accs[0].Id, UserID = userList[0].ID)
        };
        
        insert accTeamList;
        
        Product_Qualification__c[] productQulList = new Product_Qualification__c[] {
            new Product_Qualification__c(Account__c = accs[0].Id, Initiative_Status__c = 'Open', Comments__c = 'Test Comments', Startdate__c = Date.Today(), Target_End_Date__c = Date.Today().addDays(3)),
            new Product_Qualification__c(Account__c = accs[0].Id, Initiative_Status__c = 'Closed Not Qualified', Comments__c = 'Test Comments', Startdate__c = Date.Today().addDays(1), Target_End_Date__c = Date.Today().addDays(3))
        };
        
        insert productQulList;
        
        Product_Group__c[] pgList = new Product_Group__c[]{
            new Product_Group__c (Name = '4104', Product_Group_Name__c = 'Metals', Business_Unit__c = 'PAPI',Business_Unit_Name__c = 'Process Industries',
                Division__c = 'PA', Division_Name__c ='Process Automation'),
            
            new Product_Group__c (Name = '4105', Product_Group_Name__c = 'Alumnium', Business_Unit__c = 'DMDR',Business_Unit_Name__c = 'Process Industries',
                Division__c = 'PA', Division_Name__c ='Process Automation')
        };
        
        insert pgList;
        
        Product2[] prodList = new Product2[] {
            new Product2 (Description = 'Aluminium Solutions', Name = 'Desc Aluminium Solutions', Product_Group__c = 4104 ,CID__c = 'ABCD1234', IsActive = TRUE),
            new Product2 (Description = 'Aluminium Solutions', Name = 'Desc Aluminium Solutions', Product_Group__c = 4105 ,CID__c = 'ABCD2222', IsActive = TRUE)
        };
        insert prodList;
        
        ApexPages.StandardController ctrl = new ApexPages.StandardController(new Qualification_Products_List__c(Product_Qualification__c = productQulList[0].Id)); 
        Apexpages.currentPage().getParameters().put('retURL', productQulList[0].Id);
        PISProductQualificationExtension addTeam = new PISProductQualificationExtension(ctrl);
        addTeam.GoBack();
        PISProductQualificationExtension.PISNode[] innerList = new List<PISProductQualificationExtension.PISNode>();
        PISProductQualificationExtension.PISNode prd = new PISProductQualificationExtension.PISNode();
        prd.englishDescription = 'Product';
        prd.cid = 'ABCD1234';
        innerList.add(prd);
        
        PISProductQualificationExtension.ProductResult res = new PISProductQualificationExtension.ProductResult();
        
        PISProductQualificationExtension.addProducts(productQulList[0].Id, innerList);
        
        Qualification_Products_List__c[] qualProduct = new Qualification_Products_List__c[]{
            new Qualification_Products_List__c(Product_Qualification__c = productQulList[1].Id, Product__c = prodList[0].ID)
        };
        
        insert qualProduct;
        
        ApexPages.StandardController ctrl2 = new ApexPages.StandardController(qualProduct[0]); 
        Apexpages.currentPage().getParameters().put('retURL', productQulList[1].Id);
        PISProductQualificationExtension addTeam2 = new PISProductQualificationExtension(ctrl2);
        
        
        //PISProductQualificationExtensionEdit - code coverage
        
        ApexPages.StandardController ctrl3 = new ApexPages.StandardController(qualProduct[0]); 
        Apexpages.currentPage().getParameters().put('Id', qualProduct[0].Id);
        PISProductQualificationExtensionEdit addTeam3 = new PISProductQualificationExtensionEdit(ctrl3);
        addTeam3.GoBack();
       
        PISProductQualificationExtensionEdit.PISNode prdd = new PISProductQualificationExtensionEdit.PISNode();
        prdd.englishDescription = 'Product';
        prdd.cid = 'ABCD2222';
        
        PISProductQualificationExtensionEdit.ProductResult ress = new PISProductQualificationExtensionEdit.ProductResult();
        
        PISProductQualificationExtensionEdit.replaceProduct(qualProduct[0].Id, prdd);
        
         Product_Qualification_Team_Role__c[] teamRole = new Product_Qualification_Team_Role__c[] {
                new Product_Qualification_Team_Role__c(Product_Qualification__c = productQulList[1].Id, Access__c = 'Read/Write', User__c = userList[0].ID)
         };
         
         insert teamRole;
         
         system.runAs(userList[0]) {
            ApexPages.StandardController ctrl4 = new ApexPages.StandardController(qualProduct[0]); 
            Apexpages.currentPage().getParameters().put('Id', qualProduct[0].Id);
            PISProductQualificationExtensionEdit addTeam4 = new PISProductQualificationExtensionEdit(ctrl4);
         }
         
         system.runAs(userList[1]) {
            ApexPages.StandardController ctrl5 = new ApexPages.StandardController(qualProduct[0]); 
            Apexpages.currentPage().getParameters().put('Id', qualProduct[0].Id);
            PISProductQualificationExtensionEdit addTeam5 = new PISProductQualificationExtensionEdit(ctrl5);
         }
    }
        
    public static User createTestUser(Id profileId, String LastNameVal) {
        User u = new User( FirstName ='haobo', LastName = LastNameVal, Username = 'test123ABB1237'+LastNameVal+'@test123ABB1237.com', Alias = LastNameVal,
            Email = 'mtester1'+LastNameVal+'@company.com', CommunityNickname = LastNameVal,
            ProfileId = profileId, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US', ManagerId = UserInfo.getUserId());
        return u;
    }

}
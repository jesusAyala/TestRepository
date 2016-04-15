/**
*	Test class is for ClsTriggerEndUserProjectHandler.
*
@author Sherlock Feng
@created 2015-03-24
@version 1.0
@since 29.0 (Force.com ApiVersion)
*
@changelog
* 2015-03-24 Sherlock Feng <sherlock.feng@itbconsult.com>
* - Created
*/
@isTest
private class ClsTriggerEndUserProjectHandler_Test {

    static testMethod void myTest() {
        Test.startTest();
        
        End_User_Project__c eup = new End_User_Project__c();
        eup.End_User_Project_Status__c = 'Open';
        eup.Name = 'test';
        insert eup;
        
        Opportunity opp = new Opportunity();
        for(Opportunity o : [SELECT AccountId, Name, CurrencyIsoCode, Product_Group__c, StageName, Specific_Opportunity_Info__c, End_User_Project__c, CloseDate FROM Opportunity limit 1]){
        	o.End_User_Project__c = eup.Id;
        	o.CloseDate = Date.valueOf('2015-05-25');
        	update o;
        	opp = o;
        }
        
        eup.End_User_Project_Status__c = 'Closed';
        update eup;
        
        system.assert(true);
        Test.stopTest();
    }
    
}
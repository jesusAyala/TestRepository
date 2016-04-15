/**
*  This test class used to test class ClsTriggerProductHandler.
*    
@author Nikhil Pimpale
@created 2015-10-14
@version 1.0   
@since 34.0
*
@changelog
* coverage 100% 
* 
* 
* - Created
*/
@isTest (seeAllData = true)
private class ClsTriggerProductHandler_Test {

static testMethod void myUnitTest() {
 // TO DO: implement unit test
 Product_Group__c pg = new Product_Group__c();
 pg.Business_Unit__c = 'tdsd';
 pg.Name = '9990';
 pg.Division__c = 'DI1';
 insert pg;
 Product_Group__c pg1 = new Product_Group__c();
 pg1.Business_Unit__c = 'tdsd';
 pg1.Name = '9991';
 pg1.Division__c = 'DI2';
 insert pg1;
 Product2 prd = new Product2();
 prd.Name = 'InsertProductTest';
 prd.Product_Group__c = 9990;
 Test.startTest();
 insert prd;
 prd.Product_Group__c = 9991;
 update prd;
 Test.stopTest();
 }
 }
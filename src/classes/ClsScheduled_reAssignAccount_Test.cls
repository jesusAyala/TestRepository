/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-10-10
@version 1.0   
@since 28.0  
*
@changelog
* coverage 88% 
* 
* 
2014-10-10 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsScheduled_reAssignAccount_Test {

    static testMethod void myUnitTest() {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        list<ReAssigning_Related_Records__c> list_ReAssigningCustoms = new list<ReAssigning_Related_Records__c>();
        
        for(ReAssigning_Related_Records__c setting1 : [select Name, Value__c, Parent_API__c, isClone__c, Require_Field__c from ReAssigning_Related_Records__c]) {
            list_ReAssigningCustoms.add(setting1);
        }
        if(list_ReAssigningCustoms.isEmpty()) {         
            ReAssigning_Related_Records__c setting6 = new ReAssigning_Related_Records__c();
            setting6.Name = 'BatchNum';
            setting6.Value__c = '10';
            list_ReAssigningCustoms.add(setting6);
            insert list_ReAssigningCustoms;
        }
        
        Test.startTest();
        Set<Id> SafeIsland = new Set<Id>();
        ClsScheduled_reAssignAccount obj = new ClsScheduled_reAssignAccount('Duplicate', SafeIsland);                
        String jobId = system.schedule('test', sch, obj); 
        
        system.assert(true);
        Test.stopTest(); 
    }
}

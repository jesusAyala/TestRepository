/**
*  This test class used to test class ClsTriggerCaseHandler.
*
@author Jinbo Shan
@created 2015-03-12
@version 1.0   
@since 36.0
*
@changelog
* coverage 88% 
* 
* 
2015-03-12 Jinbo Shan <jinbo.shan@itbconsult.com>
* - Created
*/
@isTest
public class ClsTriggerEmailMessageHandler_Test {

 static Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        static User u = new User(Alias = 'email', Email='email@email.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='email@testcoverage.com');

private static final string SERVICESRECTYPENAME = 'Services';

    static testMethod void myUnitTest() {
    Id serviceRecTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get(SERVICESRECTYPENAME).getRecordTypeId();
    
    Group g = new Group(Type='Queue', Name='Test Coverage Queue');
    insert g;
    
    QueuesObject q = new QueueSObject(SobjectType='Case', QueueId=g.Id);
    insert q;
    
    System.runAs(u) {
    Routing_Email__c re = new Routing_Email__c();
    re.Routing_Email_Address__c = 'test@testcoverage.com';
    re.Division__c = 'DM';
    re.Business_Unit__c = 'DMDR';
    re.Country__c = 'Spain';
    insert re;
        
    Case c = new Case();
    c.RecordtypeId = serviceRecTypeId;
    c.OwnerId = g.Id;
    c.SuppliedEmail = 'test@testcoverage.com';
    c.Origin = 'Email';
    c.Status = 'New';
    insert c;
    
        
    Task t = new Task();
    t.Priority = 'High';
    t.Status = 'Open';
    t.WhatId = c.Id;
    insert t;
    
    EmailMessage newEmail = new EmailMessage();
    newEmail.FromAddress = 'test@testcoverage.com';
    newEmail.ToAddress = re.Routing_Email_Address__c;
    newEmail.Subject = 'Test Class Email';
    newEmail.TextBody = 'Test Coverage Email.';
    newEmail.Incoming = true;
    newEmail.ParentId = c.Id;
    newEmail.ActivityId = t.Id;
    
    String multipleTo = re.Routing_Email_Address__c;
    multipleTo = multipleTo + '; nottest@testcoverage.com';
    EmailMessage multipleToAddress = new EmailMessage();
    multipleToAddress.FromAddress = 'test@testcoverage.com';
    multipleToAddress.ToAddress = 'nikpimpale@gmail.com; jesus.ayala@accenture.com';
    multipleToAddress.Subject = 'Test Class Email';
    multipleToAddress.TextBody = 'Test Coverage Email.';
    multipleToAddress.Incoming = true;
    multipleToAddress.ParentId = c.Id;
    multipleToAddress.ActivityId = t.Id;
    
    Test.startTest();
    insert multipleToAddress;
    insert newEmail;
    Test.stopTest();
    }
    
    
    }

}
@isTest
public class FlowController1_Test {
    static testMethod void FlowController1_Tests() {

        // ** create a calendar event **
        Account Account1= new Account (Name= 'Account1');   // account for the contact
        Account1.BillingStreet = 'Street1';
        Account1.BillingCity = 'City1';
        Account1.BillingCountry = 'United Kingdom';
        insert Account1;
        
        Account Account2= new Account (Name= 'Account2');   // a second account
        Account2.BillingStreet = 'Street2';
        Account2.BillingCity = 'City2';
        Account2.BillingCountry = 'United Kingdom';
        insert Account2;
                                        
        Contact aContact= new Contact (LastName= 'cLastName1', AccountId= Account1.Id); // any contact will do            
        insert aContact;

        Event newEvent = new Event(
            WhoId = aContact.Id,
            // AccountId = Account2.Id,          // RJ: is read only; how to populate??
            Description = 'Description1',
            Subject = 'Subject1',                // RJ: this will be the visit report name
            ActivityDate = date.newInstance(1999, 12, 31),
            ActivityDatetime = datetime.now(),
            DurationInMinutes = 60,
            Location = 'Location1'
            );
        insert newEvent;          
        System.debug('FlowController1_Test: Event used for testing: ' + newEvent);

        // ** Initialise flow **
        PageReference pageRef = Page.Create_Visit_Report_from_Calendar_Event;
        Test.setCurrentPage(pageRef);
        Map<String, Object> params = new Map<String, Object>();
        params.put('id', newEvent.Id);
        FlowController1 FlowController1 = new FlowController1();        
        PageReference urlpageref0 = FlowController1.getReturnURL();

        // ** Get the flow results **
        try{
	        String VRid = (String) FlowController1.getApexNewVisitReportID();
        }
        catch(Exception e)
     	{}

		try{  
            Visit_Report__c rep=FlowController1.getApexNewVisitReport();
        }
        catch(Exception e)
     	{}
            
    }

}
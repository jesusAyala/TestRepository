/**   
* Trigger : OppScrngSetClassificationTrigger
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
trigger OppScrngSetClassificationTrigger on Opportunity_Screening__c (before insert, before update) {

    If(!System.label.SYS_RunOppScrngSetClassificationTrigger.equalsIgnoreCase(System.label.System_CL0002)){ // System_CL0002 --> 'NO'
     ClsTriggerFactory.createHandler(Opportunity_Screening__c.sObjectType);
     }
}
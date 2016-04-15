/**   
* ClsTriggerPlayerHandler 
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
public with sharing class ClsTriggerPlayerHandler extends ClsTriggerVirtual {
    /**
     * @see IntHelper.beforeTrigger
    */
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        try
        {
            setJobFunction(trgCtx);
        }
        catch(DMLException e){  string err = e.getmessage(); } 
    }
    
    /**
     * @see IntHelper.afterTrigger
    */
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
    }
    
    /**
     *  This trigger is used to Set Contact to Primary with a Role.
     *
     @author  Jinbo Shan
     @created 2015-03-26
     @version 1.0
     @since   30.0 (Force.com ApiVersion)
     *
     @changelog
     * 2015-03-26 Jinbo Shan <jinbo.shan@itbconsult.com>
     * - Created
    */
    @TestVisible 
    private void setJobFunction(ClsWrappers.TriggerContext trgCtx) {
       if (trgCtx.isBefore) {

            set<Id>  conids = new set<Id>();       
            for (sobject so : trgCtx.newList) {
                Player__c plyer = (Player__c)so;
                if (plyer.Contact__c != null) {
                  conids.add(plyer.Contact__c); 
                }
            }       
            Map<Id, Contact> mapContacts = new Map<Id, Contact>([Select Id, Job_Function__c from contact where id =: conids limit 1]);
            for (sobject so : trgCtx.newList) {
                Player__c plyer = (Player__c)so;
                if (plyer.Contact__c != null &&  mapContacts.get(plyer.Contact__c).Job_Function__c!= null ) {                  
                  plyer.Job_Function__c = mapContacts.get(plyer.Contact__c).Job_Function__c;
                  }
            }
            


         } 
    }      
        
}
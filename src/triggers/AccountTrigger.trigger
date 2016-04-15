/**
 * Trigger for Account 
 *      
 */
trigger AccountTrigger on Account(after update,  before insert ) {
/**
 * trigger runs only for custom label has below value
 *      
 */         
If(!(ClsAccountUtil.isAccMergeFlag) && !System.label.SYS_RunAccountTrigger.equalsIgnoreCase('NO'))
{
    System.debug('::MR::AccountTrigger');
    ClsTriggerFactory.createHandler(Account.sObjectType);                
}          
   
}
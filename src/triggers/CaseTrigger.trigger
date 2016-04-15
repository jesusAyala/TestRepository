/**
 * Trigger - centual adapter trigger for all Case
 * Created
 */
trigger CaseTrigger on Case (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
/**
 * trigger runs only for custom label has below value
 *      
 */ 
    If( !(ClsAccountUtil.isAccMergeFlag) && !System.label.SYS_RunCaseTrigger.equalsIgnoreCase(System.Label.SYS_TRIGGER_NO)){   
        ClsTriggerFactory.createHandler(Case.sObjectType);
    }
    }
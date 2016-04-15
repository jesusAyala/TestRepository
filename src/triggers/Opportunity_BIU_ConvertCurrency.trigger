/**
 *  This trigger retrieves all currency iso codes and related currency conversion rates.
 *  Then it calculates the opportunities USD amount and saves it into technical field "Technical_Amount_USD__c".
 * 
 * @author Jinbo Shan
 * @version 1.0
 * @since 33.0
 * 
 * @changelog
 * 2015-04-22 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
trigger Opportunity_BIU_ConvertCurrency on Opportunity (before insert, before update) {
 /**
 * trigger runs only for custom label has below value
 *      
 */ 
    If( !(ClsAccountUtil.isAccMergeFlag) && !System.label.SYS_RunOpportunityTrigger.equalsIgnoreCase(System.label.NO)){    
        //Get all opportunities in loop, calculate USD amount and store in field "Technical_Amount_USD__c"
        for(Opportunity oppy : Trigger.new){        
            if(oppy.Opportunity_Value__c != null) {
                oppy.Technical_Amount_USD__c =  ClsUtil.transformIsoCode(oppy.Opportunity_Value__c, oppy.CurrencyIsoCode, 'USD').setScale(2);
            }
        }
    }        
}
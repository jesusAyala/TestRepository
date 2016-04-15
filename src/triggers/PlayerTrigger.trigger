/**   
* Trigger : PlayerTrigger()
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
trigger PlayerTrigger on Player__c(before insert, before update) 
{ClsTriggerFactory.createHandler(Player__c.sObjectType);}
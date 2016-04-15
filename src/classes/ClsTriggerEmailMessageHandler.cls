/**
 * Trigger handler class for Case which does following actions
 * - 1. TBD
 * - 2. insert, undelete, update TargetGroupShare.
 *
 * @author Nikhil Pimpale
 * @created 16 Dec 2015
 * @version 1.0
 * @since 35.0
 *   
 * @changelog
 * 
 */
 public class ClsTriggerEmailMessageHandler  extends ClsTriggerVirtual {
 private Map<String,List<Case>> toAddressMap = new Map<String,List<Case>>();
 private Map<String,List<Case>> multipleToAddressMap = new Map<String,List<Case>>();
 private Set<Id> caseSet = new Set<Id>();
 private Map<Id,EmailMessage> emailMessageMap = new Map<Id,EmailMessage>();
 private Map<Id,Case> detailCaseMap = new Map<Id,Case>();
 private Map<Id,Case> caseUpdateMap = new Map<Id,Case>();
 private Map<Id,Case> singleMatchMap = new Map<Id,Case>();
 private Map<Id,Task> taskUpdateMap = new Map<Id,Task>();
 public Map<Id,EmailMessage> activityMap = new Map<Id,EmailMessage>();
 private Map<Id,Routing_Email__c> detailRoutingEmailMap = new Map<Id,Routing_Email__c> ();
 private Map<Id,Task> detailTaskMap = new Map<Id,Task>();
 
     public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
         lookupRoutingEmail(trgCtx);
     }
     public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
         closeRelatedTask(trgCtx);
     }
     @TestVisible
     private void lookupRoutingEmail(ClsWrappers.TriggerContext trgCtx){
        try
        {   
            if (trgCtx.isBefore && trgCtx.isInsert)
            {
                 for(sobject so : trgCtx.newList)
                 {
                     EmailMessage eMessage = (EmailMessage)so;
                     if(eMessage.ParentId!= null && eMessage.ToAddress != null && eMessage.Incoming)
                     {
                         emailMessageMap.put(eMessage.Id,eMessage);
                         caseSet.add(eMessage.ParentId);
                     }
                 }
                 if(caseSet.size() > 0)
                 {
                     detailCaseMap = new Map<Id,Case>([Select Id,Status,SuppliedEmail,Origin,Email_To_Case_Recipient__c,Originating_Country__c,
                                                                    Division__c,Business_Unit__c,Product_Group__c,OwnerId From Case Where Id IN:caseSet limit 10000]);
                                      
                 }
                 if(!emailMessageMap.isEmpty() && !detailCaseMap.isEmpty())
                 {
                     for(EmailMessage eMessage : emailMessageMap.values()) 
                     {
                        if(detailCaseMap.containskey(eMessage.ParentId) && detailCaseMap.get(eMessage.ParentId).Status == System.label.Trigger_Email_Message_Status_New
                           && detailCaseMap.get(eMessage.ParentId).SuppliedEmail != null && detailCaseMap.get(eMessage.ParentId).Origin== System.label.Trigger_Email_Origin_Email
                           && detailCaseMap.get(eMessage.ParentId).Email_To_Case_Recipient__c == null)
                        {
                            
                            if(eMessage.ToAddress.contains(System.label.System_CL00046))//System_CL00046 --> ';'
                            {
                                String[] temp = eMessage.ToAddress.split('\\;');   
                                for(String t:temp)
                                {
                                    t = t.trim();
                                    System.debug('Email'+t);
                                    if(multipleToAddressMap.containskey(t))
                                    {
                                        multipleToAddressMap.get(t).add(detailCaseMap.get(eMessage.ParentId));
                                    }
                                    else
                                    {
                                       multipleToAddressMap.put(t, new List<Case> { detailCaseMap.get(eMessage.ParentId) });
                                    }
                                }
                                
                            }
                            else
                            {
                                detailCaseMap.get(eMessage.ParentId).Email_To_Case_Recipient__c = eMessage.ToAddress;
                                detailCaseMap.get(eMessage.ParentId).Originating_Country__c = null;
                                caseUpdateMap.put(eMessage.ParentId,detailCaseMap.get(eMessage.ParentId));
                                if(toAddressMap.containskey(eMessage.ToAddress))
                                {
                                    toAddressMap.get(eMessage.ToAddress).add(detailCaseMap.get(eMessage.ParentId));
                                }
                                else
                                {
                                   toAddressMap.put(eMessage.ToAddress, new List<Case> { detailCaseMap.get(eMessage.ParentId) });
                                }
                            }
                        }
                    
                     }
                 }
                 if(!toAddressMap.isEmpty() || !multipleToAddressMap.isEmpty())
                 {
                     System.debug('multipleToAddressMap.keyset()'+multipleToAddressMap.keyset());
                     detailRoutingEmailMap = new Map<Id,Routing_Email__c>([Select Id,Business_Unit__c,Division__c,Product_Group__c,Routing_Email_Address__c,Country__c From Routing_Email__c Where Routing_Email_Address__c IN :toAddressMap.keyset()
                                                                           OR Routing_Email_Address__c IN :multipleToAddressMap.keyset() ORDER BY Routing_Email_Address__c ASC limit 10000]);
                 }
                 if(!detailRoutingEmailMap.isEmpty())
                 {
                     for(Routing_Email__c emailAddress: detailRoutingEmailMap.values())
                     {
                         if(multipleToAddressMap.containskey(emailAddress.Routing_Email_Address__c))
                         {
                             list<Case> tempCase = multipleToAddressMap.get(emailAddress.Routing_Email_Address__c);
                             for(Case caseVar:tempCase)
                             {
                                 if(singleMatchMap.containskey(caseVar.Id))
                                 {
                                     break;
                                 }
                                 else
                                 {
                                     if(emailAddress.Division__c != null)
                                     {
                                     caseVar.Division__c = emailAddress.Division__c;
                                     caseVar.Business_Unit__c = emailAddress.Business_Unit__c;
                                     caseVar.Product_Group__c = emailAddress.Product_Group__c;
                                     }
                                     caseVar.Email_To_Case_Recipient__c = emailAddress.Routing_Email_Address__c;
                                     if(emailAddress.Country__c != null)
                                     {
                                         caseVar.Originating_Country__c = emailAddress.Country__c;
                                     }
                                     
                                     singleMatchMap.put(caseVar.Id,caseVar);
                                 }
                             }
                         }
                         if(toAddressMap.containskey(emailAddress.Routing_Email_Address__c))
                         {
                             list<Case> tempCase = toAddressMap.get(emailAddress.Routing_Email_Address__c);
                             for(Case caseVar:tempCase)
                             {
                                     if(emailAddress.Division__c != null)
                                     {
                                     caseVar.Division__c = emailAddress.Division__c;
                                     caseVar.Business_Unit__c = emailAddress.Business_Unit__c;
                                     caseVar.Product_Group__c = emailAddress.Product_Group__c;
                                     }
                                     caseVar.Email_To_Case_Recipient__c = emailAddress.Routing_Email_Address__c;
                                     if(emailAddress.Country__c != null)
                                     {
                                         caseVar.Originating_Country__c = emailAddress.Country__c;
                                     }
                                     caseUpdateMap.put(caseVar.Id,caseVar);
                             }
                         }
                     }
                 }
                 if(!singleMatchMap.isEmpty())
                 {
                     caseUpdateMap.putAll(singleMatchMap);
                 }
                 if(!caseUpdateMap.isEmpty())
                 {
                     Database.update(caseUpdateMap.values());
                 }    
            }
        }
        catch(ClsTriggerException cte)
        {
            System.debug('Message: ' + cte.getMessage()); 
        }
        
    }
    @TestVisible
     private void closeRelatedTask(ClsWrappers.TriggerContext trgCtx){
        try
        {
            if (trgCtx.isAfter && trgCtx.isInsert)
            {
                for(sobject so : trgCtx.newList)
                {
                        EmailMessage eMessage = (EmailMessage)so;
                        if(eMessage.ParentId!= null && eMessage.ToAddress != null && eMessage.Incoming && eMessage.ActivityId != null)
                        {
                            caseSet.add(eMessage.ParentId);
                             activityMap.put(eMessage.ActivityId,eMessage);
                        }
                }
                if(caseSet.size() > 0)
                {
                     detailCaseMap = new Map<Id,Case>([Select Id,Status,SuppliedEmail,Origin,Email_To_Case_Recipient__c,
                                                                    Division__c,Business_Unit__c,Product_Group__c,OwnerId From Case Where Id IN:caseSet limit 10000]);
                                      
                } 
                if(!activityMap.isEmpty() && !detailCaseMap.isEmpty())
                {
                    detailTaskMap = new Map<Id,Task>([select Status,Id From Task where Id IN :activityMap.keyset() limit 10000]);
                }
                if(!detailTaskMap.isEmpty())
                {
                    for(Task tsk :detailTaskMap.values())
                    {
                        String tempOwner = detailCaseMap.get(activityMap.get(tsk.Id).ParentId).OwnerId;
                        if(tempOwner.startsWith(System.label.System_Task_Owner_Prefix))
                        {
                            tsk.Status = System.label.Actions_Status_Completed; //Actions_Status_Completed --> 'Completed'
                            taskUpdateMap.put(tsk.Id,tsk);
                        }
                        else
                        {
                            continue;
                        }
                    }
                    if(!taskUpdateMap.isEmpty())
                    {
                        Database.update(taskUpdateMap.values());
                    }
                }
            }
            
        }
        catch(ClsTriggerException cte)
        {
            System.debug('Message: ' + cte.getMessage()); 
        }  
     }
 }
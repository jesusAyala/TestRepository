/**   
* TriggerClass on the Joint_Business_Plan__c object to
    1. To update the Record Type based on Status 
    2. Uncheck the Mutual Agreed if start date is changed
*       
* Release - R5 
 *  
 * @author  - Vasanthi (Accenture)
 * @created - 2016-1-25
 * @version - 1.0
 * @Description - Update the Record Type to Open if the status changed from 'Cloded' to anything = as per Req#2450
 Whenever the JBP Start date changes then mutually agreed will be unchecked as per Req #2746 (KAD-00895)
   
* - Created
*/
public without sharing class ClsTriggerJointBusinessPlanHandler extends ClsTriggerVirtual {
  
    
    public Static Set<Id> processedIdSet = new Set<Id>();
    public Set<Id> rtIdSet = new Set<Id>();

/**    
    *constructor
*/
    public ClsTriggerJointBusinessPlanHandler() {
    
        for (Schema.RecordTypeInfo rt: Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName().values()) {
            rtIdSet.add(rt.getRecordTypeId());
        }
    }
    
/**    
    *Req #1960 Criteria Based Rollup summary field on the object Joint_Business_Plan__c
*/       
    public void rollupJointBusinessProductLinesValue(ClsWrappers.TriggerContext trgCtx) {
        
        Map<ID, AggregateResult> aggregateMAp = new MAp<Id, AggregateResult>();
        List<Joint_Business_Plan__c> recordList = new List<Joint_Business_Plan__c>();
        Set<Id> parentIdSet = new Set<Id>();
        Set<String> yearSet = new Set<String>();
        List<String> expList = new List<String>();
        expList.addAll(Label.System_Aggregate_Query_Expr.split(Label.CL00069));   //Label.CL00069 = comma(,) 
        //System_Aggregate_Query_Expr => sales,budget,actualSales,runRate,target2nd,target3rd,forecast
        
        if (trgCtx.isUpdate) {
            for (Joint_Business_Plan__c jbp : (List<Joint_Business_Plan__c >) trgCtx.newList) {
                
                Joint_Business_Plan__c oldJbp = (trgCtx.isInsert) ? NULL : (Joint_Business_Plan__c ) trgCtx.oldMap.get(jbp.Id);
                
                if (jbp.Start_Date__c != oldJbp.Start_Date__c) {
                    
                    recordList.add(jbp);
                    
                    if (jbp.Start_Date__c != NULL) {
                        parentIdSet.add(jbp.Id);                    
                        yearSet.add(String.valueOf(jbp.Start_Date__c.YEar()));
                    }
                }
            }
            
            if (parentIdSet.size() > 0) {
                
                Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
                
                List<AggregateResult> ag = [ SELECT SUM(Previous_Year_Currency__c) sales, SUM(Current_Year_Currency__c) budget, 
                        SUM(Current_Ongoing_Year__c) actualSales, SUM(Run_Rate_On__c) runRate, SUM(Second_Year_Currency__c) target2nd, 
                        SUM(Third_Year_Currency__c ) target3rd, SUM(Forecast_Ongoing_Year__c) forecast, Joint_Business_Plan__c 
                    FROM Joint_Business_Plan_Product_Lines__c 
                    WHERE Joint_Business_Plan__c IN :parentIdSet AND Starting_Year__c IN :yearSet AND (
                        Previous_Year_Currency__c > 0 OR Current_Year_Currency__c > 0 OR Current_Ongoing_Year__c > 0 OR Run_Rate_On__c > 0 OR 
                        Second_Year_Currency__c > 0 OR Third_Year_Currency__c > 0 OR Forecast_Ongoing_Year__c > 0)
                        GROUP BY Joint_Business_Plan__c LIMIT :limitRows ];
                        
               
               for (AggregateResult res: ag) {
                   aggregateMap.put(String.valueOf(res.get(Label.System_Joint_Business_Plan_object_API)), res);
               }     
            }
            
            
            for (Joint_Business_Plan__c jbp: recordList) {
                //exp sales,budget,actualSales,runRate,target2nd,target3rd,forecast
                jbp.Sales_previous_year__c = aggregateMap.get(jbp.Id) != NULL ? ((aggregateMap.get(jbp.Id).get(expList[0]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[0])) : 0): 0;
                jbp.Budget_Current_Year__c = (aggregateMap.get(jbp.Id) != NULL) ? ((aggregateMap.get(jbp.Id).get(expList[1]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[1])) : 0): 0;
                jbp.Actual_Sales_Year_to_Date__c = aggregateMap.get(jbp.Id) != NULL ?((aggregateMap.get(jbp.Id).get(expList[2]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[2])) : 0): 0;
                jbp.Rund_Rate_Ongoing_year__c = aggregateMap.get(jbp.Id) != NULL ? ((aggregateMap.get(jbp.Id).get(expList[3]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[3])) : 0): 0;
                jbp.Target_2nd_Year__c = aggregateMap.get(jbp.Id) != NULL ? ((aggregateMap.get(jbp.Id).get(expList[4]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[4])) : 0): 0;          
                jbp.Target_3rd_Year__c = aggregateMap.get(jbp.Id) != NULL ? ((aggregateMap.get(jbp.Id).get(expList[5]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[5])) : 0): 0;                            
                jbp.Forecast_ongoing_year__c = aggregateMap.get(jbp.Id) != NULL ? ((aggregateMap.get(jbp.Id).get(expList[6]) != NULL) ? Double.valueOf(aggregateMap.get(jbp.Id).get(expList[6])) : 0): 0;
            }
        }
    }
/**    
    * Bulk After override method
*/      
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isUpdate) {
            assingnCurrency(trgCtx);
        }
    }
/**    
    * Copy Channel common data and Channel market coverage informations  
 */ 
    public void copyAccAndChannelMarketCoverage(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> cmcIdSet = new Set<Id>();
        Map<Id, Account> accMap = new MAp<Id, Account>();
        Map<Id, Channel_Market_Coverage__c> cmcMap = new MAp<Id, Channel_Market_Coverage__c>();
        Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {
            for (Joint_Business_Plan__c jbp : (List<Joint_Business_Plan__c >) trgCtx.newList) {
                
                if (jbp.Channel_Market_Coverage__c != NULL) {
                    cmcIdSet.add(jbp.Channel_Market_Coverage__c);
                }
                
                if (jbp.Account__c != NULL) {
                    accIdSet.add(jbp.Account__c );
                }                
            }
        }
        
        if (cmcIdSet.size() > 0) {
            cmcMap = new Map<ID, Channel_Market_Coverage__c>( [ SELECT Id, Secondary_Channel_Class_2__c, Suppliers_with_complementary_products__c,
                    Suppliers_with_possible_ABB_offering__c, Division__c, Existing_ABB_offering__c
                FROM Channel_Market_Coverage__c
                WHERE Id IN :cmcIdSet LIMIT :limitRows] );
        }
        
        if (accIdSet.size() > 0) {
            
            limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            accMap = new Map<ID, Account>( [ SELECT Id, Company_Description__c
                FROM Account
                WHERE Id IN :accIdSet LIMIT :limitRows] );
        }
        
         if (accIdSet.size() > 0 || cmcIdSet.size() > 0) {
            for (Joint_Business_Plan__c jbp : (List<Joint_Business_Plan__c >) trgCtx.newList) {
                
                jbp.Company_Description__c = (jbp.Account__c != NULL) ? accMap.get(jbp.Account__c).Company_Description__c : '';
                
                if (jbp.Company_Description__c != null) {
                    
                    if (jbp.Company_Description__c.length() < 255) {
                        jbp.Check_Company_Description__c = jbp.Company_Description__c;
                    } else {
                     jbp.Check_Company_Description__c = jbp.Company_Description__c.substring(0, 255);
                    }
                }
                jbp.Secondary_Channel_Class__c = (jbp.Channel_Market_Coverage__c != NULL) ? cmcMap.get(jbp.Channel_Market_Coverage__c).Secondary_Channel_Class_2__c: '';
                jbp.Suppliers_with_complementary_products__c = (jbp.Channel_Market_Coverage__c != NULL) ? cmcMap.get(jbp.Channel_Market_Coverage__c).Suppliers_with_complementary_products__c: '';
                jbp.Division__c = (jbp.Channel_Market_Coverage__c != NULL) ? cmcMap.get(jbp.Channel_Market_Coverage__c).Division__c: '';
                jbp.Existing_ABB_offering__c = (jbp.Channel_Market_Coverage__c != NULL) ? cmcMap.get(jbp.Channel_Market_Coverage__c).Existing_ABB_offering__c: '';
                jbp.Suppliers_with_potential_ABB_offering__c = (jbp.Channel_Market_Coverage__c != NULL) ? cmcMap.get(jbp.Channel_Market_Coverage__c).Suppliers_with_possible_ABB_offering__c: '';
                         
            }
        }
    }
/**    
    * Update the Record Type to Open if the status changed from 'Closed' to anything = as per Req#2450
    * Copy Channel common data and Channel market coverage informations   
*/               
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {
            copyAccAndChannelMarketCoverage(trgCtx);
        }
        
        if (trgCtx.isUpdate) {
            
            rollupJointBusinessProductLinesValue(trgCtx);
            
            for (SObject sobj: trgCtx.newList) {
                
                if (!processedIdSet.contains(sobj.Id)) {
                
                    Joint_Business_Plan__c newJoinBusPlan = (Joint_Business_Plan__c) sobj;
                    Joint_Business_Plan__c oldJoinBusPlan = (Joint_Business_Plan__c) trgCtx.oldMap.get(sobj.Id);
                    
                    //  Update the Record Type to Open if the status changed from 'Cloded' to anything = as per Req#2450                    
                    if (newJoinBusPlan.Status__c !=  oldJoinBusPlan.Status__c && newJoinBusPlan.Status__c == Label.Closed) {
                        
                        newJoinBusPlan.Old_Record_Type_Value__c = newJoinBusPlan.RecordTypeId; // Copy the previous record type
                    
                    } else if (newJoinBusPlan.Status__c !=  oldJoinBusPlan.Status__c && oldJoinBusPlan.Status__c == Label.Closed && 
                        newJoinBusPlan.Old_Record_Type_Value__c != NULL && !(String.IsBlank(newJoinBusPlan.Old_Record_Type_Value__c)) &&
                        rtIdSet.contains(newJoinBusPlan.Old_Record_Type_Value__c)){
                        
                        newJoinBusPlan.RecordTypeId = newJoinBusPlan.Old_Record_Type_Value__c;  // Update the previous record type
                    }else{} 
                    
                   
                    //Whenever the JBP Start date changes then mutually agreed will be unchecked as per Req #2746 (KAD-00895)
                    if (newJoinBusPlan.Start_Date__c !=  oldJoinBusPlan.Start_Date__c && newJoinBusPlan.Mutually_Agreed__c) {                        
                        newJoinBusPlan.Mutually_Agreed__c = FALSE;                 
                    }
                    
                    processedIdSet.add(sobj.Id);
                }               
            }
        }
    }
    
/**     
      * Req #1960 (Update Joint Business Plan currency to Joint Business Plan Product Lines).    
*/       
    public void assingnCurrency(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> parentIdSet = new Set<Id>();
        Map<ID, String> JbpIdAndCurrencyMap = new Map<ID, String>();
        
        for (Sobject sobj : trgCtx.newList) {
        
            Joint_Business_Plan__c newJoinBusPlan = (Joint_Business_Plan__c) sobj;
            Joint_Business_Plan__c oldJoinBusPlan = (Joint_Business_Plan__c) trgCtx.oldMap.get(sobj.Id);
            
            if (newJoinBusPlan.CurrencyISOCode != oldJoinBusPlan.CurrencyISOCode) {
                parentIdSet.add(newJoinBusPlan.Id);
                JbpIdAndCurrencyMap.put(newJoinBusPlan.Id, newJoinBusPlan.CurrencyISOCode);
            }
        }
        
        if (parentIdSet.size() > 0) {
            
            Integer limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows(); 
           
            List<Joint_Business_Plan_Product_Lines__c> updateList = new List<Joint_Business_Plan_Product_Lines__c>();
            List<Channel_Business_Review__c> reviewList = new List<Channel_Business_Review__c>();
            List<Joint_Business_Plan_Market_Coverage__c> marketCoverageList = new List<Joint_Business_Plan_Market_Coverage__c>();
            
            for (Joint_Business_Plan_Product_Lines__c productLine : [ SELECT Id,CurrencyISOCode,
                  Previous_Year_Currency__c, Current_Year_Currency__c, Current_Ongoing_Year__c, Second_Year_Currency__c, Third_Year_Currency__c, Forecast_Ongoing_Year__c,Joint_Business_Plan__c  
                  FROM Joint_Business_Plan_Product_Lines__c WHERE Joint_Business_Plan__c IN :parentIdSet  LIMIT :limitRows]) {
               
                productLine.currencyISOCode = JbpIdAndCurrencyMap.get(productLine.Joint_Business_Plan__c);
                updateList.add(productLine);
            }
            
            limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows(); 
            
            for (Channel_Business_Review__c rev : [ SELECT Id, Joint_Business_Plan__c, CurrencyISOCode FROM Channel_Business_Review__c 
                    WHERE Joint_Business_Plan__c IN :parentIdSet LIMIT :limitRows]) {
                rev.currencyISOCode = JbpIdAndCurrencyMap.get(rev.Joint_Business_Plan__c);
                reviewList.add(rev);
            }
            
            limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows(); 
            
            for (Joint_Business_Plan_Market_Coverage__c jbp: [SELECT Id, Joint_Business_Plan__c, CurrencyISOCode FROM Joint_Business_Plan_Market_Coverage__c
                    WHERE Joint_Business_Plan__c IN :parentIdSet LIMIT :limitRows]) {
                jbp.currencyISOCode = JbpIdAndCurrencyMap.get(jbp.Joint_Business_Plan__c);
                marketCoverageList.add(jbp);            
            }
            
            limitRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            
            List<Sales_and_Target_channel_business_review__c> updateSalesList = new List<Sales_and_Target_channel_business_review__c> ();
            
            for (Sales_and_Target_channel_business_review__c jbp: [SELECT Id, Channel_Partner_Business_Review__r.Joint_Business_Plan__c, CurrencyISOCode FROM Sales_and_Target_channel_business_review__c
                    WHERE Channel_Partner_Business_Review__r.Joint_Business_Plan__c IN :parentIdSet LIMIT :limitRows]) {
                jbp.currencyISOCode = JbpIdAndCurrencyMap.get(jbp.Channel_Partner_Business_Review__r.Joint_Business_Plan__c);
                updateSalesList.add(jbp);     
            }
            try {
        
                if (updateList.size() > 0) {
                    
                    Database.Update(updateList);
                }
                
                if (reviewList.size() > 0) Database.Update(reviewList);
                if (marketCoverageList.size() > 0) Database.Update(marketCoverageList);
                if (updateSalesList.size() > 0) Database.Update(updateSalesList);
                
            } Catch(DMLException e) {
                
                String err = '';
                for (Integer i = 0; i < e.getNumDML(); i++) {
                    err += e.getDMLMessage(i) +Label.Line_Break;
                }
                
                for (Id tmp: parentIdSet) {
                    trgCtx.newMap.get(tmp).addError(err, false);
                }
            }
        }       
    }
    
   
}
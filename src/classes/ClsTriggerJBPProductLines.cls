/**   
* TriggerClass on the Joint Business Plan Product Lines object to automatically populate BU, DIV, PG based on Product.
*       
* Release R5
*  
* @author  Indhu Selvi Ramalingam (Accenture)
* @created 2016-01-27
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerJBPProductLines extends ClsTriggerVirtual {

    public Static Set<Id> processedIdSet = new Set<Id>();
    Integer remLimit;  
    
   
/**
* bulkBefore
*/    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isInsert) {
            assingnCurrency (trgCtx);           
        }
        
        if (trgCtx.isDelete) {
            deleteValidation(trgCtx);
        }
    }
    
    /**
    To prevent deletion when the channel partner plan status is closed
    */
     Public void deleteValidation(ClsWrappers.TriggerContext trgCtx){
         ID sysAdminProfileId = Label.CL00075;
         for (Joint_Business_Plan_Product_Lines__c con : (List<Joint_Business_Plan_Product_Lines__c>) trgCtx.oldList) {             
             //if (!adminUserIdSet.contains(UserInfo.getUserID()) && 
             if (sysAdminProfileId != Userinfo.getProfileid() && con.Channel_Partner_Business_Plan_Status__c== Label.Closed ) {
                 con.addError(Label.Business_Visit_Report_Business_Plan_Error); //You cannot save the changes - Channel Partner Business Plan is Closed/Obsolete.
             }
         }        
     }
     
/**
* bulkAfter
*/   
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {    
            if (trgCtx.isInsert) {
            copySalesTargetsResults(trgCtx);
        }
    }
/**
* bulkAfter
*/ 
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        rollupJointBusinessProductLinesValue(trgCtx);
    }
   
/**    
  * Req #1960 Criteria Based Rollup summary field on the object Joint_Business_Plan__c
*/  
    public void rollupJointBusinessProductLinesValue(ClsWrappers.TriggerContext trgCtx) {
        
        Set<Id> jbpIdSet = new Set<Id>();
        Map<String, Decimal> JbpIdAndSalesPrevYearMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndbudgetMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndactualSalesMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndrunRateMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndtarget2ndMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndtraget3rdMap = new Map<String, Decimal>();
        Map<String, Decimal> JbpIdAndforecastMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndSalesPrevYearMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndbudgetMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndactualSalesMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndrunRateMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndtarget2ndMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndtraget3rdMap = new Map<String, Decimal>();
        Map<String, Decimal> OldJbpIdAndforecastMap = new Map<String, Decimal>();
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Set<Integer> startYearSet = new Set<Integer>();
        
        List<Joint_Business_Plan__c> updateList = new List<Joint_Business_Plan__c>();             
        List<Sobject> processList = (trgCtx.IsDelete) ? trgCtx.oldList : trgCtx.newList;
           
            
        for (Joint_Business_Plan_Product_Lines__c jbp : (List<Joint_Business_Plan_Product_Lines__c>) processList) {
                
            Joint_Business_Plan_Product_Lines__c oldJbp = (trgCtx.isInsert) ? NULL : (Joint_Business_Plan_Product_Lines__c) trgCtx.oldMap.get(jbp.Id);
            
          
            if (!processedIdSet.contains(jbp.Id)) {
            
                processedIdSet.add(jbp.Id);
                
                if (jbp.Joint_Business_Plan__c != NULL && (trgCtx.IsInsert || trgCtx.IsDelete || ( trgCtx.IsUpdate && (oldJbp.Previous_Year_Currency__c !=  jbp.Previous_Year_Currency__c || oldJbp.Current_Year_Currency__c != jbp.Current_Year_Currency__c || oldJbp.Current_Ongoing_Year__c != jbp.Current_Ongoing_Year__c || oldJbp.Run_Rate_On__c != jbp.Run_Rate_On__c || oldJbp.Joint_Business_Plan__c != jbp.Joint_Business_Plan__c || oldJbp.Second_Year_Currency__c != jbp.Second_Year_Currency__c || oldJbp.Third_Year_Currency__c != jbp.Third_Year_Currency__c || oldJbp.Forecast_Ongoing_Year__c != jbp.Forecast_Ongoing_Year__c || oldJbp.Starting_Year__c != jbp.Starting_Year__c)) ) ) {
                    
                    jbpIdSet.add(jbp.Joint_Business_Plan__c);
                    
                    Decimal previousYr = (jbp.Previous_Year_Currency__c != NULL) ? jbp.Previous_Year_Currency__c : 0;
                    Decimal budget = (jbp.Current_Year_Currency__c != NULL) ? jbp.Current_Year_Currency__c : 0;
                    Decimal actualSales =  (jbp.Current_Ongoing_Year__c != NULL) ? jbp.Current_Ongoing_Year__c : 0;
                    Decimal runRate = (jbp.Run_Rate_On__c != NULL) ? jbp.Run_Rate_On__c : 0;
                    Decimal target2nd =  (jbp.Second_Year_Currency__c != NULL) ? jbp.Second_Year_Currency__c : 0;
                    Decimal traget3rd =  (jbp.Third_Year_Currency__c != NULL) ? jbp.Third_Year_Currency__c : 0;
                    Decimal forecast =  (jbp.Forecast_Ongoing_Year__c != NULL) ? jbp.Forecast_Ongoing_Year__c : 0;
                    
                    if (jbp.Starting_Year__c != NULL) {
                    
                        startYearSet.add(Integer.valueOf(jbp.Starting_Year__c));
                        
                        
                        if (!JbpIdAndSalesPrevYearMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndSalesPrevYearMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, previousYr);
                        } else {
                            JbpIdAndSalesPrevYearMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndSalesPrevYearMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + previousYr);
                        }
                        
                        if (!JbpIdAndbudgetMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndbudgetMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, budget);
                        } else {
                            JbpIdAndbudgetMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndbudgetMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + budget);
                        }
                        
                        if (!JbpIdAndactualSalesMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndactualSalesMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, actualSales);
                        } else {
                            JbpIdAndactualSalesMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndactualSalesMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + actualSales);
                        }
                        
                        if (!JbpIdAndrunRateMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndrunRateMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, runRate);
                        } else {
                            JbpIdAndrunRateMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndrunRateMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + runRate);
                        }
                        
                        if (!JbpIdAndtarget2ndMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndtarget2ndMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, target2nd);
                        } else {
                            JbpIdAndtarget2ndMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndtarget2ndMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + target2nd);
                        }
                        
                        if (!JbpIdAndtraget3rdMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndtraget3rdMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, traget3rd);
                        } else {
                            JbpIdAndtraget3rdMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndtraget3rdMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + traget3rd);
                        }
                        
                        if (!JbpIdAndforecastMap.containsKey(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c)) {
                            JbpIdAndforecastMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, forecast);
                        } else {
                            JbpIdAndforecastMap.put(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c, JbpIdAndforecastMap.get(jbp.Joint_Business_Plan__c + jbp.Starting_Year__c) + forecast);
                        }
                    }
                   
                    //system.debug(':::::::::::::::::::::::::::::::::'+oldJbp.Starting_Year__c+trgCtx);   
                    if ( (trgCtx.IsUpdate || trgCtx.IsDelete) && oldJbp.Starting_Year__c != NULL ) {
                     
                        Decimal oldpreviousYr = (oldJbp.Previous_Year_Currency__c != NULL) ? oldJbp.Previous_Year_Currency__c : 0;
                        Decimal oldbudget = (oldJbp.Current_Year_Currency__c != NULL) ? oldJbp.Current_Year_Currency__c : 0;
                        Decimal oldActualSales =  (oldJbp.Current_Ongoing_Year__c != NULL) ? oldJbp.Current_Ongoing_Year__c : 0;
                        Decimal oldRunRate = (oldJbp.Run_Rate_On__c != NULL) ? oldJbp.Run_Rate_On__c : 0;
                        Decimal oldtarget2nd =  (oldJbp.Second_Year_Currency__c != NULL) ? oldJbp.Second_Year_Currency__c : 0;
                        Decimal oldtraget3rd =  (oldJbp.Third_Year_Currency__c != NULL) ? oldJbp.Third_Year_Currency__c : 0;
                        Decimal oldforecast =  (oldJbp.forecast_Ongoing_Year__c != NULL) ? oldJbp.forecast_Ongoing_Year__c : 0;
                        
                        jbpIdSet.add(oldJbp.Joint_Business_Plan__c);
                        
                        startYearSet.add(Integer.valueOf(oldJbp.Starting_Year__c));
                        
                        if (!oldJbpIdAndSalesPrevYearMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndSalesPrevYearMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldpreviousYr);
                        } else {
                            oldJbpIdAndSalesPrevYearMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldJbpIdAndSalesPrevYearMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldpreviousYr);
                        }
                        
                        if (!oldJbpIdAndbudgetMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndbudgetMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldbudget);
                        } else {
                            oldJbpIdAndbudgetMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, OldJbpIdAndbudgetMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldbudget);
                        }
                        
                        if (!oldJbpIdAndActualSalesMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndActualSalesMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldActualSales);
                        } else {
                            oldJbpIdAndActualSalesMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldJbpIdAndActualSalesMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldActualSales);
                        }
                        
                        if (!oldJbpIdAndRunRateMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndRunRateMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldRunRate);
                        } else {
                            oldJbpIdAndRunRateMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldJbpIdAndRunRateMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldRunRate);
                        }
                        
                        if (!oldJbpIdAndtarget2ndMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndtarget2ndMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldtarget2nd);
                        } else {
                            oldJbpIdAndtarget2ndMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldJbpIdAndtarget2ndMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldtarget2nd);
                        }
                        
                        if (!oldJbpIdAndtraget3rdMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            oldJbpIdAndtraget3rdMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldtraget3rd);
                        } else {
                            oldJbpIdAndtraget3rdMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldJbpIdAndtraget3rdMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldtraget3rd);
                        }
                        
                        if (!OldJbpIdAndforecastMap.containsKey(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c)) {
                            OldJbpIdAndforecastMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, oldforecast);
                        } else {
                            OldJbpIdAndforecastMap.put(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c, OldJbpIdAndforecastMap.get(oldJbp.Joint_Business_Plan__c + oldJbp.Starting_Year__c) + oldforecast);
                        }                        
                    }
                } 
            }
        }
        
        if (jbpIdSet.size() > 0 ) {
            
           // system.debug(':::oldJbpIdAndSalesPrevYearMap:::'+oldJbpIdAndSalesPrevYearMap);
            
            for (Joint_Business_Plan__c jbp: [ SELECT ID, Start_Date__c, Actual_Sales_Year_to_Date__c, Budget_Current_Year__c, Forecast_ongoing_year__c, Rund_Rate_Ongoing_year__c, Sales_previous_year__c,
                Target_2nd_Year__c, Target_3rd_Year__c FROM Joint_Business_Plan__c WHERE ID IN :jbpIdSet AND Calendar_Year(Start_Date__c) IN :startYearSet LIMIT :remLimit]) {
                
                jbp.Sales_previous_year__c = (jbp.Sales_previous_year__c != NULL) ? jbp.Sales_previous_year__c : 0;
                jbp.Budget_Current_Year__c = (jbp.Budget_Current_Year__c != NULL) ? jbp.Budget_Current_Year__c : 0;
                jbp.Actual_Sales_Year_to_Date__c =  (jbp.Actual_Sales_Year_to_Date__c != NULL) ? jbp.Actual_Sales_Year_to_Date__c : 0;
                jbp.Rund_Rate_Ongoing_year__c = (jbp.Rund_Rate_Ongoing_year__c != NULL) ? jbp.Rund_Rate_Ongoing_year__c : 0;
                jbp.Target_2nd_Year__c =  (jbp.Target_2nd_Year__c != NULL) ? jbp.Target_2nd_Year__c : 0;
                jbp.Target_3rd_Year__c =  (jbp.Target_3rd_Year__c != NULL) ? jbp.Target_3rd_Year__c : 0;
                jbp.Forecast_ongoing_year__c =  (jbp.Forecast_ongoing_year__c != NULL) ? jbp.Forecast_ongoing_year__c : 0;
                
                String YearVal = String.valueOf(jbp.Start_Date__c.year());
                
                 if (trgCtx.IsInsert || trgCtx.IsUpdate) {
                                     
                    jbp.Sales_previous_year__c += JbpIdAndSalesPrevYearMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndSalesPrevYearMap.get(jbp.Id + YearVal) : 0;
                    jbp.Budget_Current_Year__c += (JbpIdAndbudgetMap.get(jbp.Id + YearVal) != NULL) ? JbpIdAndbudgetMap.get(jbp.Id + YearVal) : 0;
                    jbp.Actual_Sales_Year_to_Date__c += JbpIdAndactualSalesMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndactualSalesMap.get(jbp.Id + YearVal) : 0;
                    jbp.Rund_Rate_Ongoing_year__c += JbpIdAndrunRateMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndrunRateMap.get(jbp.Id + YearVal) : 0;
                    jbp.Target_2nd_Year__c += JbpIdAndtarget2ndMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndtarget2ndMap.get(jbp.Id + YearVal) : 0;          
                    jbp.Target_3rd_Year__c += JbpIdAndtraget3rdMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndtraget3rdMap.get(jbp.Id + YearVal) : 0;                              
                    jbp.Forecast_ongoing_year__c += JbpIdAndforecastMap.get(jbp.Id + YearVal) != NULL ? JbpIdAndforecastMap.get(jbp.Id + YearVal) : 0;
                }
                if (trgCtx.IsUpdate || trgCtx.IsDelete) {
                    
                    jbp.Sales_previous_year__c -= oldJbpIdAndSalesPrevYearMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndSalesPrevYearMap.get(jbp.Id + YearVal) : 0;
                    jbp.Budget_Current_Year__c -= oldJbpIdAndbudgetMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndbudgetMap.get(jbp.Id + YearVal) : 0;
                    jbp.Actual_Sales_Year_to_Date__c -= oldJbpIdAndactualSalesMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndactualSalesMap.get(jbp.Id + YearVal) : 0;
                    jbp.Rund_Rate_Ongoing_year__c -= oldJbpIdAndrunRateMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndrunRateMap.get(jbp.Id + YearVal) : 0;
                    jbp.Target_2nd_Year__c -= oldJbpIdAndtarget2ndMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndtarget2ndMap.get(jbp.Id + YearVal) : 0;          
                    jbp.Target_3rd_Year__c -= oldJbpIdAndtraget3rdMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndtraget3rdMap.get(jbp.Id + YearVal) : 0;                              
                    jbp.Forecast_ongoing_year__c -= oldJbpIdAndforecastMap.get(jbp.Id + YearVal) != NULL ? oldJbpIdAndforecastMap.get(jbp.Id + YearVal) : 0;
                }
                updateList.add(jbp);
            }
        }
        
        try {
            
            //system.debug(':::updateList:::'+updateList);
            
            Database.Update(updateList,False);
        } Catch(DMLException e) {
            
            String error = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                error += e.getDMLMessage(i) + Label.Line_Break;
            }
            
            for (Sobject sob: processList) {
                sob.addError(error, false);
            }
        }
    }
    
/**        
  * Req #1960 (Update Joint Business Plan currency to Joint Business Plan Product Lines).   
*/    
    public void assingnCurrency(ClsWrappers.TriggerContext trgCtx) {
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        Set<Id> parentIdSet = new Set<Id>();
        for (Sobject sobj : trgCtx.newList) {
            Joint_Business_Plan_Product_Lines__c sobjJBP = (Joint_Business_Plan_Product_Lines__c)sObj;
            parentIdSet.add(sobjJBP.Joint_Business_Plan__c);
        }
        
        if (parentIdSet.size() > 0) {
            
            Map<Id, Joint_Business_Plan__c> jointBusPlanMap = new Map<Id, Joint_Business_Plan__c> ([ SELECT Id, CurrencyISOCode FROM Joint_Business_Plan__c WHERE Id IN :parentIdSet LIMIT :remLimit] );
            for (Sobject sobj : trgCtx.newList) {
                Joint_Business_Plan_Product_Lines__c sobjJBP = (Joint_Business_Plan_Product_Lines__c)sObj;
                sobjJBP.CurrencyISOCode = jointBusPlanMap.get(sobjJBP.Joint_Business_Plan__c).CurrencyISOCode;
            }
        }
    }
/**    
*To copy Sales Targets and Results from Channel Partner Business Plan
*/  
    public void copySalesTargetsResults(ClsWrappers.TriggerContext trgCtx){
        
        List<Sales_and_Target_channel_business_review__c> salesTargetReviewList = new List<Sales_and_Target_channel_business_review__c>();
        Map<Id, List<Joint_Business_Plan_Product_Lines__c >> planIDSalesTargetListMap  = new Map<Id, List<Joint_Business_Plan_Product_Lines__c >>();
        
        for (Sobject sobj : trgCtx.newList) {
        
            Joint_Business_Plan_Product_Lines__c salesTarget = (Joint_Business_Plan_Product_Lines__c)sObj;            
            if (salesTarget.Joint_Business_Plan__c != NULL) {
                if (!planIDSalesTargetListMap.containsKey(salesTarget.Joint_Business_Plan__c)) {
                    planIDSalesTargetListMap.put(salesTarget.Joint_Business_Plan__c, new List<Joint_Business_Plan_Product_Lines__c>());
                }
                planIDSalesTargetListMap.get(salesTarget.Joint_Business_Plan__c).add(salesTarget);
            }
        }
        
        if (!planIDSalesTargetListMap.isEmpty()) {
            
            remLimit =  limits.getLimitQueryRows() - limits.getQueryRows(); 
            
            for (Channel_Business_Review__c channel : [SELECT Id, Joint_Business_Plan__c FROM Channel_Business_Review__c WHERE Joint_Business_Plan__c IN : planIDSalesTargetListMap.KeySet() LIMIT :remLimit ] ) {
                
                for (Joint_Business_Plan_Product_Lines__c salesTargetPlan: planIDSalesTargetListMap.get(channel.Joint_Business_Plan__c)) {
                    
                    Sales_and_Target_channel_business_review__c salesTargetReview = new Sales_and_Target_channel_business_review__c();
                    salesTargetReview.Channel_Partner_Business_Review__c = channel.Id;
                    salesTargetReview.Sales_Targets_and_Results__c = salesTargetPlan.Id;
                    salesTargetReviewList.add(salesTargetReview);
                }
            }
        }
        
        try {
            if (salesTargetReviewList.size() > 0) {
                insert salesTargetReviewList;
            }
        } Catch(DMLException e) {
            String err = '';
            for (Integer i = 0; i < e.getNumDML(); i++) {
                err += e.getDMLMessage(i) +Label.Line_Break;
            }
            
            for (Sobject sobj : trgCtx.newList) {
                sobj.addError(err, false);
            }
        }
    }
}
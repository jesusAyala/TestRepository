/**   
* TriggerClass - Update the value of Product_Qualification_Level__c & Product_Qualification_Level_2__c based on options in Product Qualification Level custom object  
* Also Update the Initiative_Status__c,Hidden_Trigger_Check__c,Current_Product_Qualification_Level__c & Current_Product_Qualification_Level_2__c in Product Qualification custom object 
*      
* Release R4
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-08-21
* @version 1.0
*
* - Created
* - Updated - Ebenezer - Qualification Level Changes 
*/
public without sharing class ClsTriggerProductQualLevelHandler extends ClsTriggerVirtual {

/**
* @see IntHelper.afterTrigger
*/   
public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {        
        updateProdQualLevel(trgCtx);                   
    }
    
/**
* @see IntHelper.afterTrigger
*/   
public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {        
        updateProdQualInitiativeStatus(trgCtx);           
    }
    
    /*     
Method : updateProdQualLevel - to update the Product_Qualification_Level__c & Product_Qualification_Level_2__c in Product_Qualification_Level__c
@author  Abiramasundari Radha (Accenture)
*/     
    @TestVisible 
    private void updateProdQualLevel(ClsWrappers.TriggerContext trgCtx) {

     Set<String> setProdQual = new Set<String>();       
     Integer currentQtr = NULL;
     String monthAndYear = NULL;
            
        if (trgCtx.isInsert || trgCtx.isUpdate) {                
            // GET Product Qualification Level RECORD INTO THE LIST
            for (sobject sObj : trgCtx.newList) {                                                  
                // Add the Record to the List - prodQualList     
                Product_Qualification_Level__c prdQualLevel = (Product_Qualification_Level__c)sObj;   
               
                if (prdQualLevel.Product_Qualification__c != NULL){       
                    setProdQual.add(prdQualLevel.Product_Qualification__c);
                }                                      
               
                //Validating ABB location and Product are linked to Product Qualification to close any Product Qualification record
                    if(prdQualLevel.Option1_NQual__c == Label.System_CL0002 || prdQualLevel.Option_1Execution__c == Label.System_CL0002 || prdQualLevel.Option_1Planning__c == Label.System_CL0002 ||
                    prdQualLevel.Option_1Qualified1__c == Label.System_CL0002 || prdQualLevel.Option_1Submitted__c == Label.System_CL0002 || prdQualLevel.Option2_NQual__c == Label.System_CL0002 ||
                    prdQualLevel.Option_2Execution__c == Label.System_CL0002 || prdQualLevel.Option_2Planning__c == Label.System_CL0002 || prdQualLevel.Option_2Qualified2__c == Label.System_CL0002 ||
                    prdQualLevel.Option_2Submitted__c == Label.System_CL0002 || prdQualLevel.Option_3Execution__c == Label.System_CL0002 || prdQualLevel.Option_3Planning__c == Label.System_CL0002 ||
                    prdQualLevel.Option_4Execution__c == Label.System_CL0002 || prdQualLevel.Option_4Planning__c == Label.System_CL0002 || prdQualLevel.Option_5Execution__c == Label.System_CL0002 ){
                        if(setProdQual != Null && setProdQual.size() > 0){
                            for(Product_Qualification__c prd : [SELECT ID, Name, Initiative_Status__c,Level_Date__c,Actual_End_Date__c,Source_Location__c, Product_Name__c FROM Product_Qualification__c WHERE ID IN: setProdQual LIMIT 10000]){
                              //  System.debug('Prod name test'+prd.Product_Name__c);
                                if(prd.Source_Location__c == Null || prd.Product_Name__c == Null){
                                
                                    prdQualLevel.AddError(Label.Product_Qualification_Error_Message);
                                }
                            }
                        }
                    }
                    
                    
                // If the user answers for option1 & Option 2 as Yes then update Product_Qualification_Level__c to Product not qualified otherwise NULL                                     
                    if(prdQualLevel.Option1_NQual__c == Label.System_CL0001 && prdQualLevel.Option2_NQual__c == Label.System_CL0001 && prdQualLevel.Option2_NQual__c != NULL){               
                        prdQualLevel.Product_Qualification_Level__c = Label.System_CL0006_R4;
                        prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL0007_R4;                                       
                    }else if(((prdQualLevel.Option1_NQual__c != Label.System_CL0001) && (prdQualLevel.Option2_NQual__c == Label.System_CL0001)) ||
                           ((prdQualLevel.Option1_NQual__c == Label.System_CL0001) && (prdQualLevel.Option2_NQual__c != Label.System_CL0001))){
                        prdQualLevel.Product_Qualification_Level__c = Label.System_CL0008_R4;
                        prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL0009_R4;                         
                    }else{}
                           
                
                // If the user answers for option1 & Option 2 as Yes/NA then update Product_Qualification_Level__c to Qualification in progress Planning otherwise must go back to the previous product qualification level              
                if(prdQualLevel.Option_1Planning__c != NULL && prdQualLevel.Option_2Planning__c != NULL && prdQualLevel.Option_3Planning__c != NULL && prdQualLevel.Option_4Planning__c != NULL ){
                    if(prdQualLevel.Option_1Planning__c == Label.System_CL0001 && (prdQualLevel.Option_2Planning__c == Label.System_CL0001 || prdQualLevel.Option_2Planning__c == Label.System_CL0003 )
                       && ( prdQualLevel.Option_3Planning__c == Label.System_CL0001 || prdQualLevel.Option_3Planning__c == Label.System_CL0003)
                       && (prdQualLevel.Option_4Planning__c == Label.System_CL0001 || prdQualLevel.Option_4Planning__c == Label.System_CL0003)){                           
                           prdQualLevel.Product_Qualification_Level__c = Label.System_CL00010;
                           prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL00011;                          
                       }
                } 
                
                // If the user answers for option1 & Option 2 as Yes/NA then update Product_Qualification_Level__c to Qualification in progress Execution otherwise must go back to the previous product qualification level              
                if( prdQualLevel.Option_1Execution__c != NULL && prdQualLevel.Option_2Execution__c != NULL && prdQualLevel.Option_3Execution__c != NULL 
                   && prdQualLevel.Option_4Execution__c != NULL && prdQualLevel.Option_5Execution__c != NULL){
                       if((prdQualLevel.Option_1Execution__c == Label.System_CL0001 || prdQualLevel.Option_1Execution__c == Label.System_CL0003) && 
                          prdQualLevel.Option_2Execution__c == Label.System_CL0001 &&
                          (prdQualLevel.Option_3Execution__c == Label.System_CL0001 || prdQualLevel.Option_3Execution__c == Label.System_CL0003) &&
                          (prdQualLevel.Option_4Execution__c == Label.System_CL0001 || prdQualLevel.Option_4Execution__c == Label.System_CL0003 ) &&
                          (prdQualLevel.Option_5Execution__c == Label.System_CL0001 || prdQualLevel.Option_5Execution__c == Label.System_CL0003 )){                              
                              prdQualLevel.Product_Qualification_Level__c = Label.System_CL00012;
                              prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL00013;                                                           
                          }             
                   }
                
                // If the user answers for option1 & Option 2 as Yes then update Product_Qualification_Level__c to Qualification in progress Submitted otherwise must go back to the previous product qualification level              
                if(prdQualLevel.Option_1Submitted__c == Label.System_CL0001 && prdQualLevel.Option_2Submitted__c == Label.System_CL0001 ){          
                    prdQualLevel.Product_Qualification_Level__c = Label.System_CL00014;
                    prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL00015;                    
                }  
                
                // Modified 14/10/2015
                // If the user answers for option1 & Option 2 as Yes then update Product_Qualification_Level__c to Product qualified otherwise must go back to the previous product qualification level
                if(prdQualLevel.Option_1Qualified1__c == Label.System_CL0001  && prdQualLevel.Option_2Qualified2__c == Label.System_CL0001 ||
                   prdQualLevel.Option_1Qualified1__c == Label.System_CL0001  && prdQualLevel.Option_2Qualified2__c == Label.System_CL0003 ){          
                    prdQualLevel.Product_Qualification_Level__c = label.System_CL00016;
                    prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL00017;                    
                } 
               
                // Added 14/10/2015
                if(prdQualLevel.Option_1Submitted__c == Label.System_CL0002 || 
                   prdQualLevel.Option_2Submitted__c == Label.System_CL0002 ){
                       prdQualLevel.Product_Qualification_Level__c = Label.System_CL00012;
                       prdQualLevel.Product_Qualification_Level_2__c = Label.System_CL00013; 
                } 
                                                                 
               
                //Update the Quarter values
                if (prdQualLevel.LastModifiedDate != NULL  && setProdQual != NULL && setProdQual.size() > 0 ) {                
                currentQtr = Decimal.valueOf(prdQualLevel.LastModifiedDate.month()).divide(3.0, 0, System.RoundingMode.UP).intValue();                                                                    
                    if(prdQualLevel.Product_Qualification_Level_2__c!= NULL || String.Isblank(prdQualLevel.Product_Qualification_Level_2__c) ){
                        DateTime datObj = prdQualLevel.LastModifiedDate;                       
                        Integer monthValue = datObj.month();
                        Integer yearValue = datObj.year(); 
                        monthAndYear = monthValue + Label.System_CL00020+ yearValue;    
                            if(currentQtr == 1){                                   
                                prdQualLevel.Quarter_1__c = prdQualLevel.Product_Qualification_Level_2__c;
                                prdQualLevel.YQ1__c = monthAndYear;
                            }else if(currentQtr == 2){                                   
                                prdQualLevel.Quarter_2__c = prdQualLevel.Product_Qualification_Level_2__c;
                                prdQualLevel.YQ2__c = monthAndYear;
                            }else if(currentQtr == 3){                                 
                                prdQualLevel.Quarter_3__c = prdQualLevel.Product_Qualification_Level_2__c;
                                prdQualLevel.YQ3__c = monthAndYear;
                            }else if(currentQtr == 4){                                    
                                prdQualLevel.Quarter_4__c = prdQualLevel.Product_Qualification_Level_2__c;
                                prdQualLevel.YQ4__c = monthAndYear;
                            }
                    }
                }                                                                                                                  
            }  
        }
    }
    
    /*     
Method : updateProdQualInitiativeStatus - to update the values in Product_Qualification__c
@author  Abiramasundari Radha (Accenture)
*/    
    @TestVisible 
    private void updateProdQualInitiativeStatus(ClsWrappers.TriggerContext trgCtx) {        
        Set<String> setProdQual = new Set<String>();
        List<Product_Qualification__c> tobeUpdateProdQualification = new List<Product_Qualification__c>();                       
        if ((trgCtx.isInsert && trgCtx.isAfter) ||  trgCtx.isUpdate) {                               
                // GET Product Qualification Level RECORD INTO THE LIST
                for (sobject sObj : trgCtx.newList) {                           
                    // Add the Record to the Set setProdQual     
                    Product_Qualification_Level__c prdQualLevel = (Product_Qualification_Level__c)sObj;    
                    if (prdQualLevel.Product_Qualification__c != NULL)
                    {       
                        setProdQual.add(prdQualLevel.Product_Qualification__c);
                    }                            
                }
                
                //Update the Product Qualification - Initiative Status based on the recent Product Qualification Level
                if (setProdQual != NULL && setProdQual.size() > 0 ) {
                    for (Product_Qualification__c prd : [SELECT ID, Name,Initiative_Status__c,Level_Date__c,Actual_End_Date__c, (SELECT Id, Name,Product_Qualification__c,Option1_NQual__c,Level_Date__c,
                                          Option_2Planning__c,Option_2Execution__c,Option_2Submitted__c,Option_2Qualified2__c,Option_3Planning__c,
                                          Option2_NQual__c,Option_1Planning__c,Option_1Execution__c,Option_1Submitted__c,Option_1Qualified1__c,
                                          Option_3Execution__c,Option_4Planning__c,Option_4Execution__c,Option_5Execution__c,
                                          Customer_Pilot_Installation_Start_Date__c,End_Date__c,Product_Qualification_Level__c,Product_Qualification_Level_2__c,
                                          Quarter_1__c,Quarter_2__c,Quarter_3__c,Quarter_4__c,YQ1__c,YQ2__c,YQ3__c,YQ4__c
                                          from  Product_Qualification_Levels__r order by CreatedDate desc LIMIT 1 )
                                          FROM Product_Qualification__c WHERE ID IN: setProdQual LIMIT 10000]){
                                                for(Product_Qualification_Level__c childPrd : prd.Product_Qualification_Levels__r){                                                                                                                                                                                                                                                 
                                                     Product_Qualification__c prdQual = new Product_Qualification__c();  
                                                     //update the Initiative_Status__c, Current_Product_Qualification_Level__c, Current_Product_Qualification_Level_2__c values in Product Qualification                                                           
                                                      if( childPrd.Option1_NQual__c == Label.System_CL0002 || childPrd.Option2_NQual__c == Label.System_CL0002 ||
                                                            childPrd.Option_1Planning__c == Label.System_CL0002 || childPrd.Option_2Planning__c == Label.System_CL0002 ||
                                                            childPrd.Option_3Planning__c == Label.System_CL0002 || childPrd.Option_4Planning__c == Label.System_CL0002 ||
                                                            childPrd.Option_1Execution__c == Label.System_CL0002 ||  childPrd.Option_2Execution__c == Label.System_CL0002 || 
                                                            childPrd.Option_3Execution__c == Label.System_CL0002 || childPrd.Option_4Execution__c == Label.System_CL0002 || 
                                                            childPrd.Option_5Execution__c == Label.System_CL0002  || childPrd.Option_1Submitted__c == Label.System_CL0002 || 
                                                            childPrd.Option_2Submitted__c == Label.System_CL0002 ){                                                                                                                                         
                                                                prdQual.Id = prd.Id;
                                                                prdQual.Initiative_Status__c = Label.System_CL0004; // Closed Not Qualified                                      
                                                                prdQual.Hidden_Trigger_Check__c =True;
                                                                prdQual.Actual_End_Date__c = system.today();
                                                                prdQual.Current_Product_Qualification_Level__c=childPrd.Product_Qualification_Level__c;
                                                                prdQual.Current_Product_Qualification_Level_2__c=childPrd.Product_Qualification_Level_2__c;                                                                                                                                                                                                                                                                                                                                   
                                                                prdQual.Quarter_1__c = childPrd.Quarter_1__c;
                                                                prdQual.Quarter_2__c = childPrd.Quarter_2__c;
                                                                prdQual.Quarter_3__c = childPrd.Quarter_3__c;
                                                                prdQual.Quarter_4__c = childPrd.Quarter_4__c;
                                                                prdQual.YQ1__c = childPrd.YQ1__c;
                                                                prdQual.YQ2__c = childPrd.YQ2__c;
                                                                prdQual.YQ3__c = childPrd.YQ3__c;
                                                                prdQual.YQ4__c = childPrd.YQ4__c;
                                                                tobeUpdateProdQualification.add(prdQual);                                         
                                                         }else{                                                                   
                                                                prdQual.Id = prd.Id;
                                                                prdQual.Initiative_Status__c = Label.System_CL0005_R4; // Open                                                              
                                                                prdQual.Hidden_Trigger_Check__c =False;
                                                                prdQual.Current_Product_Qualification_Level__c=childPrd.Product_Qualification_Level__c;
                                                                prdQual.Current_Product_Qualification_Level_2__c=childPrd.Product_Qualification_Level_2__c; 
                                                                prdQual.Quarter_1__c = childPrd.Quarter_1__c;
                                                                prdQual.Quarter_2__c = childPrd.Quarter_2__c;
                                                                prdQual.Quarter_3__c = childPrd.Quarter_3__c;
                                                                prdQual.Quarter_4__c = childPrd.Quarter_4__c;
                                                                prdQual.YQ1__c = childPrd.YQ1__c;
                                                                prdQual.YQ2__c = childPrd.YQ2__c;
                                                                prdQual.YQ3__c = childPrd.YQ3__c;
                                                                prdQual.YQ4__c = childPrd.YQ4__c; 
                                                                
                                                  If(childPrd.Product_Qualification_Level_2__c == Label.System_CL00015 || childPrd.Product_Qualification_Level_2__c == Label.System_CL00017 ){
                                                        prdQual.Initiative_Status__c = Label.System_CL00082;  
                                                        prdQual.Actual_End_Date__c = system.today();  
                                                  } 
                                                                                                                  
                                                                tobeUpdateProdQualification.add(prdQual);  
                                                         }  
                                                                                                                                                                                         
                                                    if(childPrd.Level_Date__c != Null ){prdQual.Level_Date__c=childPrd.Level_Date__c;}                            
                                                    if(childPrd.Customer_Pilot_Installation_Start_Date__c != Null){prdQual.Customer_Pilot_Installation_Start_Date__c = childPrd.Customer_Pilot_Installation_Start_Date__c; } else{prdQual.Customer_Pilot_Installation_Start_Date__c=NULL;}                                                
                                                    if(childPrd.End_Date__c != Null ){prdQual.End_Date__c=childPrd.End_Date__c;}else{prdQual.End_Date__c=NULL;}                                              
                                                }                                                        
                    } 
                    
                    //update the Product Qualification
                    if(tobeUpdateProdQualification != NULL && tobeUpdateProdQualification.size() > 0){                                                 
                        Database.update(tobeUpdateProdQualification);   
                    }                                      
                }                                         
        }          
    }   
}
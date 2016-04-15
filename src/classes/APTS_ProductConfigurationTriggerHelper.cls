/*
@Name: APTS_ProductConfigurationTriggerHelper
@Author: Hardik Shah
@CreateDate: 05/09/2015
@Description: Helper Class to Perform operations on ProductConfiguration Object
@UsedBy: APTS_ProductConfigurationHandler
******************************************************************
@ModifiedBy: Nishi and Hardik to include changes to Show Chevron for Approval Required. (Issue 135 in Element Tool)
@ModifiedDate: 27 Sep 2015
@ModifiedBy: Hardik- To Round of Digits to two decimal places.
@ModifiedDate: 28 Sep 2015
@ChangeDescription: 
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
*/

public class APTS_ProductConfigurationTriggerHelper {
    public static map<String,Decimal> mapProdConfigWithMaxDiscount = new map<String,Decimal>();
    public static map<String,String> mapProdConfigWithGTVCode = new map<String,String>();
    public static List<Apttus_Config2__LineItem__c> listCriticalDiscLineItem = new List<Apttus_Config2__LineItem__c>();
    public static final Integer THRESHOLD_DISCOUNT_DUMMY_CUTOFF = 101;
    /*
    @Addedby:Chetan Patel
    @Method to update Agreement/Proposal header fields GTV-level and MaxDiscount to Maximum discount among LineItems.
    @param:ProductConfiguration
    */
    
    public static void getMaxLineItemDiscount(Map < Id, Apttus_Config2__ProductConfiguration__c > records, Map < Id, Apttus_Config2__ProductConfiguration__c > oldRecordsMap){
        String sLocalChannelCode='';
        // Set of ProductConfigurationId
        Set < String > setProductConfig = new Set < String > ();
        // Boolean variable that marks all those product configuration whose status has changed to Finalized
        Boolean bStatusChanged = false;
        Boolean isProposal = false;
        Boolean isAgreement = false;
        Boolean isMSPAwithoutChanges = false;
        List<Apttus_Proposal__Proposal__c> lstProposal = new List<Apttus_Proposal__Proposal__c>();
        List<Apttus__APTS_Agreement__c> lstAgreement = new List<Apttus__APTS_Agreement__c>();
        list<Apttus_Config2__LineItem__c> LineswithLineNumberSequence=new list<Apttus_Config2__LineItem__c>();
                
        setProductConfig = getFilteredProductConfig(records,oldRecordsMap );
        
        // Clear Critical discount line item before we start finding critical line Item.
        listCriticalDiscLineItem.clear();

        system.debug('<<<< Product Config >>>>' + setProductConfig.size());
        if (setProductConfig.size() > 0) {

            // Fetch all the information required from Product Configuration
            List < Apttus_Config2__ProductConfiguration__c > listConfig = APTS_LP_QueryUtility.getProductConfiguration(setProductConfig);
            
            boolean isAnyLineItemWithNoRule = false;
            boolean isCartEmpty = false;
            
            
            system.debug('<<<< List Of configuration >>>>: ' + listConfig);
            for (Apttus_Config2__ProductConfiguration__c productConfig: listConfig) {
                
                if(productConfig.Apttus_Config2__LineItems__r.size()==0)
                    isCartEmpty=true;
                
                lstProposal = [select id,Apttus_Proposal__Approval_Stage__c,APTS_Local_Channel__c,APTS_GTV_Code__c,APTS_LP_MaximumSubstituteDiscount__c 
                from Apttus_Proposal__Proposal__c where id =:productConfig.Apttus_QPConfig__Proposald__c limit 1];
                 
                
                lstAgreement = [select id,Apttus_Approval__Approval_Status__c,APTS_GTV_Code__c, APTS_Local_Channel__c, Apttus__Status__c,
                                APTS_LP_MaximumSubstituteDiscount__c, APTS_MSPA_without_Changes__c, Apttus_QPComply__RelatedProposalId__c, APTS_Legacy_MSPA__c 
                                from Apttus__APTS_Agreement__c where id  =:productConfig.Apttus_CMConfig__AgreementId__c
                                 LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                
                String LocalChannel = '';
                String SalesOffice = '';
                String Country = '';
                String SalesOrganization = '';
            
                if(productConfig.Apttus_QPConfig__Proposald__c !=null){
              
                    if(productConfig.Apttus_QPConfig__Proposald__r.APTS_QuotationType__c == APTS_Constants.PROPOSAL_TYPE){      
                        
                        isProposal          =   true;
                        LocalChannel        =   productConfig.Apttus_QPConfig__Proposald__r.APTS_Local_Channel__c;
                        SalesOffice         =   productConfig.Apttus_QPConfig__Proposald__r.APTS_Sales_Office__r.PickList_Code__c;
                        Country             =   productConfig.Apttus_QPConfig__Proposald__r.APTS_Country__c;
                        SalesOrganization   =   productConfig.Apttus_QPConfig__Proposald__r.APTS_LP_Sales_Organization__c;
                        sLocalChannelCode   =   productConfig.Apttus_QPConfig__Proposald__r.APTS_Local_Channel__r.APTS_Code__c; 
                    }
                    
                }
                if(productConfig.Apttus_CMConfig__AgreementId__c != null){
             
                    if(productConfig.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == APTS_Constants.MSPA_TYPE){
                        system.debug('@@ LocalChannel agreement : ' + LocalChannel + SalesOffice);
                        
                        isAgreement = true;
                        LocalChannel = productConfig.Apttus_CMConfig__AgreementId__r.APTS_Local_Channel__c;
                        SalesOffice = productConfig.Apttus_CMConfig__AgreementId__r.APTS_Sales_Office__r.PickList_Code__c;
                        Country             =   productConfig.Apttus_CMConfig__AgreementId__r.APTS_Country__c;
                        SalesOrganization   =   productConfig.Apttus_CMConfig__AgreementId__r.APTS_LP_Sales_Organization__c;
                        sLocalChannelCode   =   productConfig.Apttus_CMConfig__AgreementId__r.APTS_Local_Channel__r.APTS_Code__c;
                    }
                }
                set<String> setGTVCode = new set<String>();
               
                
                // fetch the lineItem from ProductConfiguration
                for(Apttus_Config2__LineItem__c item: productConfig.Apttus_Config2__LineItems__r){
                    
                    setGTVCode.add(item.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c);
                  
                }
                
                system.debug('@@ line item setGTVCode : ' + setGTVCode );
                map<String,List<APTS_Approval_Rule_Matrix__c>> mapApprovalRuleMatrix = new map<String,List<APTS_Approval_Rule_Matrix__c>>();
                List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrix = [select id,APTS_Threshold_Discount__c,APTS_Approval_Level__c,APTS_CHF__c
                                                                            from APTS_Approval_Rule_Matrix__c
                                                                            where APTS_LP_Local_Channel__c=:LocalChannel
                                                                            and APTS_Sales_Office__r.PickList_Code__c =:SalesOffice
                                                                            and APTS_GTV_Level_Code__c IN :setGTVCode
                                                                            and APTS_Threshold_Discount__c < :THRESHOLD_DISCOUNT_DUMMY_CUTOFF
                                                                            and APTS_Is_Active__c=true LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                                                                            
                system.debug('@@ lstApprovalRuleMatrix after : ' + JSON.serialize(lstApprovalRuleMatrix));
                
                if(lstApprovalRuleMatrix != null && lstApprovalRuleMatrix.size() > 0) {
                    
                    for(APTS_Approval_Rule_Matrix__c rule : lstApprovalRuleMatrix){
                        
                        if(!mapApprovalRuleMatrix.keyset().contains(rule.APTS_CHF__c)){
                            
                            List<APTS_Approval_Rule_Matrix__c> tmplstApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                            tmplstApprovalRuleMatrix.add(rule);
                            mapApprovalRuleMatrix.put(rule.APTS_CHF__c,tmplstApprovalRuleMatrix);
                        }else{
                            
                            List<APTS_Approval_Rule_Matrix__c> tmplstApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                            tmplstApprovalRuleMatrix = mapApprovalRuleMatrix.get(rule.APTS_CHF__c);
                            tmplstApprovalRuleMatrix.add(rule);
                            mapApprovalRuleMatrix.put(rule.APTS_CHF__c,tmplstApprovalRuleMatrix);
                        }
                    }
                }else{
                    
                    if(lstProposal != null && lstProposal.size() > 0){
                        lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                        lstProposal[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                        lstProposal[0].APTS_GTV_Code__c  = null;
                        
                    }
                    
                    if(lstAgreement != null && lstAgreement.size() > 0){
                        System.debug(': update agreement');
                        lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                        lstAgreement[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                        lstAgreement[0].APTS_GTV_Code__c  = null;
                        
                    }
                }
                
                system.debug('@@ mapApprovalRuleMatrix : ' + JSON.serialize(mapApprovalRuleMatrix));
                
                if(mapApprovalRuleMatrix != null && mapApprovalRuleMatrix.size() > 0){
                    system.debug('<<<< Local Channel Code >>>>' + sLocalChannelCode);
                    Decimal previousDiscount = 0;
                    Decimal maxDiscount = 0;
                    map<String,Integer> maplineItemWiseRulesCount = new map <String,Integer>();
                    map<String,Apttus_Config2__LineItem__c> maplineItemWithId = new map <String,Apttus_Config2__LineItem__c>();
                    set<string> lineItemsWithNoRule = new set<String>();
                    
                    for(Apttus_Config2__LineItem__c item: productConfig.Apttus_Config2__LineItems__r){
                        
                        String combinedHeaderFields       = Country + SalesOrganization + sLocalChannelCode + SalesOffice + item.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c;
                        String combinedHeaderFieldsDetail = 'Country : '            + Country + ' | ' + 
                                                            'Sales Organization : ' + SalesOrganization + ' | ' + 
                                                            'Local Channel : '      + sLocalChannelCode + ' | ' + 
                                                            'Sales Office : '       + SalesOffice + ' | ' + 
                                                            'Product GTV Code : '   + item.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c;
                        system.debug('@@ combinedHeaderFields :'+ combinedHeaderFields);
                        if(mapApprovalRuleMatrix.keyset().contains(combinedHeaderFields)){
                            
                            List<APTS_Approval_Rule_Matrix__c> tmplstApprovalRuleMatrix  = new List<APTS_Approval_Rule_Matrix__c>();
                            tmplstApprovalRuleMatrix= mapApprovalRuleMatrix.get(combinedHeaderFields);
                            
                            if(tmplstApprovalRuleMatrix != null){
                                Integer ruleCount = 0;
                                for(APTS_Approval_Rule_Matrix__c rule :tmplstApprovalRuleMatrix){
                                    
                                    if(item.APTS_Line_Item_Discount__c >=rule.APTS_Threshold_Discount__c)
                                        ruleCount++;
                                    
                                }
                                maplineItemWiseRulesCount.put(item.id,ruleCount);
                                maplineItemWithId.put(item.id,item);
                                
                            }
                        }else{
                            
                            lineItemsWithNoRule.add(combinedHeaderFieldsDetail);
                            
                        }
                        
                    }
                    system.debug('<<<< Line Items with No Rules >>>> '+ lineItemsWithNoRule.size());
                    system.debug('<<<< Line Items with No Rules >>>> '+ JSON.serialize(lineItemsWithNoRule));
                    if(lineItemsWithNoRule.size()>0){
                        System.debug('<<<< In Side No Rules >>>>');
                        
                        String WhatId = '';
                        if(lstProposal != null && !lstProposal.isEmpty())
                            whatId = lstProposal[0].id;
                        if( lstAgreement != null && !lstAgreement.isEmpty())
                            whatId = lstAgreement[0].id;
                        String summary = 'List of line items not having approval rule matrix.';
                        for(String s : lineItemsWithNoRule)
                               summary += '\r\n' + s;
                        
                        system.debug('<<<< Before Insert Task >>>> ');
                        
                        createTask(Label.APTS_NO_APPROVAL_RULE_FOR_ONE_OF_LINE_ITEM, summary, whatId);
                        
                        isAnyLineItemWithNoRule = true;
                        system.debug('<<<< Before Values Set >>>> '+ lstProposal);
                        if(lstProposal != null && !lstProposal.isEmpty()){
                            system.debug('<<<< Set No Rule Match >>>> ');
                            lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                            lstProposal[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                            lstProposal[0].APTS_GTV_Code__c  = null;
                            
                        }
                        
                        if(lstAgreement != null && !lstAgreement.isEmpty()){
                            lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                            lstAgreement[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                            lstAgreement[0].APTS_GTV_Code__c  = null;
                            
                        }
                        
                    }else{
                        system.debug('@@ maplineItemWiseRulesCount : '+ JSON.serialize(maplineItemWiseRulesCount));
                        Integer maxCount=0;
                        if(maplineItemWiseRulesCount != null && maplineItemWiseRulesCount.size() > 0){                            
                            set<Integer> setItemDiscounts = new set<Integer>();                            
                            setItemDiscounts.addAll(maplineItemWiseRulesCount.values());
                            List<Integer> lstItemDiscounts = new List<Integer>();
                            lstItemDiscounts.addAll(setItemDiscounts);
                            lstItemDiscounts.sort();
                            system.debug('<<<< lstItemDiscounts >>>>: '+ lstItemDiscounts);
                            maxCount = lstItemDiscounts[lstItemDiscounts.size()-1];
                            system.debug('@@@ maxCount : '+ maxCount);
                            Decimal maxDiscountFromAllItems = 99999;
                            String itemGTVCodeHavingMaxDisc = '';
                            system.debug('@@ maplineItemWiseRulesCount 1 : '+ JSON.serialize(maplineItemWiseRulesCount));
                            if(maxCount>0){
                                // Set max discount details and GTV Code
                                setDiscountAndGTVCode(productConfig, isProposal, maplineItemWiseRulesCount, maplineItemWithId,maxCount);
                            }else{
                                system.debug('<<<< Auto Approval Entry >>>>');
                                // Set max discount details and GTV Code
                                setDiscountAndGTVCode(productConfig, isProposal, maplineItemWiseRulesCount, maplineItemWithId,maxCount);
                                
                                // Commented by JS - there is design change inAuto Approval.                                                               
                                if(lstAgreement != null && lstAgreement.size() > 0){
                                    //markAgreementAutoApproved(lstAgreement);
                                    lstAgreement[0].APTS_Approval_Required__c = true;
                                }
                                if(lstProposal != null && lstProposal.size() > 0){
                                    //markProposalAutoApproved(lstProposal);
                                    lstProposal[0].APTS_Approval_Required__c = true;    
                                }                              
                                
                            }
                            system.debug('@@ lstProposal :'+ lstProposal);
                            if(lstProposal !=null && lstProposal.size()>0){                                
                                lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c = false;
                                lstProposal[0].APTS_Max_Approval_Levels__c = maxCount;
                            }
                            if(lstAgreement !=null && lstAgreement.size()>0){
                                lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c = false;
                                lstAgreement[0].APTS_Max_Approval_Levels__c = maxCount;
                            }
                                    
                        }else{
                        
                            if(lstProposal !=null){
                                lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                                lstProposal[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                                lstProposal[0].APTS_GTV_Code__c  = null;
                                
                            }
                            if(lstAgreement !=null){
                                lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                                lstAgreement[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                                lstAgreement[0].APTS_GTV_Code__c  = null;                                
                            }                    
                        }
                        
                        //system.debug('@@ mapProdConfigWithMaxDiscount : ' + JSON.serialize(mapProdConfigWithMaxDiscount));
                        
                        // Set Approval related fieds on Proposal - JS - 14-Nov-2015
                        if(lstProposal !=null){
                            for(Apttus_Proposal__Proposal__c proposal :lstProposal){
                                proposal.APTS_LP_MaximumSubstituteDiscount__c = mapProdConfigWithMaxDiscount.get(proposal.id).setScale(2);
                                proposal.APTS_GTV_Code__c = mapProdConfigWithGTVCode.get(proposal.id);
                                if(lstProposal[0].Apttus_Proposal__Approval_Stage__c != 'Approved'){
                                    proposal.APTS_Approval_Required__c= true;
                                    proposal.Apttus_Proposal__Approval_Stage__c = 'Draft';
                                    proposal.APTS_LP_No_Approval_Rule_Matched__c = false;
                                }else{
                                    // Commented by JS on 18-Nov-2015
                                    //proposal.APTS_Approval_Required__c= false;
                                }
                            }
                        }
                        
                        // Set Approval related fields on Agreement - JS - 14-Nov-2015
                        if(lstAgreement !=null){
                            
                            for(Apttus__APTS_Agreement__c agreement :lstAgreement){
                                agreement.APTS_LP_MaximumSubstituteDiscount__c = mapProdConfigWithMaxDiscount.get(agreement.id).setScale(2);
                                agreement.APTS_GTV_Code__c = mapProdConfigWithGTVCode.get(agreement.id);
                                system.debug('<<<< Set Final Status >>>>');
                                if(lstAgreement[0].Apttus_Approval__Approval_Status__c != 'Approved'){
                                    agreement.APTS_Approval_Required__c= true;
                                    if(!agreement.APTS_Legacy_MSPA__c){
                                        agreement.Apttus__Status__c = 'Draft';
                                    }
                                    agreement.APTS_LP_No_Approval_Rule_Matched__c = false;

                                }else{
                                    // Commented by JS on 18-Nov-2015
                                    //agreement.APTS_Approval_Required__c= false; 
                                }
                            }
                           // update lstAgreement;
                        }
                    
                    }
                    
                }else{
                    
                    if(lstProposal != null && lstProposal.size() > 0){
                        lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                        lstProposal[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                        lstProposal[0].APTS_GTV_Code__c  = null;
                    }
                    if(lstAgreement != null && lstAgreement.size() > 0){
                        lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c = true;
                        lstAgreement[0].APTS_LP_MaximumSubstituteDiscount__c = null;
                        lstAgreement[0].APTS_GTV_Code__c  = null;
                    }
                    
                    
                }
                
                if(lstProposal != null &&  lstProposal.size() > 0 && lstProposal[0].APTS_LP_No_Approval_Rule_Matched__c && isAnyLineItemWithNoRule==FALSE){
                    
                    if(isCartEmpty)
                        createTask(Label.APTS_EMPTY_CART, Label.APTS_EMPTY_CART, lstProposal[0].id);
                    else
                        createTask(Label.APTS_NO_APPROVAL_RULE_MATRIX, Label.APTS_NO_APPROVAL_RULE_MATRIX_DESCRIPTION, lstProposal[0].id);
                }
                
                if(lstAgreement != null &&  lstAgreement.size() > 0 && lstAgreement[0].APTS_LP_No_Approval_Rule_Matched__c && isAnyLineItemWithNoRule==FALSE){
                    
                    if(isCartEmpty)
                        createTask(Label.APTS_EMPTY_CART, Label.APTS_EMPTY_CART, lstAgreement[0].id);
                    else
                        createTask(Label.APTS_NO_APPROVAL_RULE_MATRIX, Label.APTS_NO_APPROVAL_RULE_MATRIX_DESCRIPTION, lstAgreement[0].id);
                }

            }
            
        }
        
        // Set Critical Discount flag = True on line Item + JS - 27-Nov-2015
        if(listCriticalDiscLineItem.size() > 0){
            update listCriticalDiscLineItem;
        }

        if(lstProposal != null && lstProposal.size() > 0){
            update lstProposal;
        }
        
        if(lstAgreement != null && lstAgreement.size() > 0){
            update lstAgreement;
        }
        
    }
    
   /**
       @ Method to re arrange the line numbers on shopping cart
       @ param: list of product configurations  
       @ Assumption: There will be only stand alone products on cart.
   **/
    public static void populateLineNumber(list<Apttus_Config2__ProductConfiguration__c > prodConfigs){
        
         integer i=0;
         list<Apttus_Config2__LineItem__c> linesWithLineNumberSequence=new list<Apttus_Config2__LineItem__c>();
         system.debug('#####lines3'+prodConfigs.size());
         
         list<Apttus_Config2__LineItem__c> configLines=[select Id,APTS_Line_Number_Custom__c,Apttus_Config2__ConfigurationId__c  from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c IN: prodConfigs LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
         system.debug('#####lines5'+configLines.size());
         
         // loop through each configuration
         for (Apttus_Config2__ProductConfiguration__c productConfig: prodConfigs) {  
            
                 system.debug('#####lines2');
            for(Apttus_Config2__LineItem__c item: configLines){
            
              if(item.Apttus_Config2__ConfigurationId__c==productConfig.Id){
                 //assign proper line number for each line item
                 item.APTS_Line_Number_Custom__c=i+1;
                 i++;
                 system.debug('#####lines'+item.Id);
                 linesWithLineNumberSequence.add(item);
              }
              
            }
         }
         
         if(!LineswithLineNumberSequence.isEmpty()){
             update linesWithLineNumberSequence;  
         }
     
  }       
    
     /*
    
    @Method to skip finalisation logic for Product Config records which belong to MSPAs created with changes from an Approved Quote.
    @param:ProductConfiguration
    */
    
    private static Set < String > getFilteredProductConfig(Map < Id, Apttus_Config2__ProductConfiguration__c > records, Map < Id, Apttus_Config2__ProductConfiguration__c > oldRecordsMap){
        Set < String > setProductConfig = new Set < String > ();
        Map <String, String> objToProductconfigMap = new Map<String,String>();
        List <Apttus__APTS_Agreement__c> toBeReset = new List<Apttus__APTS_Agreement__c>();
        Apttus__APTS_Agreement__c tmpagrmt ;
        Boolean bStatusChanged = false;
        
         
        for (Apttus_Config2__ProductConfiguration__c productConfig: records.values()) {
            
            Apttus_Config2__ProductConfiguration__c newConfig = records.get(productConfig.ID);
            Apttus_Config2__ProductConfiguration__c oldConfig = oldRecordsMap.get(productConfig.ID);
            //recalculate the approvals and set approved status only for non cloned items
         /*    string flag= ApexPages.currentPage().getParameters().get('flag');
           
            for(string param: ApexPages.currentPage().getParameters().values()){
               system.debug('param is '+param);        
            }
        */
            if((oldConfig != null && newConfig.Apttus_Config2__Status__c.equals('Finalized') && newConfig.Apttus_Config2__Status__c != oldConfig.Apttus_Config2__Status__c ))
                bStatusChanged = newConfig.Apttus_Config2__Status__c.equals('Finalized');
            //RG added exclusion rule to exclude MSPAs created from Quote with change
            
            if (bStatusChanged ){
                System.debug('change in the status of the - prod config to finalize');
                objToProductconfigMap.put((productConfig.Apttus_QPConfig__Proposald__c!=null?productConfig.Apttus_QPConfig__Proposald__c: productConfig.Apttus_CMConfig__AgreementId__c), productConfig.Id);
            }
            
        }
        
        List<Apttus_Proposal__Proposal__c> proposals = [select id,Apttus_Proposal__Approval_Stage__c,APTS_Local_Channel__c,APTS_GTV_Code__c,APTS_LP_MaximumSubstituteDiscount__c 
                from Apttus_Proposal__Proposal__c where id IN :objToProductconfigMap.keySet() LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
        
        List<Apttus__APTS_Agreement__c> agrmts = [select id,Apttus_Approval__Approval_Status__c,APTS_GTV_Code__c, APTS_Local_Channel__c, APTS_isClone__c,
                                APTS_LP_MaximumSubstituteDiscount__c, APTS_MSPA_From_Quote__c, Apttus__Status__c, Apttus_QPComply__RelatedProposalId__c 
                                from Apttus__APTS_Agreement__c where id  IN :objToProductconfigMap.keySet() LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                               
        system.debug('<<<< Proposal Size >>>>: ' + proposals.size());                       
        if(proposals!=null && proposals.size()>0){
            for (Apttus_Proposal__Proposal__c proposal: proposals){
                setProductConfig.add(objToProductconfigMap.get(proposal.Id));
            }
        }
        
        system.debug('<<<< Agreement Size >>>>: ' + agrmts.size());                       
        if(agrmts!=null && agrmts.size()>0) {
            for(Apttus__APTS_Agreement__c agrmt: agrmts){
                setProductConfig.add(objToProductconfigMap.get(agrmt.Id));
                
                system.debug('### is it included ?###'+agrmt.APTS_MSPA_From_Quote__c);
                /*
                if(agrmt.APTS_MSPA_From_Quote__c == null && !agrmt.APTS_isClone__c){
                    setProductConfig.add(objToProductconfigMap.get(agrmt.Id));
                }
                */
                if(agrmt.APTS_MSPA_From_Quote__c!=null){
                   
                    if(agrmt.APTS_MSPA_From_Quote__c.equals('Without Changes')){
                     system.debug('### inside if condition'+agrmt.APTS_MSPA_From_Quote__c);
                        tmpagrmt = new Apttus__APTS_Agreement__c (Id = agrmt.Id, Apttus__Status__c=APTS_Constants.STATUS_APPROVED_ACTION_REQ);
                    }else if(agrmt.APTS_MSPA_From_Quote__c.equals('With Changes')){
                        tmpagrmt = new Apttus__APTS_Agreement__c (Id = agrmt.Id, APTS_MSPA_From_Quote__c='');
                    system.debug('### is it included ?###'+agrmt.APTS_MSPA_From_Quote__c+';;'+agrmt.Apttus__Status__c);
                    toBeReset.add(tmpagrmt);
                   }
                }
                
                if(agrmt.APTS_isClone__c){
                    tmpagrmt = new Apttus__APTS_Agreement__c (Id = agrmt.Id, APTS_isClone__c=FALSE);
                    toBeReset.add(tmpagrmt);
                }
            }
        }
        
        if(toBeReset!=null && toBeReset.size()>0){
            update toBeReset;
        }
        
        return setProductConfig;
        
    }
    
    private static void setDiscountAndGTVCode(Apttus_Config2__ProductConfiguration__c productConfig, Boolean bProposal, map<String,Integer> maplineItemWiseRulesCount, map<String,Apttus_Config2__LineItem__c> maplineItemWithId,Decimal maxCount){
        
        Decimal maxDiscountFromAllItems = 99999;
        String itemGTVCodeHavingMaxDisc = '';
        String sCriticalLineItemId = '';
        Apttus_Config2__LineItem__c oCriticalDiscLineItem = new Apttus_Config2__LineItem__c();
        for(String key : maplineItemWiseRulesCount.keyset()){
            if(key != null){
                system.debug(' @@ key @@  : '+ key);
                Integer keyCount = (Integer)maplineItemWiseRulesCount.get(key);
                Apttus_Config2__LineItem__c keyItem = maplineItemWithId.get(key);
                system.debug(' @@ key : '+ keyItem);
                system.debug(' @@ keyCount : '+ keyCount);
                if(keyCount ==maxCount){
                    
                    
                    if(maxDiscountFromAllItems == 99999){
                        maxDiscountFromAllItems = keyItem.APTS_Line_Item_Discount__c;
                        itemGTVCodeHavingMaxDisc = keyItem.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c;
                        sCriticalLineItemId = keyItem.Id;
                    }
                    if(keyItem.APTS_Line_Item_Discount__c > maxDiscountFromAllItems){
                        maxDiscountFromAllItems = keyItem.APTS_Line_Item_Discount__c;
                        itemGTVCodeHavingMaxDisc = keyItem.Apttus_Config2__ProductId__r.APTS_Hierarchy_Level_3_Code__c;
                        sCriticalLineItemId = keyItem.Id;
                    }
                    system.debug('@@@ maxDiscountFromAllItems : '+ maxDiscountFromAllItems);
                    
                }
            }
        }
        if(bProposal){
            mapProdConfigWithMaxDiscount.put(productConfig.Apttus_QPConfig__Proposald__c,maxDiscountFromAllItems);
            mapProdConfigWithGTVCode.put(productConfig.Apttus_QPConfig__Proposald__c,itemGTVCodeHavingMaxDisc);
        }
        else{
            mapProdConfigWithMaxDiscount.put(productConfig.Apttus_CMConfig__AgreementId__c,maxDiscountFromAllItems);
            mapProdConfigWithGTVCode.put(productConfig.Apttus_CMConfig__AgreementId__c,itemGTVCodeHavingMaxDisc);
        }
        
        // Set Critical Discount LineItem flag to true
        if(!String.isEmpty(sCriticalLineItemId)){
            oCriticalDiscLineItem = maplineItemWithId.get(sCriticalLineItemId);
            oCriticalDiscLineItem.APTS_Is_Critical_Discount__c = True;
            listCriticalDiscLineItem.add(oCriticalDiscLineItem);
        }
        system.debug('<<<< Critical Line Item >>>> :'+ listCriticalDiscLineItem);
        
    }
    

    
    private static void createTask(String subject, String description, String whatId){
        
        Task t = new Task();
        t.Subject = subject;
        t.WhatId = whatId;
        t.Description = description;
        t.Status = 'Completed';
        t.Priority = 'Normal';
        t.ActivityDate = system.today();
        insert t;

    }
}
/*
@Name: APTS_EditApprovalRuleMatrixExtension
@Author: Chetan Patel
@CreateDate: 15th Oct 2015
@Description: Extension class for APTS_EditApprovalRuleMatrix VF page
              to allow users to manage approval rule matrix records 
@UsedBy: Visualforce Page - APTS_EditApprovalRuleMatrix
*/
public class APTS_EditApprovalRuleMatrixExtension {
    
    public APTS_Approval_Rule_Matrix__c oApprovalRuleMatrix {get; set;}
    public List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrix {get; set;}
    public List<APTS_Approval_Rule_Matrix__c> lstAddApprovalRuleMatrix {get; set;}
    public List<APTS_Approval_Rule_Matrix__c> lstDeleteApprovalRuleMatrix {get; set;}
    public APTS_Approval_Rule_Matrix__c deleteApprovalRuleMatrix {get; set;} 
    public List<ApprovalRuleMatrixWrapper> lstApprovalRuleMatrixWrapper {get; set;}
    public map<Decimal, List<APTS_Approval_Rule_Matrix__c>> mapApprovalRuleMatrixByDiscount {get; set;}
    public map<Decimal, List<APTS_Approval_Rule_Matrix__c>> mapApprovalRuleMatrixByRows {get; set;}
    public Integer iTotalCount {get;set;}
    public Integer iRowIndex {get;set;}
    public List<Apttus__APTS_Admin__c> lstAdmin;
    public Integer maxRowsAllowed {get; set;}   
    public List<APTS_Approval_Rule_Matrix__History> lstHistory {get; set;}
    public map<String,String> mapFieldAPIFieldLabel {get; set;}
    public boolean isCreate {get; set;}
    public boolean isEdit {get; set;}
    public boolean isSaveSuccess {get; set;}
    //public List<APTS_Approval_Rule_Matrix__c> lstDummyApprovalRuleMatrix {get; set;}
    
    public List<APTS_Approval_Rule_Matrix__c> lstActualApprovalRuleMatrix;
    public string oldCombinedField = '';
    public boolean isExisting;
    public boolean isThresholdNotValid;
    // Constants
    
    public static final String MAX_APPROVAL_LEVELS = 'APTS_MaxApprovalRuleMatrixLevels';
    public static final String ID = 'Id';
    public static final Integer THRESHOLD_DISCOUNT_DUMMY_CUTOFF = 101;
    //controller extension
    public APTS_EditApprovalRuleMatrixExtension(ApexPages.StandardController stdController) {
        
        try {
                oApprovalRuleMatrix = (APTS_Approval_Rule_Matrix__c)stdController.getRecord();
                mapApprovalRuleMatrixByRows = new map<Decimal, List<APTS_Approval_Rule_Matrix__c>>();
                lstHistory = new List<APTS_Approval_Rule_Matrix__History>();
                lstApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                //lstDummyApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                isThresholdNotValid = false;
                if(oApprovalRuleMatrix.id!=null){
                    
                    oApprovalRuleMatrix = [select id,name,APTS_LP_Local_Channel__c,APTS_Sales_Office__c,APTS_LP_Sales_Office__r.APTS_Code__c,APTS_LP_Sales_Office__c,APTS_Country__c, APTS_Max_Discount__c,APTS_Threshold_Discount__c,
                                           APTS_GTV_Level_Code__c,APTS_Sales_Organisation__c,APTS_CHF__c,APTS_Is_Active__c
                                           from APTS_Approval_Rule_Matrix__c where id=:oApprovalRuleMatrix.id LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                    oldCombinedField = oApprovalRuleMatrix.APTS_CHF__c;
                    lstActualApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c> ();
                    
                    lstActualApprovalRuleMatrix = [select id,name,APTS_Threshold_Discount__c,APTS_Assigned_to__c,APTS_Approval_Level__c, APTS_Max_Discount__c,APTS_CHF__c,APTS_Is_Active__c
                                                   , APTS_Sales_Office__c,APTS_LP_Sales_Office__r.APTS_Code__c,APTS_LP_Sales_Office__c, (select OldValue, NewValue, Parent.Id, Parent.name from Histories)
                                                   from APTS_Approval_Rule_Matrix__c where 
                                                   APTS_CHF__c=:oApprovalRuleMatrix.APTS_CHF__c
                                                   order by APTS_Threshold_Discount__c,APTS_Approval_Level__c asc LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                    
                    
                    //End
                    for(APTS_Approval_Rule_Matrix__c rule :lstActualApprovalRuleMatrix){
                        
                        if(rule.APTS_Threshold_Discount__c<THRESHOLD_DISCOUNT_DUMMY_CUTOFF)
                            lstApprovalRuleMatrix.add(rule);
                        /*
                        else
                            lstDummyApprovalRuleMatrix.add(rule);
                        */
                    }
                    
                    isEdit = true;
                    isCreate =false;
                    
                    prepareMapApprovalRuleMatrixByRows(lstApprovalRuleMatrix);   
                    
                }else{
                    
                    oApprovalRuleMatrix = new APTS_Approval_Rule_Matrix__c();
                    oApprovalRuleMatrix.APTS_Country__c = [select id,Country from User where id=:UserInfo.getUserId()].Country;
                    lstApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                    isCreate = true;
                    isEdit = false;
                    
                }
                
                isSaveSuccess = true;
                isExisting = false;
                iTotalCount = lstApprovalRuleMatrix.size();
                system.debug(' @@@ iTotalCount : '+ iTotalCount);
                lstDeleteApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
                deleteApprovalRuleMatrix = new APTS_Approval_Rule_Matrix__c();
                
                //logic for maximum no of approval rules that can be created
                
                lstAdmin = [select id,Apttus__Value__c from Apttus__APTS_Admin__c where name=:MAX_APPROVAL_LEVELS LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                if(lstAdmin.isEmpty())
                    maxRowsAllowed = 1000;     
                else
                    maxRowsAllowed = Integer.ValueOf(lstAdmin[0].Apttus__Value__c);
                
                mapFieldAPIFieldLabel = new map<String,String>();
                getFieldLabel();
                getHistory(lstApprovalRuleMatrix); 
                system.debug('@@ mapFieldAPIFieldLabel : '+ JSON.serialize(mapFieldAPIFieldLabel));
                
                
            
        }
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
        
    }

    //add row with new threshold with approvers
    public void addRow(){
        
        try {
            lstAddApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
            //lstApprovalRuleMatrix.add(new APTS_Approval_Rule_Matrix__c());
            lstAddApprovalRuleMatrix.add(new APTS_Approval_Rule_Matrix__c());
            //System.debug('@@ lstApprovalRuleMatrix :  ' + lstApprovalRuleMatrix );
            mapApprovalRuleMatrixByRows.put(mapApprovalRuleMatrixByRows.keyset().size()+1,lstAddApprovalRuleMatrix);
            rearrangeMapKey(mapApprovalRuleMatrixByRows);
        }
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
        
     }
    //delete existing row with threshold with approvers
    public void deleteRow(){
            
        try{
             iRowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('iRowNumber'));
             iRowIndex = iRowIndex+1;
             System.debug('row to be deleted ' + iRowIndex );
             system.debug('@@ mapApprovalRuleMatrixByRows : ' + mapApprovalRuleMatrixByRows.keyset());
             if(mapApprovalRuleMatrixByRows.keyset().contains(iRowIndex)){
                 
                 List<APTS_Approval_Rule_Matrix__c> lsttmp = new List<APTS_Approval_Rule_Matrix__c>();
                 lsttmp = mapApprovalRuleMatrixByRows.get(iRowIndex);
                 system.debug(' @@ lsttmp : '+ lsttmp);
                 if(lsttmp != null && lsttmp.size()>0){
                    for(APTS_Approval_Rule_Matrix__c ruleDelete : lsttmp){
                        
                        if(ruleDelete.id != null)
                            lstDeleteApprovalRuleMatrix.add(ruleDelete);
                    }
                 }
                 
                 //deleteApprovalRuleMatrix = lsttmp.remove(g);
                 system.debug('@@ lstDeleteApprovalRuleMatrix : ' + lstDeleteApprovalRuleMatrix);
                 mapApprovalRuleMatrixByRows.remove(iRowIndex);
                 rearrangeMapKey(mapApprovalRuleMatrixByRows);
             } 
             
             system.debug('@@ mapApprovalRuleMatrixByRows : ' + mapApprovalRuleMatrixByRows.keyset());
             
             getHistory(lstApprovalRuleMatrix);
        
        }catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
         
    }
    //add new approver within same threshold     
    public void addRowInner(){
        
        try {
         
             iRowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('iRowNumber'));
             iRowIndex = iRowIndex+1;
             system.debug('@@ iRowIndex : '+ iRowIndex);
             system.debug('@@ mapApprovalRuleMatrixByRows addRowInner : ' + mapApprovalRuleMatrixByRows.keyset());
             lstAddApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
             
             lstAddApprovalRuleMatrix = mapApprovalRuleMatrixByRows.get(iRowIndex);
             system.debug('@@ lstAddApprovalRuleMatrix :' + lstAddApprovalRuleMatrix);
             if(lstAddApprovalRuleMatrix != null){
                 lstAddApprovalRuleMatrix.add(new APTS_Approval_Rule_Matrix__c());
                 mapApprovalRuleMatrixByRows.put(iRowIndex,lstAddApprovalRuleMatrix);
             }
             
             rearrangeMapKey(mapApprovalRuleMatrixByRows);
        }
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
         
    }
    //delete existing approver within same threshold    
    public void deleteRowInner(){
         
        try {
            
            iRowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('iRowNumber'));
            Integer innerRowNumber = Integer.valueOf(ApexPages.currentPage().getParameters().get('innerRowNumber'));
            iRowIndex =iRowIndex+1;
            
            lstAddApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
            lstAddApprovalRuleMatrix = mapApprovalRuleMatrixByRows.get(iRowIndex);
            deleteApprovalRuleMatrix = lstAddApprovalRuleMatrix.remove(innerRowNumber);
            if(deleteApprovalRuleMatrix.id != null)
            lstDeleteApprovalRuleMatrix.add(deleteApprovalRuleMatrix);
            mapApprovalRuleMatrixByRows.put(iRowIndex,lstAddApprovalRuleMatrix);
            
            rearrangeMapKey(mapApprovalRuleMatrixByRows);
            
        }catch (Exception e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
        System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
         
     }
    //save and return to listview
    public PageReference Save(){
        try{
        if(checkWithExistingCombination()){
            isExisting = true;
            return null;
        }else if(isThresholdNotValidCheck()){
            
            isThresholdNotValid = true;
            return null;
        }else{
            saveOrAdd();
            if(isSaveSuccess){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.APTS_APPROVAL_RULE_MATRIX_SUCCESS_MSG));
                return listView(APTS_Approval_Rule_Matrix__c.sObjectType);
            }
            else{
                
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_ERROR_MSG));
                return null;
            }
            
        }
        
        }catch (Exception e) {
            isSaveSuccess = false;
            System.debug('@@ The following exception has occurred: ' + e.getMessage() + e.getLineNumber());
            return null;
        }

    }
    //save and return to the screen    
    public PageReference Add(){
        
        PageReference pageRef= null;
        try{
        if(checkWithExistingCombination()){
            isExisting = true;
            return null;
        }else if(isThresholdNotValidCheck()){
            isThresholdNotValid = true;
            return null;
        }else{
            
            saveOrAdd();
            if(isSaveSuccess){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.APTS_APPROVAL_RULE_MATRIX_SUCCESS_MSG));
                pageRef = Page.APTS_EditApprovalRuleMatrix;
                pageRef.getParameters().put(ID, oApprovalRuleMatrix.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_ERROR_MSG));
                return null;
            }
            
           
        }
        
        }catch (Exception e) {
            isSaveSuccess = false;
            System.debug('@@ The following exception has occurred: ' + e.getMessage() + e.getLineNumber());
            return null;
        }
        
    }
    
    private boolean isThresholdNotValidCheck(){
        
        boolean isThresholdNotValidtmp = false;
        if(isEdit){
        if(!mapApprovalRuleMatrixByRows.isEmpty()){
                
                for(Decimal key :mapApprovalRuleMatrixByRows.keyset()){
                    
                    List<APTS_Approval_Rule_Matrix__c> lsttmp = new List<APTS_Approval_Rule_Matrix__c>();
                    lsttmp = mapApprovalRuleMatrixByRows.get(key);
                    if(!lsttmp.isEmpty()){
                        
                        for(APTS_Approval_Rule_Matrix__c rule :lsttmp){
                            if(rule.APTS_Threshold_Discount__c>100)
                                isThresholdNotValidtmp = true;
                            
                        }
                    }
                }
        }
            
        }
        if(isCreate){
            
            if(oApprovalRuleMatrix.APTS_Threshold_Discount__c>100)
                isThresholdNotValidtmp = true;
        }
        
        system.debug('@@ isThresholdNotValidtmp :  '+ isThresholdNotValidtmp);
        return isThresholdNotValidtmp;
    }
    
    private boolean checkWithExistingCombination(){
        isExisting = false;
        oldCombinedField = oApprovalRuleMatrix.APTS_CHF__c;
        String locaChannelCode = [select id,APTS_Code__c  from APTS_Master_Picklist_Table__c where id=:oApprovalRuleMatrix.APTS_LP_Local_Channel__c].APTS_Code__c;
        String salesOfficeCode = [select id,APTS_Code__c  from APTS_Master_Picklist_Table__c where id=:oApprovalRuleMatrix.APTS_LP_Sales_Office__c].APTS_Code__c;
        string newCombinedFieldsVal = oApprovalRuleMatrix.APTS_Country__c + oApprovalRuleMatrix.APTS_Sales_Organisation__c + locaChannelCode + salesOfficeCode + oApprovalRuleMatrix.APTS_GTV_Level_Code__c;
        system.debug('@@ newCombinedFieldsVal : '+ newCombinedFieldsVal);
        system.debug('@@ oldCombinedField : '+ oldCombinedField);
        List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrixExisting = new List<APTS_Approval_Rule_Matrix__c>();
                lstApprovalRuleMatrixExisting = [select id from APTS_Approval_Rule_Matrix__c where 
                                                 APTS_CHF__c  = :newCombinedFieldsVal LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                                
        system.debug('@@ oApprovalRuleMatrix.APTS_LP_Local_Channel__c : '+ oApprovalRuleMatrix.APTS_LP_Local_Channel__c);
        system.debug('@@ lstApprovalRuleMatrixExisting size : '+ lstApprovalRuleMatrixExisting.size());
        if(lstApprovalRuleMatrixExisting!=null && lstApprovalRuleMatrixExisting.size()>0 && newCombinedFieldsVal != oldCombinedField && isEdit){
            system.debug('@@ inside create  : ');
            isExisting = true;
            
        }
        if(lstApprovalRuleMatrixExisting!=null && lstApprovalRuleMatrixExisting.size()>0 && isCreate){
            system.debug('@@ inside create  : ');
            isExisting = true;
            
        }
        
        return isExisting;
    }
    //save all updates done by user in edit screen
    public PageReference saveOrAdd(){
        
        try{
            
            String combinedHeaderFieldsVal='';
            isSaveSuccess = true;
            if(isCreate){
                
                lstApprovalRuleMatrix.add(oApprovalRuleMatrix);
                Set<APTS_Approval_Rule_Matrix__c> temp = new Set<APTS_Approval_Rule_Matrix__c>();
                temp.addAll(lstApprovalRuleMatrix);
                lstApprovalRuleMatrix.clear();
                lstApprovalRuleMatrix.addAll(temp);
                temp.clear();
                set <Id> InsertedIds = new set<Id>();
                
                system.debug('@@ lstApprovalRuleMatrix @@ before insert '+ JSON.serialize(lstApprovalRuleMatrix));
                for (Database.SaveResult result : Database.insert(lstApprovalRuleMatrix,false)) {
                    if (!result.isSuccess()) {
                        isSaveSuccess = false;
                        Database.Error error = result.getErrors().get(0);
                String failedDML = error.getMessage();
                        System.debug('@@ inserted: '+failedDML);
                    }else{
                        System.debug('@@ inserted: '+result.getId());
                        InsertedIds.add(result.getId());
                    }
                }
                system.debug('@@ InsertedIds :  '+ InsertedIds);
                combinedHeaderFieldsVal = [select id, APTS_CHF__c from APTS_Approval_Rule_Matrix__c where id IN : InsertedIds limit 1].APTS_CHF__c;
                system.debug('@@ combinedHeaderFieldsVal :'+ combinedHeaderFieldsVal);
                
                lstApprovalRuleMatrix = [select id,name,APTS_Threshold_Discount__c,APTS_Assigned_to__c,APTS_Approval_Level__c, APTS_Max_Discount__c,APTS_CHF__c,APTS_Is_Active__c,
                                        APTS_LP_Local_Channel__c,APTS_Sales_Office__c,APTS_LP_Sales_Office__r.APTS_Code__c,APTS_LP_Sales_Office__c,APTS_GTV_Level_Code__c,
                                        (select OldValue, NewValue, Parent.Id, Parent.name from Histories)
                                        from APTS_Approval_Rule_Matrix__c where 
                                        APTS_CHF__c = :combinedHeaderFieldsVal 
                                        and APTS_Threshold_Discount__c < :THRESHOLD_DISCOUNT_DUMMY_CUTOFF
                                        order by APTS_Threshold_Discount__c,APTS_Approval_Level__c asc LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
                prepareMapApprovalRuleMatrixByRows(lstApprovalRuleMatrix);
                
            }
            if(!isCreate){
                
                String RuleId='';
                for(APTS_Approval_Rule_Matrix__c rule :lstApprovalRuleMatrix){
                    
                    if(rule.id !=null)
                        RuleId = rule.id;
                        
                }
                combinedHeaderFieldsVal = [select id,APTS_CHF__c from APTS_Approval_Rule_Matrix__c where id = :RuleId limit 1].APTS_CHF__c;
                system.debug('@@ combinedHeaderFieldsVal update : '+ combinedHeaderFieldsVal);
                
            }
            /*
            lstDummyApprovalRuleMatrix = [select id,name,APTS_Threshold_Discount__c,APTS_Assigned_to__c,APTS_Approval_Level__c, APTS_Max_Discount__c,APTS_CHF__c,APTS_Is_Active__c,
                                            APTS_LP_Local_Channel__c,APTS_Sales_Office__c,APTS_LP_Sales_Office__r.APTS_Code__c,APTS_LP_Sales_Office__c,APTS_GTV_Level_Code__c
                                            ,(select OldValue, NewValue, Parent.Id, Parent.name from Histories)
                                            from APTS_Approval_Rule_Matrix__c where 
                                            APTS_CHF__c = :combinedHeaderFieldsVal 
                                            and APTS_Threshold_Discount__c > :THRESHOLD_DISCOUNT_DUMMY_CUTOFF
                                            order by APTS_Approval_Level__c asc LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
            */
            lstApprovalRuleMatrixWrapper = new List<ApprovalRuleMatrixWrapper>();
            set<Decimal> setDiscounts = new set<Decimal>();
            List<Decimal> lstDiscounts = new List<Decimal>();
            rearrangeMapKey(mapApprovalRuleMatrixByRows);
            if(!mapApprovalRuleMatrixByRows.isEmpty()){
                
                for(Decimal key :mapApprovalRuleMatrixByRows.keyset()){
                    
                    List<APTS_Approval_Rule_Matrix__c> lsttmp = new List<APTS_Approval_Rule_Matrix__c>();
                    lsttmp = mapApprovalRuleMatrixByRows.get(key);
                    if(!lsttmp.isEmpty()){
                        
                        for(APTS_Approval_Rule_Matrix__c rule :lsttmp){
                            rule.APTS_Threshold_Discount__c = lsttmp[0].APTS_Threshold_Discount__c;
                            lstDiscounts.add(rule.APTS_Threshold_Discount__c);
                            lstApprovalRuleMatrixWrapper.add(new ApprovalRuleMatrixWrapper(rule));
                        }
                    }
                }
                /*
                if(lstDummyApprovalRuleMatrix != null && lstDummyApprovalRuleMatrix.size()>0){
                    
                    for(APTS_Approval_Rule_Matrix__c rule :lstDummyApprovalRuleMatrix){
                            rule.APTS_Threshold_Discount__c = lstDummyApprovalRuleMatrix[0].APTS_Threshold_Discount__c;
                            lstDiscounts.add(rule.APTS_Threshold_Discount__c);
                            lstApprovalRuleMatrixWrapper.add(new ApprovalRuleMatrixWrapper(rule));
                        }
                }
                */
                lstApprovalRuleMatrixWrapper.sort();
                system.debug('@@ lstApprovalRuleMatrixWrapper @@ : '+ lstApprovalRuleMatrixWrapper);
                setDiscounts.addAll(lstDiscounts);
                lstDiscounts.clear();
                lstDiscounts.addAll(setDiscounts);
                lstDiscounts.add(100);
                lstDiscounts.sort();
                system.debug('@@ lstDiscounts : ' + lstDiscounts);
                lstApprovalRuleMatrix.clear();
                //lstDummyApprovalRuleMatrix.clear();
                Integer i=1, j=1;
                Decimal previousThresholdDisc = 99999;
                Decimal previousMaxDisc = 99999;
                String updatedSalesOfficeCode = [select id,APTS_Code__c from APTS_Master_Picklist_Table__c where id=:oApprovalRuleMatrix.APTS_LP_Sales_Office__c limit 1].APTS_Code__c;
                system.debug('@@ updatedSalesOfficeCode @@ : '+ updatedSalesOfficeCode);
                String lSOSalesOfficeId = getLSOfSalesOfficeId(updatedSalesOfficeCode);
                for(ApprovalRuleMatrixWrapper ruleWrapper :lstApprovalRuleMatrixWrapper){
                    
                        APTS_Approval_Rule_Matrix__c rule = ruleWrapper.ApprovalRuleMatrix;
                        
                        rule.APTS_Country__c = oApprovalRuleMatrix.APTS_Country__c;
                        rule.APTS_LP_Local_Channel__c = oApprovalRuleMatrix.APTS_LP_Local_Channel__c;
                        rule.APTS_GTV_Level_Code__c = oApprovalRuleMatrix.APTS_GTV_Level_Code__c;
                        rule.APTS_Sales_Office__c = lSOSalesOfficeId;
                        rule.APTS_LP_Sales_Office__c = oApprovalRuleMatrix.APTS_LP_Sales_Office__c;
                        rule.APTS_Sales_Organisation__c = oApprovalRuleMatrix.APTS_Sales_Organisation__c;
                        rule.APTS_GTV_Level_Code__c  = oApprovalRuleMatrix.APTS_GTV_Level_Code__c ;
                        rule.APTS_Is_Active__c  = oApprovalRuleMatrix.APTS_Is_Active__c ;
                        rule.APTS_Approval_Level__c = i++;
                        system.debug(' @@ j : '+ j);
                        system.debug(' @@ rule : '+ rule);
                        system.debug(' @@ previousThresholdDisc : '+ previousThresholdDisc);
                        if(previousThresholdDisc==99999){
                            rule.APTS_Max_Discount__c = lstDiscounts[j];
                            previousThresholdDisc = rule.APTS_Threshold_Discount__c;
                            
                            
                        }else if(rule.APTS_Threshold_Discount__c==previousThresholdDisc){
                            rule.APTS_Max_Discount__c = lstDiscounts[j];
                            
                        }else{
                            j++;
                            rule.APTS_Max_Discount__c = lstDiscounts[j];
                            previousThresholdDisc = rule.APTS_Threshold_Discount__c;
                            
                        }
                        if(rule.APTS_Threshold_Discount__c <THRESHOLD_DISCOUNT_DUMMY_CUTOFF)
                            lstApprovalRuleMatrix.add(rule);
                        /*
                        else
                            lstDummyApprovalRuleMatrix.add(rule);
                        */    
                            
                        
                }
            }
            system.debug('@@ lstApprovalRuleMatrix  :' +  JSON.serialize(lstApprovalRuleMatrix.size()));
            system.debug('@@ lstApprovalRuleMatrix size : ' +  lstApprovalRuleMatrix.size());
            /*
            Integer totalRulesForCombinedFields = lstDummyApprovalRuleMatrix.size() + lstApprovalRuleMatrix.size();
            system.debug('@@ totalRulesForCombinedFields : ' +  totalRulesForCombinedFields);
            
            if(totalRulesForCombinedFields<maxRowsAllowed){
                
                integer c=0;
                Decimal d=0;
                system.debug('@@ level : '+ lstApprovalRuleMatrix.size()+1);
                d =  totalRulesForCombinedFields+1;
                
                for(c=totalRulesForCombinedFields;c<maxRowsAllowed;c++){
                    APTS_Approval_Rule_Matrix__c cloned = lstApprovalRuleMatrix[lstApprovalRuleMatrix.size()-1].clone();
                    cloned.APTS_Threshold_Discount__c = 10000;
                    cloned.APTS_Max_Discount__c = 10000;
                    cloned.APTS_Approval_Level__c = d++;
                    lstApprovalRuleMatrix.add(cloned);
                }
                
            }
            if(totalRulesForCombinedFields>maxRowsAllowed){
                
                integer c=0,d=lstDummyApprovalRuleMatrix.size()-1;
                
                for(c=totalRulesForCombinedFields;c>maxRowsAllowed;c--){
                    
                    system.debug(' @@ lstDummyApprovalRuleMatrix level : ' + lstDummyApprovalRuleMatrix.get(d).APTS_Approval_Level__c);
                    lstDeleteApprovalRuleMatrix.add(lstDummyApprovalRuleMatrix.get(d));
                    d--;
                }
                
            }
            */
            system.debug('@@ final lstApprovalRuleMatrix : '+ JSON.serialize(lstApprovalRuleMatrix));
            Set<Id> upsertIds = new Set<Id>();
            List<APTS_Approval_Rule_Matrix__c> lstAllApprovalRuleMatrix = new List<APTS_Approval_Rule_Matrix__c>();
            lstAllApprovalRuleMatrix.addAll(lstApprovalRuleMatrix);
            //lstAllApprovalRuleMatrix.addAll(lstDummyApprovalRuleMatrix);
            
            
            for(Database.UpsertResult ur : Database.upsert(lstAllApprovalRuleMatrix,false)){
                if(ur.isSuccess()){
                    upsertIds.add(ur.getId());
                }else{
                    isSaveSuccess = false;
                }
            } 
            
            system.debug('@@ lstDeleteApprovalRuleMatrix :'+ lstDeleteApprovalRuleMatrix);
            lstDeleteApprovalRuleMatrix =  [select id from APTS_Approval_Rule_Matrix__c where id IN :lstDeleteApprovalRuleMatrix LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
            if(lstDeleteApprovalRuleMatrix != null)
                delete lstDeleteApprovalRuleMatrix;
            
            combinedHeaderFieldsVal = [select id,APTS_CHF__c from APTS_Approval_Rule_Matrix__c where id IN : upsertIds limit 1].APTS_CHF__c;
            system.debug('@@ combinedHeaderFieldsVal :'+ combinedHeaderFieldsVal);
            
            lstApprovalRuleMatrix = [select id,name,APTS_Threshold_Discount__c,APTS_Assigned_to__c,APTS_Approval_Level__c, APTS_Max_Discount__c,APTS_Is_Active__c,
                                     APTS_LP_Local_Channel__c,APTS_Sales_Office__c,APTS_LP_Sales_Office__r.APTS_Code__c,APTS_LP_Sales_Office__c,APTS_GTV_Level_Code__c    
                                     ,(select OldValue, NewValue, Parent.Id, Parent.name from Histories)
                                     from APTS_Approval_Rule_Matrix__c where 
                                     APTS_CHF__c = :combinedHeaderFieldsVal
                                     and APTS_Threshold_Discount__c < :THRESHOLD_DISCOUNT_DUMMY_CUTOFF
                                     order by APTS_Threshold_Discount__c,APTS_Approval_Level__c asc LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
            system.debug('@@ lstApprovalRuleMatrix after save :'+ JSON.serialize(lstApprovalRuleMatrix));                         
            prepareMapApprovalRuleMatrixByRows(lstApprovalRuleMatrix);
            
            isEdit = true;
            isCreate =false;
            system.debug('@@  isCreate : '+isCreate);
            system.debug('@@  isEdit : '+isEdit);
            
        }
        catch (Exception e) {
            isSaveSuccess = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage());
        }
        return null;
        
    }
    
    public static PageReference listView(Schema.sObjectType destinationSObject) {
        Schema.DescribeSObjectResult destination = destinationSObject.getDescribe();
        PageReference pageRef = new PageReference('/' + destination.getKeyPrefix());
        pageRef.setRedirect(true);
        return pageRef;
    }
    // wrapper class to implement custom sorting of List based on custom field
    public class ApprovalRuleMatrixWrapper implements Comparable {
        
        public APTS_Approval_Rule_Matrix__c ApprovalRuleMatrix { get; set; }
    
        public ApprovalRuleMatrixWrapper(APTS_Approval_Rule_Matrix__c ApprovalRuleMatrix) {
            this.ApprovalRuleMatrix = ApprovalRuleMatrix;
        }
    
        // This method returns an integer, that is the result of the comparison
        public Integer compareTo(Object compareTo) {
            Integer returnValue = 0;

            // Defining comparison object
            // ApprovalRuleMatrix          - is a first object for compare
            // compareToApprovalRuleMatrix - is a next element of the list
            ApprovalRuleMatrixWrapper compareToApprovalRuleMatrix = (ApprovalRuleMatrixWrapper)compareTo;
    
            // Now we can compare two compareToApprovalRuleMatrix objects to each other 
            // based on every sObject field
            if(ApprovalRuleMatrix.APTS_Threshold_Discount__c > compareToApprovalRuleMatrix.ApprovalRuleMatrix.APTS_Threshold_Discount__c) {
                returnValue = 1;
            }
            else {
                returnValue = -1;
            }
            
            return returnValue;

        }
    }
    
    public class ApprovalRuleMatrixWrapperByDiscount {
        
        public Decimal thresholdDiscount {get; set;}
        public Decimal maxDiscount {get; set;}
        public List<APTS_Approval_Rule_Matrix__c> lstRule { get; set; }
        public ApprovalRuleMatrixWrapperByDiscount(Decimal thresholdDiscount,Decimal maxDiscount,APTS_Approval_Rule_Matrix__c rule) {
            
            if(lstRule == null)
                lstRule = new List<APTS_Approval_Rule_Matrix__c>();
            lstRule.add(rule);
            this.thresholdDiscount = thresholdDiscount;
            this.maxDiscount = maxDiscount;
            
        }
        
    }
    
    private void getFieldLabel(){
       
        for(Schema.SObjectField fld: APTS_Approval_Rule_Matrix__c.SObjectType.getDescribe().fields.getMap().values()){
            String fieldAPI = fld.getDescribe().getName();
            String fieldLabel = fld.getDescribe().getLabel();    
            mapFieldAPIFieldLabel.put(fieldAPI,fieldLabel);
        }
        
        
    }
    
    private void getHistory(List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrix){
        
        lstHistory = [SELECT CreatedById,CreatedBy.Name, CreatedDate,OldValue, NewValue, Parent.Id, Parent.name,Field
        from APTS_Approval_Rule_Matrix__History 
        where Parent.Id IN :lstApprovalRuleMatrix
        ORDER BY CreatedDate DESC LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
        system.debug('@@ lstHistory '+ lstHistory);
        
        for(APTS_Approval_Rule_Matrix__History h :lstHistory){
            
            if(!mapFieldAPIFieldLabel.keyset().contains(h.Field))
                mapFieldAPIFieldLabel.put(h.Field,h.Field);
        }
    }
    
    public PageReference getHistoryOnComplete(){
        
        try{
            lstHistory = [SELECT CreatedById,CreatedBy.Name, CreatedDate,OldValue, NewValue, Parent.Id, Parent.name,Field
            from APTS_Approval_Rule_Matrix__History 
            where Parent.Id IN :lstApprovalRuleMatrix
            ORDER BY CreatedDate DESC LIMIT :APTS_Constants.SELECT_SOQL_LIMIT];
            
            if(lstHistory!=null){
                
                for(APTS_Approval_Rule_Matrix__History h :lstHistory){
                    
                    if(!mapFieldAPIFieldLabel.keyset().contains(h.Field))
                        mapFieldAPIFieldLabel.put(h.Field,h.Field);
                }
                
            }else{
                lstHistory = new List<APTS_Approval_Rule_Matrix__History>();
            }
            
            if(isExisting){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.APTS_CAN_NOT_CHANGE_HEADER_FIELDS));
                return null;
                
            }else if(isThresholdNotValid){
                
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Threshold discount can not be more than 100.'));
                return null;
            }else{
                
                if(isSaveSuccess)
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.APTS_APPROVAL_RULE_MATRIX_SUCCESS_MSG));
                else
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_ERROR_MSG));
                return null;
            }
        }catch (Exception e) {
            isSaveSuccess = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.APTS_APPROVAL_RULE_MATRIX_PAGE_ERROR));
            System.debug('@@ The following exception has occurred: ' + e.getMessage() + e.getLineNumber());
            return null;
        }
        
        system.debug('@@ lstHistory JSON: '+ JSON.serialize(lstHistory));
        return null;
    }
    
    private void rearrangeMapKey(map<Decimal,List<APTS_Approval_Rule_Matrix__c>> mapApprovalRuleMatrixByRowsVal){
         
         map<Decimal,List<APTS_Approval_Rule_Matrix__c>> tmpmapApprovalRuleMatrixByRows = new map<Decimal,List<APTS_Approval_Rule_Matrix__c>>();
         
         for(Decimal key : mapApprovalRuleMatrixByRowsVal.keySet()){
             
             tmpmapApprovalRuleMatrixByRows.put(key,mapApprovalRuleMatrixByRowsVal.get(key));
         }
         mapApprovalRuleMatrixByRows.clear();
         system.debug('@@ tmpmapApprovalRuleMatrixByRows '+ tmpmapApprovalRuleMatrixByRows);
         Integer q=1;
         for(Decimal key : tmpmapApprovalRuleMatrixByRows.keySet()){
             
             mapApprovalRuleMatrixByRows.put(q++,tmpmapApprovalRuleMatrixByRows.get(key));
         }
         
         
     }
     
    private void prepareMapApprovalRuleMatrixByRows(List<APTS_Approval_Rule_Matrix__c> lstApprovalRuleMatrix){
        
        mapApprovalRuleMatrixByDiscount = new map<Decimal, List<APTS_Approval_Rule_Matrix__c>>();
        
        
        for(APTS_Approval_Rule_Matrix__c rule :lstApprovalRuleMatrix) {
                
                    if(!mapApprovalRuleMatrixByDiscount.keyset().contains(rule.APTS_Threshold_Discount__c)){
                        
                        List<APTS_Approval_Rule_Matrix__c> tmplstRule  = new List<APTS_Approval_Rule_Matrix__c>();
                        tmplstRule.add(rule);
                        mapApprovalRuleMatrixByDiscount.put(rule.APTS_Threshold_Discount__c,tmplstRule);
                        
                    }else{
                        
                        List<APTS_Approval_Rule_Matrix__c> tmplstRule  = new List<APTS_Approval_Rule_Matrix__c>();
                        tmplstRule = mapApprovalRuleMatrixByDiscount.get(rule.APTS_Threshold_Discount__c);
                        tmplstRule.add(rule);
                        mapApprovalRuleMatrixByDiscount.put(rule.APTS_Threshold_Discount__c,tmplstRule);
                        
                    }
            }
            
            List<Decimal> aList = new List<Decimal>();
            aList.addAll(mapApprovalRuleMatrixByDiscount.keySet());
            aList.sort();
            mapApprovalRuleMatrixByRows.clear();
            Integer p=1;
            for(Decimal a: aList)
            {
               mapApprovalRuleMatrixByRows.put(p++,mapApprovalRuleMatrixByDiscount.get(a));
            }
    }
    
    private string getLSOfSalesOfficeId(String salesOfficeCode){
        
        List<LSO_Field_Entries__c> lstLSOFieldEntries = new List<LSO_Field_Entries__c>();
        string lSOSalesOfficeId = '';
        system.debug('@@ salesOfficeCode : '+ salesOfficeCode);
        if(salesOfficeCode != null && salesOfficeCode !=''){
            //Id lsoRecordTypeId = '';
            Id lsoRecordTypeId;
            List<RecordType> listRecordType = [Select Id, Name From RecordType  Where SobjectType = 'LSO_Field_Entries__c' AND Name = 'LSO ERP Picklist Entries'];
            if(listRecordType.size() > 0){
                lsoRecordTypeId = listRecordType[0].Id;
            }
            lstLSOFieldEntries =  [ SELECT Id, PickList_Code__c, PickList_Description__c, Country__c FROM LSO_Field_Entries__c
                                                        WHERE PickList_Code__c =: salesOfficeCode
                                                        AND RecordTypeId =: lsoRecordTypeId
                                                      ];
            if(lstLSOFieldEntries !=null && lstLSOFieldEntries.size()>0)
                lSOSalesOfficeId = lstLSOFieldEntries[0].id;
            
        }
        system.debug('@@ lstLSOFieldEntries : '+ lstLSOFieldEntries);
        system.debug('@@ lSOSalesOfficeId : '+ lSOSalesOfficeId);
        return lSOSalesOfficeId;
    }

}
/**
 * TriggerClass -  Based on the answers provided on the Channel Market Coverage, user will be automatically directed to the corresponding record type. 
 * Controller for Vf pgae - JBPRecordTypePage
 *  Release R5
 * @author  Ayiravalli Arasu (Accenture)
 * @created 2016-1-04
 * @version 1.0
 * Created
 */
public with sharing class JointBusinessPlanRecordTypeController
{
    
    public Id abbBasicAdminProfileId = NULL;
/**
 * redirect method 
 * Based on the answers provided on the Channel Market Coverage, user will be automatically directed to the corresponding record type. 
 * 
 */     
    public PageReference redirect(){
         Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
         Channel_Market_Coverage__c ChanMarkCov=[select id, Primary_Channel_Class__c, Targeted_AVP__c, Targeted_Key_Strategic__c from Channel_Market_Coverage__c 
                  where id=:ApexPages.currentPage().getParameters().get(Label.ApexClass_id) LIMIT :remLimit];
         Map<String, Schema.RecordTypeInfo> JBP_RECORD_TYPES = Schema.SObjectType.Joint_Business_Plan__c.getRecordTypeInfosByName();
         Profile[] basicProf = [ SELECT ID, Name FROM Profile WHERE Name = :system.label.ABB_Basic_Admin_Profile_Name LIMIT :remLimit];
         abbBasicAdminProfileId = (basicProf != NULL && basicProf.size() > 0) ? basicProf[0].Id : NULL; 
          
         //System.debug('-----------------'+JBP_RECORD_TYPES);
       /*  
        1  Distributor as partner 
        2   Distributor as strategic/key partner 
        3   Distributor as AVP 
        4   Technical channel as partner 
        5   Technical channel as key/strategic partner or AVP 
      */   
                 
         String JBP_DistAsPartner_RECORD_TYPE_ID = JBP_RECORD_TYPES.get(Label.JBP_RecordType_Name1).getRecordTypeId(); // JBP_RecordType_Name1 => 1. Distributor as Partner
         String JBP_DistAsStraKeyPartner_RECORD_TYPE_ID = JBP_RECORD_TYPES.get(Label.JBP_RecordType_Name2).getRecordTypeId(); // JBP_RecordType_Name2 => 2. Distributor as Strategic/Key Partner
         String JBP_DistAsAVP_RECORD_TYPE_ID = JBP_RECORD_TYPES.get(Label.JBP_RecordType_Name3).getRecordTypeId(); // JBP_RecordType_Name3 => 3. Distributor as AVP
         String JBP_TechAsPartner_RECORD_TYPE_ID = JBP_RECORD_TYPES.get(Label.JBP_RecordType_Name4).getRecordTypeId(); // JBP_RecordType_Name4 => 4. Technical Channel as Partner
         String JBP_TechKeyStraPartner_RECORD_TYPE_ID = JBP_RECORD_TYPES.get(Label.JBP_RecordType_Name5).getRecordTypeId(); // JBP_RecordType_Name5 => 5. Technical Channel as Key/Strategic Partner or AVP

         
         String strAccountId = System.currentPageReference().getParameters().get(Label.System_ID_Account);       
         Id userProfileId = Userinfo.getProfileid();
         Id currUser = UserInfo.getUserId();
         Set<ID> setAccTeamUserIds = new Set<ID>(); 
         
         if (strAccountId != NULL) { 
                
                Id accOwnerID;
                Id accID = ID.valueOf(strAccountId.trim());           
                
                Account[] accList = [ SELECT Id, OwnerID FROM Account WHERE Id =: accID LIMIT :remLimit];
                
                if (accList != NULL && accList.size() > 0) accOwnerID = accList[0].OwnerId;
                   
                for(AccountTeamMember atm : [SELECT id, UserId, AccountId, Account.OwnerID FROM AccountTeamMember where AccountId =: accID LIMIT :remLimit]){
                    setAccTeamUserIds.add(atm.userId);
                } 
                        
              
                if(accID != NULL && (setAccTeamUserIds == NULL || (setAccTeamUserIds != NULL && !setAccTeamUserIds.contains(currUser))) && currUser != accOwnerID && abbBasicAdminProfileId != userProfileId ){
                   apexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,System.label.System_CL00102));
                   return null;
                }  
         } 
         
             PageReference pReference = null;
             String strObject = System.currentPageReference().getParameters().get(Label.System_Object); // Label.System_Object => Object
             Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get(strObject); 
             pReference = new PageReference(Label.System_CL00020 + oGenericObj.getDescribe().getKeyPrefix() + Label.System_CL00112); 
             
             Map<String, String> m = pReference.getParameters();      
                if(oGenericObj != null){                
                    PageReference pEditReference = new PageReference(Label.System_CL00020 +  oGenericObj.getDescribe().getKeyPrefix() + Label.System_CL00112);  // Label.System_CL00112 =>  /e         
                    m.putAll(StaticFunctions.createLabelParameters(pEditReference, oGenericObj.newSObject()));
                    m.put(Label.System_Nooverride, Label.System_CL00114);           
                    m.put(Label.System_CL00045, ApexPages.currentPage().getParameters().get(Label.System_CL00045));         
                }
                           
                if(ChanMarkCov.Targeted_AVP__c== TRUE ){
                    if(ChanMarkCov.Primary_Channel_Class__c == Label.CMS_Primary_Channel_Class_Value){    // CMS_Primary_Channel_Class_Value => Distributor (DIS)
                        m.put(Label.Business_RecordType, JBP_DistAsAVP_RECORD_TYPE_ID);
                        pReference.setRedirect(false);
                        return pReference;
                    }else if(ChanMarkCov.Primary_Channel_Class__c != Label.CMS_Primary_Channel_Class_Value){
                        m.put(Label.Business_RecordType, JBP_TechKeyStraPartner_RECORD_TYPE_ID);
                        pReference.setRedirect(false);
                        return pReference; 
                    }else{}
                }else if(ChanMarkCov.Targeted_AVP__c== FALSE ){
                    if(ChanMarkCov.Primary_Channel_Class__c == Label.CMS_Primary_Channel_Class_Value && ChanMarkCov.Targeted_Key_Strategic__c== TRUE){
                        m.put(Label.Business_RecordType, JBP_DistAsStraKeyPartner_RECORD_TYPE_ID);
                        pReference.setRedirect(false);
                        return pReference; 
                    }else if(ChanMarkCov.Primary_Channel_Class__c == Label.CMS_Primary_Channel_Class_Value && ChanMarkCov.Targeted_Key_Strategic__c== FALSE){
                        //System.debug('---------- distributor as partner-----------');
                        m.put(Label.Business_RecordType, JBP_DistAsPartner_RECORD_TYPE_ID);  //System.debug('test');
                        pReference.setRedirect(false);
                        return pReference; 
                    }else if(ChanMarkCov.Primary_Channel_Class__c != Label.CMS_Primary_Channel_Class_Value){
                        if(ChanMarkCov.Targeted_Key_Strategic__c==TRUE){
                            m.put(Label.Business_RecordType, JBP_TechKeyStraPartner_RECORD_TYPE_ID);
                            pReference.setRedirect(false);
                            return pReference;
                        }else{
                            m.put(Label.Business_RecordType, JBP_TechAsPartner_RECORD_TYPE_ID); //Label.Business_RecordType => RecordType
                            pReference.setRedirect(false);
                            return pReference;
                        }
                    }else{}
                }else{
                    return null;
                }
            
            return null;
    }
}
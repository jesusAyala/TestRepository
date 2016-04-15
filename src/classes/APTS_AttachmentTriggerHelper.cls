/*
Description: Helper class for Attachment object
Created Date: 10-Feb-2016
*/
public class APTS_AttachmentTriggerHelper {
    
    PRIVATE STATIC STRING sREMOVABLETEXTINAGREEMENTTEMPLATENAME = 'Original_';
    public static void updateAttachmentName(List<Attachment> listAttachment){    
        
       
        
        Set<ID> setParentIds = new Set<ID>();
        
        if (listAttachment.size() > 0) {
            for(Attachment att: listAttachment){
                setParentIds.add(att.ParentId);
            }
            
            Map<Id, Apttus_Proposal__Proposal__c> mapQuotation = new Map<Id, Apttus_Proposal__Proposal__c>([select Id , Name, Apttus_Proposal__Proposal_Name__c from Apttus_Proposal__Proposal__c where Id IN:setParentIds]);   
            Map<Id, Apttus__APTS_Agreement__c> mapAgreement = new Map<Id, Apttus__APTS_Agreement__c>([select Id , Name from Apttus__APTS_Agreement__c where Id IN:setParentIds]);
            
            
            
            for(Attachment oAttachment: listAttachment){
                  Date dateToday = Date.today();
                system.debug('Attachments:' + oAttachment);                
                if(mapQuotation.get(oAttachment.ParentId)!= null ){ 
                    Apttus_Proposal__Proposal__c oQuotation = mapQuotation.get(oAttachment.ParentId);
                    //By Hypercare: 04-MAR: Assuming that the format of the generated document may not change in future,making the changes.
                     if(oAttachment.Name.contains(oQuotation.Name) && oAttachment.Name.contains('_' + dateToday.Year() + '-' + dateToday.month()) ) {
                    	String sNewName = createAttachmentName( oQuotation.Name + '_' + oQuotation.Apttus_Proposal__Proposal_Name__c, oAttachment.Name);            
                    	oAttachment.Name = sNewName;        
                     }
                }
                          
                 else if( mapAgreement.get(oAttachment.ParentId)!= null) {
                    Apttus__APTS_Agreement__c oAgreement = mapAgreement.get(oAttachment.ParentId);
                    //By Hypercare: 04-MAR: Assuming that the format of the generated document may not change in future,making the changes.
                     if(oAttachment.Name.contains(oAgreement.Name) && oAttachment.Name.contains('_' + dateToday.Year() + '-' + dateToday.month()) ) {
                    	String sAttachmentName = oAttachment.Name;
                    	sAttachmentName = sAttachmentName.replace(sREMOVABLETEXTINAGREEMENTTEMPLATENAME, ''); // Need to confirm with Jignesh
                    	String sNewName = createAttachmentName( oAgreement.Name, sAttachmentName);            
                    	oAttachment.Name = sNewName;
                     }
                }
            }
        }
    }
    
    private static String createAttachmentName( String sParentName, String sTemplateName){
        String sAttachmentName='';
        // TO DO - Logic to generate name as a <yyyymmdd>_<Quote ID>_<Quotation name>_<name of quotation template>.doc
        
        String sDate = getDate();
        String sTemplateType = getTemplateType(sTemplateName);
        if (sParentName == null || sParentName == '' ) { sParentName = 'NULL' ; } 
        sTemplateName = sTemplateName.replace(sParentName, '***');
        sTemplateName = getTemplateName(sTemplateName);
         
        sAttachmentName = sDate + '_' + sParentName + '_' + sTemplateName + sTemplateType ;
       
        return sAttachmentName;
    }
    
    private static String getDate(){
        Date dateToday = Date.today();
        String sMonth = String.valueof(dateToday.month());
        String sDay = String.valueof(dateToday.day());
        if(sMonth.length()==1){
            sMonth = '0' + sMonth;
        }
        if(sDay.length()==1){
            sDay = '0' + sDay;
        }
        String sToday = String.valueof(dateToday.year()) + sMonth + sDay ;
        return sToday;
    }
    
    private static String getTemplateName(String sOrgTemplateName){
        String sNewTemplateName = sOrgTemplateName;
        if (sOrgTemplateName != null && sOrgTemplateName != '') {
            String[] result = sOrgTemplateName.split('_\\s*');    
            if ( result.size() >= 2 ) {
                sNewTemplateName = result[1];
            }             
        } 
        else {
            sNewTemplateName = 'NULL' ; 
        }
        
        return sNewTemplateName;
    }
    
    private static String getTemplateType(String sOrgTemplateName){
        String sNewTemplateType;
        if (sOrgTemplateName != null && sOrgTemplateName != '') {
            String[] result1 = sOrgTemplateName.split('\\.');   
            if ( result1.size() >= 1 ) {
                integer iSize = result1.size();
                sNewTemplateType = '.' + result1[iSize-1];
            }             
        } 

        return sNewTemplateType;
    }
    
}
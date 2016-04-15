/**
 *      @author Anand Rajwani
 *      @date   24/02/2015
        @description    Contains the trigger functions for Lead.
        @Modification Log:        
        Anand Rajwani       24/02/2015      Original Version
        Rahul Mehta         29/12/2015      Updated Version
        Ishita Bhardwaj     14/01/2016      Updated Version
 */

public class Lead_triggerFunctions {

    public static final String FORM_HTML_START = '<HTML><BODY>';
    public static final String FORM_HTML_END = '</BODY></HTML>';

/*
   *  @author       Anand Rajwani   
   *  @description      Story# R-131: Generates pdf document when a lead is converted.
   *  @param            List<Lead>   Updated list of Leads.
   *  @param            List<Lead>   Original list of Leads.
   *  @return     Void.
   */
    
    public static void generatePDF(list<Lead> lst_NewLead, list<Lead> lst_OldLead){
        
        map<Lead, string> map_LeadContent = new map<Lead, string>();
        list<Lead> lst_Lead = new List<Lead>();
        Map<string, string> map_oppId = new map<string, string>(); //to store converted opportunity ID and lead number
        ID Rectypeid=Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Contact Center').getRecordTypeId();//Fetching Lead Record Type Id for Contact center Record Type of Lead
        system.debug('###'+Rectypeid);
        for(integer i=0; i<lst_NewLead.size(); i++){
            if(lst_NewLead.get(i).IsConverted && !lst_OldLead.get(i).IsConverted){
            System.debug('*****'+lst_NewLead.get(i).ConvertedOpportunityId);
             System.debug('*****'+Rectypeid);
                lst_Lead.add(lst_NewLead.get(i)); 
                if(lst_NewLead.get(i).RecordTypeId==Rectypeid && lst_NewLead.get(i).ConvertedOpportunityId!=null )//To check if the record type matches the contact center record type or not
                {
                 System.debug('here*****');
                map_oppId.put(lst_NewLead.get(i).ConvertedOpportunityId,lst_NewLead.get(i).Lead_Number__c);
                }
                    
            }
        }
        String pdfContent = '' + FORM_HTML_START;
        if(map_oppId.size()>0)
        {
        updateLeadNumberOnOpp(map_oppId);
        }
       
        For(Lead obj_lead: lst_Lead){
        System.debug('***##'+obj_lead.RecordTypeID);
        try
        {
            pdfContent = '' + FORM_HTML_START;
            pdfContent = pdfContent + '<H2>Lead Qualifying Information in PDF</H2>';
           pdfContent = pdfContent + '<P>' + 'Subject ' + ': ' + obj_Lead.subject__c + '</P>';
           pdfContent = pdfContent + '<P>' + 'Company ' + ': ' + obj_Lead.company + '</P>';
           pdfContent = pdfContent + '<P>' + 'Phone ' + ': ' + obj_Lead.Phone + '</P>';
           pdfContent = pdfContent + '<P>' + 'Email ' + ': ' + obj_Lead.Email + '</P>';
           pdfContent = pdfContent + '<P>' + 'Division ' + ': ' + obj_Lead.Division__c + '</P>';
           if(obj_Lead.Description!=null && obj_Lead.Description!='')
           {
           pdfContent = pdfContent + '<P>' + 'Description ' + ': ' +obj_Lead.Description__c.stripHtmlTags()+ '</P>';// To always send Description field value as Plain text irrespective of the HTML tags
           }
            else
           {pdfContent = pdfContent + '<P>' + 'Description ' + ': ' +obj_Lead.Description__c + '</P>';}   
            //Dynamically grab fields from fieldset to store in the PDF
            Schema.FieldSet fs2 = Schema.SObjectType.Lead.fieldSets.Lead_Qualification;
           
            //Append each Field to the PDF
            for(Schema.FieldSetMember fieldDef : fs2.getFields())
            {
                String name = fieldDef.getLabel();
                if(name=='Description')//To exclude description field from field set
                continue;//To exclude description field from field set
                pdfContent = pdfContent + '<P>' + name + ': ' + obj_Lead.get(fieldDef.getFieldPath()) + '</P>';
                system.debug('pdfContent -- '+ pdfContent);
            }
            pdfContent = pdfContent + FORM_HTML_END;
            map_LeadContent.put(obj_lead, pdfContent);
        }catch(Exception e)
        {
            pdfContent = '' + FORM_HTML_START;
            pdfContent = pdfContent + '<P>THERE WAS AN ERROR GENERATING PDF: ' + e.getMessage() + '</P>';
            pdfContent = pdfContent + FORM_HTML_END;
        }
        }
               
        
        attachPDF.attachPDFMethod(lst_Lead,map_LeadContent);            
        
    }
    
   /*
   *  @author       Ishita Bhardwaj
   *  @description  populates Lead number field on converted opportunity and opportunity info when lead is converted.
   *  @return       Void.
   */
    
    public static void UpdateLeadNumberOnOpp(Map<string,String> map_oppId)
    {
     
        List<Opportunity>ConvertedOpp=new List<Opportunity>(); //to store updated opportunity records
        List<Opportunity_Information__c>ConvertedOppInfo=new List<Opportunity_Information__c>(); //to store updated opportunity information records
        
        for(Opportunity opp : [select ID,Name,Lead_Number__c from Opportunity where ID in :map_oppId.keyset()])
        {
        opp.Lead_Number__c=map_oppId.get(opp.id);
        ConvertedOpp.add(opp);
        }
        update ConvertedOpp;
        for(Opportunity_Information__c oppinfo: [select Id, Lead_Number__c,Opportunity_Name_m__c from Opportunity_Information__c where Opportunity_Name_m__c in :map_oppId.keyset()])
        {
        oppinfo.Lead_Number__c=map_oppId.get(oppinfo.Opportunity_Name_m__c);
        ConvertedOppInfo.add(oppinfo);
        }
        update ConvertedOppInfo;
        
    }
}
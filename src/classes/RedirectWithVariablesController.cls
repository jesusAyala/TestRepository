/**
 *      @description    Class for the Redirect With Variables page. 
        Function: Handles the controller logic for the RedirectWithVariables page.
       
 */
public with sharing class RedirectWithVariablesController {


    /*
     *  Method name:    redirectUser
     *  @description    Redirects the user to the given object + parameters
     *  @return         PageReference The page the user needs to be redirect to.
     */
    public PageReference redirectUser(){
        try{
        //Get object name
        String strObject = System.currentPageReference().getParameters().get('object');
        
        //Allow record type selection? if set to yes, then allow RTS
        String strEnableRTS = System.currentPageReference().getParameters().get('allowRTS');
        String objectId = System.currentPageReference().getParameters().get(Label.System_ObjectId);
        String recordTypeVal = System.currentPageReference().getParameters().get(Label.Business_RecordType);
        
        //If there is an object name
        if(strObject != ''){
            
            //Create a generic object based on the name
            Schema.Sobjecttype oGenericObj = Schema.getGlobalDescribe().get(strObject);     
            String ret = ApexPages.currentPage().getParameters().get('retURL');
            
            if (ret != NULL && ret != '') {                   
                ret = ret.substring(ret.lastIndexOf('/'), ret.length());                  
            }
            //If a real object has been given
            if(oGenericObj != null){
                
                PageReference pReference = null;
                
                //Check if we have to use record type selection or not
                if(strEnableRTS != '' && strEnableRTS == 'true'){
                    
                     String entVal = (objectId != null && objectId != '') ? objectId  : +oGenericObj.getDescribe().getKeyPrefix(); 
                    
                    //If we need RTS, the URL will have to point to the recordtypeselect.jsp
                    if(oGenericObj.getDescribe().custom){
                        pReference = new PageReference('/setup/ui/recordtypeselect.jsp?ent=' +entVal+ '&save_new_url=/' + oGenericObj.getDescribe().getKeyPrefix() + '/e?retURL='+ret);                   
                    }
                    else{
                        pReference = new PageReference('/setup/ui/recordtypeselect.jsp?ent=' + strObject + '&save_new_url=/' + oGenericObj.getDescribe().getKeyPrefix() + '/e?');                   
                    }
                        
                }else{
                
                    //Else create the page reference to the edit page of this object
                    pReference = new PageReference('/' +  oGenericObj.getDescribe().getKeyPrefix() + '/e');
                }
                
                //Also get a separate reference - we always need to get the parameters based on the edit page
                PageReference pEditReference = new PageReference('/' +  oGenericObj.getDescribe().getKeyPrefix() + '/e');
                
                //Get all current parameters - this could be either edit page or the record type selection.
                Map<String, String> m = pReference.getParameters();
                //Create the parameters for the URL (translates field to ID)             
                m.putAll(StaticFunctions.createLabelParameters(pEditReference, oGenericObj.newSObject()));
                m.put('nooverride', '1');
                m.put('saveURL', ApexPages.currentPage().getParameters().get('saveURL'));                
                m.put('retURL', ApexPages.currentPage().getParameters().get('retURL'));
                
                if (recordTypeVal != NULL && recordTypeVal != '') {
                    m.put('RecordType',recordTypeVal );
                }
                
               
                pReference.setRedirect(false);    
                            
                //Return the page
                return pReference;
            }
        }
        
        }
        catch(Exception e){
           //if(e.getTypeName() == 'System.VisualforceException')
           //{ 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You do not have the required permissions, please contact your System Administrator'));             
            return null;
           //}
        }
        //Return null if someone is playing with the URL
        return null;
        
    }
}
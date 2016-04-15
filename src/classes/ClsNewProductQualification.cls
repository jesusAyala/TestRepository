/*
* Apex Page - ClsNewProductQualification 
* Description - Class written to redirect the Product Qualification page
                
* Created By - Indhu Ramalingam(Accenture)
*/
public with sharing class ClsNewProductQualification {

    private final Product_Qualification__c prdQualrec;
/*
* Constructor -  ClsNewProductQualification               
* Created By - Ayiravalli Arasu(Accenture)
*/
    public ClsNewProductQualification(ApexPages.StandardController controller) 
    {
         this.prdQualrec = (Product_Qualification__c)controller.getRecord();           
    }
/*
* Method savePQRecord             
* redirects the previous page
*/
    public PageReference savePQRecord()
    {
        try{
        Database.Upsert(prdQualrec);
        PageReference pageReference = new PageReference(System.label.Product_Qualification_URL+prdQualrec.Id);
        pageReference.setRedirect(true);
        return pageReference;
        return null;
        }
        catch (DMLException e){
                return null;
        }
    }
/*
* Method cancelPQRecord
* redirects the previous page
*/    
    public PageReference cancelPQRecord() {
        PageReference cancelPage = new PageReference(System.label.Product_Qualification_URL1);
        
        if (prdQualrec.Account__c != NULL) {
            cancelPage = new PageReference(Label.System_CL00020+prdQualrec.Account__c);
        }
        //cancelPage.setRedirect(true);
        return cancelPage;
    } 
}
/**   
* Controller : ClsProdQualificationSaveAddProducts
* Release R5
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-12-23* @version 1.0
*
*/ 
global with sharing class ClsProdQualificationSaveAddProducts{
/**
* class PISNode
*/   
    global class PISNode
    {
         public String cid;
         public String englishDescription;
         public String languageSpecificDescription;
    }
    
    private final Qualification_Products_List__c QualProduct;
    public String parentId {get;set;}
    public String returnURL {get;set;}
/**
* Constructor
*/   
    global ClsProdQualificationSaveAddProducts(ApexPages.StandardController controller) {
        String controllerName = String.valueOf(controller.getRecord().getSObjectType());        
        this.QualProduct = (Qualification_Products_List__c)controller.getRecord();                        
        returnURL = apexpages.currentpage().getparameters().get(Label.System_CL00045);     
        
        parentId = ApexPages.currentPage().getURL();
         
    }
/** 
* Method PISredir
* redirect the page after save
*/    
    public Pagereference PISredir()    
    {        
        String AccName =apexpages.currentpage().getparameters().get(Label.System_CL00122);
        String AccId = apexpages.currentpage().getparameters().get(Label.System_CL00121);        
        //String Strnewurl = '/a4B/e?CF00N20000009a3Xa='+AccName+'&CF00N20000009a3Xa_lkid='+AccId+'&retURL=/'+AccId+'&saveURL=/apex/AddProductsQualificationPIS';
        String Strnewurl = '';
        if(apexpages.currentpage().getparameters().get(Label.System_CL00124) != null)
        {
            Strnewurl = '/apex/AddProductsQualificationPIS?retURL=/'+apexpages.currentpage().getparameters().get(Label.System_CL00124);            
        }
        else
        {
            Strnewurl = '/a4B/e?CF00N20000009a3Xa='+AccName+'&CF00N20000009a3Xa_lkid='+AccId+'&retURL=/'+AccId+'&saveURL=/apex/VFProductQualSaveAddProd';
        }
        //String Strnewurl = '/a4B/e?CF00N20000009a3Xa='+AccName+'&CF00N20000009a3Xa_lkid='+AccId+'&retURL=/'+AccId+'&saveURL=/apex/VFProductQualSaveAddProd';
        PageReference pageRef = new PageReference(Strnewurl);
        return pageRef;        
    }
    
}
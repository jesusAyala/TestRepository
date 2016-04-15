public class ProductQualificationLevelRecordCount {
public Id prodId;  
public String prodName;
public Boolean isProductQualLevelExist;
    
    public ProductQualificationLevelRecordCount(ApexPages.StandardController controller) {    
        prodId = Apexpages.currentPage().getParameters().get(System.label.System_CL00018);  //System.label.System_CL00018 => id    
       // prodName = Apexpages.currentPage().getParameters().get('Name');
    }
    
    public Pagereference recordCount(){
    
        List<Product_Qualification__c> lstPrdQualHeader = [Select Id,Name from Product_Qualification__c where Id =: prodId limit 1 ];
        if(lstPrdQualHeader.size() > 0){
        prodName = lstPrdQualHeader[0].Name;
        }
        List<Product_Qualification_Level__c> lstPrdQual = [Select id from Product_Qualification_Level__c where Product_Qualification__c =: prodId limit 50000 ];
        if(lstPrdQual != null && lstPrdQual.size() >0)
        {isProductQualLevelExist = True;}else {isProductQualLevelExist = False;} 
        
        if(isProductQualLevelExist){          
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.System_CL0010_R4));     
            return null;       
        }else{
          
           Schema.DescribeSObjectResult objKeyPrefix = Product_Qualification_Level__c.SObjectType.getDescribe();
           String keyPrefix = objKeyPrefix.getKeyPrefix();          
           PageReference pageRef = new PageReference(Label.CL0001+keyPrefix+Label.CL0001+Label.System_CL0011_R4+Label.System_CL0012_R4+Label.System_CL0014_R4+prodName+Label.System_CL0016_R4+Label.System_CL0013_R4+Label.System_CL0014_R4+prodId+Label.System_CL0015_R4+prodId+Label.System_CL0017_R4+prodId);
           return pageRef;            
        } 
        
        PageReference pageRef = new PageReference(Label.CL0001 + prodId);       
        return pageRef;
    }
    
    public Pagereference GoBack(){                           
           PageReference pageRef = new PageReference(Label.CL0001+prodId); 
           return pageRef;                                           
    }

}
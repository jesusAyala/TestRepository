public class APTS_AddMoreProductsCustomController{
    
    Id ConfigId;
    Id ConfigRequestId;
    
    public pagereference GotoCatalog(){
      //configuration Id
      ConfigId=Apexpages.currentpage().getparameters().get('Id');
      //Config request Id
      ConfigRequestId=Apexpages.currentpage().getparameters().get('ConfigrequestId'); 
      
      pagereference page=new pagereference('/apex/APTS_ConfigureProductsCustom?id='+ConfigId+'&configRequestId='+ConfigRequestId+'');
     
      return page;
   }
   
 }
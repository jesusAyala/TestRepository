public class APTS_ProductConfigurationHandler {

    public void maxDiscount(Map<Id,Apttus_Config2__ProductConfiguration__c> records, Map<Id,Apttus_Config2__ProductConfiguration__c> oldRecordsMap){
        
        List<Apttus_Config2__ProductConfiguration__c> listofProductConfig = new List<Apttus_Config2__ProductConfiguration__c>();
  		
        try{
        	for(Apttus_Config2__ProductConfiguration__c productConfig : records.values()){
                    //Create an old and new map so that we can compare values
                    Apttus_Config2__ProductConfiguration__c oldConfig = oldRecordsMap.get(productConfig.ID);    
                    Apttus_Config2__ProductConfiguration__c newConfig = records.get(productConfig.ID);
                                                 
                    boolean isStatusChanged = !oldConfig.Apttus_Config2__Status__c.equals(APTS_Constants.PRODUCT_CONFIG_STATUS_FINALIZED) && 
                        					  newConfig.Apttus_Config2__Status__c.equals(APTS_Constants.PRODUCT_CONFIG_STATUS_FINALIZED);
                	
                
                    //4. put these records in a list
                    if(isStatusChanged){
                           listofProductConfig.add(productConfig);
                    }
			}
        
            if(listofProductConfig.size() > 0 ){
                
                
            }
        }
        catch(Exception e){
            System.debug('Error:\t'+e.getMessage());
        }
        
    }
    
    
}
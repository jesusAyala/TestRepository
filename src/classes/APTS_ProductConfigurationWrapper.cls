/*************************************************************
@Name: APTS_ProductConfigurationTriggerHelper
@Author: Hardik Shah
@CreateDate: 05/09/2015
@Description: Wraper Class to hold lineItema that has maximum discount and maximum discount value 
@UsedBy: APTS_ProductConfigurationHandler
******************************************************************
@ModifiedBy: NA
@ModifiedDate: NA
@ChangeDescription: 
**** PS: @ModifiedBy and @ChangeDescription can be repeated multiple time, based on number of changes made to the original process.
******************************************************************/


public class APTS_ProductConfigurationWrapper {
   // LineItem that has maximum discount
   public  Apttus_Config2__LineItem__c lineItem = null;
   // discount value
   public Decimal dcDisount ;
}
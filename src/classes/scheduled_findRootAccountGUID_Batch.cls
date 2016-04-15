/**
 * ApexClass -  scheduled_findRootAccountGUID_Batch 
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-2-8
 * @version 1.0
 * Description: As per Req #2737(KAD-00821) To find root account GUID. 
 * Created 
  */  
global class scheduled_findRootAccountGUID_Batch implements Schedulable {
/**
 * Method execute To find root account GUID.
 * Release R5
 * @author  Vasanthi (Accenture)
  */ 
   global void execute(SchedulableContext sc) {
      FindRootAccountGUID_Batch b = new FindRootAccountGUID_Batch (); 
      database.executebatch(b);
   }
}
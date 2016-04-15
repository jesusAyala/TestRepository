/*************************************************************
@Name: APTS_ProcessorControl
@Author: Ganga Vemula
@CreateDate: 28th sep 2015.
@Description: This class with the static variable that is shared by the trigger APTS_AgreementTriggerHelper
@UsedBy: 
******************************************************************/
public class APTS_ProcessorControl {
    public static boolean inFutureContext = false;
    
    //Axay - Control too many SOQL for Approval Request Trigger
    public static boolean isByPassTriggerOnDML = false;
}
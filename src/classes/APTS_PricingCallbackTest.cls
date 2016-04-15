@isTest
public class APTS_PricingCallbackTest {

    public static testMethod void testOne() {
        User usr = APTS_LP_TestUtility.getUser();
        System.runAs(usr) {
            
            Apttus_Config2.CustomClass.PricingMode mode = Apttus_Config2.CustomClass.PricingMode.ADJUSTMENT;
            
            APTS_PricingCallback callback = new APTS_PricingCallback();
            callback.setMode(mode);
            callback.finish();
        }
    }
}
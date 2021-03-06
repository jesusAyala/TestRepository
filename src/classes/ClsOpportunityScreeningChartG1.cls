/**   
    * Controller : Gate1
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public with sharing class ClsOpportunityScreeningChartG1{

    Public String gate1Per{get;set;}
    Public String gate2Per{get;set;}
    Public String willGate1{get;set;}
    Public String willGate2{get;set;}
    Public String fitGate1{get;set;}
    Public String fitGate2{get;set;}
    Public String getGate1{get;set;}
    Public String getGate2{get;set;}
    private final Opportunity_Screening__c oPSrec;

    /**   
    * Constructor : Gate1
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public clsOpportunityScreeningChartG1(ApexPages.StandardController controller) {
    
    this.oPSrec= (Opportunity_Screening__c)controller.getRecord();
    
    Opportunity_Screening__c[] oPS_G1 = [Select Id,GATE1_WILL_CategoryScore__c,GATE1_FIT_CategoryScore__c,GATE1_GET_CategoryScore__c,GATE2_WILL_CategoryScore__c,GATE2_FIT_CategoryScore__c,GATE2_GET_CategoryScore__c, GATE1_Completeness__c,GATE2_Completeness__c from Opportunity_Screening__c where Id = : oPSrec.Id limit 1];
    
    gate1Per= string.valueof(Math.round(oPS_G1[0].GATE1_Completeness__c))+Label.CL00056;
    gate2Per= Label.CL00070;
    willGate1= string.valueof(Math.round(oPS_G1[0].GATE1_WILL_CategoryScore__c));
    willGate2= string.valueof(Label.CL00070);
    fitGate1= string.valueof(Math.round(oPS_G1[0].GATE1_FIT_CategoryScore__c));
    fitGate2= string.valueof(Label.CL00070);
    getGate1= string.valueof(Math.round(oPS_G1[0].GATE1_GET_CategoryScore__c));
    getGate2= string.valueof(Label.CL00070);
    }
    
                
    /**   
    *  Barchart : getPieData() Method
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */       
    public List<PieWedgeData> getPieData() {
    Integer comptn = 0;
    Integer custRelatn = 0;
    Integer safeIsland = 0;
    Integer resce = 0;
    Integer strategy = 0;
    Integer business = 0;
    Integer project = 0;
    Integer endUser = 0;
    
     Opportunity_Screening__c[] oPS_G2 = [Select Id,GATE1_WILL_EndUserGroupScore__c,GATE1_WILL_BusinessGroupScore__c,GATE1_WILL_ProjectDevelopGroupScore__c,
                                                GATE1_FIT_ResourcesGroupScore__c,GATE1_FIT_SafeIslandGroupScore__c,GATE1_FIT_StrategyGroupScore__c,
                                                GATE1_GET_CompetitionGroupScore__c,GATE1_GET_CustomerRelationGroupScore__c 
                                                from Opportunity_Screening__c where Id = : oPSrec.Id limit 1];
                                                 
     if(oPS_G2 != null && oPS_G2.size() >0)
     {
        comptn = integer.valueof(oPS_G2[0].GATE1_GET_CompetitionGroupScore__c);
        custRelatn = integer.valueof(oPS_G2[0].GATE1_GET_CustomerRelationGroupScore__c);
        safeIsland = integer.valueof(oPS_G2[0].GATE1_FIT_SafeIslandGroupScore__c);
        resce = integer.valueof(oPS_G2[0].GATE1_FIT_ResourcesGroupScore__c);    
        strategy = integer.valueof(oPS_G2[0].GATE1_FIT_StrategyGroupScore__c);
        business = integer.valueof(oPS_G2[0].GATE1_WILL_BusinessGroupScore__c);
        project = integer.valueof(oPS_G2[0].GATE1_WILL_ProjectDevelopGroupScore__c);
        endUser = integer.valueof(oPS_G2[0].GATE1_WILL_EndUserGroupScore__c);
     }
     List<PieWedgeData> data = new List<PieWedgeData>();     
        data.add(new PieWedgeData(Label.CL00045,comptn));
        data.add(new PieWedgeData(Label.CL00046,custRelatn ));   
        data.add(new PieWedgeData(Label.CL00047,safeIsland));  
        data.add(new PieWedgeData(Label.CL00048,resce));            
        data.add(new PieWedgeData(Label.CL00050,strategy));  
        data.add(new PieWedgeData(Label.CL00051,business));      
        data.add(new PieWedgeData(Label.CL00052,project));      
        data.add(new PieWedgeData(Label.CL00053,endUser));
     return data;
    }

    /**   
    *  Barchart : PieWedgeData Wrapper Class
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public class PieWedgeData {

        public String name { get; set; }
        public Integer data { get; set; }
        public String tip{ get; set; }
        /**   
        *  Barchart : PieWedgeData Wrapper Class Constructor
        * Release R4
        *  
        * @author  MohanRaj Kasinathan (Accenture)
        * @created  2015-09-08* @version 1.0
        *
        */ 
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;            
            this.tip = string.valueof(data)+Label.CL00056;
        }
    }


}
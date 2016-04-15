/**   
* Controller : Gate2  Risk Profiling
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
public with sharing class ClsOpportunityScreeningChart{

    Public String gate1Per{get;set;}
    Public String gate2Per{get;set;}
    Public String willGate1{get;set;}
    Public String willGate2{get;set;}
    Public String fitGate1{get;set;}
    Public String fitGate2{get;set;}
    Public String getGate1{get;set;}
    Public String getGate2{get;set;}
    private final Opportunity_Screening__c oPSrec;    
    Public Decimal ordervalue{get;set;}
    Public Decimal site{get;set;}
    Public Decimal technical{get;set;}
    Public Decimal scope{get;set;}
    Public Decimal sCM{get;set;}
    Public Decimal resources{get;set;}
    Public Decimal project{get;set;}
    Public Decimal political{get;set;}
    Public Decimal security{get;set;}
    Public Decimal customer{get;set;}
    Public Decimal contract{get;set;}
    Public Decimal commercial{get;set;}    
                   
    /**   
    * Constructor : Gate2  Risk Profiling
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public clsOpportunityScreeningChart(ApexPages.StandardController controller) {
    
     this.oPSrec= (Opportunity_Screening__c)controller.getRecord();
    
     Opportunity_Screening__c[] oPS_G3 = [Select Id, RISK_Commercial__c,Risk_Contract_Agreement__c,Risk_Customer__c,Risk_Security__c,Risk_Political__c,Risk_Project__c,
                                                     Risk_Resource__c,Risk_SCM__c,Risk_Scope__c,Risk_Technical__c,Risk_Site__c,Risk_OrderValue__c from Opportunity_Screening__c where Id = : oPSrec.Id LIMIT 1];
    
    ordervalue = oPS_G3[0].Risk_OrderValue__c;    
    site = oPS_G3[0].Risk_Site__c;      
    technical = oPS_G3[0].Risk_Technical__c;      
    scope = oPS_G3[0].Risk_Scope__c;      
    sCM = oPS_G3[0].Risk_SCM__c;      
    resources = oPS_G3[0].Risk_Resource__c;  
    project = oPS_G3[0].Risk_Project__c;    
    political = oPS_G3[0].Risk_Political__c;      
    security = oPS_G3[0].Risk_Security__c;      
    customer = oPS_G3[0].Risk_Customer__c;      
    contract = oPS_G3[0].Risk_Contract_Agreement__c;      
    commercial = oPS_G3[0].RISK_Commercial__c;    
                                                     
  
    Opportunity_Screening__c[] oPS_G1 = [Select Id,GATE1_WILL_CategoryScore__c,GATE1_FIT_CategoryScore__c,GATE1_GET_CategoryScore__c,GATE2_WILL_CategoryScore__c,GATE2_FIT_CategoryScore__c,GATE2_GET_CategoryScore__c, GATE1_Completeness__c,GATE2_Completeness__c from Opportunity_Screening__c where Id = : oPSrec.Id LIMIT 1];
    
    gate1Per= string.valueof(Math.round(oPS_G1[0].GATE1_Completeness__c))+Label.CL00056;
    gate2Per= string.valueof(Math.round(oPS_G1[0].GATE2_Completeness__c))+Label.CL00056;
    willGate1= string.valueof(Math.round(oPS_G1[0].GATE1_WILL_CategoryScore__c));
    willGate2= string.valueof(Math.round(oPS_G1[0].GATE2_WILL_CategoryScore__c));
    fitGate1= string.valueof(Math.round(oPS_G1[0].GATE1_FIT_CategoryScore__c));
    fitGate2= string.valueof(Math.round(oPS_G1[0].GATE2_FIT_CategoryScore__c));
    getGate1= string.valueof(Math.round(oPS_G1[0].GATE1_GET_CategoryScore__c));
    getGate2= string.valueof(Math.round(oPS_G1[0].GATE2_GET_CategoryScore__c));

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
    try{   
        Integer compedge = 0;
        Integer comptn = 0;
        Integer custRelatn = 0;
        Integer safeIsland = 0;
        Integer resce = 0;
        Integer commercial = 0;
        Integer strategy = 0;
        Integer business = 0;
        Integer project = 0;
        Integer endUser = 0;
    
     Opportunity_Screening__c[] oPS_G2 = [Select Id,GATE2_WILL_BusinessValueGroupScore__c,GATE2_WILL_EndUserGroupScore__c,GATE2_WILL_ProjDevelopGroupScore__c,
                                                GATE2_FIT_CommercialGroupScore__c,GATE2_FIT_ResourcesGroupScore__c,GATE2_FIT_RiskGroupScore__c,
                                                GATE2_FIT_SafeIslandGroupScore__c,GATE2_FIT_StrategyGroupScore__c,
                                                GATE2_GET_CompetitionGroupScore__c,GATE2_GET_CompetitiveEdgeGroupScore__c,GATE2_GET_CustomerRelationGroupScore__c 
                                                from Opportunity_Screening__c where Id = : oPSrec.Id LIMIT 1];
     if(oPS_G2 != null && oPS_G2.size() >0)
     {
        compedge = integer.valueof(oPS_G2[0].GATE2_GET_CompetitiveEdgeGroupScore__c);
        comptn = integer.valueof(oPS_G2[0].GATE2_GET_CompetitionGroupScore__c);
        custRelatn = integer.valueof(oPS_G2[0].GATE2_GET_CustomerRelationGroupScore__c);
        safeIsland = integer.valueof(oPS_G2[0].GATE2_FIT_SafeIslandGroupScore__c);
        resce = integer.valueof(oPS_G2[0].GATE2_FIT_ResourcesGroupScore__c);
        commercial = integer.valueof(oPS_G2[0].GATE2_FIT_CommercialGroupScore__c);
        strategy = integer.valueof(oPS_G2[0].GATE2_FIT_StrategyGroupScore__c);
        business = integer.valueof(oPS_G2[0].GATE2_WILL_BusinessValueGroupScore__c);
        project = integer.valueof(oPS_G2[0].GATE2_WILL_ProjDevelopGroupScore__c);
        endUser = integer.valueof(oPS_G2[0].GATE2_WILL_EndUserGroupScore__c);
     }           
     List<PieWedgeData> data = new List<PieWedgeData>(); 
        data.add(new PieWedgeData(Label.CL00044,compedge));
        data.add(new PieWedgeData(Label.CL00045,comptn));
        data.add(new PieWedgeData(Label.CL00046,custRelatn ));   
        data.add(new PieWedgeData(Label.CL00047,safeIsland));  
        data.add(new PieWedgeData(Label.CL00048,resce));    
        data.add(new PieWedgeData(Label.CL00049,commercial));    
        data.add(new PieWedgeData(Label.CL00050,strategy));  
        data.add(new PieWedgeData(Label.CL00051,business));      
        data.add(new PieWedgeData(Label.CL00052,project));      
        data.add(new PieWedgeData(Label.CL00053,endUser));    
          
     return data;
     }
     catch(DMLException e){  return null; } 
    }

    /**   
    *  Barchart : PieWedgeData Wrapper Class
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public with sharing class PieWedgeData {

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

    /**   
    * Stacked Barchart : data - get Method.
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public Item[] data {
        get {
            return new Item[] {
                    new Item(Label.CL00057, ordervalue),                    
                    new Item(Label.CL00058,site),
                    new Item(Label.CL00059, technical),
                    new Item(Label.CL00060,scope),
                    new Item(Label.CL00061,sCM),
                    new Item(Label.CL00062,resources),
                    new Item(Label.CL00063,project), 
                    new Item(Label.CL00064,political), 
                    new Item(Label.CL00065,security),  
                    new Item(Label.CL00066,customer),    
                    new Item(Label.CL00067,contract),  
                    new Item(Label.CL00068,commercial)
                    };
                    
        }
    }

    // Vary these arrays to determine how many are stacked
    private String[] stackFields = new String[] {Label.System_CL00048, Label.System_CL00049,Label.System_CL00050};
    private String[] stackTitles = new String[] {Label.CL00072,Label.CL00073,Label.CL00073};

    public String fields {
        get {
            return String.join(stackFields, Label.CL00069);
        }
    }
    
    public String titles {
        get {
           return String.join(stackTitles, Label.CL00069);           
        }
    }

    /**   
    * Stacked Barchart : Item - Wrapper Class.
    * Release R4
    *  
    * @author  MohanRaj Kasinathan (Accenture)
    * @created  2015-09-08* @version 1.0
    *
    */ 
    public with sharing class Item {

        private String name;
        private Decimal per;
        private Integer data1;
        private Integer data2;
        private Integer data3;
        private String data;
        private String lbl;
        
        /**   
        *  Stacked Barchart : Item - Wrapper Class Constructor.
        * Release R4
        *  
        * @author  MohanRaj Kasinathan (Accenture)
        * @created  2015-09-08* @version 1.0        
        */ 
        Item(String name, Decimal per) {
            this.name = name;
            integer perval =  Math.round(per);
            
            if(perval <= 50)
            {
                data1 = perval;
                data2 = 0;
                data3 = 0; 
            }
            else if(perval > 50 && perval <= 75)
            {
                data1 = 0;
                data2 = perval;
                data3 = 0; 
            }
            else if(perval > 75)
            {
                data1 = 0;
                data2 = 0;
                data3 = perval; 
            }           
            else
            {
                data1 = 0;
                data2 = 0;
                data3 = 0;
            }
            
            lbl = Label.CL00054 +name+ Label.CL00055;
            data = string.valueof(perval)+Label.CL00056;
                 
        }
        
    }
}
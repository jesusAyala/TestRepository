/**   
* Controller : ClsCustSegmChart
* Release R5
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-12-01* @version 1.0
*
*/ 
public class ClsCustSegmChart {
    
    private Map<String,Integer> ChartMap = new Map<String,Integer>();
    public List<chartClass> data{get;set;}
    
    private Map<String, Integer>  segmentWithScoreMap = new Map<String, Integer>();
    public Item[] data1 {get;set;}
    public String stackFieldStr;
/**    
  * constructor
*/  
    public ClsCustSegmChart(ApexPages.StandardController controller) {
        
        String accID = ApexPages.CurrentPage().getPArameters().get(Label.System_CL00018); // Label.System_CL00018 => id
        Account acc = (Account)controller.getRecord();
        data = new List<chartClass>();
        data1 = new List<Item>();
        String st = Label.data_Stack_Fields; //data1,data2,data3,data4,data5,data6
        stackFieldStr = st.substring(0, st.LastIndexOf(Label.CL00069));
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        String pickVal = Label.Sys_Customer_Segmentation_PIE_Customer_Marketing_Segmentation;
        String[] valueArr = pickVal.split(Label.CL00069);
        segmentWithScoreMap = new Map<String, Integer>{valueArr[0]=>1, valueArr[1]=>2, valueArr[2]=>3, valueArr[3]=>4, valueArr[4]=>5};
        if (accID != NULL) {
              
            List<AggregateResult> lstcustseg = [SELECT Business_Line_BU__c, Marketing_Segmentation_Year__c, PIE_Customer_Marketing_Segmentation__c
                  FROM Customer_Segmentation__c WHERE Business_Line_BU__c != NULL AND Account__c = :accID and Marketing_Segmentation_Year__c != NULL AND 
                      RecordType.DeveloperName = 'Customer_Marketing_Segmentation' 
                      GROUP BY Marketing_Segmentation_Year__c, Business_Line_BU__c, PIE_Customer_Marketing_Segmentation__c LIMIT :remLimit]; 
            
            for (AggregateResult seg: lstcustseg ) {
                
                chartClass chart = new chartClass();
                chart.BUandSegmentYear =  String.valueOf(seg.get(Label.Sys_Business_Line_BU)) + Label.System_hyphen + String.valueOf(seg.get(Label.Sys_Marketing_Segmentation_Year))  ;
                chart.score = segmentWithScoreMap.containsKey(String.valueOf(seg.get(Label.Sys_PIE_Customer_Marketing_Segmentation))) ? segmentWithScoreMap.get(String.valueOf(seg.get(Label.Sys_PIE_Customer_Marketing_Segmentation))): 0;
                //data.add(chart);
                data1.add(new Item(chart.BUandSegmentYear,chart.score));
                   
            }
          
       }
         
    }
/**    
   * wrapper
 */  
    public class chartClass{  
        public Integer score {get;set;}
        public String BUandSegmentYear {get;set;}
    } 
/**    
  * Data fields
*/    
    public String fields {
        get {
            return stackFieldStr; //data1,data2,data3,data4,data5
        }
    }
 /**    
  * Titles
 */ 
    public String titles {
        get {
           return Label.Sys_Customer_Segmentation_PIE_Customer_Marketing_Segmentation;    //Not applicable, Others, Weak or not approved supplier,Supplier amongst others,Preferred Supplier       
        }
    }
    
/**
* Inner class used to display value in chart
*/
    public with sharing class Item {

        private String name;
        private Decimal per;
        private Integer data1;
        private Integer data2;
        private Integer data3;
        private Integer data4;
        private Integer data5;
        private String data;
        private String lbl;
/**
* Item values for chart
*/     
        Item(String name, Decimal per) {
            this.name = name;
            integer perval =  Math.round(per);
            
            if(perval == 1 )
            {
                data1 = perval;
                data2 = 0;
                data3 = 0; 
                data4 = 0;
                data5 = 0;
            }
            else if(perval == 2)
            {
                data1 = 0;
                data2 = perval;
                data3 = 0; 
                data4 = 0;
                data5 = 0; 
            }
            else if(perval == 3)
            {
                data1 = 0;
                data2 = 0;
                data3 = perval; 
                data4 = 0;
                data5 = 0; 
            }       
            else if(perval == 4)
            {
                data1 = 0;
                data2 = 0;
                data3 = 0; 
                data4 = perval;
                data5 = 0; 
            }
            else if(perval == 5)
            {
                data1 = 0;
                data2 = 0;
                data3 = 0; 
                data4 = 0;
                data5 = perval; 
            }           
            else
            {
                data1 = 0;
                data2 = 0;
                data3 = 0; 
                data4 = 0;
                data5 = 0;
            }
            
            lbl = name;
            data = string.valueof(perval);
                 
        }
        
    }
  
}
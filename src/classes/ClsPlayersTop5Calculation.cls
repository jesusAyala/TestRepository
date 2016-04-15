/**   
* Controller : ClsPlayers
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
public with sharing class ClsPlayersTop5Calculation {
public Decimal topValue1{get;set;}
public Decimal topValue2{get;set;}
public Decimal topValue3{get;set;}
public Decimal topValue4{get;set;}
public Decimal topValue5{get;set;}

public String topPriority1{get;set;}
public String topPriority2{get;set;}
public String topPriority3{get;set;}
public String topPriority4{get;set;}
public String topPriority5{get;set;}

public string cTid {get;set;}
/**   
* Controller : ClsPlayers - Contstructor
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
public clsPlayersTop5Calculation(ApexPages.StandardController controller) {

Capture_Team__c cP = (Capture_Team__c)controller.getRecord();
String parentId = cP.Id;
clsPlayersCalculation(parentId);
}

/**   
* Controller : ClsPlayersCalculation Method()
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
Public void clsPlayersCalculation(ID parentId)
{ 

   Try
   {  
   cTid = parentId;
   
   Map<String, Decimal> priorityMap = new Map<String, Decimal>();
   Map<String, Decimal> priorityFinalMap = new Map<String, Decimal>(); 
    
   Set<String> picklistValues = new Set<String>();
   Schema.DescribeFieldResult fieldResult =  Player__c.Value_Priority_1__c.getDescribe(); 
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
   for( Schema.PicklistEntry f : ple) 
   {       
      picklistValues.add(f.getValue()); 
      priorityMap.put(f.getValue(), 0);
   }

       
    Map<Id, Player__c> playerPriority1Map = new Map<Id, Player__c>([Select Id, Value_Priority_1__c, Power_Value__c  from  Player__c where Capture_Team__c =:cTid limit 50000]);
    Map<Id, Player__c> playerPriority2Map = new Map<Id, Player__c>([Select Id, Value_Priority_2__c, Power_Value__c  from  Player__c where Capture_Team__c =:cTid limit 50000]);
    Map<Id, Player__c> playerPriority3Map = new Map<Id, Player__c>([Select Id, Value_Priority_3__c, Power_Value__c  from  Player__c where Capture_Team__c =:cTid limit 50000]);

    for(Player__c P1: playerPriority1Map.Values())
    { 
       Decimal priority1Val = 0.5 * playerPriority1Map.get(P1.Id).Power_Value__c; 
       String pickValue = playerPriority1Map.get(P1.Id).Value_Priority_1__c;        
       Decimal masterVal =  priorityMap.get(pickValue);
       Decimal finalVal = priority1Val + masterVal;
       priorityMap.put(pickValue,finalVal);
    }
    
    for(Player__c P2: playerPriority2Map.Values())
    { 
       Decimal priority2Val = 0.35 * playerPriority2Map.get(P2.Id).Power_Value__c; 
       String pickValue = playerPriority2Map.get(P2.Id).Value_Priority_2__c;        
       Decimal masterVal =  priorityMap.get(pickValue);
       Decimal finalVal = priority2Val + masterVal;
       priorityMap.put(pickValue,finalVal);
    } 
     
    for(Player__c P3: playerPriority3Map.Values())
    { 
       Decimal priority3Val = 0.15 * playerPriority3Map.get(P3.Id).Power_Value__c; 
       String pickValue = playerPriority3Map.get(P3.Id).Value_Priority_3__c;        
       Decimal masterVal =  priorityMap.get(pickValue);
       Decimal finalVal = priority3Val + masterVal;
       priorityMap.put(pickValue,finalVal);
    }    
         
    Integer i = picklistValues.size(); 
    for(integer j =0; j< i; j++)
    {
    Decimal finalVal=0.00;
    String finalPicVal = ''; 
    for (String key : priorityMap.keySet()) {           
        
        if(!priorityFinalMap.containsKey(key))
        {  
           if(finalVal < priorityMap.get(key) )  
           {  
            finalVal = priorityMap.get(key);         
            finalPicVal = key;
           }        
        }            
    }    
    if(finalPicVal != '')
    {priorityFinalMap.put(finalPicVal,finalVal);}
    
    }  
    
    for (String key : priorityMap.keySet()) {           
        
        if(!priorityFinalMap.containsKey(key))
        { 
           priorityFinalMap.put(key,priorityMap.get(key));   
        }            
    }
     
        
     Integer m = 1;
     for (String key : priorityFinalMap.keySet()) {                   
        if(m == 1)
        { 
            topValue1 = priorityFinalMap.get(key); 
            topPriority1 = key;   
        }  
        if(m == 2)
        { 
            topValue2 = priorityFinalMap.get(key); 
            topPriority2 = key;   
        }
        if(m == 3)
        { 
            topValue3 = priorityFinalMap.get(key); 
            topPriority3 = key;   
        } 
        if(m == 4)
        { 
            topValue4 = priorityFinalMap.get(key); 
            topPriority4 = key;   
        } 
        if(m == 5)
        { 
            topValue5 = priorityFinalMap.get(key); 
            topPriority5 = key;   
        }      
        
        m++;
     }  
     
          
            
      
     }
     catch(DMLException e)
     {  
        topValue1 = 0.00;
        topValue2 = 0.00;
        topValue3 = 0.00;
        topValue4 = 0.00;
        topValue5 = 0.00;
        
        topPriority1 = '';
        topPriority2 = '';
        topPriority3 = '';
        topPriority4 = '';
        topPriority5 = '';     
     } 
      
}
/**   
* Controller : Refresh Method()
* Release R4
*  
* @author  MohanRaj Kasinathan (Accenture)
* @created  2015-09-08* @version 1.0
*
*/ 
public pagereference Refresh()
{
   try
   {
   PageReference palyerCal = Page.PlayersTop5Calculation;
   palyerCal.getParameters().put( Label.System_CL00080, cTid);
   palyerCal.setRedirect(true);
   return palyerCal;
   }
   catch(DMLException e){  return null; }
}

}
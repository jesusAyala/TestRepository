/**   
* Class - ClsChannelQualificationEvaluation
* Controller for VF Page - ChannelQualificationEvaluation 
* Taking the values from Channel Qualification table and show the values in Stacked bar chart. This will be displayed in channel pre qualification page layout.
* Release R5
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-11-26
* @version 1.0
*
* - Created
*/
public with sharing class ClsChannelQualificationEvaluation{

    private final Channel_Qualifications__c channelQual;
    private Decimal generalValue = 0;
    private Decimal marketValue = 0;
    private Decimal portfolioValue = 0;
    private Decimal orgSkillValue = 0;
    private Decimal attitudevalue = 0;
    private Decimal businessValue = 0;
    
/**   
* Constructor - ClsChannelQualificationEvaluation
*/
public ClsChannelQualificationEvaluation(ApexPages.StandardController controller) {   
    this.channelQual= (Channel_Qualifications__c)controller.getRecord();   
    Channel_Qualifications__c[] channelQualScore = [Select Id, Name,General_Score__c,Market_Score__c,Portfolio_Score__c,
                                    Organization_Score__c,Business_Score__c,Attitude_Score__c     
                                    from Channel_Qualifications__c where Id = : channelQual.Id limit 1];        
    if(channelQualScore != null && channelQualScore.size() >0){
        generalValue = (Decimal)channelQualScore[0].General_Score__c;
        marketValue =  (Decimal)channelQualScore[0].Market_Score__c;
        portfolioValue = (Decimal)channelQualScore[0].Portfolio_Score__c;
        orgSkillValue =  (Decimal)channelQualScore[0].Organization_Score__c;    
        attitudevalue =  (Decimal)channelQualScore[0].Attitude_Score__c;
        businessValue =  (Decimal)channelQualScore[0].Business_Score__c;       
    }   
}

public Item[] data {
    get {
        return new Item[] {            
            new Item(Label.Channel_Qualification_Business_Target,businessValue),  //Label.Channel_Qualification_Business_Target => Business [Target 4.00]
            new Item(Label.Channel_Qualification_Attitude_Target,attitudevalue),   //Label.Channel_Qualification_Attitude_Target => Attitude [Target 4.50]                            
            new Item(Label.Channel_Qualification_Org_Skill_Target,orgSkillValue),  //Label.Channel_Qualification_Org_Skill_Target => Organization Skill [Target 4.00]
            new Item(Label.Channel_Qualification_Portfolio_Target, portfolioValue), //Label.Channel_Qualification_Portfolio_Target => Portfolio [Target 4.00]
            new Item(Label.Channel_Qualification_Market_Target,marketValue), //Label.Channel_Qualification_Market_Target => Market [Target 4.00]
            new Item(Label.Channel_Qualification_General_Target, generalValue) //Label.Channel_Qualification_General_Target => General [Target 4.50]
        };        
    }
}   

// Vary these arrays to determine how many are stacked
/*
Label.Channel_Qualification_Data1 => data1, Label.Channel_Qualification_Data2 => data2,Label.Channel_Qualification_Data3 => data3
//Label.Channel_Qualification_Label1 => Label1, Label.Channel_Qualification_Label2 =>Label2, Label.Channel_Qualification_Label3 => Label3
*/
private String[] stackFields = new String[] {Label.Channel_Qualification_Data1,Label.Channel_Qualification_Data2,Label.Channel_Qualification_Data3};  
private String[] stackTitles = new String[] {Label.Channel_Qualification_Label1,Label.Channel_Qualification_Label2,Label.Channel_Qualification_Label3};

public String fields {
    get {
        return String.join(stackFields,Label.CL00069);
    }
}

public String titles {
    get {
        return String.join(stackTitles,Label.CL00069);           
    }
}

/**   
* Stacked Barchart : Item - Wrapper Class.
* Release R4
*  
* @author  Abiramasundari Radha (Accenture)
*
*/ 
public with sharing class Item {
    private String name;
    private Decimal per;
    private Decimal data1;
    private Decimal data2;
    private Decimal data3;
    private String data;
    private String lbl;
    /**   
    *  Stacked Barchart : Item - Wrapper Class Constructor.
    * Release R4
    *  
    * @author  Abiramasundari Radha (Accenture)       
    */ 
    Item(String name, Decimal per) {
        this.name = name;                
        decimal perval =  per.setScale(2, RoundingMode.HALF_UP);
        
        if(perval > 4){
            data1 = perval ;
            data2 = 0;
            data3 = 0;
        }            
        else if(perval == 4){
            data1 = 0;
            data2 = perval;
            data3 = 0;
        }            
        else if(perval < 4){
            data1 = 0;
            data2 = 0;
            data3 = perval ;
        }
        else{
            data1 = 0;
            data2 = 0;
            data3 = 0;
        }
        
        String strname ='';
        if(name.contains(Label.Channel_Qualification_Target4))
        {
        strname = name.replace(Label.Channel_Qualification_Target4,'');
        }
        else
        {
        strname = name.replace(Label.Channel_Qualification_Target4_5,''); 
        }
        lbl = strname;
        data = string.valueof(perval);
    }
  }
}
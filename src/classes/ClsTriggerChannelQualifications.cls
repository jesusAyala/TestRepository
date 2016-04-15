/**   
* TriggerClass - ChannelQualifications
* Macro - From the value of Weight and Answer calculate the result and update in the score fields.       
* Release R5
*  
* @author  Abiramasundari Radha (Accenture)
* @created 2015-11-30
* @version 1.0
*
* - Created
*/
public without sharing class ClsTriggerChannelQualifications extends ClsTriggerVirtual {

    public Static Set<Id> processedIdSet = new Set<Id>();
    
/**   
* Constructor 
*/    
    public ClsTriggerChannelQualifications () {
    }
/**   
* @see bulkAfter
*/    
    public override void bulkAfter(ClsWrappers.TriggerContext trgCtx) {
        
        if (trgCtx.isInsert || trgCtx.isUpdate) {
            updateChannelQual(trgCtx);
        }        
    }
 /**   
* @ see bulkBefore
*/   
    public override void bulkBefore(ClsWrappers.TriggerContext trgCtx) {
     
        Set<Id> setAccountId = new Set<Id>();
        Set<Id> setChanMarScopeId = new Set<Id>();
        Map<Id, Account> mapAccount = new Map<Id,Account>();
        Map<Id,Channel_Market_Coverage__c> mapChanMarScope = new Map<Id,Channel_Market_Coverage__c>();   
        Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
        
        if(trgCtx.isInsert || trgCtx.isUpdate){
            for (SObject sobj: trgCtx.newList) {
                Channel_Qualifications__c CQ = (Channel_Qualifications__c)sobj;
                if(CQ.Account__c != NULL){
                    setAccountId.add(CQ.Account__c);
                }
                if(CQ.Channel_Market_Coverage__c != NULL){
                    setChanMarScopeId.add(CQ.Channel_Market_Coverage__c);
                }           
            }
            
            mapAccount = new Map<Id,Account>([SELECT Id, Company_Description__c FROM Account where Id IN :setAccountId LIMIT :remLimit]);
            mapChanMarScope = new Map<Id,Channel_Market_Coverage__c>([SELECT Id, Division__c, Customer_Base__c, Focussed_Industry1__c, Product_Line1__c FROM Channel_Market_Coverage__c
                                                                      WHERE Id IN :setChanMarScopeId LIMIT :remLimit]);
            
            if(setChanMarScopeId.size() > 0 || setAccountId.size() > 0) {
               for (SObject sobj: trgCtx.newList) {
                    Channel_Qualifications__c CQ = (Channel_Qualifications__c)sobj;
                    CQ.Company_Description__c = mapAccount.containskey(CQ.Account__c) ? mapAccount.get(CQ.Account__c).Company_Description__c : CQ.Company_Description__c;
                    if (mapChanMarScope.containskey(CQ.Channel_Market_Coverage__c)){
                        CQ.Customer_Base__c = mapChanMarScope.get(CQ.Channel_Market_Coverage__c).Customer_Base__c;
                        CQ.Industries_focused__c = mapChanMarScope.get(CQ.Channel_Market_Coverage__c).Focussed_Industry1__c;
                        CQ.ABB_Product_Lines_discussed__c = mapChanMarScope.get(CQ.Channel_Market_Coverage__c).Product_Line1__c;
                        CQ.Division__c = mapChanMarScope.get(CQ.Channel_Market_Coverage__c).Division__c;
                    }
                }
            }
        }
    }
 /**   
* Method updateChannelQual
* Get the answer for Score values
*/    
    public void updateChannelQual(ClsWrappers.TriggerContext trgCtx) {
        
        List<Channel_Qualifications__c> channelList = new List<Channel_Qualifications__c>();
        List<Channel_Qualifications__c> toBeUpdatedchannelList = new List<Channel_Qualifications__c>();
        
        for (sobject sObj : trgCtx.newList) {                                                                      
            
            Channel_Qualifications__c channelQual = (Channel_Qualifications__c)sObj;
            Channel_Qualifications__c oldChannel = (trgCtx.isUpdate) ? (Channel_Qualifications__c) trgCtx.oldMap.get(channelQual.Id) : NULL;
            
           if (trgCtx.isInsert || (trgCtx.isUpdate && (oldChannel.General_Answer_1__c != channelQual.General_Answer_1__c || 
                            oldChannel.General_Answer_2__c != channelQual.General_Answer_2__c || 
                            oldChannel.General_Answer_3__c != channelQual.General_Answer_3__c || oldChannel.Market_Answer_1__c != channelQual.Market_Answer_1__c ||                        
                            oldChannel.Market_Answer_2__c != channelQual.Market_Answer_2__c || oldChannel.Portfolio_Answer_1__c != channelQual.Portfolio_Answer_1__c ||  
                            oldChannel.Portfolio_Answer_2__c != channelQual.Portfolio_Answer_2__c ||   
                            oldChannel.Portfolio_Answer_3__c != channelQual.Portfolio_Answer_3__c ||                     
                            oldChannel.Portfolio_Answer_4__c != channelQual.Portfolio_Answer_4__c || oldChannel.Organization_Answer_1__c != channelQual.Organization_Answer_1__c ||  
                            oldChannel.Organization_Answer_2__c != channelQual.Organization_Answer_2__c ||   
                            oldChannel.Organization_Answer_3__c != channelQual.Organization_Answer_3__c || 
                            oldChannel.Organization_Answer_4__c != channelQual.Organization_Answer_4__c ||  
                            oldChannel.Organization_Answer_5__c != channelQual.Organization_Answer_5__c ||  
                            oldChannel.Organization_Answer_6__c != channelQual.Organization_Answer_6__c ||  
                            oldChannel.Organization_Answer_7__c != channelQual.Organization_Answer_7__c ||  
                            oldChannel.Organization_Answer_8__c != channelQual.Organization_Answer_8__c ||  
                            oldChannel.Organization_Answer_9__c != channelQual.Organization_Answer_9__c ||  
                            oldChannel.Organization_Answer_10__c != channelQual.Organization_Answer_10__c ||                      
                            oldChannel.Organization_Answer_11__c != channelQual.Organization_Answer_11__c || oldChannel.Attitude_Answer_1__c != channelQual.Attitude_Answer_1__c ||                        
                            oldChannel.Attitude_Answer_2__c != channelQual.Attitude_Answer_2__c || oldChannel.BP_Answer_1__c != channelQual.BP_Answer_1__c || 
                            oldChannel.BP_Answer_2__c != channelQual.BP_Answer_2__c || oldChannel.BP_Answer_3__c != channelQual.BP_Answer_3__c ||                    
                            oldChannel.BP_Answer_4__c != channelQual.BP_Answer_4__c))) {
                 
                if (!processedIdSet.contains(channelQual.Id)) {        // To avoid recursive trigger issue   
                    channelList.add(channelQual);
                }
           }
        }   
        
        if (channelList.size() > 0) {
        
            for (Channel_Qualifications__c channel: channelList) {
                
                processedIdSet.add(channel.Id);
                
                Channel_Qualifications__c updateChannel = new Channel_Qualifications__c( Id = channel.Id);
                
               updateChannel.General_Score__c = calculateScore(channel.General_Value_1__c, channel.General_Value_2__c, channel.General_Value_3__c, '', '', '', '', '', '', '', '', channel.General_Answer_1__c,
                   channel.General_Answer_2__c, channel.General_Answer_3__c,'' , '', '', '', '', '', '', '',3 ) ;
                
               updateChannel.Market_Score__c = calculateScore(channel.Market_Value_1__c, channel.Market_Value_2__c, '', '', '', '', '', '', '', '', '', channel.Market_Answer_1__c,
                   channel.Market_Answer_2__c, '', '', '', '', '', '', '', '', '', 2 ) ;
                
               updateChannel.Portfolio_Score__c = calculateScore(channel.Portfolio_Value_1__c, channel.Portfolio_Value_2__c, channel.Portfolio_Value_3__c, channel.Portfolio_Value_4__c, '', '', '', '', '', '', '', channel.Portfolio_Answer_1__c,
                   channel.Portfolio_Answer_2__c, channel.Portfolio_Answer_3__c, channel.Portfolio_Answer_4__c, '', '', '', '', '', '', '',4 ) ;
                
              // commented- updateChannel.Organization_Score__c = calculateScore(channel.Organization_Value_1__c, channel.Organization_Value_2__c, channel.Organization_Value_3__c, channel.Organization_Value_4__c,channel.Organization_Value_5__c, channel.Organization_Value_6__c, channel.Organization_Value_7__c, channel.Organization_Value_8__c, channel.Organization_Value_9__c, channel.Organization_Value_10__c, channel.Organization_Value_11__c, channel.Organization_Answer_1__c,
                   //channel.Organization_Answer_2__c, channel.Organization_Answer_3__c, channel.Organization_Answer_4__c, channel.Organization_Answer_5__c, channel.Organization_Answer_6__c, channel.Organization_Answer_7__c, channel.Organization_Answer_8__c, channel.Organization_Answer_9__c, channel.Organization_Answer_10__c, channel.Organization_Answer_11__c, 11 ) ;
                
                updateChannel.Organization_Score__c = methodOrganizationScore(channel);
               updateChannel.Attitude_Score__c = calculateScore(channel.Attitude_Value_1__c, channel.Attitude_Value_2__c, '', '', '', '', '', '', '', '', '', channel.Attitude_Answer_1__c,
                   channel.Attitude_Answer_2__c, '', '', '', '', '', '', '', '', '', 2 ) ;
                
               updateChannel.Business_Score__c = calculateScore(channel.BP_Value_1__c, channel.BP_Value_2__c, channel.BP_Value_3__c, channel.BP_Value_4__c, '', '', '', '', '', '', '', channel.BP_Answer_1__c,
                   channel.BP_Answer_2__c, channel.BP_Answer_3__c, channel.BP_Answer_4__c, '', '', '', '', '', '', '',4 ) ;
                   
                toBeUpdatedchannelList.add(updateChannel);
            }
        }
        
        try {        
                  
             Database.update(toBeUpdatedchannelList);
        } Catch (DMLException e) {
            
            String error = '';
            Integer pos = 0;
            
            for (Integer i = 0; i < e.getNumDML(); i++) {
                error += e.getDMLMessage(i) + Label.Line_Break;
            }
            
            for (Channel_Qualifications__c channel : toBeUpdatedchannelList) {
                
                channelList[pos].addError(error, FALSE);
                pos++;
            }
        }
    }
/**
* Method calculateScore
* calculate the values
*/    
    public Decimal calculateScore( String val1, String val2, String val3, String val4, String val5,String val6,String val7,String val8,String val9,String val10,String val11,
        String answer1, String answer2, String answer3, String answer4, String answer5, String answer6, String answer7, String answer8, String answer9, String answer10, String answer11, Decimal totalValues) {
                        
        Decimal generalVal =  (val1 == Label.Business_Must_Have) ? 6 : ( isNumber(val1) ? Integer.valueOf(val1) : 0);
        Decimal generalVal2 = (val1 != NULL && isNumber(answer1)) ? generalVal * Integer.ValueOf(answer1) : 0; 
        Decimal generalVal3 = (generalVal == 6) ? 1 : 0;
        Decimal generalVal4  = ((generalVal3 * generalVal2) > 23) ? 1 : 0;
        Decimal generalVal5 =  (generalVal3 == 1) ? generalVal4 * generalVal2 : generalVal2; //T =IF(R19=1,S19*Q19,Q19)
        Decimal generalVal6 =  (generalVal3 == generalVal4) ? 1 : 0; //Formula 6 => U =IF(R19=S19,1,0) END OF ROW 1 
        
       
        Decimal generalVal7 =  (val2 == Label.Business_Must_Have) ? 6 : ( isNumber(val2) ? Integer.valueOf(val2) : 0); // START OF ROW 2 Formula 1 => P =IF(L19="Must Have", 6, L19)
        Decimal generalVal8 = (val2 != NULL && isNumber(answer2)) ? generalVal7 * Integer.ValueOf(answer2) : 0; // Formula 2 => Q =P19*B19
        Decimal generalVal9 = (generalVal7 == 6) ? 1 : 0; //Formula 3 => R =IF(P19=6,1,0)
        Decimal generalVal10  = ((generalVal9 * generalVal8) > 23) ? 1 : 0;
        Decimal generalVal11 =  (generalVal9 == 1) ? generalVal10 * generalVal8 : generalVal8; //T =IF(R19=1,S19*Q19,Q19)
        Decimal generalVal12 =  (generalVal9 == generalVal10) ? 1 : 0; //Formula 6 => U =IF(R19=S19,1,0) END OF ROW 2
       
        Decimal gVal1 =  (val3 == Label.Business_Must_Have) ? 6 : ( isNumber(val3) ? Integer.valueOf(val3) : 0); // START OF ROW 3 Formula 1 => P =IF(L19="Must Have", 6, L19)
        Decimal gVal2 = (val3 != NULL && isNumber(answer3)) ? gVal1 * Integer.ValueOf(answer3) : 0; // Formula 2 => Q =P19*B19
        Decimal gVal3 = (gVal1 == 6) ? 1 : 0; //Formula 3 => R =IF(P19=6,1,0)
        Decimal gVal4  = ( (gVal3 * gVal2) > 23) ? 1 : 0;
        Decimal gVal5 =  (gVal3 == 1) ? gVal4 * gVal2 : gVal2; //T =IF(R19=1,S19*Q19,Q19)
        Decimal gVal6 =  (gVal3 == gVal4) ? 1 : 0; //Formula 6 => U =IF(R19=S19,1,0) END OF ROW 3       
        
     
        Decimal gVal11 =  (val4 == Label.Business_Must_Have) ? 6 : ( isNumber(val4) ? Integer.valueOf(val4) : 0); // START OF ROW 3 Formula 1 => P =IF(L19="Must Have", 6, L19)
        Decimal gVal12 = (val4 != NULL && isNumber(answer4)) ? gVal11 * Integer.ValueOf(answer4) : 0; // Formula 2 => Q =P19*B19
        Decimal gVal13 = (gVal11 == 6) ? 1 : 0; //Formula 3 => R =IF(P19=6,1,0)
        Decimal gVal14  = ( (gVal13 * gVal12) > 23) ? 1 : 0;
        Decimal gVal15 =  (gVal13 == 1) ? gVal14 * gVal12 : gVal12; //T =IF(R19=1,S19*Q19,Q19)
        Decimal gVal16 =  (gVal13 == gVal14) ? 1 : 0; //Formula 6 => U =IF(R19=S19,1,0) END OF ROW 4        
        
      
        Decimal Score = 0;
        
        if ( (generalVal + generalVal7)  > 0) {
            Score= ( (( generalVal5 + generalVal11) / ( generalVal + generalVal7 )) * ( generalVal6 * generalVal12 ));
        }
        if (totalValues == 3 && (generalVal + generalVal7 + gVal1) > 0) {
            Score = ( (( generalVal5 + generalVal11 + gVal5) / ( generalVal + generalVal7 + gVal1)) * ( generalVal6 * generalVal12 * gVal6 ));
        }
        
        if (totalValues == 4 && ( generalVal + generalVal7 + gVal1 + gVal11 ) > 0) {
            Score = ( (( generalVal5 + generalVal11 + gVal5 + gVal15 ) / ( generalVal + generalVal7 + gVal1 + gVal11 )) * ( generalVal6 * generalVal12 * gVal6 * gVal16));
        }     
        //system.debug('::score::'+score);
        return score;
    }
/**
* Boolean Method
* Set the value for bollean variable
*/ 
    public Boolean isNumber(String val) {
        
        Boolean returnVal = FALSE;
        try {            
            if (val != NULL && val != '') {
                Integer num = Integer.valueOf(val);
                returnVal = TRUE;
            }
            
        } Catch(TypeException e) {   }
        return returnVal;
    }
/**
* Calculate the method for Organization score
*/    
    public Decimal methodOrganizationScore(Channel_Qualifications__c channelIds){    
            MAP <ID,Channel_Qualifications__c> mapNewChannelQual = new Map <ID,Channel_Qualifications__c>();
            Map<Id, List<Channel_Qualifications__c>> mapChannelQual6 = new Map<Id, List<Channel_Qualifications__c>>();       
            Decimal organizationValue1 = 0.0; 
            Decimal organizationValue2 = 0.0; 
            Decimal organizationValue3 = 0.0; 
            Decimal organizationValue4 = 0.0; 
            Decimal organizationValue5 = 0.0; 
            Decimal organizationValue6 = 0.0; 
            Decimal organizationValue7 = 0.0; 
            Decimal organizationValue8 = 0.0; 
            Decimal organizationValue9 = 0.0;
            Decimal organizationValue10 = 0.0; 
            Decimal organizationValue11 = 0.0; 
            Decimal organizationValue12 = 0.0; 
            Decimal organizationValue13 = 0.0; 
            Decimal organizationValue14 = 0.0; 
            Decimal organizationValue15 = 0.0; 
            Decimal organizationValue16 = 0.0; 
            Decimal organizationValue17 = 0.0; 
            Decimal organizationValue18 = 0.0; 
            Decimal organizationValue19 = 0.0; 
            Decimal organizationValue20 = 0.0; 
            Decimal organizationValue21 = 0.0; 
            Decimal organizationValue22 = 0.0; 
            Decimal organizationValue23 = 0.0; 
            Decimal organizationValue24 = 0.0; 
            Decimal organizationValue25 = 0.0;  
            Decimal organizationValue26 = 0.0; 
            Decimal organizationValue27 = 0.0; 
            Decimal organizationValue28 = 0.0; 
            Decimal organizationValue29 = 0.0; 
            Decimal organizationValue30 = 0.0; 
            Decimal organizationValue31 = 0.0;        
            Decimal organizationValue32 = 0.0; 
            Decimal organizationValue33 = 0.0; 
            Decimal organizationValue34 = 0.0; 
            Decimal organizationValue35 = 0.0; 
            Decimal organizationValue36 = 0.0; 
            Decimal organizationValue37 = 0.0; 
            Decimal organizationValue38 = 0.0; 
            Decimal organizationValue39 = 0.0; 
            Decimal organizationValue40 = 0.0; 
            Decimal organizationValue41 = 0.0; 
            Decimal organizationValue42 = 0.0; 
            Decimal organizationValue43 = 0.0;
            Decimal organizationValue44 = 0.0; 
            Decimal organizationValue45 = 0.0; 
            Decimal organizationValue46 = 0.0; 
            Decimal organizationValue47 = 0.0; 
            Decimal organizationValue48 = 0.0; 
            Decimal organizationValue49 = 0.0;        
            Decimal organizationValue50 = 0.0; 
            Decimal organizationValue51 = 0.0; 
            Decimal organizationValue52 = 0.0; 
            Decimal organizationValue53 = 0.0; 
            Decimal organizationValue54 = 0.0; 
            Decimal organizationValue55 = 0.0;
            Decimal organizationValue56 = 0.0; 
            Decimal organizationValue57 = 0.0; 
            Decimal organizationValue58 = 0.0; 
            Decimal organizationValue59 = 0.0; 
            Decimal organizationValue60 = 0.0; 
            Decimal organizationValue61 = 0.0; 
            Decimal organizationValue62 = 0.0; 
            Decimal organizationValue63 = 0.0; 
            Decimal organizationValue64 = 0.0; 
            Decimal organizationValue65 = 0.0; 
            Decimal organizationValue66 = 0.0; 
            Decimal organizationValue67 = 0.0;     
            Channel_Qualifications__c iChannelRows = channelIds ;                
           
            if(iChannelRows.Organization_Value_1__c != NULL){  
        //START OF ROW 1
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_1__c != NULL &&  iChannelRows.Organization_Value_1__c == 'Must have'){           
                       organizationValue1 = 6;               
                   }else{
                       organizationValue1 = (iChannelRows.Organization_Value_1__c != NULL && isNumber(iChannelRows.Organization_Value_1__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_1__c) : NULL;
                   }  
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_1__c != NULL && isNumber(iChannelRows.Organization_Answer_1__c) ){
                       organizationValue2 = organizationValue1*Integer.ValueOf(iChannelRows.Organization_Answer_1__c);   
                   }
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue1 == 6){
                       organizationValue3 = 1;                                    
                   }else{
                       organizationValue3 = 0;
                   }                
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue3*organizationValue2 > 23){
                       organizationValue4 = 1;              
                   }else{
                       organizationValue4 = 0;
                   }  
                  
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue3 == 1){
                       organizationValue5 = organizationValue4*organizationValue2;              
                   }else{
                       organizationValue5 = organizationValue2;
                   }   
                  
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue3 == organizationValue4){
                       organizationValue6 = 1;               
                   }else{
                       organizationValue6 = 0;
                   }        
                         
       // END OF ROW 1              
        //START OF ROW 2
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_2__c != NULL &&  iChannelRows.Organization_Value_2__c == 'Must have'){           
                       organizationValue7 = 6;               
                   }else{
                       organizationValue7 = (iChannelRows.Organization_Value_2__c != NULL && isNumber(iChannelRows.Organization_Value_2__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_2__c) : NULL;
                   } 
                                                    
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_2__c != NULL && isNumber(iChannelRows.Organization_Answer_2__c)){
                       organizationValue8 = organizationValue7*Integer.ValueOf(iChannelRows.Organization_Answer_2__c);   
                   }  
                                                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue7 == 6){
                       organizationValue9 = 1;                                    
                   }else{
                       organizationValue9 = 0;
                   }  
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue9*organizationValue8 > 23){
                       organizationValue10 = 1;              
                   }else{
                       organizationValue10 = 0;
                   }
                                
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue9 == 1){
                       organizationValue11 = organizationValue10*organizationValue8;              
                   }else{
                       organizationValue11 = organizationValue8;
                   }   
                                
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue9 == organizationValue10){
                       organizationValue12 = 1;               
                   }else{
                       organizationValue12 = 0;
                   }
                  
       // END OF ROW 2
          
    //START OF ROW 3
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_3__c != NULL &&  iChannelRows.Organization_Value_3__c == 'Must have'){           
                       organizationValue13 = 6;               
                   }else{
                       organizationValue13 =  (iChannelRows.Organization_Value_3__c != NULL && isNumber(iChannelRows.Organization_Value_3__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_3__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_3__c != NULL && isNumber(iChannelRows.Organization_Answer_3__c)){
                       organizationValue14 = organizationValue13*Integer.ValueOf(iChannelRows.Organization_Answer_3__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue13 == 6){
                       organizationValue15 = 1;                                    
                   }else{
                       organizationValue15 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue15*organizationValue14 > 23){
                       organizationValue16 = 1;              
                   }else{
                       organizationValue16 = 0;
                   }  
                   
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue15 == 1){
                       organizationValue17 = organizationValue16*organizationValue14;              
                   }else{
                       organizationValue17 = organizationValue14;
                   }  
                  
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue15 == organizationValue16){
                       organizationValue18 = 1;               
                   }else{
                       organizationValue18 = 0;
                   }   
                           
       // END OF ROW 3             
              
        //START OF ROW 4
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_4__c != NULL &&  iChannelRows.Organization_Value_4__c == 'Must have'){           
                       organizationValue20 = 6;               
                   }else{
                       organizationValue20 =  (iChannelRows.Organization_Value_4__c != NULL && isNumber(iChannelRows.Organization_Value_4__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_4__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_4__c != NULL && isNumber(iChannelRows.Organization_Answer_4__c)){
                       organizationValue21 = organizationValue20*Integer.ValueOf(iChannelRows.Organization_Answer_4__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue20 == 6){
                       organizationValue22 = 1;                                    
                   }else{
                       organizationValue22 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue22*organizationValue21 > 23){
                       organizationValue23 = 1;              
                   }else{
                       organizationValue23 = 0;
                   }  

                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue22 == 1){
                       organizationValue24 = organizationValue23*organizationValue21;              
                   }else{
                       organizationValue24 = organizationValue21;
                   }  

                   
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue22 == organizationValue23){
                       organizationValue25 = 1;               
                   }else{
                       organizationValue25 = 0;
                   }   
                          
                   // END OF ROW 4 
                   
                       //START OF ROW 5
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_5__c != NULL &&  iChannelRows.Organization_Value_5__c == 'Must have'){           
                       organizationValue26 = 6;               
                   }else{
                       organizationValue26 =  (iChannelRows.Organization_Value_5__c != NULL && isNumber(iChannelRows.Organization_Value_5__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_5__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_5__c != NULL && isNumber(iChannelRows.Organization_Answer_5__c)){
                       organizationValue27 = organizationValue26*Integer.ValueOf(iChannelRows.Organization_Answer_5__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue26 == 6){
                       organizationValue28 = 1;                                    
                   }else{
                       organizationValue28 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue28*organizationValue27 > 23){
                       organizationValue29 = 1;              
                   }else{
                       organizationValue29 = 0;
                   }  
                   
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue28 == 1){
                       organizationValue30 = organizationValue29*organizationValue27;              
                   }else{
                       organizationValue30 = organizationValue27;
                   }  
                   
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue28 == organizationValue29){
                       organizationValue31 = 1;               
                   }else{
                       organizationValue31 = 0;
                   }   
                           
                   // END OF ROW 5 
                //START OF ROW 6
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_6__c != NULL &&  iChannelRows.Organization_Value_6__c == 'Must have'){           
                       organizationValue32 = 6;               
                   }else{
                       organizationValue32 = (iChannelRows.Organization_Value_6__c != NULL && isNumber(iChannelRows.Organization_Value_6__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_6__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_6__c != NULL && isNumber(iChannelRows.Organization_Answer_6__c)){
                       organizationValue33 = organizationValue32*Integer.ValueOf(iChannelRows.Organization_Answer_6__c);   
                   }  
                   
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue32 == 6){
                       organizationValue34 = 1;                                    
                   }else{
                       organizationValue34 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue34*organizationValue33 > 23){
                       organizationValue35 = 1;              
                   }else{
                       organizationValue35 = 0;
                   }  
                   
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue34 == 1){
                       organizationValue36 = organizationValue35*organizationValue33;              
                   }else{
                       organizationValue36 = organizationValue33;
                   }  
                  
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue34 == organizationValue35){
                       organizationValue37 = 1;               
                   }else{
                       organizationValue37 = 0;
                   }   
                             
                   // END OF ROW 6                 
      
                //START OF ROW 7
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_7__c != NULL &&  iChannelRows.Organization_Value_7__c == 'Must have'){           
                       organizationValue38 = 6;               
                   }else{
                       organizationValue38 =  (iChannelRows.Organization_Value_7__c != NULL && isNumber(iChannelRows.Organization_Value_7__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_7__c) : NULL;
                   } 
                 
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_7__c != NULL && isNumber(iChannelRows.Organization_Answer_7__c)){
                       organizationValue39 = organizationValue38*Integer.ValueOf(iChannelRows.Organization_Answer_7__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue38 == 6){
                       organizationValue40 = 1;                                    
                   }else{
                       organizationValue40 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue40*organizationValue39 > 23){
                       organizationValue41 = 1;              
                   }else{
                       organizationValue41 = 0;
                   }  
                   
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue40 == 1){
                       organizationValue42 = organizationValue41*organizationValue39;              
                   }else{
                       organizationValue42 = organizationValue39;
                   }  
                   
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue40 == organizationValue41){
                       organizationValue43 = 1;               
                   }else{
                       organizationValue43 = 0;
                   }   
                         
                   // END OF ROW 7 
    
                //START OF ROW 8
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_8__c != NULL &&  iChannelRows.Organization_Value_8__c == 'Must have'){           
                       organizationValue44 = 6;               
                   }else{
                       organizationValue44 =  (iChannelRows.Organization_Value_8__c != NULL && isNumber(iChannelRows.Organization_Value_8__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_8__c) : NULL;
                   } 
                   
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_8__c != NULL && isNumber(iChannelRows.Organization_Answer_8__c)){
                       organizationValue45 = organizationValue44*Integer.ValueOf(iChannelRows.Organization_Answer_8__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue44 == 6){
                       organizationValue46 = 1;                                    
                   }else{
                       organizationValue46 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue46*organizationValue45 > 23){
                       organizationValue47 = 1;              
                   }else{
                       organizationValue47 = 0;
                   }  
                  
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue46 == 1){
                       organizationValue48 = organizationValue47*organizationValue45;              
                   }else{
                       organizationValue48 = organizationValue45;
                   }  
                  
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue46 == organizationValue47){
                       organizationValue49 = 1;               
                   }else{
                       organizationValue49 = 0;
                   }   
                             
                   // END OF ROW 8 
              
                   //START OF ROW 9
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_9__c != NULL &&  iChannelRows.Organization_Value_9__c == 'Must have'){           
                       organizationValue50 = 6;               
                   }else{
                       organizationValue50 =  (iChannelRows.Organization_Value_9__c != NULL && isNumber(iChannelRows.Organization_Value_9__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_9__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_9__c != NULL && isNumber(iChannelRows.Organization_Answer_9__c)){
                       organizationValue51 = organizationValue50*Integer.ValueOf(iChannelRows.Organization_Answer_9__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue50 == 6){
                       organizationValue52 = 1;                                    
                   }else{
                       organizationValue52 = 0;
                   } 
                  
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue52*organizationValue51 > 23){
                       organizationValue53 = 1;              
                   }else{
                       organizationValue53 = 0;
                   }  
                  
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue52 == 1){
                       organizationValue54 = organizationValue53*organizationValue51;              
                   }else{
                       organizationValue54 = organizationValue51;
                   }  
                  
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue52 == organizationValue53){
                       organizationValue55 = 1;               
                   }else{
                       organizationValue55 = 0;
                   }   
                            
                   // END OF ROW 9  
              
                  //START OF ROW 10
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_10__c != NULL &&  iChannelRows.Organization_Value_10__c == 'Must have'){           
                       organizationValue56 = 6;               
                   }else{
                       organizationValue56 =  (iChannelRows.Organization_Value_10__c != NULL && isNumber(iChannelRows.Organization_Value_10__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_10__c) : NULL;
                   } 
                  
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_10__c != NULL && isNumber(iChannelRows.Organization_Answer_10__c)){
                       organizationValue57 = organizationValue56*Integer.ValueOf(iChannelRows.Organization_Answer_10__c);   
                   }  
                  
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue56 == 6){
                       organizationValue58 = 1;                                    
                   }else{
                       organizationValue58 = 0;
                   } 
                                              
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue58*organizationValue57 > 23){
                       organizationValue59 = 1;              
                   }else{
                       organizationValue59 = 0;
                   }  
                                             
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue58 == 1){
                       organizationValue60 = organizationValue59*organizationValue57;              
                   }else{
                       organizationValue60 = organizationValue57;
                   }  
                                                 
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue58 == organizationValue59){
                       organizationValue61 = 1;               
                   }else{
                       organizationValue61 = 0;
                   }   
                     
                   // END OF ROW 10      
                     //START OF ROW 11
                   // Formula 1 => P =IF(L19="Must Have", 6, L19)           
                   if(iChannelRows.Organization_Value_11__c != NULL &&  iChannelRows.Organization_Value_11__c == 'Must have'){           
                       organizationValue62 = 6;               
                   }else{
                       organizationValue62 =  (iChannelRows.Organization_Value_11__c != NULL && isNumber(iChannelRows.Organization_Value_11__c)) ? Integer.ValueOf(iChannelRows.Organization_Value_11__c) : NULL;
                   } 
                                              
                   // Formula 2 => Q =P19*B19
                   if(iChannelRows.Organization_Answer_11__c != NULL && isNumber(iChannelRows.Organization_Answer_11__c)){
                       organizationValue63 = organizationValue62*Integer.ValueOf(iChannelRows.Organization_Answer_11__c);   
                   }  
                                             
                   //Formula 3 => R =IF(P19=6,1,0)
                   if(organizationValue62 == 6){
                       organizationValue64 = 1;                                    
                   }else{
                       organizationValue64 = 0;
                   } 
                   //Formula 4 => S =IF(R19*Q19>23,1,0)
                   if(organizationValue64*organizationValue63 > 23){
                       organizationValue65 = 1;              
                   }else{
                       organizationValue65 = 0;
                   }  
                                               
                   //Formula 5 => T =IF(R19=1,S19*Q19,Q19)
                   if(organizationValue64 == 1){
                       organizationValue66 = organizationValue65*organizationValue63;              
                   }else{
                       organizationValue66 = organizationValue63;
                   }  
                                             
                   //Formula 6 => U =IF(R19=S19,1,0)
                   if(organizationValue64 == organizationValue65){
                       organizationValue67 = 1;               
                   }else{
                       organizationValue67 = 0;
                   }   
                             
                   // END OF ROW 11              
                //FORMULA 7 => V = =(SUM(T19:T21)/SUM(P19:P21))*(U19*U20*U21);
                   organizationValue19 = (((organizationValue5+organizationValue11+organizationValue17+organizationValue24+organizationValue30+organizationValue36+organizationValue42+organizationValue48+organizationValue54+organizationValue60+organizationValue66)/
                   (organizationValue1+organizationValue7+organizationValue13+organizationValue20+organizationValue26+organizationValue32+organizationValue38+organizationValue44+organizationValue50+organizationValue56+organizationValue62))*
                   (organizationValue6*organizationValue12*organizationValue18*organizationValue25*organizationValue31*organizationValue37*organizationValue43*organizationValue49*organizationValue55*organizationValue61*organizationValue67 ));
                                           
                  return organizationValue19;
                   }                                   
          
             return organizationValue19;
    }
}
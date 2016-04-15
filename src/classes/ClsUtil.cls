/**
 * Public Method
 *
 * @author Sherlock Feng
 * @created 2015-03-19
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)
 * 
 * @changelog
 * 2015-03-19 Sherlock Feng <sherlock.feng@salesforce.com>
 * - Created
 */
public class ClsUtil {
    
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    
    //format Inquiry Number in Lead/Case
    public String formatInquiryNumber(){
        String fn = '';
        String str = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        Integer len = str.length();
        system.debug('@--->'+len);
        Integer rand = 0;
        Integer i = 0;
        for(Integer j=0; j<5;j++){
            rand = Math.round(Math.random()*1000);
            i = Math.mod(rand, len);
            fn += str.substring(i, i+1);
        }
        Date myDate = date.today();
        String strY = String.valueOf(myDate.year());
        String strM = myDate.month()<10 ? '0'+String.valueOf(myDate.month()) : String.valueOf(myDate.month());
        String strD = myDate.day()<10 ? '0'+String.valueOf(myDate.day()) : String.valueOf(myDate.day());
        String fin = strY + strM + strD + '-' + fn;
        return fin;
    }
    
    /**
    * The method is used to get the currency IsoCode, currency Rate
    *
    @author Jinbo Shan
    @created 2015-04-23
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * Jinbo Shan Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */

    private static void getExchangeRate(){
        if(map_isoCode_exchangeRate == null){
            map_isoCode_exchangeRate = new map<String, Decimal>();
            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, SystemModstamp, ConversionRate  from CurrencyType]){
                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
            }
        }
    }
    
    /**
    * The method is used to exchange the value between different IsoCode
    *
    @author Jinbo Shan
    @created 2015-04-23
    @version 1.0
    @since 33.0 (Force.com ApiVersion)
    *
    @return            map<String, >   key is IsoCode, value is Rate.
    *
    @changelog
    * 2015-04-23 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    public static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode){
        Decimal result = 0;
        if(sourceValue != null){
            String k = fromIsoCode + toIsoCode;
            if(map_convertionRate.containsKey(k)){
                return sourceValue * map_convertionRate.get(k);
            }
            
            Decimal fromRate = 1; 
            Decimal toRate = 1; 
            getExchangeRate();
            if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
            else fromRate = 1;
            if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') toRate =  map_isoCode_exchangeRate.get(toIsoCode);
            else toRate = 1;
            result = sourceValue * ( toRate / fromRate );
            map_convertionRate.put(k, toRate / fromRate);
        }        
        
        return result;
    }

    //  -------------------------------------------------------------------------
  //  HELPER method: sendTemplatedEmail
  //  -------------------------------------------------------------------------
  public static void sendTemplatedEmail(String[] toRecipients, String[] ccRecipients, String templateApiName, ID targetObjId, Id whatId, ID orgWideEmailId, Boolean saveAsActivity, Attachment[] attachList ) {
    //  templateId   must be ID of an Email template
    //  targetObjId must be a Contact, User, Lead Id -- also used in merge fields of template recipient.xxxx
    //  whatId    must be an SObject that is used in the merge fields of the template relatedTo.xxxx
    //  fromId    if non null, use current user, otherwise, use this ID (most likely an org wide no reply id)
    //  bcc      not permitted when using templates
    
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
    Id templateId;  
    try {templateId = [select id, name from EmailTemplate where developername = : templateApiName].id;}
    catch (Exception e) {
      throw new ClsTriggerException ('[U-03] Unable to locate EmailTemplate using name: ' + templateApiName + 
                    ' refer to Setup | Communications Templates ' + templateApiName);
    }
      
      email.setToAddresses(toRecipients);
      email.setCcAddresses(ccRecipients);
      email.setTargetObjectId(targetObjId);
      email.setWhatId(whatId);
      email.setorgWideEmailAddressId(orgWideEmailId);
      email.setTemplateId(templateId);
      email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
      
      System.debug(LoggingLevel.INFO,'** entered sendTemplatedEmail, to:' + toRecipients + ' cc:' + ccRecipients +  ' templateId:' + templateId + ' tagetObjId:' + targetObjId + 
                      ' whatId:' + whatId + ' orgWideEmailId: ' + orgWideEmailId);
      //try {
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          return;
     /* }
      catch (EmailException e) {throw new ClsTriggerException('[U-02] sendTemplatedEmail error. ' + e.getMessage());}*/
    
  }  
}
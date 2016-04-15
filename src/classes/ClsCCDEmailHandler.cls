/**
 * Inbound Email handler class for CCDv2 integration
 *
 * @author Jens Becker
 * @created 2015-03-11
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)
 * 
 * @changelog
 * 2015-03-11 Jens Becker <jens.becker@salesforce.com>
 * - Created
 */
global class ClsCCDEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        system.debug('::MR::');
        system.debug('@envelope:'+envelope);
        system.debug('@email.plainTextBody:'+email.plainTextBody);
        try{
            Lead l = new Lead(); 
            String contentBody = '<?xml'+ email.plainTextBody.substringBetween('<?xml','</inquiry>')+'</inquiry>';
            system.debug('@email.contentBody:'+contentBody);
            l = parseContent(contentBody);
            //Fetching the assignment rules on case
            AssignmentRule AR = new AssignmentRule();
            AR = [select id from AssignmentRule where SobjectType = 'Lead' and Active = true limit 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
            //Setting the DMLOption on Case instance
            l.setOptions(dmlOpts);
            insert l;
            result.success = true;
        }catch (exception e){
            result.success = false;
            result.message = e.getMessage()+'';
        }

        return result;
    }

    public map<String,String> getMapField(){
        map<String,String> map_field = new map<String,String>();
        //map<String, CCDv2Mapping__c> map_CCDv2Mapping = CCDv2Mapping__c.getAll();
        for(CCDv2Mapping__c c: [SELECT Field_Name__c, Name, XML_Tag__c, Type__c, sObject__c FROM CCDv2Mapping__c])
        {
            map_field.put(c.XML_Tag__c,c.Field_Name__c);
        }
        return map_field;
    }
    public map<String,String> getMapType(){
        map<String,String> map_type = new map<String,String>();
        //map<String, CCDv2Mapping__c> map_CCDv2Mapping = CCDv2Mapping__c.getAll();
        for(CCDv2Mapping__c c: [SELECT Field_Name__c, Name, XML_Tag__c, Type__c, sObject__c FROM CCDv2Mapping__c])
        {
            map_type.put(c.XML_Tag__c,c.Type__c);
        }
        return map_type;
    }

    public Lead parseContent(String strEmailBody){
        Lead l = new Lead();
        map<String,String> map_field = getMapField();
        map<String,String> map_type = getMapType();
        map<String,CCDv2DivMap__c > map_ProductCategory = CCDv2DivMap__c.getAll();
        system.debug('@map_field--'+map_field);
        XmlStreamReader reader = new XmlStreamReader(strEmailBody);
        
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            system.debug('@reader.getEventType()--'+reader.getEventType());
            system.debug('@reader.getLocalName()--'+reader.getLocalName());
            // Start at the beginning of the lead and make sure that it is a lead
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                // Pass the lead to the parseBook method (below) 
                if(map_field.containsKey(reader.getLocalName())) {
                    String val = parseEmailBody(reader);
                    if(map_type.get(reader.getLocalName()).toLowerCase()=='string'){
                        if(reader.getLocalName().toLowerCase()=='categoryid' && !map_ProductCategory.isEmpty()){
                            if(map_ProductCategory.containsKey(val)){
                                l.put('Product_Category__c',map_ProductCategory.get(val).CCDv2_Category__c);
                                l.put('Division__c',map_ProductCategory.get(val).Division__c);
                                if(map_ProductCategory.get(val).Business_Unit__c != null)
                                {
                                    l.put('Business_Unit__c',map_ProductCategory.get(val).Business_Unit__c); // New Custom Setting Value to map Business unit to Lead record // Jan12 2016 MohanRaj//
                                }
                            }else{
                               l.put(map_field.get(reader.getLocalName()),val); 
                            }
                        }else{
                            l.put(map_field.get(reader.getLocalName()),val);
                        }
                    }else if(map_type.get(reader.getLocalName()).toLowerCase()=='datetime'){
                        Datetime myDate = DatetimeFormat(val);
                        l.put(map_field.get(reader.getLocalName()),myDate);
                    }else if(map_type.get(reader.getLocalName()).toLowerCase()=='date'){
                        Date myDate = DateFormat(val);
                        l.put(map_field.get(reader.getLocalName()),myDate);
                    }else if(map_type.get(reader.getLocalName()).toLowerCase()=='decimal'){
                        Decimal myDecimal = Decimal.valueOf(val);
                        l.put(map_field.get(reader.getLocalName()),myDecimal);
                    }else if(map_type.get(reader.getLocalName()).toLowerCase()=='boolean'){
                        Boolean b = Boolean.valueOf(val);
                        l.put(map_field.get(reader.getLocalName()),b);
                    }
                    
                }
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                system.debug('@end');
                break;
            }
        }
        
        return l;
    }
    public String parseEmailBody(XmlStreamReader reader) {
        String str = '';
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            system.debug('@reader.getEventType()++'+reader.getEventType());
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                str += reader.getText();
                system.debug('@str++'+str);
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                system.debug('@xx');
                break;
            }
        }
        return str;
    }
    public Datetime DatetimeFormat(String val) {
        string year = val.substring(0, 4);
        string month = val.substring(5, 7);
        string day = val.substring(8, 10);
        string hour = val.substring(11, 13);
        string minute = val.substring(14, 16);
        string second = val.substring(17, 19);
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        Datetime myDate = Datetime.valueOf(stringDate);
        return myDate;
    }
    public Date DateFormat(String val) {
        string year = val.substring(0, 4);
        string month = val.substring(5, 7);
        string day = val.substring(8, 10);
        string hour = val.substring(11, 13);
        string minute = val.substring(14, 16);
        string second = val.substring(17, 19);
        string stringDate = year + '-' + month + '-' + day + ' ' + hour + ':' + minute +  ':' + second;
        Date myDate = Date.valueOf(stringDate);
        return myDate;
    }

}
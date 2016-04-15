<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APTS_LP_Quotation_Send_email_expiration_alert_to_record_owner_upon_expiry</fullName>
        <description>APTS_LP_Quotation Send email expiration alert to record owner upon expiry</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Quotation_expired_notice</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Quote_Notification_QuotehasbeenCancelled</fullName>
        <description>APTS_LP_Quote Notification_QuotehasbeenCancelled</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Quote_Notification_QuotehasbeenCancelled</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Quote_Notification_QuotehasbeenRejected</fullName>
        <description>APTS_LP_Quote Notification_QuotehasbeenRejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Quote_Notification_QuotehasbeenRejected</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Spain_Quote_hasbeenapproved</fullName>
        <description>APTS_LP_Spain - Quote hasbeenapproved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Quote_Notification_QuotehasbeenApproved</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Spain_Quote_hasbeensubmitted</fullName>
        <description>LP_Spain - Quote hasbeensubmitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Quote_Notification_QuotehasbeenSubmitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>APTS_LP_Quotation_Status_Expired</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Expired</literalValue>
        <name>Status Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
 <fieldUpdates>
        <fullName>APTS_LP_Quote_Status_Approved</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Approved</literalValue>
        <name>Quote Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Quote_Status_NotSubmitted</fullName>
        <field>Apttus_QPApprov__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Quote Status NotSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Stage_Draft</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Recalled</literalValue>
        <name>Stage Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Valid_From_Today</fullName>
        <field>Apttus_Proposal__ExpectedStartDate__c</field>
        <formula>TODAY()</formula>
        <name>Valid From Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Set_value_for_placeholder</fullName>
        <field>APTS_Is_Placeholder_Quote__c</field>
        <literalValue>0</literalValue>
        <name>Set value for placeholder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordType_Unlock</fullName>
        <description>RecordType Unlock</description>
        <field>RecordTypeId</field>
        <lookupValue>LP</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordType Unlock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
<fieldUpdates>
        <fullName>APTS_QuotationClosedStatustoBlank</fullName>
        <field>APTS_Quotation_Closed_Status__c</field>
        <name>APTS_QuotationClosedStatustoBlank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_QuotationStatusOpen</fullName>
        <field>APTS_Quotation_Category__c</field>
        <literalValue>Open</literalValue>
        <name>APTS_QuotationStatusOpen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_QuoteOpenStatustoDraft</fullName>
        <field>Apttus_Proposal__Approval_Stage__c</field>
        <literalValue>Draft</literalValue>
        <name>APTS_QuoteOpenStatustoDraft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
<rules>
        <fullName>APTS_DefaultQuotationStatus</fullName>
        <actions>
            <name>APTS_QuotationClosedStatustoBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_QuotationStatusOpen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_QuoteOpenStatustoDraft</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal__c.APTS_Quotation_Category__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Created to rule to set &quot;Quotation Status&quot; as &quot;Open&quot;. Scenario is, when user clone the quote when it is in closed status, same values are getting copied and user is not able to process that quote.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Quotation_Expired</fullName>
        <actions>
            <name>APTS_Set_value_for_placeholder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name =  $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_LP_Quotation_Send_email_expiration_alert_to_record_owner_upon_expiry</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>APTS_LP_Quotation_Status_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Proposal__Proposal__c.Apttus_Proposal__Valid_Until_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>APTS_LP_Quote Notification_QuotehasbeenCancelled</fullName>
        <actions>
            <name>APTS_LP_Quote_Notification_QuotehasbeenCancelled</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>APTS_LP_Quote Notification_QuotehasbeenCancelled</description>
        <formula>ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Cancelled&apos;) &amp;&amp;  RecordType.Name == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Quote Notification_QuotehasbeenRejected</fullName>
        <actions>
            <name>APTS_LP_Quote_Notification_QuotehasbeenRejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>APTS_LP_Quote Notification_QuotehasbeenRejected</description>
        <formula>ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Rejected&apos;)&amp;&amp;  RecordType.Name == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Spain - Quote Unlock RT Change Page Layout</fullName>
        <actions>
            <name>RecordType_Unlock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>LP_Spain - Quote Unlock RecordType. Change Page Layout to enable edit.</description>
        <formula>AND(OR ( ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Not Submitted&apos;), ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Rejected&apos;), ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Cancelled&apos;), ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Generated&apos;), ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Presented&apos;)  ), RecordType.Name == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Spain - Quote hasbeenapproved</fullName>
        <actions>
            <name>APTS_LP_Spain_Quote_hasbeenapproved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>APTS_LP_Spain - Quote hasbeenapproved</description>
        <formula>ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Approved&apos;)&amp;&amp;  RecordType.Name == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Spain - Quote hasbeensubmitted</fullName>
        <actions>
            <name>APTS_LP_Spain_Quote_hasbeensubmitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>LP_Spain - Quote hasbeensubmitted</description>
        <formula>ISPICKVAL(Apttus_QPApprov__Approval_Status__c,&apos;Pending Approval&apos;)&amp;&amp; RecordType.Name == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
   <rules>
        <fullName>APTS_LP_Update Fields Quote Upon Recall</fullName>
        <actions>
            <name>APTS_LP_Quote_Status_NotSubmitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Stage_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Valid_From_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>RecordType_Unlock</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Fields Quote Upon Recall, cancel</description>
        <formula>RecordType.Name =  $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c  &amp;&amp; ISPICKVAL(  Apttus_QPApprov__Approval_Status__c , &quot;Cancelled&quot;) &amp;&amp;   Apttus_Proposal__Proposal_Name__c != null</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

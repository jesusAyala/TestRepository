<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APTS_LP_ABB_Agreement_Request_has_been_Cancelled_Notification_RecordOwner</fullName>
        <description>ABB Agreement Request has been Cancelled Notification (RecordOwner)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_Notification_MSPAhasbeenCancelled</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_ABB_Agreement_Request_has_been_Rejected_Notification_RecordOwner</fullName>
        <description>ABB Agreement Request has been Rejected Notification (RecordOwner)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_Notification_MSPAhasbeenRejected</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_ABB_Agreement_Request_has_been_Submitted_Notification_RecordOwner</fullName>
        <description>ABB Agreement Request has been Submitted Notification (RecordOwner)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_Notification_MSPAhasbeenSubmitted</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Notification_to_MSPA_Owner_for_Approval_has_been_approved</fullName>
        <description>Notification to MSPA Owner for Approval has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_Notification_MSPAhasbeenApproved</template>
    </alerts>
    <alerts>
        <fullName>Notify_MSPA_Creator_when_submitted_for_Approval</fullName>
        <description>Notify MSPA Creator when submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_Notify_MSPA_Owner_When_Submitted</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Send_email_expiration_alert_to_record_owner_1_week_before_expiration</fullName>
        <description>APTS_LP_Send email expiration alert to record owner 1 week before expiration</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_nearing_expiration_notice_2Weeks</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Send_email_expiration_alert_to_record_owner_2_weeks_before_expiration</fullName>
        <description>APTS_LP_Send email expiration alert to record owner 2 weeks before expiration</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_nearing_expiration_notice_2Weeks</template>
    </alerts>
    <alerts>
        <fullName>APTS_LP_Send_email_expiration_alert_to_record_owner_upon_expiry</fullName>
        <description>APTS_LP_Send email expiration alert to record owner upon expiry</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Agreement_expired_notice</template>
    </alerts>
    <alerts>
        <fullName>APTS_MSPACreationinSAPFailedNotificationEmailAlert</fullName>
        <description>APTS_MSPACreationinSAPFailedNotificationEmail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_MSPACreationFailureNotificationTemplate</template>
    </alerts>
    <alerts>
        <fullName>APTS_MSPASuccessNotificationEmail</fullName>
        <description>APTS_MSPASuccessNotificationEmail</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_MSPASuccessEmailNotificationTemplate</template>
    </alerts>
    <alerts>
        <fullName>APTS_MSPA_Block_Notification</fullName>
        <description>APTS MSPA Block Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_MSPABlockNotification</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_inform_when_residual_order_amount_is_above_80_of_Max_order_amoun</fullName>
        <description>Notification to inform when residual order amount is above 80% of Max order amount</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apttus__ApttusEmailTemplates/APTS_LP_Standard_Mail</template>
    </alerts>
    <fieldUpdates>
        <fullName>APTS_LP_Approval_Status_NotSubmitted</fullName>
        <field>Apttus_Approval__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Approval Status NotSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Approved</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Approved</literalValue>
        <name> Status: Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Category_Request</fullName>
        <field>Apttus__Status_Category__c</field>
        <literalValue>Request</literalValue>
        <name>Status Category: Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Draft</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Status Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Expired</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Status Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Presented</fullName>
        <description>After presented, change status to &apos;Presented&apos;</description>
        <field>Apttus__Status__c</field>
        <literalValue>Presented</literalValue>
        <name>Status: Presented</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_LP_Status_Recalled</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_MSPA_Status_Update</fullName>
        <description>Make MSPA Status as Approved</description>
        <field>Apttus__Status__c</field>
        <literalValue>Approved but Action Required</literalValue>
        <name>MSPA Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_PopulateMSPADescription</fullName>
        <field>Apttus__Description__c</field>
        <formula>&apos;MSPA - &apos;+ Apttus__Account__r.Name+ &apos; - &apos;+  APTS_SAP_Reference_No__c</formula>
        <name>APTS_PopulateMSPADescription</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Upd_Default_Status_to_Draft</fullName>
        <field>Apttus__Status__c</field>
        <literalValue>Draft</literalValue>
        <name>APTS Upd Default Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordIDwithCurrentId</fullName>
        <field>APTS_Record_Id__c</field>
        <formula>Id</formula>
        <name>APTS_UpdateRecordIDwithCurrentId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Valid_From_Date_Change</fullName>
        <field>Apttus__Contract_Start_Date__c</field>
        <formula>APTS_MSPA_Start_Date__c</formula>
        <name>Valid From Date Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Valid_To_Date_Change</fullName>
        <description>Work when MSPA is created from Quotation</description>
        <field>Apttus__Contract_End_Date__c</field>
        <formula>APTS_MSPA_End_Date__c</formula>
        <name>Valid To Date Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SearchFieldUpdate</fullName>
        <description>Update the account search field with Account Name</description>
        <field>Apttus__Account_Search_Field__c</field>
        <formula>Apttus__Account__r.Name  &amp;  Apttus__FF_Agreement_Number__c</formula>
        <name>Search Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetAgreementNumber</fullName>
        <description>Set agreement number from the auto generated contract number</description>
        <field>Apttus__Agreement_Number__c</field>
        <formula>Apttus__Contract_Number__c</formula>
        <name>Set Agreement Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Apttus__SetClonetriggertofalse</fullName>
        <description>Set Clone trigger to false</description>
        <field>Apttus__Workflow_Trigger_Created_From_Clone__c</field>
        <literalValue>0</literalValue>
        <name>Set Clone trigger to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Category_Expired</fullName>
        <field>Apttus__Status_Category__c</field>
        <literalValue>Expired</literalValue>
        <name>Status Category Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_APTS_LP_Status_Old</fullName>
        <description>Updates the Dummy Field APTS LP Status Old to previous value of Status Field</description>
        <field>APTS_LP_Status_Old__c</field>
        <formula>TEXT(PRIORVALUE(Apttus__Status__c))</formula>
        <name>Update APTS LP Status Old</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Agreement_Name_for_MSPA</fullName>
        <field>Name</field>
        <formula>IF( ISBLANK(APTS_LP_AccountCustomer__c),&quot;MSPA&quot;, &quot;MSPA&quot;+&quot;_&quot;+ Apttus__Account__r.Name +&quot;_&quot;+ APTS_SAP_Reference_No__c)</formula>
        <name>Update Agreement Name for MSPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
   <rules>
        <fullName>APTS_ChangeMSPAStatus</fullName>
        <actions>
            <name>APTS_MSPA_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(AND(TEXT(Apttus__Status__c ) &lt;&gt; &apos;Approved but failed to load on SAP&apos;, TEXT(Apttus__Status__c )&lt;&gt; &apos;Approved&apos;,TEXT(Apttus__Status__c )&lt;&gt; &apos;Blocked&apos;), RecordType.Name =  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c ,  OR(APTS_Related_Quotation_Status__c =&apos;Approved&apos;,APTS_Related_Quotation_Status__c = &apos;Generated&apos;, APTS_Related_Quotation_Status__c = &apos;Presented&apos; ), APTS_MSPA_without_Changes__c = true, APTS_Record_Id__c = Id, ISPICKVAL(Apttus__Status__c, &apos;Draft&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_ABB Agreement Request has been Approved - RecordOwner</fullName>
        <actions>
            <name>APTS_LP_Notification_to_MSPA_Owner_for_Approval_has_been_approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>ABB Agreement Agreement Request has been Approved (RecordOwner)</description>
        <formula>RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp; (TEXT( Apttus_Approval__Approval_Status__c ) == &apos;Approved&apos; || TEXT( Apttus_Approval__Approval_Status__c ) == &apos;Approved but Action Required&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_ABB Agreement Request has been Rejected Notification - RecordOwner</fullName>
        <actions>
            <name>APTS_LP_ABB_Agreement_Request_has_been_Rejected_Notification_RecordOwner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>ABB Agreement Request has been Rejected Notification (RecordOwner)</description>
        <formula>ISPICKVAL( Apttus_Approval__Approval_Status__c , &apos;Rejected&apos;) &amp;&amp;  RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_ABB Agreement Request has been Submitted Notification - RecordOwner</fullName>
        <actions>
            <name>Notify_MSPA_Creator_when_submitted_for_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>ABB Agreement Request has been Submitted Notification (RecordOwner)</description>
        <formula>ISPICKVAL( Apttus_Approval__Approval_Status__c , &apos;Pending Approval&apos;) &amp;&amp;  RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
     <rules>
        <fullName>APTS_LP_Change Status In Signatures to Approved</fullName>
        <actions>
            <name>APTS_LP_Status_Category_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Status_Presented</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change In Signatures status to Approved as we are not using esignature in our AWA process. &apos;In signatures&apos; without esignatures doesnt have a valid reason to be there so we overwrite it with approved status.</description>
        <formula>OR( ISPICKVAL( Apttus__Status__c , &apos;In Signatures&apos;), ISPICKVAL( Apttus__Status__c , &apos;Other Party Review&apos;)) &amp;&amp;  RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_MSPA Expired</fullName>
        <active>true</active>
        <formula>RecordType.Name == $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp; Apttus__Contract_End_Date__c &lt;= TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_LP_Status_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Category_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>APTS_LP_MSPA Send email expiration alert 2 and 1 week before expiration</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>MSPA</value>
        </criteriaItems>
        <description>MSPA Notify 2 weeks before Expiration</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_LP_Send_email_expiration_alert_to_record_owner_2_weeks_before_expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>APTS_LP_Send_email_expiration_alert_to_record_owner_1_week_before_expiration</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Apttus__APTS_Agreement__c.Apttus__Contract_End_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
     <rules>
        <fullName>APTS_LP_MSPA_EXPIRED_TO_DRAFT</fullName>
        <actions>
            <name>APTS_LP_Status_Category_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Status_Draft</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Status_Recalled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Change Expired to Draft when Valid To Date is in future.</description>
        <formula>If( AND((RecordType.Name =  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c ) ,Apttus__Contract_End_Date__c &gt; TODAY(),  PRIORVALUE(Apttus__Status__c) = &apos;Expired&apos; ) ,  true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_LP_Store_Previous_Value</fullName>
        <actions>
            <name>Update_APTS_LP_Status_Old</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Stores Previous Value of Status Field.</description>
        <formula>(RecordType.Name =  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c) &amp;&amp; ISCHANGED(Apttus__Status__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
   <rules>
        <fullName>APTS_LP_Update Fields MSPA Upon Recall</fullName>
        <actions>
            <name>APTS_LP_ABB_Agreement_Request_has_been_Cancelled_Notification_RecordOwner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>APTS_LP_Approval_Status_NotSubmitted</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_LP_Status_Recalled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Fields MSPA Upon after recall, cancel</description>
        <formula>RecordType.Name =  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp;  ISPICKVAL(Apttus_Approval__Approval_Status__c, &quot;Cancelled&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_MSPA Agreement Name</fullName>
        <actions>
            <name>Update_Agreement_Name_for_MSPA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Agreement Name for MSPA Record type</description>
        <formula>RecordType.Name ==   $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
 <rules>
        <fullName>APTS_MSPACreationinSAPFailedNotificationRule</fullName>
        <actions>
            <name>APTS_MSPACreationinSAPFailedNotificationEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( Apttus__Status__c, &apos;Approved but failed to load on SAP&apos;) &amp;&amp;  RecordType.Name == $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
     <rules>
        <fullName>APTS_MSPAEndDate</fullName>
        <actions>
            <name>APTS_Valid_To_Date_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To be run when MSPA is created from Quotation</description>
        <formula>RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp;  NOT(ISBLANK( APTS_MSPA_End_Date__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
     <rules>
        <fullName>APTS_MSPAStartDate</fullName>
        <actions>
            <name>APTS_Valid_From_Date_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp; NOT(ISBLANK( APTS_MSPA_Start_Date__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
 <rules>
        <fullName>APTS_MSPASuccessNotificationRule</fullName>
        <actions>
            <name>APTS_MSPASuccessNotificationEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>MSPA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_MSPA_Blocked_Notification</fullName>
        <actions>
            <name>APTS_MSPA_Block_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c &amp;&amp; ISPICKVAL( Apttus__Status__c, &apos;Blocked&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_PopulateMSPADescription</fullName>
        <actions>
            <name>APTS_PopulateMSPADescription</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name ==  $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
  <rules>
        <fullName>APTS_SetRecordId</fullName>
        <actions>
            <name>APTS_UpdateRecordIDwithCurrentId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>APTS_Record_Id__c  = null &amp;&amp;  RecordType.Name == $Setup.APTS_Agreement_Record_Type__c.APTS_Default_Record_Type__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Reset Clone Trigger</fullName>
        <actions>
            <name>Apttus__SetClonetriggertofalse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Workflow_Trigger_Created_From_Clone__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Reset Clone Trigger</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Search Field Update</fullName>
        <actions>
            <name>Apttus__SearchFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate an external Id search field with account name, so that side bar support can work with Account name search</description>
        <formula>or(not (isnull(Apttus__Account__r.Name)) ,not (isnull(Apttus__FF_Agreement_Number__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Apttus__Set Agreement Number</fullName>
        <actions>
            <name>Apttus__SetAgreementNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus__APTS_Agreement__c.Apttus__Agreement_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set agreement number for new agreements. The agreement number is auto generated.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

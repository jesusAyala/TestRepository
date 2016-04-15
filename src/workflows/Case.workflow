<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Auto_Response_Finland_Drives_Alert</fullName>
        <description>Case Auto Response Finland Drives Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>nikhil.pimpale@accenture.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Management_Template/Auto_response_Email</template>
    </alerts>
    <alerts>
        <fullName>Case_Auto_Response_Finland_Motors_Alert</fullName>
        <description>Case Auto Response Finland Motors Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>nikhil.pimpale@accenture.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_Management_Template/Auto_response_Email</template>
    </alerts>
    <alerts>
        <fullName>Case_Closure_Notification</fullName>
        <description>Case Closure Notification</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management_Template/Case_Closure_Alert</template>
    </alerts>
    <alerts>
        <fullName>Case_Closure_Notification_to_Web_Email</fullName>
        <description>Case Closure Notification to Web Email</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management_Template/Case_Closure_Alert</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_4_Hours_before_First_Response</fullName>
        <description>Case Email: 4 Hours before First Response</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management_Template/New_assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Email_Milestone_Violation_Alert</fullName>
        <description>Case Email: Milestone Violation Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management_Template/New_assignment_notification</template>
    </alerts>
    <alerts>
        <fullName>Case_closure_notification_to_customer</fullName>
        <description>Case closure notification to customer</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_Management_Template/Case_Closure_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_EmailNotification</fullName>
        <field>Email2Case_Notification_sent__c</field>
        <literalValue>1</literalValue>
        <name>Update EmailNotification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Resolution_Time</fullName>
        <field>Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>Case Resolution Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Target_Resolution_Date_Conv</fullName>
        <field>target_Resolution_Date1__c</field>
        <formula>DATEVALUE(Target_Resolution_Date__c)</formula>
        <name>Case Target Resolution Date Conv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Update_Record_Type_to_Close</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case Update Record Type to Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Layout_Show</fullName>
        <description>Change the Case Record Type to call a different Layout</description>
        <field>RecordTypeId</field>
        <lookupValue>Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Layout (Show)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Response_Time</fullName>
        <description>Case Response time (Time from “Case Status is New” TO the First Time Response i.e. “Case Status is Contacted”)</description>
        <field>Response_Time__c</field>
        <formula>Now()</formula>
        <name>Populate Response Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reason_to_not_notify_customer</fullName>
        <field>Update_Not_Required_Reason__c</field>
        <formula>&quot;As closed in CCRP, no notification will be sent from SFDC&quot;</formula>
        <name>Reason to not notify customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Time_Stamp</fullName>
        <field>X1st_Response__c</field>
        <formula>LastModifiedDate</formula>
        <name>Time Stamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_NPS_Survey</fullName>
        <description>Integration Workstream : R5 : R-2486</description>
        <field>NPS_Survey__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck NPS Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Notify_Customer</fullName>
        <field>Update_Customer_via_Email__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Notify Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_Assigned_Date</fullName>
        <description>Update field &apos;Assigned Date&apos;</description>
        <field>Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>Update field Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>1st Response Time Stamp</fullName>
        <actions>
            <name>Time_Stamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule will make sure when a Case progress from  the Status NEW, the system can track that time and use it for</description>
        <formula>AND(  ISBLANK(X1st_Response__c),  NOT(ISPICKVAL(Status,&quot;New&quot;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Auto-Response Finland Drives</fullName>
        <actions>
            <name>Case_Auto_Response_Finland_Drives_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_EmailNotification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_To_Case_Recipient__c</field>
            <operation>equals</operation>
            <value>nikhil.pimpale@accenture.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email2Case_Notification_sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Auto Response for cases created from Finland Drives routing address</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Auto-Response Finland Motors</fullName>
        <actions>
            <name>Case_Auto_Response_Finland_Motors_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_EmailNotification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Email_To_Case_Recipient__c</field>
            <operation>equals</operation>
            <value>nikhil.pimpale@accenture.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Email2Case_Notification_sent__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Auto Response for cases created from Finland routing address</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closure Notification</fullName>
        <actions>
            <name>Case_Closure_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_closure_notification_to_customer</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This WF sends email if case is closed and Update Customer is checked on case closure page layout.</description>
        <formula>AND(  ISPICKVAL(Status,&quot;Closed&quot;),  Parent.Id = Null )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Closure Notification to Web User</fullName>
        <actions>
            <name>Case_Closure_Notification_to_Web_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This WF sends email if case is closed and Update Customer is checked on case closure page layout.</description>
        <formula>AND(  ISPICKVAL(Status,&quot;Closed&quot;),  Update_Customer_via_Email__c,  ISBLANK(ContactId),  NOT(ISBLANK( SuppliedEmail )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Resolution Time</fullName>
        <actions>
            <name>Case_Resolution_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case Response time when Case is set to closed or Solution Implemented</description>
        <formula>AND(   OR(     ISPICKVAL(Status, &apos;Closed&apos;),     ISPICKVAL(Status, &apos;Solution Implemented&apos;)   ),   ISBLANK( Assigned_Date__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Target Resolution Date Conversion</fullName>
        <actions>
            <name>Case_Target_Resolution_Date_Conv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Target_Resolution_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Time Response</fullName>
        <actions>
            <name>Populate_Response_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Case Response time (Time from “Case Status is New” TO the First Time Response i.e. “Case Status is Contacted”)</description>
        <formula>AND (ISCHANGED( Status ) ,  ISPICKVAL(PRIORVALUE( Status ), &apos;New&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Update Close Case Record Type</fullName>
        <actions>
            <name>Case_Update_Record_Type_to_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>This WFR will update the record type of case when it gets Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deactivate Email for customer CCRP</fullName>
        <actions>
            <name>Reason_to_not_notify_customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Notify_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Update_Customer_via_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck NPS Survey for Complaints</fullName>
        <actions>
            <name>Uncheck_NPS_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Complaint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.NPS_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Integration Workstream : R-2486</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

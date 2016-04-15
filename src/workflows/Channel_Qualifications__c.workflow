<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Channel_Pre_Qualification_Approved</fullName>
        <description>Channel Pre-Qualification Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Pre_Qualification_Record_Approved</template>
    </alerts>
    <alerts>
        <fullName>Channel_Pre_Qualification_Record_Submit_for_Approval</fullName>
        <description>Channel Pre-Qualification Record Submit for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Pre_Qualification_Record_Submit_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>Channel_Pre_Qualification_Rejected</fullName>
        <description>Channel Pre-Qualification Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Pre_Qualification_Record_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Closed_Record_Type_PreQualificati</fullName>
        <description>R5 - Update Closed Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Channel_Pre_Qualification</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type PreQualificati</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_of_Completed1</fullName>
        <description>R5 - When the Status is changed to &quot;Completed&quot;, Date of Completed is updated with current date.</description>
        <field>Date_of_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Update Date of Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Draft</fullName>
        <description>R5: Update Status to &apos;Draft&apos;</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date_Details</fullName>
        <description>R5 - Approved Date Details</description>
        <field>Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Approved Date Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date_Details1</fullName>
        <description>R5 - Approved Date Details</description>
        <field>Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Approved Date Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Details</fullName>
        <description>R5 - Approved Details</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approved Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChannelPreQualificationField_Update</fullName>
        <description>R5 - Field Update to display Channel Qualification Detail Page Layout</description>
        <field>RecordTypeId</field>
        <lookupValue>Channel_Qualification_Detail_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Channel Pre-Qualification Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Details</fullName>
        <description>R5 - Rejected Details</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Rejected Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_Name</fullName>
        <description>R5 - Set Approver Name</description>
        <field>Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+ $User.LastName</formula>
        <name>Set Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_Name1</fullName>
        <description>R5 - Set Approver Name</description>
        <field>Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+ $User.LastName</formula>
        <name>Set Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ABB_Product_Lines</fullName>
        <field>ABB_Product_Lines_discussed__c</field>
        <formula>Channel_Market_Coverage__r.Product_Line1__c</formula>
        <name>Update ABB Product Lines</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Channel_Qualification_Company_Des</fullName>
        <field>Company_Description__c</field>
        <formula>Account__r.Company_Description__c</formula>
        <name>Update Channel Qualification Company Des</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Record_Type</fullName>
        <description>R5 - Update Closed Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Channel_Pre_Qualification</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Of_Completed</fullName>
        <description>R5 - Update Date Of Completed</description>
        <field>Date_of_Completed__c</field>
        <formula>TODAY()</formula>
        <name>Update Date Of Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Open_Record_Type</fullName>
        <description>R5 - To update record type from closed to open when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Channel_Qualification_Detail_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Open Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <description>R5 - Update Status</description>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status1</fullName>
        <description>R5 - Update Status</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status2</fullName>
        <description>R5 - Update Status</description>
        <field>Status__c</field>
        <literalValue>Declined</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Channel Pre-Qualification Closed Layout Rule</fullName>
        <actions>
            <name>Update_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>equals</operation>
            <value>Obsolete</value>
        </criteriaItems>
        <description>R5 - Rule to update Closed layout(Closed Channel Pre-Qualification) . Channel Pre-Qualification Layout Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Pre-Qualification Date Rule</fullName>
        <actions>
            <name>Update_Date_Of_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>R5 - Channel Pre-Qualification Completed Date Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Pre-Qualification Detail Layout Rule</fullName>
        <actions>
            <name>ChannelPreQualificationField_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>R5 - Rule to update Detail layout(Channel Qualification Detail Page) . Channel Pre-Qualification Layout Rule. New Rule to display different layouts for record types</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Pre-Qualification Status Rule</fullName>
        <actions>
            <name>Update_Open_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Qualifications__c.Status__c</field>
            <operation>equals</operation>
            <value>In Approval,Draft</value>
        </criteriaItems>
        <description>R5 - Change the page layout from closed to open when status changes.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>To populate Company Description on Channel PArtner Pre Qual</fullName>
        <actions>
            <name>Update_ABB_Product_Lines</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Channel_Qualification_Company_Des</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Channel_Business_Review_Approved</fullName>
        <description>Channel Business Review Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Business_Review_Record_Approved</template>
    </alerts>
    <alerts>
        <fullName>Channel_Business_Review_Rejected</fullName>
        <description>Channel Business Review Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Business_Review_Record_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Channel_Business_Review_Submit_for_Approval</fullName>
        <description>Channel Business Review Submit for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Channel_Business_Review_Record_Submit_for_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Draft</fullName>
        <description>R5: To change the status to Draft</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Of_Completion1</fullName>
        <description>R5 - When the Status is changed to &quot;Completed&quot;, Date of Completion is updated with current date.</description>
        <field>Date_of_Completion__c</field>
        <formula>TODAY()</formula>
        <name>Update Date Of Completion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date_Details</fullName>
        <description>R5 Approved Date Details used in Approval process</description>
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
        <description>R5 - Approved Details for Approval Process</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approved Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Channel_End_Period_Field_Update</fullName>
        <description>R5 - Field update to display the Record type &quot;Channel End-Period Business Review Detail&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Channel_End_Period_Business_Review_Detail</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Channel End-Period Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Channel_Mid_Period_Field_Update</fullName>
        <description>R5 - Field update to display the Record type &quot;Channel Mid-Period Business Review Detail&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>Channel_Mid_Period_Business_Review_Detail</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Channel Mid-Period Field Update</name>
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
        <description>R5 - Set Approver Name from the Approval Process</description>
        <field>Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+ $User.LastName</formula>
        <name>Set Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_Name1</fullName>
        <description>R5 - Set Approver Name from the Approval Process</description>
        <field>Approver_Name__c</field>
        <formula>$User.FirstName +&quot; &quot;+ $User.LastName</formula>
        <name>Set Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Record_Type</fullName>
        <description>R5 - Update Closed Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Channel_Business_Review</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Of_Completion</fullName>
        <description>R5 - Update Date of Completion when Status is changed to Completed.</description>
        <field>Date_of_Completion__c</field>
        <formula>TODAY()</formula>
        <name>Update Date Of Completion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <description>R5 - Update Status to In Approval</description>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status1</fullName>
        <description>R5 - Update Status to Additional Details Required</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status2</fullName>
        <description>R5 - Update Status to Additional Details Required</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Channel Business Review Closed Layout Rule</fullName>
        <actions>
            <name>Update_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Obsolete</value>
        </criteriaItems>
        <description>R5 - Channel Business Review Closed Layout Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Business Review Date of Completion Rule</fullName>
        <actions>
            <name>Update_Date_Of_Completion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>R5 - Rule to update Date of Completion when Status is changed to Completed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel End-Period Business Review Detail Layout Rule</fullName>
        <actions>
            <name>Channel_End_Period_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Business_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>End-Period Business Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Obsolete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>R5 - Rule to update the Channel End-Period Business Review Detail layout</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Mid-Period Business Review Detail Layout Rule</fullName>
        <actions>
            <name>Channel_Mid_Period_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Business_Review__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Mid-Period Business Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Obsolete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_Business_Review__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>R5 - Rule to update the Channel Mid-Period Business Review Detail layout</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

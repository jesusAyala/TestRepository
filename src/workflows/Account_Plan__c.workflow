<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Plan_Approval</fullName>
        <description>Account Plan Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Account_Plan_Record_Submit_For_Approval</template>
    </alerts>
    <alerts>
        <fullName>Account_Plan_Approved</fullName>
        <description>Account Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Account_Plan_Record_Approved</template>
    </alerts>
    <alerts>
        <fullName>Account_Plan_Rejected</fullName>
        <description>Account Plan Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Account_Plan_Record_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
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
        <field>Approver_Comments__c</field>
        <formula>&apos;Approved&apos;</formula>
        <name>Approved Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Details</fullName>
        <description>R5 - Rejected Details</description>
        <field>Approver_Comments__c</field>
        <formula>&apos;Rejected&apos;</formula>
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
        <fullName>Status_Update1</fullName>
        <description>R5 - Status Update</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update2</fullName>
        <description>R5 - Status Update</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_RT_to_Freeze_Budget</fullName>
        <description>R5 - To update record type to open when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Freeze_Budget</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed RT to Freeze Budget</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Record_Type</fullName>
        <description>R5 - To update record type to closed when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Account_Plan_Closed_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Master_Closed_Record_Type</fullName>
        <description>R5 - To update record type to closed when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Account_Plan_Closed_Page</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Master_Open_Record_Type</fullName>
        <description>R5 - To update record type to open when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Account_Plan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Open Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Closed_Record_Type</fullName>
        <description>R5 - To update record type to closed when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Account_Support_Plan_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Open_Record_Type</fullName>
        <description>R5 - To update record type to open when the status changes.</description>
        <field>RecordTypeId</field>
        <lookupValue>Account_Support_Plan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Open Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Unique_Account_Plan_Check</fullName>
        <description>R5 - Concatenate fields for duplicate check of Support Plan.</description>
        <field>Unique_Account_Plan_Check__c</field>
        <formula>Account__c  &amp; Name &amp; RecordType.Name &amp; TEXT( Account_Plan_Year__c ) &amp;  BU__c  &amp;  PG__c  &amp;  Product_Lines__c  &amp;  DIV__c</formula>
        <name>Update Unique Account Plan Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Unique_Master_Plan_Check</fullName>
        <description>R5 - Concatenate fields for duplicate check of Master Plan.</description>
        <field>Unique_Account_Plan_Check__c</field>
        <formula>Account__c  &amp; RecordType.Name  &amp; TEXT(Account_Plan_Year__c )</formula>
        <name>Update Unique Master Plan Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Freeze Budget Account Plan Closed Rule</fullName>
        <actions>
            <name>Update_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Freeze Budget</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>R5 - Rule to update the Master Plan closed layout when the Status is changed to Closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Freeze Budget Account Plan Open Rule</fullName>
        <actions>
            <name>Update_Closed_RT_to_Freeze_Budget</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Master Plan Closed Page</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Planning,Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Freeze_Account_Plan_Budgets__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>R5 - Rule to update the Master Plan open layout when the Status is changed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Master Account Plan Closed Rule</fullName>
        <actions>
            <name>Update_Master_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Master Account Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>R5 - Rule to update the Master Plan closed layout when the Status is changed to Closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Master Account Plan Open Rule</fullName>
        <actions>
            <name>Update_Master_Open_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Master Plan Closed Page</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Planning,Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Freeze_Account_Plan_Budgets__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>R5 - Rule to update the Master Plan open layout when the Status is changed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Support Account Plan Closed Rule</fullName>
        <actions>
            <name>Update_Support_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sub Account Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>R5 - Rule to update the Support Plan closed layout when the Status is changed to Closed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Support Account Plan Open Rule</fullName>
        <actions>
            <name>Update_Support_Open_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Support Plan Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Planning,Approved</value>
        </criteriaItems>
        <description>R5 - Rule to update the Support Plan open layout when the Status is changed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unique Master Account Plan Rule</fullName>
        <actions>
            <name>Update_Unique_Master_Plan_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Master Account Plan</value>
        </criteriaItems>
        <description>R5 - Duplicate check for creating Unique Master Plan record.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unique Support Account Plan Rule</fullName>
        <actions>
            <name>Update_Unique_Account_Plan_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sub Account Plan</value>
        </criteriaItems>
        <description>R5 - Duplicate check for creating Unique Support Plan record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

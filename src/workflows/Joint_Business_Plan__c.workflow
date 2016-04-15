<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Joint_Business_Plan_Approved</fullName>
        <description>Joint Business Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Joint_Business_Plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>Joint_Business_Plan_Record_Approval</fullName>
        <description>Joint Business Plan Record Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Joint_Business_Plan_Record_Submit_For_Approval</template>
    </alerts>
    <alerts>
        <fullName>Joint_Business_Plan_Rejected</fullName>
        <description>Joint Business Plan Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ABB_Account_Templates_R5/Joint_Business_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Status_to_Draft</fullName>
        <description>R5: Change the status to &apos;Draft&apos;</description>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Update Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ABB_Overview_Update</fullName>
        <description>R5-Updating the ABB overview Must have filed value</description>
        <field>ABB_Overview_Info__c</field>
        <formula>IF(LEN(ABB_Overview__c) &lt; 1  , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>ABB Overview Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Co_Operation_Overview_1_Update</fullName>
        <description>R5 - Updating the Co-Operation Overview 1 Must have field value</description>
        <field>Co_operation_Overview_1_Info__c</field>
        <formula>IF(LEN( Co_operation_Overview_1__c ) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Co-Operation Overview 1 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Co_Operation_Overview_2_Update</fullName>
        <description>R5 - Updating the Co-Operation Overview 2 Must have filed value</description>
        <field>Co_operation_Overview_2_Info__c</field>
        <formula>IF(LEN( Co_operation_Overview_2__c ) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Co-Operation Overview 2 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Company_Strategy_Update</fullName>
        <description>R5-Updating the Company Strategy Update Must have filed value</description>
        <field>Company_strategy__c</field>
        <formula>IF(LEN(	Company_strategy__c) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Company Strategy Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JBPUpdate_Information_Sharing_Must_Have</fullName>
        <description>R5 - Updating Information sharing info field</description>
        <field>Information_Sharing_Info__c</field>
        <formula>IF(LEN(Information_Sharing__c) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>JBPUpdate Information Sharing Must Have</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Logistics_Update</fullName>
        <description>R5 - Updating the Logistics Must have field value</description>
        <field>Logistics_Info__c</field>
        <formula>IF(LEN(  Logistics__c  ) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Logistics Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Sales_Warranties_Info_update</fullName>
        <description>R5- updating Sales Warranties Info update as &quot;Must Have&quot;</description>
        <field>After_Sales_and_Warranties_Info__c</field>
        <formula>IF(LEN(After_sales_and_warranties__c) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Sales Warranties Info update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_Name</fullName>
        <description>R5 - Approver Name</description>
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
        <fullName>Training_and_Authorization_Plan_Info</fullName>
        <description>R5- Update &quot;training and Authorisation Plan Info value as Must Have</description>
        <field>Training_and_Authorization_Plan_Info__c</field>
        <formula>IF(LEN(Training_and_Authorization_Plan__c) &lt; 1 , &quot;Must Have&quot;, &quot;&quot;)</formula>
        <name>Training and Authorization Plan Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Mutually_Agreed_Checkbox</fullName>
        <description>R5 - Whenever the Joint Business Plan Start Date changes, then Mutually Agreed will be unchecked.</description>
        <field>Mutually_Agreed__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Mutually Agreed Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Record_Type</fullName>
        <description>R5 - Update Closed Record Type for Joint Business Plan</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Joint_Business_Plan</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Closed Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <description>R5 - Update Status to &quot;In Approval&quot;</description>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status1</fullName>
        <description>R5 - Update Status to &quot;Additional Details Required&quot;</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status2</fullName>
        <description>R5 - Update Status to &quot;Additional Details Required&quot;</description>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JBP Company Strategy Info Field Update</fullName>
        <actions>
            <name>Company_Strategy_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JBP Information Sharing info field update</fullName>
        <actions>
            <name>JBPUpdate_Information_Sharing_Must_Have</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 - rule to update Information Sharing info field as Must Have</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Joint Business Plan Checkbox Rule</fullName>
        <actions>
            <name>Uncheck_Mutually_Agreed_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5 - Whenever the Joint Business Plan Start Date changes, then Mutually Agreed will be unchecked.</description>
        <formula>ISCHANGED( End_Date__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Joint Business Rule Layout Rule</fullName>
        <actions>
            <name>Update_Closed_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Joint_Business_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Joint_Business_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Obsolete</value>
        </criteriaItems>
        <description>R5 - Joint Business Rule Layout Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update ABB Overview Must Have</fullName>
        <actions>
            <name>ABB_Overview_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Co-Operation Overview 1 Info</fullName>
        <actions>
            <name>Co_Operation_Overview_1_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Co-Operation Overview 2 Info</fullName>
        <actions>
            <name>Co_Operation_Overview_2_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Logistics Info</fullName>
        <actions>
            <name>Logistics_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Sales Warranties Must Have</fullName>
        <actions>
            <name>Sales_Warranties_Info_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 - Rule to update the value Must Have</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Training and Authorization Plan Must Have</fullName>
        <actions>
            <name>Training_and_Authorization_Plan_Info</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5- Rule to update the Must have value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

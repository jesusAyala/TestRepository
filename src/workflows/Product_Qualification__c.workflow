<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Product_Qualification_Approved</fullName>
        <description>Product Qualification Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Qualification_Record_Approved</template>
    </alerts>
    <alerts>
        <fullName>Product_Qualification_Initiative_Approved</fullName>
        <description>Product Qualification Initiative Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Qualification_Record_Approved</template>
    </alerts>
    <alerts>
        <fullName>Product_Qualification_Initiative_Rejected</fullName>
        <description>Product Qualification Initiative Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Qualification_Record_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Product_Qualification_Initiative_Submit_for_Approval</fullName>
        <description>Product Qualification Initiative Submit for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Product_Qualification_Record_Submit_For_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Date_Details</fullName>
        <description>R4 Approved Date Details used in Approval process</description>
        <field>Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Approved Date Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Details</fullName>
        <field>Approval_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approved Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Details</fullName>
        <description>R4 Rejected Details</description>
        <field>Approval_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Rejected Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Actual_End_Date</fullName>
        <description>R4-This Field Update will be used to capture the current data whenever the initiative status is closed not qualified or closed qualified</description>
        <field>Actual_End_Date__c</field>
        <formula>Today()</formula>
        <name>Set Actual End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Actual_End_Date_in_PRD_Qual</fullName>
        <description>R4 Set Actual End Date in PRD Qual</description>
        <field>Actual_End_Date__c</field>
        <formula>Today()</formula>
        <name>Set Actual End Date in PRD Qual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Actual_End_date_in_PQ</fullName>
        <description>R4 Set Actual End date in Product Qualification</description>
        <field>Actual_End_Date__c</field>
        <formula>Today()</formula>
        <name>Set Actual End date in PQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approver_Name</fullName>
        <description>R4- Set Approver Name from the Approval Process</description>
        <field>ApproverName__c</field>
        <formula>$User.FirstName +&quot;  &quot;+  $User.LastName</formula>
        <name>Set Approver Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initiative_Status</fullName>
        <description>R4 - This Field Update will be used to automatically set the status to closed qualified whenever the qualification level reaches to +2</description>
        <field>Initiative_Status__c</field>
        <literalValue>Closed Qualified</literalValue>
        <name>Set Initiative Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initiative_Status_to_Qualified</fullName>
        <description>R4 Set Initiative Status to closed Qualified If the level is +3</description>
        <field>Initiative_Status__c</field>
        <literalValue>Closed Qualified</literalValue>
        <name>Set Initiative Status to Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PQ_RecordType_Closed_Qualified</fullName>
        <description>R4 Update PQ RecordType Closed Qualified</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Qualified</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update PQ RecordType Closed Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PQ_Record_Type_Closed</fullName>
        <description>R4 Update the PQ Record_Type to Closed</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Qualified</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update PQ Record Type Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PQ_Record_Type_Closed_NQ</fullName>
        <description>R4 Update the PQ Record_Type to Closed Not Qualified</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Not_Qualified_Layout</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update PQ Record Type Closed NQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PQ_Record_Type_Closed_Qualified</fullName>
        <description>R4 Update PQ Record Type Closed Qualified</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Qualified</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update PQ Record Type Closed Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Initiative Status to Qualified</fullName>
        <actions>
            <name>Update_PQ_Record_Type_Closed_Qualified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product_Qualification__c.Initiative_Status__c</field>
            <operation>equals</operation>
            <value>Closed Qualified</value>
        </criteriaItems>
        <description>R4- This Workflow will be used to automatically set the status to closed qualified whenever the qualification level reaches to +3</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type PQ Closed Not Qualified</fullName>
        <actions>
            <name>Update_PQ_Record_Type_Closed_NQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product_Qualification__c.Initiative_Status__c</field>
            <operation>equals</operation>
            <value>Closed Not Qualified</value>
        </criteriaItems>
        <description>R4 Update the page layout to Closed Qualified When the Status changed to Closed Not Qualified</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

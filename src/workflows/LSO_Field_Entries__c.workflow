<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LSOFieldEntries_ERP_DupeCheck_FldUpd</fullName>
        <field>ERP_Unique__c</field>
        <formula>LSO_Pick_List_Value_Name__c &amp; PickList_Code__c &amp; text(Country__c)&amp; RecordType.Name</formula>
        <name>LSOFieldEntries_ERP_DupeCheck_FldUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LSOFieldEntries_Manual_DupeCheck_FldUpd</fullName>
        <field>Manual_Unique__c</field>
        <formula>LSO_Pick_List_Value_Name__c &amp; PickList_Code__c &amp; text(Country__c)&amp; Value__c&amp; RecordType.Name</formula>
        <name>LSOFieldEntries_Manual_DupeCheck_FldUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LSOFieldEntries_ERP_DupeCheck</fullName>
        <actions>
            <name>LSOFieldEntries_ERP_DupeCheck_FldUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LSO_Field_Entries__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LSO ERP Picklist Entries</value>
        </criteriaItems>
        <description>R4 Workflow field Update - Update the value Unique check on LSO Field Entries object for ERP Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LSOFieldEntries_Manual_DupeCheck</fullName>
        <actions>
            <name>LSOFieldEntries_Manual_DupeCheck_FldUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LSO_Field_Entries__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LSO Manual Picklist Entries</value>
        </criteriaItems>
        <description>R4 Workflow field Update - Update the value Unique check on LSO Field Entries object for Manual Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

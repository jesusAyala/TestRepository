<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LSO_Record_Unique_Check</fullName>
        <description>R3 - Workflow Field update - Concatenate the field values of Account ID, Country__c, LBU, LSO,</description>
        <field>LSODataNonBuying_Unique__c</field>
        <formula>Account__r.Id &amp; Text(Country__c) &amp; LBU__c &amp; LSO__c&amp; Local_Customer_ID__c</formula>
        <name>LSO Record Unique Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LSO Record Unique Check</fullName>
        <actions>
            <name>LSO_Record_Unique_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Reference_Data__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>R3 - Workflow Field update - Concatenate the field values of Account ID, Country, Division,  LSO and LBU.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ERPMapping_DupeChek_FldUpd</fullName>
        <description>R3v1 - ERP Mapping Dupe Check</description>
        <field>ERPMapping_Unique__c</field>
        <formula>ERP_ID__c &amp; Text(SAP_Sales_Organization__c) &amp; Text(SAP_Distribution_Channel__c) &amp; Text(SAP_Division__c) &amp; LBU__c &amp; LSO__c</formula>
        <name>ERPMapping_DupeChek_FldUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ERPMapping_DupeCheck</fullName>
        <actions>
            <name>ERPMapping_DupeChek_FldUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ERP_Mapping__c.ERP_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R3v1 - MRPMapping Dupe Check</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

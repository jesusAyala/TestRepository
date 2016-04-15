<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_Competitors_Value</fullName>
        <description>R5 - will update the Unique Competitors Value</description>
        <field>Unique_Competitors_Value__c</field>
        <formula>Joint_Business_Plan__c+Main_Competitors__c</formula>
        <name>Update Unique Competitors Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Channel Business Plan Competitor Unique Check</fullName>
        <actions>
            <name>Update_Unique_Competitors_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5 - Rule to check the Competitor Unique value in Channel Business Plan</description>
        <formula>ISNEW() ||  ISCHANGED(Main_Competitors__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

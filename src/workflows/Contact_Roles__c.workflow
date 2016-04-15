<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Unique_Contact_Check</fullName>
        <description>R5 - Update Unique Contact Check</description>
        <field>Unique_Contact_Check__c</field>
        <formula>Account_Plan__c  &amp;   Contact__c</formula>
        <name>Update Unique Contact Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Contact Role Check</fullName>
        <actions>
            <name>Update_Unique_Contact_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Roles__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 - Unique Contact Role Check</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

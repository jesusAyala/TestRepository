<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Unique_Team_Member_Check</fullName>
        <description>R5 Worflow field update to check the duplicate User in the Channel Pre-Qualification Team.</description>
        <field>Unique_User_Check__c</field>
        <formula>Channel_Pre_Qualification__c  &amp;  User__c</formula>
        <name>Unique Team Member Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Team Member Check</fullName>
        <actions>
            <name>Unique_Team_Member_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Pre_Qualification_Team__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 Workflow rule to check the duplicate User in the Channel Pre-Qualification Team members List.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

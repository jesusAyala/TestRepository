<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Actual_End_Date</fullName>
        <description>R5 - Update Actual End Date</description>
        <field>Actual_End_Date__c</field>
        <formula>IF( OR(ISPICKVAL( Status__c , &quot;Completed&quot;), ISPICKVAL( Status__c , &quot;Cancelled&quot;)) , TODAY() , NULL)</formula>
        <name>Update Actual End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Actual End Date</fullName>
        <actions>
            <name>Update_Actual_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Actions__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Actions__c.Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>R5 - Update Actual End Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

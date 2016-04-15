<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Actual_End_Date</fullName>
        <description>R5 - Update Actual End Date</description>
        <field>Actual_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Actual End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JBP Actions Actual End Date Rule</fullName>
        <actions>
            <name>Update_Actual_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan_Actions__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed,Cancelled</value>
        </criteriaItems>
        <description>R5 - Joint Business Plan Actions Actual End Date Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Product_Group_Number</fullName>
        <description>Created as part of R5-2343 to store the value copied from Product Group Temp</description>
        <field>Product_Group_Number__c</field>
        <formula>Product_Group_Temp__c</formula>
        <name>Update Product Group Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Proudct Group Number</fullName>
        <actions>
            <name>Update_Product_Group_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as part of R5-2343 to store the value copied from Product Group Temp</description>
        <formula>TRUE &amp;&amp; (Deleted__c  = false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

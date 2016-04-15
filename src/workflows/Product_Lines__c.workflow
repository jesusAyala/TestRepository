<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Unique_Product_Lines_Check</fullName>
        <description>R5 Duplicate check in Product Lines and Contact</description>
        <field>Unique_Product_Check__c</field>
        <formula>Product__c  &amp;  Contact__c</formula>
        <name>Unique Product Lines Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Check Product Lines</fullName>
        <actions>
            <name>Unique_Product_Lines_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product_Lines__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 Workflow Rule for duplicate check in Product Lines and Contact</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

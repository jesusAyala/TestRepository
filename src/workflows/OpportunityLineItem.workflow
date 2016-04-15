<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Product_Group_from_Product</fullName>
        <description>R3v1 - Update Product Group from Product</description>
        <field>Product_Group__c</field>
        <formula>Product2.Product_Group__c</formula>
        <name>Update Product Group from Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Product Group of Opportunity Product</fullName>
        <actions>
            <name>Update_Product_Group_from_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R3v1 - Set Product Group of Opportunity Product from Product&apos;s PG</description>
        <formula>Product2Id &lt;&gt; NULL</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

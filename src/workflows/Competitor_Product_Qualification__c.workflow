<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_the_Unique_Check_Field_Competitor</fullName>
        <description>R4 Concatenate the field Product Qualification Id and Account ID</description>
        <field>Unique_Check__c</field>
        <formula>Product_Qualification__c  &amp;  Account__c</formula>
        <name>Update the Unique Check Field Competitor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Check Competitor</fullName>
        <actions>
            <name>Update_the_Unique_Check_Field_Competitor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Competitor_Product_Qualification__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R4 Workflow field Update - Update the value Unique check on Competitor Object</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

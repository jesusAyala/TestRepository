<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_the_Unique_Check_FieldContactRole</fullName>
        <description>R4 Concatenate the field Product Qualification Id and Conatct ID</description>
        <field>Unique_Check__c</field>
        <formula>Product_Qualification__c  &amp;  Contact__c</formula>
        <name>Update the Unique Check FieldContactRole</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Check Contact Role</fullName>
        <actions>
            <name>Update_the_Unique_Check_FieldContactRole</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Role__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R4 Workflow field Update - Update the value Unique check on Contact Role Object</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

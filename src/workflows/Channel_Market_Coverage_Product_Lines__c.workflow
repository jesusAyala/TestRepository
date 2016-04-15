<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Unique_ChannelMarCoverageProdLine_Check</fullName>
        <description>R5 - Duplicate check in Channel Market Coverage Product Lines and Channel Market Coverage.</description>
        <field>Unique_Product_Check__c</field>
        <formula>Product__c  &amp;  Channel_Market_Coverage__c</formula>
        <name>Unique ChannelMarCoverageProdLine Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique Check Channel Market Coverage Product Line</fullName>
        <actions>
            <name>Unique_ChannelMarCoverageProdLine_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Channel_Market_Coverage_Product_Lines__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R5 - Workflow Rule for duplicate check in Channel Market Coverage Product Line and Channel Market Coverage.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

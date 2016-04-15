<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>APTS_Update_External_ID</fullName>
        <description>Update External ID</description>
        <field>APTS_External_ID__c</field>
        <formula>APTS_LP_SAP_Customer_ID__c +  TEXT(APTS_LP_Sales_Organisation__c) +  TEXT(APTS_LP_Distribution_Channel__c)</formula>
        <name>Update External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APTS_CreateExternalID1_WF</fullName>
        <actions>
            <name>APTS_Update_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>APTS_LP_Local_Customer_Reference_Data__c.APTS_LP_SAP_Customer_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>APTS_LP_Local_Customer_Reference_Data__c.APTS_LP_Distribution_Channel__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>APTS_LP_Local_Customer_Reference_Data__c.APTS_LP_Sales_Organisation__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Creates an External ID -- CustomerID + sales Org + Distribution Channel</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

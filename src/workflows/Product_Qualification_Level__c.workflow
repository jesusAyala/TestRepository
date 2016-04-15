<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_PQL_Record_Type_Closed_NQ</fullName>
        <description>R4 Update PQL Record Type Closed NQ</description>
        <field>RecordTypeId</field>
        <lookupValue>Product_Qualification_Level_Closed_NQ</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update PQL Record Type Closed NQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_PQ_Level_Closed</fullName>
        <description>R4 Update the record type to Product_Qualification_Level_Closed When the Level reached +2</description>
        <field>RecordTypeId</field>
        <lookupValue>Product_Qualification_Level_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type PQ Level Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update PQL Record Type Closed NQ</fullName>
        <actions>
            <name>Update_PQL_Record_Type_Closed_NQ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product_Qualification__c.Initiative_Status__c</field>
            <operation>equals</operation>
            <value>Closed Not Qualified</value>
        </criteriaItems>
        <description>R4 Update PQL Record Type Closed NQ</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Record Type Product Qualification Level Closed</fullName>
        <actions>
            <name>Update_Record_Type_PQ_Level_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Product_Qualification__c.Initiative_Status__c</field>
            <operation>equals</operation>
            <value>Closed Qualified</value>
        </criteriaItems>
        <description>R4 Update the record type to Product_Qualification_Level_Closed When the Level reached +2</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

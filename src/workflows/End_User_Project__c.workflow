<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>End_User_Project_Approved_Alert</fullName>
        <description>End User Project Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EndUserProject_Approved_Alert2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Project_RT_to_Closed</fullName>
        <description>When an End User Project is Closed / Cancelled change Page Layout (no new Opportunities)</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Project RT to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Project_RT_to_Default</fullName>
        <description>When an End User Project is not Closed / Cancelled change to default Page Layout (new Opportunities available)</description>
        <field>RecordTypeId</field>
        <lookupValue>Default</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Project RT to Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Change Project RT to Closed</fullName>
        <actions>
            <name>Change_Project_RT_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>End_User_Project__c.End_User_Project_Status__c</field>
            <operation>equals</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <description>Changes RT of Project to Closed Page Layout</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Project RT to Default</fullName>
        <actions>
            <name>Change_Project_RT_to_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>End_User_Project__c.End_User_Project_Status__c</field>
            <operation>notEqual</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <description>Changes RT of Project to Default Page Layout</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

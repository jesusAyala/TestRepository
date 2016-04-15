<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Account_Plan_Year_Unique</fullName>
        <description>R5 - to update Account Plan year Unique field</description>
        <field>Account_Plan_Year_Unique__c</field>
        <formula>Account_Plan__c + TEXT(Account_Plan_Year__c)</formula>
        <name>Update Account Plan Year Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Date_End_Date</fullName>
        <field>Start_Date_End_Date__c</field>
        <formula>TEXT(Start_Date__c) &amp; TEXT(End_Date__c)</formula>
        <name>Update Start Date &amp; End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account Plan Year Uniqueness</fullName>
        <actions>
            <name>Update_Account_Plan_Year_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5 - Req #	1711 (To make Account Plan Year as Unique)</description>
        <formula>ISNEW() || ISCHANGED(Account_Plan_Year__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Popultate Start Date and End Date</fullName>
        <actions>
            <name>Update_Start_Date_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5: Req # 1707</description>
        <formula>ISNEW() || (ISCHANGED( Start_Date__c ) || ISCHANGED(  End_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

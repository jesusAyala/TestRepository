<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Freeze_Budget_Record_Type</fullName>
        <description>R5 - Change the record type to Freeze Budget when the Status is Active.</description>
        <field>RecordTypeId</field>
        <lookupValue>Freeze_Budget</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Freeze Budget Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Open_Record_Type</fullName>
        <description>R5 - Update Open Record Type</description>
        <field>RecordTypeId</field>
        <lookupValue>Joint_Business_Plan_Product_Lines</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Open Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Year_and_Product</fullName>
        <field>Starting_Year_Product__c</field>
        <formula>Joint_Business_Plan__c + TEXT(Starting_Year__c )+ Product__c</formula>
        <name>Update Start Year and Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Joint Business Plan Product Lines Freeze Budget Layout Rule</fullName>
        <actions>
            <name>Update_Freeze_Budget_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>R5 - Whenever status changes to active, then update to Freeze Budget record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Joint Business Plan Product Lines Open Layout Rule</fullName>
        <actions>
            <name>Update_Open_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Joint_Business_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Draft,In Approval,Closed</value>
        </criteriaItems>
        <description>R5 - Whenever status changes to draft/in approval/closed, then update to Open record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <!--rules>
        <fullName>JBP Product Lines Date Rule</fullName>
        <actions>
            <name>Update_Actual_Year_to_Date_Changed_on</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>R5 - Whenever the Current Ongoing Year of Joint Business Plan Product Lines changes, then capture the date on the field called as &quot;Actual Year to Date Changed on&quot;.</description>
        <formula>ISCHANGED( Current_Ongoing_Year__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules-->
    <rules>
        <fullName>Starting Year %26 Product Unique</fullName>
        <actions>
            <name>Update_Start_Year_and_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5 - To populate Starting Year &amp; Product (Unique check)</description>
        <formula>ISNEW() || ( ISCHANGED( Starting_Year__c ) ||  ISCHANGED( Product__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

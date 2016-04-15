<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Mail_Opt_Out</fullName>
        <description>This update sets the mail opt out in the contact, when the field Preferred Contact Method is set to &quot;Do not contact&quot;</description>
        <field>Mail_Opt_Out__c</field>
        <literalValue>1</literalValue>
        <name>Check Mail Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Do Not Contact</fullName>
        <actions>
            <name>Check_Email_Opt_Out2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Check_Fax_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Check_Mail_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Check_Phone_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Check all the opt out checkboxes, when the Preferred Contact Method is &quot;Do Not Contact&quot;.</description>
        <formula>ISPICKVAL( Preferred_Contact_Method__c , &quot;Do Not Contact&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

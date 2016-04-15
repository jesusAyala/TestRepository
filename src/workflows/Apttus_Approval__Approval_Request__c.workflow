<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Reset_trigger</fullName>
        <description>Reset trigger flag when comments have been entered for an approval request without actually approving or rejecting request.</description>
        <field>Apttus_Approval__Workflow_Trigger_Added_Comments__c</field>
        <literalValue>0</literalValue>
        <name>Reset trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval Request Comments Modified</fullName>
        <actions>
            <name>Reset_trigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Approval__Approval_Request__c.Apttus_Approval__Workflow_Trigger_Added_Comments__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Workflow rule that fires when an approval request has had comments added without actually approving or rejecting the request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Apttus_Approval__Approval Request Comments Modified</fullName>
        <actions>
            <name>Apttus_Approval__ApprovalRequestCommentsEntered</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Apttus_Approval__Resettrigger</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Apttus_Approval__Approval_Request__c.Apttus_Approval__Workflow_Trigger_Added_Comments__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Workflow rule that fires when an approval request has had comments added without actually approving or rejecting the request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

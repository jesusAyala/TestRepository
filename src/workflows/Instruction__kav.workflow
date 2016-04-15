<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Instruction_Article_Expiration_Email_Alert</fullName>
        <description>Instruction Article Expiration Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Instruction_Article_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>KB_Approved_Instruction_article</fullName>
        <description>KB Approved Instruction article</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Article_Approved_Instruction</template>
    </alerts>
    <alerts>
        <fullName>KB_Reject_Instruction_article1</fullName>
        <description>KB Reject Instruction article</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Article_Reject_Instruction</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Was_Sent_for_Approval</fullName>
        <field>Was_Sent_for_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Update Was Sent for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Instruction Article Expiration</fullName>
        <active>true</active>
        <description>Notify about Instruction Article has Expired one hour after the article is expired.</description>
        <formula>AND(NOT(ISNULL(Expiry_Date__c)),IsLatestVersion)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Instruction_Article_Expiration_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Instruction__kav.Expiry_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>

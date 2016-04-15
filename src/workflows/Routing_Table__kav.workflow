<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>KB_Approve_Routing_Table_article</fullName>
        <description>KB Approve Routing Table article</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Article_Approved_Routing_Table</template>
    </alerts>
    <alerts>
        <fullName>KB_Reject_Routing_Table_article</fullName>
        <description>KB Reject Routing Table article</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Article_Reject_Routing_Table</template>
    </alerts>
    <alerts>
        <fullName>Routing_Table_Article_Expiration_Email_Alert</fullName>
        <description>Routing Table Article Expiration Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Routing_Table_Article_Expiration_Notification</template>
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
        <fullName>Notify Routing Table Article Expiration</fullName>
        <active>true</active>
        <description>Notify about Routing Table Article has Expired one hour after the article is expired.</description>
        <formula>AND(NOT(ISNULL(Expiry_Date__c)),IsLatestVersion)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Routing_Table_Article_Expiration_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Routing_Table__kav.Expiry_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>

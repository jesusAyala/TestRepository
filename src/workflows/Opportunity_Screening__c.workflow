<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Opportunity_Screening_Approved_Alert</fullName>
        <description>Opportunity Screening Approved Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Opportunity_Screening_Approved_Alert2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status</fullName>
        <description>R5 Approval OOTB &amp; AWA</description>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status for Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Aprproval_Status</fullName>
        <description>R5 approval process AWA &amp; OOTB</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Aprproval Status for Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Screening_Approved</fullName>
        <description>R4 - Opportunity Screening Approved</description>
        <field>IsApproved__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity Screening Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Screening_Unapproved</fullName>
        <description>R4 - Opportunity Screening Unapproved</description>
        <field>IsApproved__c</field>
        <literalValue>0</literalValue>
        <name>Opportunity Screening Unapproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revoke_Manual_Approval</fullName>
        <description>After Manual approval completion the checkbox will be unchecked.</description>
        <field>Manual_Approval_Required__c</field>
        <literalValue>0</literalValue>
        <name>Revoke Manual Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <description>Update Approval Status to &apos;Submitted&apos;</description>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>

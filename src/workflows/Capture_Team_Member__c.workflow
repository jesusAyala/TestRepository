<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Capture_Team_Member_Email</fullName>
        <description>R4 - Capture Team Member Action</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Capture_Team_Member</template>
    </alerts>
    <rules>
        <fullName>Capture Team Member Email</fullName>
        <actions>
            <name>Capture_Team_Member_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Capture_Team_Member__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>R4 - Capture Team Member Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

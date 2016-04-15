<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetCancellationDatetoNOW</fullName>
        <field>Apttus_Approval__Cancellation_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Cancellation Date to NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cancellation_Date_to_Null</fullName>
        <field>Apttus_Approval__Cancellation_Date__c</field>
        <name>Set Cancellation Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Effective_Date_to_Null</fullName>
        <description>Set Effective Date to Null</description>
        <field>Apttus_Approval__Effective_Date__c</field>
        <name>Set Effective Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Expiration_Date_to_Null</fullName>
        <field>Apttus_Approval__Expiration_Date__c</field>
        <name>Set Expiration Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Effect_Flag_to_False</fullName>
        <field>Apttus_Approval__InEffect__c</field>
        <literalValue>0</literalValue>
        <name>Set In Effect Flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_In_Effect_Flag_to_True</fullName>
        <description>Set In Effect Flag to True</description>
        <field>Apttus_Approval__InEffect__c</field>
        <literalValue>1</literalValue>
        <name>Set In Effect Flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Is_Active_to_False</fullName>
        <field>Apttus_Approval__IsActive__c</field>
        <literalValue>0</literalValue>
        <name>Set Is Active to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APTS Cancel Backup on Expiration Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__InEffect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Backup/Delegate Approver - Cancel Backup on Expiration Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>SetCancellationDatetoNOW</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Effective_Date_to_Null</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Expiration_Date_to_Null</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_In_Effect_Flag_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Is_Active_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Backup_Approver__c.Apttus_Approval__Expiration_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>APTS_Set In Effect on Effective Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__InEffect__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Approval__Backup_Approver__c.Apttus_Approval__IsActive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Backup/Delegate Approver- Set In Effect on Effective Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Cancellation_Date_to_Null</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Effective_Date_to_Null</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_In_Effect_Flag_to_True</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Apttus_Approval__Backup_Approver__c.Apttus_Approval__Effective_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>

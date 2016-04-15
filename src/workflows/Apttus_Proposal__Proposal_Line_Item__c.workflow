<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata"> 
<fieldUpdates>
        <fullName>APTS_Change_Product_is_GTV_Product_to_Tr</fullName>
        <description>When Product is Hierarchy = True then Change Product is GTV Product to True.</description>
        <field>APTS_Product_is_GTV_Product__c</field>
        <literalValue>1</literalValue>
        <name>Change Product is GTV Product to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Update_Hierarchy_Level_3_Code_text</fullName>
        <field>APTS_Hierarchy_Level_3_Code_text__c</field>
        <formula>APTS_Hierarchy_Level_3_Code__c</formula>
        <name>Update Hierarchy Level 3 Code text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APTS Change Product is GTV Product to True</fullName>
        <actions>
            <name>APTS_Change_Product_is_GTV_Product_to_Tr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Product_Is_Hierarchy__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When Product is hierarchy equal to True then update Product is GTV Product to True.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Update Hierarchy Level 3 Code text</fullName>
        <actions>
            <name>APTS_Update_Hierarchy_Level_3_Code_text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Proposal__Proposal_Line_Item__c.APTS_Hierarchy_Level_3_Code__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

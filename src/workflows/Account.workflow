<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Incomplete_Account_Update_Request_to_Owner</fullName>
        <description>Incomplete Account - Update Request to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Incomplete</template>
    </alerts>
    <fieldUpdates>
        <fullName>Bring_Default_Account_Layout</fullName>
        <description>Changes record type to read/write on Accounts (Default)</description>
        <field>RecordTypeId</field>
        <lookupValue>Default</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Bring Default Account Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bring_Family_Tree_Level</fullName>
        <field>Site</field>
        <formula>TEXT(Family_Tree_Level__c)</formula>
        <name>Bring Family Tree Level</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bring_GIS_Approved_Account_Layout</fullName>
        <description>Changes record type to &quot;GIS Approved&quot; on Accounts</description>
        <field>RecordTypeId</field>
        <lookupValue>GIS_Approved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Bring GIS Approved Account Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Bring_Read_Only_Account_Layout</fullName>
        <description>Set the record type to &quot;Read Only&quot; on Accounts</description>
        <field>RecordTypeId</field>
        <lookupValue>Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Bring Read Only Account Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>data.migration@abb.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change record Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Technical_Incomplete_Date</fullName>
        <description>Reset Technical Incomplete Date to NULL</description>
        <field>Technical_Incomplete_Date__c</field>
        <name>Reset Technical Incomplete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resubmit_Account_for_GIS_Approval</fullName>
        <description>Resubmit Account for GIS Approval after update of Account Name and/or Address --&gt; Company Status &quot;Open&quot;</description>
        <field>Company_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Resubmit Account for GIS Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_to_Rejected</fullName>
        <description>Set the account to Company Status &quot;Rejected&quot; after 14 days</description>
        <field>Company_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Account to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Active_flag_to_False</fullName>
        <description>Sets the checkbox &quot;Active&quot; to false</description>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Set Active flag to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Active_flag_to_True</fullName>
        <description>If the record type of account is set to Default, set the checkbox Active to True</description>
        <field>Active__c</field>
        <literalValue>1</literalValue>
        <name>Set Active flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_current_date_on_Technical_Incomplete</fullName>
        <description>Set current date on Technical Incomplete Date field</description>
        <field>Technical_Incomplete_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set current date on Technical Incomplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Short_Name</fullName>
        <field>Account_Short_Name__c</field>
        <formula>LEFT(Name, 100)</formula>
        <name>Update Short Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_Channel_Class</fullName>
        <description>created as part of R5 2280</description>
        <field>Channel_Class_Level1__c</field>
        <literalValue>ABBINT</literalValue>
        <name>set Channel Class</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Get Family Tree Level</fullName>
        <actions>
            <name>Bring_Family_Tree_Level</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule will transcribe the value of the field Family_Tree_Level__c into the field Site (now renamed as Level). This information will be then available in the Account Hierarchy view only!</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification Account Owner Incomplete</fullName>
        <actions>
            <name>Incomplete_Account_Update_Request_to_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send a notification to account owner when an account was set to incomplete.</description>
        <formula>AND(  ISPICKVAL(Company_Status__c, &quot;Incomplete&quot;),  NOT( ISCHANGED( Name ) ),   NOT( ISCHANGED( BillingCity ) ),  NOT( ISCHANGED( BillingCountry ) ),  NOT( ISCHANGED( BillingState ) ),  NOT( ISCHANGED( BillingStreet ) ),  NOT( ISCHANGED( BillingState ) ),  NOT( ISCHANGED( BillingPostalCode ) ),  NOT( OR( RecordType.DeveloperName = &quot;ABB_ICV&quot;, RecordType.DeveloperName = &quot;External_Non_Buying_Account&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pre-populate Short Name</fullName>
        <actions>
            <name>Update_Short_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is to ensure that every new Account record has always a default Short Name. This is a requirement for the Account Change functionality that has been implemented, via a Flow.</description>
        <formula>ISBLANK(Account_Short_Name__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Re-Set Account Approved</fullName>
        <actions>
            <name>Set_Active_flag_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Active__c = FALSE,  ISCHANGED( Company_Status__c ), TEXT(Company_Status__c)= &quot;Approved&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reject Incomplete Account after 14 days</fullName>
        <actions>
            <name>Set_Account_to_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Deactivate an account after being &quot;Incomplete&quot; for 14 days.</description>
        <formula>IF(  AND(    ISPICKVAL( Company_Status__c , &quot;Incomplete&quot;),    Technical_Incomplete_Date__c  &lt;  TODAY()-14,    NOT( OR( RecordType.DeveloperName = &quot;ABB_ICV&quot;, RecordType.DeveloperName = &quot;External_Non_Buying_Account&quot;))  ),  True, False )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Account.Technical_Incomplete_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Reset Technical Incomplete Date</fullName>
        <actions>
            <name>Reset_Technical_Incomplete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_Status__c</field>
            <operation>notEqual</operation>
            <value>Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>ABB ICV,External non-buying Account</value>
        </criteriaItems>
        <description>Reset the current date on field Technical Incomplete Date when Company Status changes from &quot;Incomplete&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Resubmit Account for GIS Approval</fullName>
        <actions>
            <name>Resubmit_Account_for_GIS_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Resubmit Account (Company Status &quot;Incomplete&quot;) for GIS Approval after update of Account Name and/or Address --&gt; Company Status &quot;Open&quot;)</description>
        <formula>IF(  AND(   ISPICKVAL( Company_Status__c , &quot;Incomplete&quot;),   OR(     ISCHANGED( Name ),     ISCHANGED( BillingCity ),     ISCHANGED( BillingCountry ),     ISCHANGED( BillingState ),     ISCHANGED( BillingStreet ),     ISCHANGED( BillingPostalCode )   ),   NOT( OR( RecordType.DeveloperName = &quot;ABB_ICV&quot;, RecordType.DeveloperName = &quot;External_Non_Buying_Account&quot;))  ),  True, False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Channel Class for ICV Accounts</fullName>
        <actions>
            <name>set_Channel_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>ABB ICV</value>
        </criteriaItems>
        <description>created as part of R5 2280</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Technical Incomplete Date</fullName>
        <actions>
            <name>Set_current_date_on_Technical_Incomplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_Status__c</field>
            <operation>equals</operation>
            <value>Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Technical_Incomplete_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>ABB ICV,External non-buying Account</value>
        </criteriaItems>
        <description>Set the current date on field Technical Incomplete Date</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Show Default Account Layout</fullName>
        <actions>
            <name>Bring_Default_Account_Layout</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Active_flag_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_Status__c</field>
            <operation>equals</operation>
            <value>Open,Clearing,Incomplete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Read Only,GIS Approved,ABB ICV,External Non-Buying Account</value>
        </criteriaItems>
        <description>Changes the record type to Default on accounts in case &quot;Company Status&quot; is Open, Clearing or Incomplete</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Show GIS Approved Account Layout</fullName>
        <actions>
            <name>Bring_GIS_Approved_Account_Layout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>ABB ICV,External non-buying Account</value>
        </criteriaItems>
        <description>Changes the record type to &quot;GIS Approved&quot; on accounts in case &quot;Company Status&quot; is Approved</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Show Read Only Account Layout</fullName>
        <actions>
            <name>Bring_Read_Only_Account_Layout</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Active_flag_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_Status__c</field>
            <operation>equals</operation>
            <value>Out of Business,Duplicate,Not a Legal Entity,Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Read Only,ABB ICV,External Non-Buying Account</value>
        </criteriaItems>
        <description>Changes the Account Record Type to &quot;Read Only&quot; if &quot;Account Status&quot; is Out of Business,Duplicate,Not a Legal Entity,Rejected</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Submit NEW Account for Clearance</fullName>
        <actions>
            <name>Change_record_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_to_Main_Opportunity_Owner</fullName>
        <description>Alert to Main Opportunity Owner</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Alternative_Opportunity_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Notification_when_user_creating_Opportunity_from_ServIS</fullName>
        <description>Notification, when user creating Opportunity from ServIS</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Support_R5/Notify_Opportunity_Owner_and_Account_Team_member_from_ServIS</template>
    </alerts>
    <alerts>
        <fullName>Send_Customer_Feedback_Questionaire</fullName>
        <description>Send Customer Feedback Questionaire</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Customer_Feedback_Questionaire_Alert</template>
    </alerts>
    <alerts>
        <fullName>ServIS_Opportunity_Creation_Notification</fullName>
        <description>ServIS Opportunity Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Customer_Key_Account_Manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Support_R5/Notify_Opportunity_Owner_and_Key_Account_Manager</template>
    </alerts>
    <alerts>
        <fullName>Stage_Notification_on_Prospecting_and_30_Days_to_Close</fullName>
        <description>Stage Notification on Prospecting and 30 Days to Close</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Notification_Stage_Prospecting</template>
    </alerts>
    <fieldUpdates>
        <fullName>Consortium_Field_Update</fullName>
        <field>Consortium__c</field>
        <literalValue>No</literalValue>
        <name>Consortium Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Budget_Year_Update</fullName>
        <description>Updates the Budget Year with the year of the Expected Award Date</description>
        <field>Budget_Year__c</field>
        <formula>TEXT(YEAR(CloseDate))</formula>
        <name>Budget Year Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Class_and_Industry_FldUpd</fullName>
        <field>Channel_Class__c</field>
        <name>Class and Industry FldUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Create_new_Opportunity_Name</fullName>
        <description>Update of the opportunity name is case it is [auto-generated]</description>
        <field>Name</field>
        <formula>TEXT( Account.BillingCountryCode ) &amp; &quot;-&quot;
&amp;Account.Account_Short_Name__c</formula>
        <name>Create new Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Create_new_Unrelated_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Name  &amp; &apos;-&apos; &amp;  Specific_Opportunity_Info__c</formula>
        <name>Create new Unrelated Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Get_Main_Opportunity_Owner_Email</fullName>
        <description>Get the Main Opportunity Owner Email</description>
        <field>Owner_s_Email__c</field>
        <formula>Alternative_Opportunity_To__r.Owner.Email</formula>
        <name>Get Main Opportunity Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Large_Business</fullName>
        <description>The Opportunity value &gt; 15m.</description>
        <field>Large_Business__c</field>
        <literalValue>1</literalValue>
        <name>Large Business</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Qualification_Not_Required</fullName>
        <description>R4 - Opportunity Qualification Not Required Status update</description>
        <field>Opportunity_Qualification_Status__c</field>
        <literalValue>Not Required</literalValue>
        <name>Opportunity Qualification Not Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Qualification_Required</fullName>
        <description>R4 - Opportunity Qualification Required Status update</description>
        <field>Opportunity_Qualification_Status__c</field>
        <literalValue>Required</literalValue>
        <name>Opportunity Qualification Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordTypeSwitchtoCancelOpportunity</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CANCEL_OPPORTUNITY</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeSwitchtoCancelOpportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordTypeSwitchtoClosedOpportuntiy</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CLOSE_OPPORTUNITY</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeSwitchtoClosedOpportuntiy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordTypeSwitchtoInitial</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Initial</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeSwitchtoInitial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordTypeSwitchtoRegular</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Regular</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordTypeSwitchtoRegular</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Round_Probability</fullName>
        <description>Round up / down the user input for probability</description>
        <field>Probability</field>
        <formula>Round( Probability*10, 0 ) / 10</formula>
        <name>Round Probability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Commit_Timestamp</fullName>
        <description>When Commit checkbox is set this field is updated</description>
        <field>Commit_Set_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Commit Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Commit_User</fullName>
        <description>When Commit checkbox is set this field is updated</description>
        <field>Commit_Set_User__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp; $User.LastName</formula>
        <name>Set Commit User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opp_RecType_to_Fast_Regular</fullName>
        <description>Changes the record type to Regular</description>
        <field>RecordTypeId</field>
        <lookupValue>Regular</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Opp RecType to Fast Regular</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Opportunity_name_to_Auto_Generate</fullName>
        <field>Name</field>
        <formula>&quot;[auto-generated]&quot;</formula>
        <name>Set Opportunity name to Auto-Generate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RR_created_on</fullName>
        <description>Set the created date for RiskReview Doc ID to NOW</description>
        <field>RR_created_on__c</field>
        <formula>TODAY()</formula>
        <name>Set RR created on</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Target_Timestamp</fullName>
        <description>When Target checkbox is set this field is updated</description>
        <field>Target_Set_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Target Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Target_User</fullName>
        <description>When Target checkbox is set this field is updated</description>
        <field>Target_Set_User__c</field>
        <formula>$User.FirstName &amp; &quot; &quot; &amp;  $User.LastName</formula>
        <name>Set Target User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tender_Screening_Not_Required</fullName>
        <description>R4 - Tender Screening Not Required</description>
        <field>Opportunity_Screening_Gate_2_Status__c</field>
        <literalValue>Not Required</literalValue>
        <name>Tender Screening Not Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tender_Screening_Required</fullName>
        <description>R4 - Tender Screening Required status update</description>
        <field>Opportunity_Screening_Gate_2_Status__c</field>
        <literalValue>Required</literalValue>
        <name>Tender Screening Required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Commit_Timestamp</fullName>
        <description>When Commit checkbox is deleted this field is cleared</description>
        <field>Commit_Set_Timestamp__c</field>
        <name>Unset Commit Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Commit_User</fullName>
        <description>When Commit checkbox is set this field is cleared</description>
        <field>Commit_Set_User__c</field>
        <name>Unset Commit User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Target_Timestamp</fullName>
        <description>When Target checkbox is deleted this field is cleared</description>
        <field>Target_Set_Timestamp__c</field>
        <name>Unset Target Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Target_User</fullName>
        <description>When Target checkbox is set this field is cleared</description>
        <field>Target_Set_User__c</field>
        <name>Unset Target User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Actual_Bidding_Submission_Date_Te</fullName>
        <description>Update of Actual Bidding Submission Date (Tech). with the value of Actual Bidding Submission Date (Comm.)</description>
        <field>Actual_Bid_Submission_Date_Tech__c</field>
        <formula>Actual_Bid_Submission_Date_Comm__c</formula>
        <name>Update Actual Bidding Submission Date Te</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Quotes_Task_checkbox</fullName>
        <description>R5</description>
        <field>Closed_Quotes_Task_Created__c</field>
        <literalValue>1</literalValue>
        <name>Update Closed Quotes Task checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Value</fullName>
        <description>Updates Opportunity value to 0 if the stage is selected as “Prospect” &amp; “Pursuit”</description>
        <field>Opportunity_Value__c</field>
        <formula>IF(ISPICKVAL( StageName , &quot;Prospecting&quot;)||ISPICKVAL(StageName , &quot;Opportunity Pursuit&quot;), 0,  Opportunity_Value__c)</formula>
        <name>Update Opportunity Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Value_Bid</fullName>
        <description>Updates Opportunity Value Bid with Opportunity Value when Stage progresses from Bidding to Negotiation</description>
        <field>Opportunity_Value_Bid__c</field>
        <formula>Opportunity_Value__c</formula>
        <name>Update Opportunity Value Bid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Value_Pursuit</fullName>
        <description>Updates Opportunity Value Pursuit with Opportunity Value when Stage progresses from Opportunity Pursuit</description>
        <field>Opportunity_Value_Pursuit__c</field>
        <formula>Opportunity_Value__c</formula>
        <name>Update Opportunity Value Pursuit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Requested_Bidding_Submission_Date</fullName>
        <description>Update Requested Bidding Date (Tech). with the value from Requested Bidding Date (Comm) for Fast Track (since this field is not visible on the page layout.</description>
        <field>Requested_Bid_Submission_Date_Tech__c</field>
        <formula>Requested_Bid_Submission_Date_Comm__c</formula>
        <name>Update Requested Bidding Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Technical_Change_Record_Type</fullName>
        <description>Update the Opportunity Technical: Change Record Type field to TRUE. This will make sure that the record type is not changed automatically based on the product group through the existing workflow rules.</description>
        <field>Technical_Change_of_record_type__c</field>
        <literalValue>1</literalValue>
        <name>Update Technical Change Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_expected_award_date</fullName>
        <description>R5- created as part of requirement 2341 to update expected award date on opportunity.</description>
        <field>CloseDate</field>
        <formula>Lead_TimeFrame__c</formula>
        <name>Update_expected_award_date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdateConsortium</fullName>
        <actions>
            <name>Consortium_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND ( 2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Consortium__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_RecordType__c</field>
            <operation>equals</operation>
            <value>Regular</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_RecordType__c</field>
            <operation>equals</operation>
            <value>Close Opportunity</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Alternative Opportunity Closure</fullName>
        <actions>
            <name>Alert_to_Main_Opportunity_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Get_Main_Opportunity_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is to notify owner of the Main opportunity when an Alternative opportunity is cancelled
(an Alternative Opportunity can be defined by setting the lookup &quot;Main Opportunity&quot;)</description>
        <formula>AND(  ISPICKVAL(StageName,&quot;Closed Lost (Cancelled)&quot;),        NOT(ISBLANK(Alternative_Opportunity_To__c))     )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Always set Opportunity name on creation</fullName>
        <actions>
            <name>Set_Opportunity_name_to_Auto_Generate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When creating a new opportunity, the opportunity name is always set to [auto-generated] initially (i.e. lead conversion)</description>
        <formula>AND(  ISNEW(),  RecordType.Name = &quot;Initial&quot;,  ISBLANK( Product_Group__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Budget Year</fullName>
        <actions>
            <name>Budget_Year_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Target__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Commit__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>WFR which updates the Budget Year with the year of the Expected Award Date (Close Date).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Commit Checkbox False</fullName>
        <actions>
            <name>Unset_Commit_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unset_Commit_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>User and Timestamp are updated when Commit checkbox is not set</description>
        <formula>NOT( Commit__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Commit Checkbox True</fullName>
        <actions>
            <name>Set_Commit_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Commit_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>User and Timestamp are updated when Commit checkbox is set</description>
        <formula>Commit__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Large Business</fullName>
        <actions>
            <name>Large_Business</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Value__c</field>
            <operation>greaterOrEqual</operation>
            <value>&quot;USD 15,000,000&quot;</value>
        </criteriaItems>
        <description>If an Opportunity value &gt;15m the checkbox is checked and that Opportunity = &apos;Large Business&apos;. If an Opportunity &lt;15m, the checkbox is unchecked and that Opportunity = &apos;Base Business&apos;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification on Prospecting</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <description>This workflow creates a notification if opportunity is in stage &quot;Prospecting&quot; and Expected Award Date is less than 30 days from today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Stage_Notification_on_Prospecting_and_30_Days_to_Close</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Qualification Not Required Status update Rule</fullName>
        <actions>
            <name>Opportunity_Qualification_Not_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Qualification_Required__c</field>
            <operation>equals</operation>
            <value>NO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Qualification_Status__c</field>
            <operation>notEqual</operation>
            <value>BID,NO BID</value>
        </criteriaItems>
        <description>R4 - Opportunity Qualification Not Required Status update Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Qualification Required Status update Rule</fullName>
        <actions>
            <name>Opportunity_Qualification_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Qualification_Required__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Qualification_Status__c</field>
            <operation>notEqual</operation>
            <value>BID,NO BID</value>
        </criteriaItems>
        <description>R4 - Opportunity Qualification Required Status update Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Value Rule</fullName>
        <actions>
            <name>Update_Opportunity_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Value__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updates Opportunity value to 0 if the stage is selected as “Prospect” &amp; “Pursuit”</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity notification ServIS</fullName>
        <actions>
            <name>ServIS_Opportunity_Creation_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(OR(        NOT(            ISNULL(ServIS_Opportunity_Owner_Email__c)           ),        NOT(            ISNULL(Creator_Email__c)           )       ),    ServIS_Opportunity_Owner_Email__c  &lt;&gt;  Creator_Email__c         )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Predefault Channel Class</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Predefault Channel and Industry</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Prevent automatic update of Opportunity Fast Track record type_Rel2</fullName>
        <actions>
            <name>Update_Technical_Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule is similiar to the existing &quot;Prevent automatic update of Opportunity Regular record type&quot; but only in place for release 2 until the approval process for changing to Fast Track is put in place.</description>
        <formula>AND( RecordType.Name=&quot;Fast Track&quot;, ISCHANGED(RecordTypeId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prevent automatic update of Opportunity Regular record type</fullName>
        <actions>
            <name>Update_Technical_Change_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule will set the Opportunity field Technical: Change of record type to TRUE in order to prevent the automatic change of record type based on Product Group through the existing workflow rules.</description>
        <formula>AND (RecordType.Name=&quot;Regular&quot;, ISCHANGED(RecordTypeId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RecordTypeSwitchtoCancelOpportunity</fullName>
        <actions>
            <name>RecordTypeSwitchtoCancelOpportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost Without ABB Bid</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost (Cancelled)</value>
        </criteriaItems>
        <description>This triggers when the stage of an opportunity changes to Closed Lost (Cancelled)/Closed Lost Without ABB Bid</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RecordTypeSwitchtoClosedOpportunity</fullName>
        <actions>
            <name>RecordTypeSwitchtoClosedOpportuntiy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RecordTypeSwitchtoInitial</fullName>
        <actions>
            <name>RecordTypeSwitchtoInitial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Opportunity Pursuit</value>
        </criteriaItems>
        <description>This triggers when the stage of an opportunity changes to Prospecting/Opportunity Pursuit</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RecordTypeSwitchtoRegular</fullName>
        <actions>
            <name>RecordTypeSwitchtoRegular</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Bidding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiation</value>
        </criteriaItems>
        <description>This triggers when the stage of an opportunity changes to Bidding/Negotiation</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Round Probability</fullName>
        <actions>
            <name>Round_Probability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Values of the probability entered by a user will be round up / down to the next 10%</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Questionaire and Follow-up</fullName>
        <actions>
            <name>Send_Customer_Feedback_Questionaire</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Follow_up_on_this_Opportunity</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Value__c</field>
            <operation>greaterThan</operation>
            <value>&quot;USD 2,000,000&quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>To contact the customer and capture feedback and seek reference approval for opportunities Closed (Won/Lost).  - follow up Task to Opportunity Owner for Opportunities &gt; 2$M only, Due Date: 1 week from now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set New Opportunity Name</fullName>
        <actions>
            <name>Create_new_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>equals</operation>
            <value>[auto-generated]</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Specific_Opportunity_Info__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>An opportunity name is generated for (new) opportunities in case name is set to [auto-generated]</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Opp RecType to Regular</fullName>
        <actions>
            <name>Set_Opp_RecType_to_Fast_Regular</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Technical_Record_Type__c</field>
            <operation>equals</operation>
            <value>Regular</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Technical_Change_of_record_type__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Converts opportunity to record type &quot;Regular&quot; according result of field &quot;Technical_Record_Type__c&quot; (e.g. definition in object Product Group).
Workflow rules will change the record type accordingly.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set new unrelated Opportunity name</fullName>
        <actions>
            <name>Create_new_Unrelated_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
            <value>[auto-generated]</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Specific_Opportunity_Info__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Switch RecType to Fast Track</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Technical_Record_Type__c</field>
            <operation>equals</operation>
            <value>Fast Track</value>
        </criteriaItems>
        <description>Converts opportunity to record type &quot;Fast Track&quot; according result of field &quot;Technical_Record_Type__c&quot; (e.g. definition in object Product Group).
Workflow rules will change the record type accordingly.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Target Checkbox False</fullName>
        <actions>
            <name>Unset_Target_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unset_Target_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>User and Timestamp are updated when Target checkbox is not set</description>
        <formula>NOT( Target__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Target Checkbox True</fullName>
        <actions>
            <name>Set_Target_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Target_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>User and Timestamp are updated when Target checkbox is set</description>
        <formula>Target__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task for User</fullName>
        <actions>
            <name>Update_Closed_Quotes_Task_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>All_Quotes_are_Closed</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.All_Quotes_Closed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Prospecting,Opportunity Pursuit,Bidding,Negotiation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Closed_Quotes_Task_Created__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>R5 - Workflow rule to create a task for user when all quotes are closed and Opportunity is not closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tender Screening Not Required Status update Rule</fullName>
        <actions>
            <name>Tender_Screening_Not_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Tender_Screening_Required__c</field>
            <operation>equals</operation>
            <value>NO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Screening_Gate_2_Status__c</field>
            <operation>notEqual</operation>
            <value>BID,NO BID</value>
        </criteriaItems>
        <description>R4 - Tender Screening Not Required Status update Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tender Screening Required Status update Rule</fullName>
        <actions>
            <name>Tender_Screening_Required</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Tender_Screening_Required__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Screening_Gate_2_Status__c</field>
            <operation>notEqual</operation>
            <value>BID,NO BID</value>
        </criteriaItems>
        <description>R4 - Tender Screening Required Status update Rule</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Actual Bidding Submission Date Technical</fullName>
        <actions>
            <name>Update_Actual_Bidding_Submission_Date_Te</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fast Track</value>
        </criteriaItems>
        <description>The Actual Bidding Submission Date (Tech) should be filled with the value from Actual Bidding Submission Date (Comm) for the Opportunity Fast Track record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Value Bid</fullName>
        <actions>
            <name>Update_Opportunity_Value_Bid</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Opportunity Value Bid is always updated when the stage changes from Bidding</description>
        <formula>AND(  ISCHANGED( StageName ),  TEXT( StageName ) = &quot;Negotiation&quot;,  ISPICKVAL(PRIORVALUE( StageName ), &quot;Bidding&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Value Pursuit</fullName>
        <actions>
            <name>Update_Opportunity_Value_Pursuit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Opportunity Value Pursuit is always updated when the stage changes from Opportunity Pursuit</description>
        <formula>AND(  ISCHANGED( StageName ),  TEXT( StageName ) &lt;&gt; &quot;Prospecting&quot;,  ISPICKVAL(PRIORVALUE( StageName ), &quot;Opportunity Pursuit&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update RR created onDate</fullName>
        <actions>
            <name>Set_RR_created_on</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the created Date on the opportunity, when the RiskReview Doc ID is provided back from RiskReview Interface.</description>
        <formula>ISCHANGED(RR_Doc_ID__c) &amp;&amp; ISBLANK(PRIORVALUE(RR_Doc_ID__c)) &amp;&amp; ISNULL(RR_created_on__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Requested Bidding Submission Date Technical</fullName>
        <actions>
            <name>Update_Requested_Bidding_Submission_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Fast Track</value>
        </criteriaItems>
        <description>The Requested Bidding Submission Date (Tech) should be filled with the value from Requested Bidding Submission Date (Comm) for the Opportunity Fast Track record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update expected award date on opportunity</fullName>
        <actions>
            <name>Update_expected_award_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>R5-Created as part of Requirement 2341 to update expected award date on opportunity.</description>
        <formula>NOT(  ISNULL( Lead_TimeFrame__c ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>All_Quotes_are_Closed</fullName>
        <assignedToType>owner</assignedToType>
        <description>All Quotes are closed .</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>All Quotes are Closed</subject>
    </tasks>
    <tasks>
        <fullName>Follow_up_on_this_Opportunity</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please follow-up on this closed opportunity and send the questionnaire to the customer.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Open</status>
        <subject>Follow up on this Opportunity</subject>
    </tasks>
</Workflow>

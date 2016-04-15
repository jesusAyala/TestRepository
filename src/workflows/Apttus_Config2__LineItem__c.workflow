<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
	<fieldUpdates>
        <fullName>APTS_DefaultBasePrice</fullName>
        <field>Apttus_Config2__BasePrice__c</field>
        <formula>0</formula>
        <name>APTS_DefaultBasePrice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>    
	<fieldUpdates>
        <fullName>APTS_Set_Discount_Type_A</fullName>
        <field>APTS_Discount_Type__c</field>
        <literalValue>Additional Discount</literalValue>
        <name>APTS Set Discount Type - A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Set_Discount_Type_N</fullName>
        <field>APTS_Discount_Type__c</field>
        <literalValue>Net Price Discount</literalValue>
        <name>APTS Set Discount Type - N</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Set_Discount_Type_S</fullName>
        <field>APTS_Discount_Type__c</field>
        <literalValue>Substitute Discount</literalValue>
        <name>APTS Set Discount Type - S</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_DefaultDiscTypeToSbst_Field_Updates</fullName>
        <description>Default Discount type to Substitute Discount</description>
        <field>APTS_Discount_Type__c</field>
        <literalValue>Substitute Discount</literalValue>
        <name>APTS DefaultDiscTypeToSbst Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_update_is_custom_pricing</fullName>
        <field>Apttus_Config2__IsCustomPricing__c</field>
        <literalValue>1</literalValue>
        <name>APTS_update_is_custom_pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_DefaultDiscountType</fullName>
        <description>Default the discount type to NetPriceDiscount</description>
        <field>APTS_Discount_Type__c</field>
        <literalValue>Net Price Discount</literalValue>
        <name>APTS_DefaultDiscountType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Set_Discount_Adj_Type_In_Line_Item</fullName>
        <description>Field update to set &quot;% Discount&quot; as Adjustment Type in Line Item when Additional or Substitute Discount is selected as Discount Type.</description>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <literalValue>% Discount</literalValue>
        <name>Set % Discount Adj. Type In Line Item</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>    
    <fieldUpdates>
        <fullName>APTS_Set_LineItem_Adj_Amt_for_Discount</fullName>
        <description>Field update For Line Item to copy
1. &quot;Discount %&quot; value in &quot;Adjustment Amount&quot; for Substitute Disc.
2. total value of &quot;Discount % + Standard Discount&quot; in &quot;Adjustment Amount&quot; for Additional Disc.
3. &quot;Net Price Override * Qty&quot; value for Net Price Disc.</description>
        <field>Apttus_Config2__AdjustmentAmount__c</field>
        <formula>IF( TEXT( APTS_Discount_Type__c ) = &quot;Substitute Discount&quot; ,  APTS_Discount_Percentage__c * 100 ,  IF( TEXT( APTS_Discount_Type__c ) = &quot;Additional Discount&quot; ,  (APTS_Discount_Percentage__c  +  APTS_LP_Standard_Discount__c) * 100 ,  IF( TEXT( APTS_Discount_Type__c ) = &quot;Net Price Discount&quot; , APTS_Net_Price_Override__c *  Apttus_Config2__Quantity__c , null) ) )</formula>
        <name>Set LineItem Adj Amt for Discount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>    
    <fieldUpdates>
        <fullName>APTS_Set_None_Adj_Type_In_Line_Item</fullName>
        <description>Field update to set &quot;--None--&quot; as Adjustment Type in Line Item when &quot;--None--&quot; is selected as Discount Type.</description>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <name>Set None Adjustment Type In Line Item</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_Set_Price_Override_Adj_Type_In_LI</fullName>
        <description>Field update to set &quot;Price Override&quot; as Adjustment Type in Line Item when Net Price Discount is selected as Discount Type.</description>
        <field>Apttus_Config2__AdjustmentType__c</field>
        <literalValue>Price Override</literalValue>
        <name>Set Price Override Adj Type In Line Item</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>    
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeANS_Field_Updates</fullName>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Only_Additional_Net_and_Substitute_Discounts_availble</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeANS Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeAN_Field_Updates</fullName>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Additional_and_Net_Discounts_availble</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeAN Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeAS_Field_Updates</fullName>
        <description>Only Additional and Substitute Discounts available.</description>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Additional_and_Substitute_Discounts_availble</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeAS Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeA_Field_Updates</fullName>
        <description>If Cart Line Item. Product.Is hierarchy = TRUE and Hierarchy Discounts = A and Hierarchy Level = 3, then record type of Line Item should be equal to the record type which has Adjustment Type as Additional Discounts and Substitute Discounts.</description>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Only_Additional_Discount</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeA Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeN</fullName>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Only_Net_Discount_Available</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS_UpdateRecordTypeN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeNS_Field_Updates</fullName>
        <description>record type which has Adjustment Types as Net price and Substitute Discounts</description>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Only_Net_and_Substitute_Discounts</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeNS Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeNone_Field_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>APTS_No_Adjustment_Available</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeNone Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APTS_UpdateRecordTypeS_Field_Updates</fullName>
        <description>Updates Record Type of Line Item Object to &apos;Only Substitute Discount&apos;, where discount type is only Substitute discount available.</description>
        <field>RecordTypeId</field>
        <lookupValue>APTS_Only_Substitute_Discount</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>APTS UpdateRecordTypeS Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
	<rules>
        <fullName>APTS_DefaultBasePrice</fullName>
        <actions>
            <name>APTS_DefaultBasePrice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.Apttus_Config2__BasePrice__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>WF rule to set Gross price as 0, when its value is blank. Gross price will be blank when we add the hierarchies from opportunity line to Quote/MSPA.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
	<rules>
        <fullName>APTS Set Discount Type - A</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Additional discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;A&apos;), AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;A&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - AN</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_N</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Additional and Net Price discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;AN&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;AN&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - ANS</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_S</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Additional, Net Price and Subsitute discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;ANS&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;ANS&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - AS</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_S</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Additional and Subsitute discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;AS&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;AS&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - N</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_N</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Net Price discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;N&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;N&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - NS</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_S</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Net Price and Substitute discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;NS&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;NS&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Set Discount Type - S</fullName>
        <actions>
            <name>APTS_Set_Discount_Type_S</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set default Substitute discount</description>
        <formula>OR (  AND (APTS_BundleOptionIsHierarchy__c = TRUE, Apttus_Config2__ConfigurationId__r.APTS_Hierarchy_Discounts__c = &apos;S&apos;),  AND (APTS_BundleOptionIsHierarchy__c = FALSE,Apttus_Config2__ConfigurationId__r.APTS_Product_Discounts__c = &apos;S&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeA Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeA_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_update_is_custom_pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = A , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;A&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;A&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;A&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;A&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeAN Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeAN_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = AN , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;AN&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;AN&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;AN&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;AN&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeANS Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeANS_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = ANS , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;ANS&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;ANS&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;ANS&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;ANS&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeAS Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeAS_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product.Is hierarchy = TRUE and Hierarchy Discounts = AS and Hierarchy Level = 3, then record type of Line Item should be equal to the record type which has Adjustment Type as Additional Discounts and Substitute Discounts.</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;AS&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;AS&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;AS&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;AS&apos;,  CONTAINS(TEXT(Apttus_Config2__ProductId__r.APTS_Hierarchy_Level__c), Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_level__c)  , Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeN Rule</fullName>
        <actions>
            <name>APTS_DefaultDiscountType</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_UpdateRecordTypeN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = N , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;N&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;N&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;N&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;N&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeNS Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeNS_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = NS , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;NS&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;NS&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;NS&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;NS&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeNone Rule</fullName>
        <actions>
            <name>APTS_UpdateRecordTypeNone_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Adjustment Type should be none.</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;S&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;S&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  ,   if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null,  Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),   AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;S&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c )=&apos;S&apos;,  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c)  ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>APTS Select Record TypeS Rule</fullName>
        <actions>
            <name>APTS_DefaultDiscTypeToSbst_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_UpdateRecordTypeS_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cart Line Item. Product. Is Hierarchy = FALSE and Product Discounts = S , then record type of Line Item should be equal to the record type which has Adjustment Types as Net price and Substitute Discounts .. and so on for all combinations possible</description>
        <formula>OR( if(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Product_Discounts__c)=&apos;S&apos;), AND(APTS_BundleOptionIsHierarchy__c =false, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Product_Discounts__c)=&apos;S&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c) ) ,  IF(AND(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__c != null, Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_LP_MSPA_Type__c == &apos;MSPA&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_CMConfig__AgreementId__r.APTS_Hierarchy_Discounts__c )=&apos;S&apos;),  AND(APTS_BundleOptionIsHierarchy__c =true, TEXT(Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Hierarchy_Discounts__c)=&apos;S&apos;, Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.APTS_Record_Type_Name__c == $Setup.APTS_Proposal_Record_Type__c.APTS_Default_Record_Type__c))  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules> 
    <rules>
        <fullName>APTS_Update Line Item Adjustment Type And Amount On Net Price Discount</fullName>        
        <actions>
            <name>APTS_Set_LineItem_Adj_Amt_for_Discount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_Set_Price_Override_Adj_Type_In_LI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Type__c</field>
            <operation>equals</operation>
            <value>Net Price Discount</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Net_Price_Override__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule to set &quot;Adjustment Type&quot; to &quot;Price Override&quot; and copy value of &quot;Net Price Override&quot; field to &quot;Adjustment Amount&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Update Line Item Adjustment Type And Amount On None Discount Type</fullName>        
        <actions>
            <name>APTS_Set_LineItem_Adj_Amt_for_Discount</name>
            <type>FieldUpdate</type>
        </actions>        
        <actions>
            <name>APTS_Set_None_Adj_Type_In_Line_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Type__c</field>
            <operation>equals</operation>
            <value>--None--</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Rule to set &quot;Adjustment Type&quot; to &quot;--None--&quot; and value to NULL/blank when selected discount type is &quot;--None--&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APTS_Update Line Item Adjustment Type And Amount On Substitute or Additional Discount</fullName>
        <actions>
            <name>APTS_Set_Discount_Adj_Type_In_Line_Item</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>APTS_Set_LineItem_Adj_Amt_for_Discount</name>
            <type>FieldUpdate</type>
        </actions>        
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Type__c</field>
            <operation>equals</operation>
            <value>Substitute Discount</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Type__c</field>
            <operation>equals</operation>
            <value>Additional Discount</value>
        </criteriaItems>
        <criteriaItems>
            <field>Apttus_Config2__LineItem__c.APTS_Discount_Percentage__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Rule to set &quot;Adjustment Type&quot; to &quot;% Discount&quot; and copy value of &quot;Discount %&quot; (in case of Substitute Discount) or &quot;Discount % + Standard Discount&quot; (in case of Additional Discount) to &quot;Adjustment Amount&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

trigger Account_UpdateCountryCustomSearchField on Account (after insert, after update) 
{
If(!System.label.SYS_RunAccountTrigger.equalsIgnoreCase('NO')){

    List<Account> updateList = new List<Account>();
    Account acc;

    for(Account orgAcc : Trigger.new)
    {
        if(orgAcc.Primary_Address_Country__c != orgAcc.BillingCountry)
        {
            acc = orgAcc.clone(true,false);
                
            acc.Primary_Address_Country__c = orgAcc.BillingCountry;
            
            updateList.add(acc);
        }
    }
    
    if(updateList.size() != 0)
    {
        update updateList;
    }
    }
}
Public class AccountChangeFlowController
{   
    //Test GITHUB 
    public boolean haswhereclause=false;
    public boolean first=true;
    public boolean second=false;
    public string varContactID{get;set;}
    public String inputText1{get;set;} // input text1 value  from vf
    public String inputText2{get;set;} // input text2 value  from vf
    public String inputText3{get;set;} // input text3 value  from vf
    public String inputText4{get;set;} // input text4 value  from vf
    public String inputText5{get;set;} // input text5 value  from vf
    public string Email{get;set;}
    public string SuccessEmail{get;set;}
    public string MailingCity{get;set;}
    public string MailingCountry{get;set;}
    public string MailingStreet{get;set;}
    public string MailingState{get;set;}
    public string MailingPostalCode{get;set;}
    public string FirstName{get;set;}
    public string LastName{get;set;}
    public string displayscreen{get;set;}
    //public string displayscreen1{get;set;}
    
    List<Account> selectaccount=new List<Account>();
    public Contact con{get;set;}
    public Id contactId{get;set;}
    //variable to hold Contact Record and id
    public Account acc{get;set;}
    public Id accountId{get;set;} 
    public Boolean hasMultiplePages{get;set;} 
    public Boolean isErrorInContact{get;set;}
    public string accountQuery='select BillingCity,AccSelectionDetail__c,BillingCountry,BillingPostalCode,BillingState,BillingStreet,Name,Phone,GUID__c,Active__c from Account '; 
    /**
*@purpose : Method to hold selected contacts  
*@Param : None 
*@Return : Pagereference
**/
    public PageReference getSelected() {
        System.debug('======Inside the Get Function======');
        accountId = ApexPages.currentPage().getParameters().get('acid');
        System.debug('======Inside the Get Function======' +accountId );
        //contact = [SELECT Id,Name,Accountid,Account.Name,MobilePhone,Email FROM Contact WHERE id = :contactId]; 
        //acc=[select Id,Name,BillingStreet,BillingCity,Phone,BillingCountry,BillingPostalCode,BillingState from Account where ID=:accountID];
        
        /*system.debug('===='+con.Email);              
        system.debug('===='+acc.BillingStreet);
        system.debug('===='+acc.BillingCity );
        system.debug('===='+acc.BillingPostalCode);*/
        //getAcc(accountId);
        return null;
    }
    
    public Account getAcc(Id accountId)
    {
        if(accountId != NULL)
            acc=[select Id,Name,BillingStreet,BillingCity,Phone,AccSelectionDetail__c,BillingCountry,BillingPostalCode,BillingState from Account where ID=:accountID];
        else
            acc = new Account();
        return acc;
    }
    public ApexPages.StandardSetController conAcc{get;set;}
    public List<Account> querySelectAccount()
    { 
        if(first || second)
        {
            if(inputText1 !='' && inputText1!=null)
            {
                if(!hasWhereClause)
                {
                    hasWhereClause=true;
                    //string a='%'+inputText1+'%';
                    accountQuery= accountQuery+ 'where Name like \'%'+inputText1+'_%\'';
                }
                else
                {
                    accountQuery=accountQuery+ 'AND  Name like \'%'+inputText1+'_%\'';
                }
            }
            if(inputText2!='' && inputText2!=null)
            {
                if(!hasWhereClause)
                {
                    hasWhereClause=true;
                    accountQuery= accountQuery+ 'where BillingCountry like \'%'+inputText2+'%\'';
                }
                else
                {
                    accountQuery= accountQuery+ 'AND BillingCountry like \'%'+inputText2+'%\'';
                }
            }
            if(inputText3 !='' && inputText3!=null)
            {
                if(!hasWhereClause)
                {
                    hasWhereClause=true;
                    accountQuery= accountQuery+ 'where BillingCity like \'%'+inputText3+'%\'';
                }
                else
                {
                    accountQuery= accountQuery+ 'AND BillingCity like \'%'+inputText3+'%\'';
                }
            }
            if(inputText4 !='' && inputText4!=null)
            {
                if(!hasWhereClause)
                {
                    hasWhereClause=true;
                    accountQuery= accountQuery+ 'where Account_Short_Name__c like \'%'+inputText4+'%\'';
                }
                else
                {
                    accountQuery= accountQuery+ 'AND Account_Short_Name__c like \'%'+inputText4+'%\'';
                }
            }
            if(inputText5 !='' && inputText5!=null)
            {
                if(!hasWhereClause)
                {
                    hasWhereClause=true;
                    accountQuery= accountQuery+ 'where GUID__c=\''+inputText5+'\'';
                }
                else
                {
                    accountQuery= accountQuery+ 'AND GUID__c=\''+inputText5+'\'';
                }
            } 
            if(accountQuery.contains('LIMIT')==false) {
                accountQuery=accountQuery+'LIMIT 1000';
            }
            first=false; 
            
        }
        system.debug('-->'+accountQuery); 
        
        selectAccount = Database.query(accountQuery);
        system.debug('***** selectaccount'+selectaccount);
        return selectaccount;
        return pageAccounts;

    }
    public void createContact()
    {
        isErrorInContact = false;
        try {
            Contact  c = new Contact();
            c.FirstName=con.FirstName;
            c.LastName=con.LastName;
            c.Email=Email;
            c.MailingCity=acc.BillingCity;
            c.MailingStreet=acc.BillingStreet;
            c.MailingCountry=acc.BillingCountry;
            c.MailingState=acc.BillingState;
            c.Phone=acc.Phone;
            c.AccountID=acc.Id;
            c.MailingPostalCode=acc.BillingPostalCode;
            c.Type__c=con.Type__c;
            insert c;     
            if(con.Active__c==true)
            {
                con.Active__c=false;
                con.Successor_Contact__c=c.ID;
                system.debug('==='+c.ID);
            }
            update con;
            SuccessEmail=c.Email;
            MailingCity= c.MailingCity;
            MailingStreet=c.MailingStreet;
            MailingCountry=c.MailingCountry;
            MailingState=c.MailingState;
            MailingPostalCode=c.MailingPostalCode;
            FirstName=c.FirstName;
            LastName=c.LastName; 
        }
        catch(DMLException ed) {
            isErrorInContact = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ed.getDmlMessage(0)));            
        }
        catch(Exception e) {
            isErrorInContact = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));            
        }
    }
    
    public AccountChangeFlowController(ApexPages.StandardController controller)
    {   
        
        //pageNumber = 0;
        //totalPageNumber = 0;
        //pageSize = 20;
        displayscreen='screen1';       
        contactId=ApexPages.currentPage().getParameters().get('varContactID');
        system.debug('==>>'+contactId);      
        con=[select Active__c,Email,Name,FirstName,LastName,Type__c from contact where id=:contactId];
        accountQuery='select BillingCity,BillingCountry,AccSelectionDetail__c,BillingPostalCode,BillingState,BillingStreet,Name,Phone,GUID__c,Active__c from Account ';
    }
  
    

    public void step1()
    {    
        //totalPageNumber=0;
        accountId = null;
        pageAccounts = new List<account>();
        first=true;
        hasWhereClause=false;
        displayscreen='screen1';
        accountQuery='select BillingCity,BillingCountry,BillingPostalCode,AccSelectionDetail__c,BillingState,BillingStreet,Name,Phone,GUID__c,Active__c from Account ';
        
        
    }
    public void step2()
    {    
        BindData(1);
        displayscreen='screen2';
        
    } 
    public void step3()
    {    
        getAcc(accountId);
        displayscreen='screen3';
        
    }
    public void step4()
    {
        if(!String.isNotBlank(Email)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Email'));
        }
        else if(validateEmail(Email) == false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter valid Email'));
        } 
        else {
            displayscreen='screen4';
            createContact();
        }               
        
    }
    public void step5()
    {
        displayscreen='screen2';
    }
    public void step6()
    {
        displayscreen='screen3';
    }
    
    
    public List<Account> pageAccounts{get{
        if(conAcc != NULL)
            return conAcc.getRecords();
        return new List<Account>();
    }set;}


    public void BindData(Integer newPageIndex)
    {
        try
        {
            system.debug('***** bind data called');
            querySelectAccount();
            hasMultiplePages = false;
            if(selectAccount != NULL && selectAccount.size() > 0) {
                
                Decimal pages = selectAccount.size()/20;
                if(pages > 1)
                    hasMultiplePages = true;
                else
                    hasMultiplePages = false;
            }
            
            conAcc = new ApexPages.StandardSetController(selectaccount);
                       
            //pageAccounts = conAcc.getRecords();
            if (selectaccount == null || selectaccount.size() <= 0) {
                selectaccount = new List<Account>();
                //pageAccounts = null;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view. Please refine search filters!'));
            }
            
            selectaccount = new List<Account>();
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }
    /*public PageReference nextBtnClick() {
        system.debug('***** next button click');
        BindData(pageNumber + 1);
        return null;
    }
    public PageReference previousBtnClick() {
        BindData(pageNumber - 1);
        return null;
    }*/
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a rel="nofollow" href="http://www.regular-expressions.info/email.html" target="_blank">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
    
        if (!MyMatcher.matches()) 
            res = false;
        return res; 
    }
    /************************** New Pagination Code *****************************************************************/
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return conAcc.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return conAcc.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumberAcc {
        get {
            return conAcc.getPageNumber();
        }
        set;
    }

    // returns the first page of records
     public void first() {
         conAcc.first();
     }

     // returns the last page of records
     public void last() {
         conAcc.last();
     }

     // returns the previous page of records
     public void previous() {
         conAcc.previous();
     }

     // returns the next page of records
     public void next() {
         conAcc.next();
     }

     // returns the PageReference of the original page, if known, or the home page.
     /*public void cancel() {
         conAcc.cancel();
     }*/
    
    
}
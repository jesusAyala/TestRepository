/**
 * ApexClass -  ClsChannelPreQualificCompareController (Controller for the VF Page-ChannelPreQualificationComparePage)
 * Release R5
 * @author  Vasanthi (Accenture)
 * @created 2016-1-25
 * @version 1.0
 * Description: As per Req #2307 (KAD-00685) When the user click on the button it should take all the selected channel pre-qualification from the list view and display a comparison chart based on the Average Score as well as scores mentioned on the each of the section.

 * Created
 
  */
public class ClsChannelPreQualificCompareController { 
     
    public List<ChannelPQWrapper > selectedchannelPQs {get;set;}
    public ApexPages.StandardSetController setCon{ get; set; }
    public Channel_Qualifications__c channel {get;set;}
    public Channel_Qualifications__c channelTo {get;set;}
    public String division {get;set;}
    public String channelName {get;set;}
    public String accName {get;set;}
    public String sortDirection{get;set;}
    public String sortingColumn{get;set;}  
    public Boolean iscompareClicked {get;set;}
    public String selectedProductQualIds {get;set;}
    public String selectedOpt {get;set;}
    public String selCountry {get;set;}
    public Item[] data1 {get;set;}
    Set<Id> SelectedProductQualicIdSet = new Set<Id>(); 
    String basicQuery;  
    String accountId;       
    
    
    Date createdDatFrom;
    Date createdDatTo;
    Date nextDat;
    Date nextDatTo;
    Date compDateFrom;
    Date compDateTo;
    Date nextCompDat;
    Date nextCompDatTo;
        
    
    public String selectedChannelId {get;set;}
/**    
  * inner class to display in page
*/    
    public class ChannelPQWrapper {  
    
        public Channel_Qualifications__c preQuals{get; set;}        
        public Boolean selected {get; set;}
        public Integer row {get;set;}            
    }  
/**    
    * used in chart
*/    
    public String fields {
        get {
            return label.data_Stack_Fields;
        }
    }
/**    
  * used in chart
*/  
    public String titles {
        get {
           return Label.data_Stack_Titles;           
        }
    }
    
    List<String> orderByList = new List<String>();
    List<String> displayOptList = new List<String>();
    List<String> scoreName = new List<String>();
/**
* constructor
*/
    public ClsChannelPreQualificCompareController() {
    
        accountId = ApexPages.currentPage().getParameters().get(Label.ApexClass_id);   
        channel = new Channel_Qualifications__c( Status__c = '');
        channelTo = new Channel_Qualifications__c( Status__c = '');
        selectedchannelPQs = new List<ChannelPQWrapper>();
        orderByList.addAll(Label.order_by_ASC_DESC.split(Label.CL00069)); //Label.CL00069 = comma(,) Label.order_by_ASC_DESC = ASC, DESC
        sortingColumn = Label.System_Name;
        sortDirection = orderByList[0];
        data1 = new List<Item>();
        iscompareClicked = FALSE;
        displayOptList.addAll(Label.Default_display_Option.split(Label.CL00069)); //0-All 1-Selected 2-Unselected
        scoreName.addAll(Label.data_Stack_Titles.split(Label.CL00069)); //General Score,Market Score,Portfolio Score,Organization Score,Attitude Score,Business Score
        selectedOpt = displayOptList[0]; 
        basicQuery = Label.channelPreQual_query_string; 
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Id, Name, Account__r.Name, Account__r.Primary_Address_Country__c, Average__c, General_Score__c, Market_Score__c, Portfolio_Score__c, Organization_Score__c, Attitude_Score__c, Business_Score__c, Account__c 
                                   FROM Channel_Qualifications__c WHERE Account__c != NULL ORDER BY Name LIMIT 10000]));
                               
        setCon.setPageSize(20);
                            
    }  
/**    
    * To construct wrapper records
*/    
    public List<ChannelPQWrapper> getChannelPQList() {
        
        List<ChannelPQWrapper > channelList = new List<ChannelPQWrapper>();
        
        for(Channel_Qualifications__c chanelPreQuals : (List<Channel_Qualifications__c>) setCon.getRecords()) {
                
            ChannelPQWrapper channel = new ChannelPQWrapper ();
            channel.preQuals = chanelPreQuals;
            channel.selected = (SelectedProductQualicIdSet.contains(chanelPreQuals.Id)) ? TRUE : FALSE;    
            channelList.add(channel);
        }
        return channelList;  
    }
/**    
   * To change dispalying records
*/   
    public void changeDisplayingRecords() {
        SelectedProductQualicIdSet.clear();
        String st = selectedChannelId;
        addSelectedIds(st);
        String query = '';
        sortingColumn = Label.System_Name;
        sortDirection = orderByList[0];
        
        if (selectedOpt == displayOptList[0]) {
            query = basicQuery ;
        }
        
        if (selectedOpt == displayOptList[1]) {
            query = basicQuery + ' AND (Id IN :SelectedProductQualicIdSet)';
        } 
        
        if (selectedOpt == displayOptList[2]) {
            query = basicQuery + ' AND (Id NOT IN :SelectedProductQualicIdSet)';
        } 
        
        //basicQuery = query;
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query + ' ORDER BY Name Limit 10000'));
    }
/**    
 * To get Channel Partner market scope picklist values
*/ 
    public List<SelectOption> getDivisionList() {
        
        List<SelectOption> DivisionOpts = new List<SelectOption>{new SelectOption('', Label.System_None_Pick_Value)};
        Schema.DescribeFieldResult familyPickValues = Channel_Market_Coverage__c.Division__c.getDescribe();
       
        for(Schema.Picklistentry sp: familyPickValues.getPicklistValues() ){
            DivisionOpts.add(new SelectOption(sp.getLabel(), sp.getLabel()));
        }
        return DivisionOpts ;
    }
/**    
 * To get Account Primary Address picklist values
*/ 
    public List<SelectOption> getprimaryCountryList() {
        
        List<SelectOption> DivisionOpts = new List<SelectOption>{new SelectOption('', Label.System_None_Pick_Value)};
        Schema.DescribeFieldResult familyPickValues = Account.Primary_Address_Country__c.getDescribe();
       
        for(Schema.Picklistentry sp: familyPickValues.getPicklistValues() ){
            DivisionOpts.add(new SelectOption(sp.getLabel(), sp.getLabel()));
        }
        return DivisionOpts ;
    }
/**    
  * Sorting
*/  
    public PageReference sortRecordsByColumn() {
        
        sortDirection = (sortDirection == orderByList[0]) ? orderByList[1] : orderByList[0]; //orderByList[0] - ASC orderByList[1] DESC
        
        String query;
        if (selectedOpt == displayOptList[0]) {
            query = basicQuery ;
        }
        
        if (selectedOpt == displayOptList[1]) {
            query = basicQuery + ' AND (Id IN :SelectedProductQualicIdSet)';
        } 
        
        if (selectedOpt == displayOptList[2]) {
            query = basicQuery + ' AND (Id NOT IN :SelectedProductQualicIdSet)';
        } 
        
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query + ' ORDER BY '+ sortingColumn + ' ' + sortDirection + ' Limit 10000'));
        return null;
    }
/**    
 * To display the selected records in another page and display chart
 */
    public PageReference displaySelectedRecords() {
        
        Set<Id> selectedRecIdSet = new Set<Id>();
        String st = selectedChannelId;
        iscompareClicked = TRUE;
        selectedchannelPQs.clear(); 
        selectedProductQualIds = '';
        data1.clear();
        List<Id> str = new List<Id>();
        if (st != null && !String.isBlank(st)) {
            if (st.contains(Label.CL00069)){                
                str = st.split(Label.CL00069);
            } else {
                str.add(st);
            }   
            selectedRecIdSet.addAll(str);
            SelectedProductQualicIdSet = selectedRecIdSet;
            Integer remLimit =  limits.getLimitQueryRows() - limits.getQueryRows();
            Channel_Qualifications__c[] channelList =  [SELECT Id, Name, Account__r.Name, Average__c, General_Score__c, Market_Score__c, Portfolio_Score__c, Organization_Score__c, Attitude_Score__c, Business_Score__c, Account__c 
                                   FROM Channel_Qualifications__c WHERE Id IN :selectedRecIdSet LIMIT :remLimit];
            
            Integer i = 1;  
            Integer j = 1;                     
            for (Channel_Qualifications__c chanelPreQuals :channelList ) {  
                
                selectedProductQualIds += chanelPreQuals.Id +Label.System_Colon;
                ChannelPQWrapper channel = new ChannelPQWrapper();
                channel.preQuals = chanelPreQuals ;
                channel.row = j;                    
                selectedchannelPQs.add(channel );
                j++;
               data1.add(new Item(chanelpreQuals, String.valueOf(i)));
                //data1.add(new Item(scoreName[0], chanelpreQuals.General_Score__c.SetScale(2), String.valueOf(i)));
                //data1.add(new Item(scoreName[1], chanelpreQuals.Market_Score__c.SetScale(2), String.valueOf(i)));
                //data1.add(new Item(scoreName[2], chanelpreQuals.Portfolio_Score__c.SetScale(2), String.valueOf(i)));
               // data1.add(new Item(scoreName[3], chanelpreQuals.Organization_Score__c.SetScale(2), String.valueOf(i)));
               // data1.add(new Item(scoreName[4], chanelpreQuals.Attitude_Score__c.SetScale(2), String.valueOf(i)));
                //data1.add(new Item(scoreName[5], chanelpreQuals.Business_Score__c.SetScale(2), String.valueOf(i)));
                
                 i++;
            }  
            
            selectedProductQualIds = selectedProductQualIds.substring(0, selectedProductQualIds.length()-1); 
        }
        
        return null;
    }
/**    
   * To redirect to chart displaying page
*/   
    public PageReference goToChartPage() {
        PageReference pg = Page.selectedChannelPreQualPage;
        pg.setRedirect(FALSE);
        return pg;
    }
/**    
  * Search Channel Qualification based on filters
*/  
    public PageReference SearchChannelPreQual() {
        
        selectedProductQualIds = '';
        SelectedProductQualicIdSet.clear();
      
        String query = Label.channelPreQual_query_string;
        
        createdDatFrom = (channel.Approval_Date__c != NULL) ? channel.Approval_Date__c : NULL;
        createdDatTo = (channelTo.Approval_Date__c != NULL) ? channelTo.Approval_Date__c : NULL;
        
        nextDat = (channel.Approval_Date__c != NULL) ? channel.Approval_Date__c.addDays(1) : NULL;
        nextDatTo = (channelTo.Approval_Date__c != NULL) ? channelTo.Approval_Date__c.addDays(1) : NULL;
        
        compDateFrom = (channel.Date_of_Completed__c != NULL) ? channel.Date_of_Completed__c: NULL;
        compDateTo = (channelTo.Date_of_Completed__c != NULL) ? channelTo.Date_of_Completed__c: NULL;
       
        nextCompDat = (channel.Date_of_Completed__c != NULL) ? channel.Date_of_Completed__c.addDays(1) : NULL;
        nextCompDatTo = (channel.Date_of_Completed__c != NULL) ? channel.Date_of_Completed__c.addDays(1) : NULL;
        
      
        query += (channel.Status__c != NULL) ? ' AND Status__c = \''+ channel.Status__c + '\'' : '';
        query += (selCountry != NULL) ? ' AND Account__r.Primary_Address_Country__c = \''+ selCountry + '\'' : '';
        
        if (createdDatFrom != NULL && createdDatTo != NULL) {
            query += ' AND CreatedDate >= :createdDatFrom AND CreatedDate < :nextDatTo';
        } else if (createdDatFrom != NULL && createdDatTo == NULL) {
            query += ' AND CreatedDate >= :createdDatFrom ';
        } else if (createdDatFrom == NULL && createdDatTo != NULL) {
            query += ' AND CreatedDate < :nextDatTo ';
        }else{}
        
        if (compDateFrom != NULL && compDateTo != NULL) {
            query += ' AND Date_of_Completed__c >= :compDateFrom AND Date_of_Completed__c <= :compDateTo';
        } else if (compDateFrom != NULL && compDateTo == NULL) {
            query += ' AND Date_of_Completed__c >= :compDateFrom ';
        } else if (compDateFrom == NULL && compDateTo != NULL) {
            query += ' AND Date_of_Completed__c <= :compDateTo ';
        }else{}
       
        query += (division != NULL) ? ' AND Channel_Market_Coverage__r.Division__c INCLUDES (\''+ division + '\')': '';
        query += (!String.isBlank(channelName)) ? ' and Name Like \'%'+ channelName +'%\'' : '';
        query += (!String.isBlank(accName)) ? ' and Account__r.Name Like \'%'+ accName+'%\'' : '';
        
        basicQuery = query ;
        
        if (selectedOpt == displayOptList[1]) {
            query = query+ ' AND (Id IN :SelectedProductQualicIdSet)';
        } 
        
        if (selectedOpt == displayOptList[2]) {
            query = query+ ' AND (Id NOT IN :SelectedProductQualicIdSet)';
        } 
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(query + ' ORDER BY Name Limit 10000'));
        return null;
    }
    
/**
 * Option All, Selected and Unselected
*/ 
    public List<SelectOption> getdisplayOpt (){
        
        return new List<SelectOption>{new SelectOption(displayOptList[0], displayOptList[0]), new SelectOption(displayOptList[1], displayOptList[1]), new SelectOption(displayOptList[2], displayOptList[2])};
    }
/**    
  * Reirect to page
*/    
    public PageReference cancel() {        
        PageReference pg = (accountId != NULL) ? new PageREference('/'+accountId) : null; //Page.ChannelPreQualificationComparePage;
        pg.setRedirect(TRUE);
        return pg;
    }
/**    
  * To go to channel pre qualifiation displaying page
*/  
    public PageReference backToDisplay() {
    
        selectedchannelPQs.clear();  
        iscompareClicked = FALSE;
        this.setCon.setpagenumber(1);
        PageReference pg = Page.ChannelPreQualificationComparePage;
        pg.setRedirect(FALSE);
        return pg;
    }
/**    
  * previous page number
*/  
    public Boolean getHasPrevious(){ 
        return this.setCon.getHasPrevious(); 
    }
/** 
  * next number
*/  
    public Boolean getHasNext(){ 
        return this.setCon.getHasNext(); 
    }
/** 
   * current page number
*/   
    public Integer getPageNumber(){ 
        return this.setCon.getPageNumber(); 
    }
/**    
  * Total page count
*/  
    Public Integer getTotalPages(){
 
        Decimal totalSize = this.setCon.getResultSize();
        Decimal pageSize = this.setCon.getPageSize();
 
        Decimal pages = totalSize/pageSize;
 
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
/** 
  * Go to next page
*/  
    public void doNext() { 
        
        String st =selectedChannelId;
        addSelectedIds(st);
        
        if (this.setCon.getHasNext())  {
            this.setCon.next(); 
        }           
    }
/** 
 * returns the first page of records
*/  
    public void first() {
    
        String st =selectedChannelId;
        addSelectedIds(st);
        this.setCon.first();
    }
/**
  * returns the last page of records
*/  
    public void last() {
    
        String st =selectedChannelId;
        addSelectedIds(st);
        this.setCon.last();
    }
/**    
   * To add the selected ids in set
*/   
    public void addSelectedIds(String st) {
        
        selectedProductQualIds = '';
        List<Id> str = new List<Id>();
        if (st != null && st != '') {
            if (st.contains(Label.CL00069)){                
                str = st.split(Label.CL00069);
            } else {
                str.add(st);
            }   
            SelectedProductQualicIdSet.addAll(str);
        }
    }
/**    
 * Go to previous page
*/ 
    public void doPrevious(){ 
        
        //To keep the selected id during navigation (pagination)
        String st =selectedChannelId;
        addSelectedIds(st);
       
        if(this.setCon.getHasPrevious())  this.setCon.previous();   
    }
/**    
 * inner class for chart purpose
*/ 
    public with sharing class Item {

        private String name;
        private Decimal per;
        private Decimal data1;
        private Decimal data2;
        private Decimal data3;
        private Decimal data4;
        private Decimal data5;
        private Decimal data6;
        private String data;
        private String lbl;
        
        /**   
        *  Stacked Barchart : Item - Wrapper Class Constructor.
          
        */ 
        Item(Channel_Qualifications__c chanelpreQuals, String displayRow) {
            this.name = name;
            Decimal perval =  per; //Math.round(per);
            
            data1 = chanelpreQuals.General_Score__c.SetScale(2);
            data2 = chanelpreQuals.Market_Score__c.SetScale(2);
            data3 = chanelpreQuals.Portfolio_Score__c.SetScale(2); 
            data4 = chanelpreQuals.Organization_Score__c.SetScale(2);
            data5 = chanelpreQuals.Attitude_Score__c.SetScale(2);
            data6 = chanelpreQuals.Business_Score__c.SetScale(2);
           
            lbl = displayRow;
            data = string.valueof(perval);
            this.name = displayRow;
                 
        }
    }
}
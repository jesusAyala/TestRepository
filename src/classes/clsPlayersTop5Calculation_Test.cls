@istest (SeeAllData = False)
public class clsPlayersTop5Calculation_Test {

Private Static testmethod void clsPlayersTop5Calculation_Test(){   


    Account Acc = new Account();
    Acc.Name = 'Test account';
    Acc.BillingCountry = 'India';
    Acc.BillingStreet = 'Test Street';
    Acc.BillingCity = 'Test City';
    
    insert Acc; 
    
    Contact con = new Contact();
    con.LastName = 'Test Contact';
    con.email = 'Test@email.com';
    con.AccountId = Acc.Id;
    
    insert con;
    
    End_User_Project__c EUP = new End_User_Project__c();
    
    EUP.Name = 'Test EUP';
    EUP.Account_End_User__c = Acc.Id;
    EUP.End_User_Project_Status__c = 'Open';
    
    insert EUP;
    
    Capture_Team__c CP = new Capture_Team__c();
    CP.Name = 'Test Capture Team';
    CP.End_User_Project__c = EUP.Id;
    
    insert CP;
    
    List<Player__c> lstPly = new List<Player__c>();
    
    Player__c P1 = new Player__c();
    P1.Capture_Team__c = CP.Id;
    P1.Contact__c = con.Id;
    P1.Value_Priority_1__c = 'Low risk';
    P1.Value_Priority_2__c = 'Technology';
    P1.Value_Priority_3__c = 'Rapid payback';
    P1.Power__c = 'High';
    lstPly.add(P1);
    
     
    Player__c P2 = new Player__c();
    P2.Capture_Team__c = CP.Id;
    P2.Value_Priority_1__c = 'Technology';
    P2.Value_Priority_2__c = 'Low risk';
    P2.Value_Priority_3__c = 'Rapid payback';
    P2.Power__c = 'High';
    lstPly.add(P2);
    
    Player__c P3 = new Player__c();
    P3.Capture_Team__c = CP.Id;
    P3.Value_Priority_1__c = 'Technology';
    P3.Value_Priority_2__c = 'Rapid payback';
    P3.Value_Priority_3__c = 'Low risk';
    P3.Power__c = 'High';
    lstPly.add(P3);
    
    Player__c P4 = new Player__c();
    P4.Capture_Team__c = CP.Id;
    P4.Value_Priority_1__c = 'Low risk';
    P4.Value_Priority_2__c = 'Technology';
    P4.Value_Priority_3__c = 'Rapid payback';
    P4.Power__c = 'High';
    lstPly.add(P4);
    
    Player__c P5 = new Player__c();
    P5.Capture_Team__c = CP.Id;
    P5.Value_Priority_1__c = 'Low risk';
    P5.Value_Priority_2__c = 'Technology';
    P5.Value_Priority_3__c = 'Rapid payback';
    P5.Power__c = 'High';
    lstPly.add(P5);
    
    insert lstPly;

    
    ApexPages.currentPage().getParameters().put('Id', CP.Id);        
    
    ApexPages.StandardController CPctrl = new ApexPages.StandardController(CP);
    clsPlayersTop5Calculation objController  =  new clsPlayersTop5Calculation(CPctrl);    
    
    objController.Refresh();
    
    }
    
    
    
    
    
}
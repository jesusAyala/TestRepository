@isTest(seeAllData=true) 
private class PISOpportunityProductsExtension_Test {

    static testMethod void myUnitTest() {
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Name = 'sdjnbosetssss';
            insert acc;
            
            Contact con = ClsTestHelp.createTestContacts();
            con.LastName = 'tesddsssdd';
            con.AccountId = acc.Id;
            con.Email_Opt_Out__c = false;
            con.Preferred_Contact_Method__c = 'Email';
            insert con;
            
            Test.startTest();
            Product_Group__c pg = new Product_Group__c();
            pg.Business_Unit__c = 'tdsd';
            pg.Name = 'jinboetdspro';
            pg.Division__c = '10';
            insert pg;
            
            LBU_Code__c lc = new LBU_Code__c();
            lc.Abacus_Code__c = 'sd32';
            lc.BU__c = 'sswe';
            lc.Division__c = 'ssa';
            insert lc;
            
            Pricebook2 pb2 = new Pricebook2();
            pb2.Name = 'jinbotestd';
            pb2.CurrencyIsoCode = 'USD';
            insert pb2;
            
            Pricebook2 pb1 = new Pricebook2();
            pb1.Name = 'jinbotesddstd';
            pb1.CurrencyIsoCode = 'USD';
            insert pb1;
            
            Opportunity oppy = new Opportunity();
            oppy.AccountId = acc.Id;
            oppy.Primary_Contact__c = con.Id; 
            oppy.Name = 'Testpyssss';
            oppy.StageName = 'Negotiation';
            oppy.CloseDate = system.today();
            oppy.Actual_Bid_Submission_Date_Comm__c = system.today();
            oppy.Product_Group__c = pg.Id;
            oppy.Requested_Bid_Submission_Date_Comm__c = system.today();
            oppy.Application__c = 'AP.302 Cable Car - Ski Lift';
            oppy.Local_Business_Unit__c = lc.Id;
            oppy.Local_Product_Group__c = pg.Id;
            oppy.CurrencyIsoCode = 'USD';
            oppy.Opportunity_Value__c = 18646;
            insert oppy;
            
            Opportunity oppy1 = new Opportunity();
            oppy1.AccountId = acc.Id;
            oppy1.Primary_Contact__c = con.Id; 
            oppy1.Name = 'Tesyssss';
            oppy1.StageName = 'Negotiation';
            oppy1.CloseDate = system.today();
            oppy1.Actual_Bid_Submission_Date_Comm__c = system.today();
            oppy1.Product_Group__c = pg.Id;
            oppy1.Requested_Bid_Submission_Date_Comm__c = system.today();
            oppy1.Application__c = 'AP.302 Cable Car - Ski Lift';
            oppy1.Local_Business_Unit__c = lc.Id;
            oppy1.Local_Product_Group__c = pg.Id;
            oppy1.CurrencyIsoCode = 'USD';
            oppy1.Opportunity_Value__c = 18646;
            
            insert oppy1;
            
            Product2 p = new Product2();
            p.Name = 'jisksj';
            p.CID__c='876743h';
            p.isActive = true;
            insert p;
            p.CID__c='87673h';
            update p;
                       
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = Test.getStandardPricebookId();
            pbe.UnitPrice = 20;
            pbe.Product2Id = p.Id;
            pbe.IsActive = true;
            pbe.CurrencyIsoCode = 'USD';
            insert pbe;
            system.debug('**@@pbe' + pbe.CurrencyIsoCode);
            
            OpportunityLineitem oli = new OpportunityLineitem();
            oli.OpportunityId = oppy.Id;
            oli.PricebookEntryId = pbe.Id;
            oli.Quantity = 2.03;
            oli.TotalPrice = 221.1;
            insert oli;
            Test.stopTest();
            system.debug('**@@oli' + oli.CurrencyIsoCode);
            
            list<PISOpportunityProductsExtension.PISNode> products = new list<PISOpportunityProductsExtension.PISNode>();
            
            /*PISOpportunityProductsExtension.PISNode pisNode = new PISOpportunityProductsExtension.PISNode();
            pisNode.cid = 'tess';
            pisNode.englishDescription = 'testsddas';
            pisNode.languageSpecificDescription = 'tesssssss';
            products.add(pisNode);*/           
            ApexPages.StandardController ExtController = new ApexPages.StandardController(oli); 
            
            PISOpportunityProductsExtension cls = new PISOpportunityProductsExtension(ExtController);
            //PISOpportunityProductsExtension.ProductResult pr = PISOpportunityProductsExtension.replaceProduct(oli.Id, pisNode);
            //pisNode.cid = '87673h';
            //pr = PISOpportunityProductsExtension.replaceProduct(oli.Id, pisNode);
            PISOpportunityProductsExtension.ProductResult pr1 = PISOpportunityProductsExtension.addProducts(oppy1.Id, products);
            pr1 = PISOpportunityProductsExtension.addProducts(oppy.Id, products);
            //pisNode.cid = p.CID__c;
            //products.add(pisNode);
            PISOpportunityProductsExtension.ProductResult pr2 = PISOpportunityProductsExtension.addProducts(oppy.Id, products);
            
            
    }
}
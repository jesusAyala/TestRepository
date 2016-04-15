@isTest

private class TestFreezeUsers 
{
     static testmethod void test()
     {           
        
         Test.startTest();
         ScheduleFreezeUsers m = new ScheduleFreezeUsers();
         String sch = '20 30 8 10 2 ?';
         String jobID = system.schedule('FreezeUsers', sch, m);
         Test.stopTest();
     }
}
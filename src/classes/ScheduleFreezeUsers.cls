global class ScheduleFreezeUsers implements schedulable
{
    global void execute(SchedulableContext sc)
    {   
        FreezeUsers fu = new FreezeUsers();//creating Batch class object     
        database.executebatch(fu);
    }
}
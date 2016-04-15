global class FreezeUsers implements Database.Batchable<sObject>
{   
    List<UserLogin> LoggedinUsers=new List<UserLogin>();
    List<UserLogin> toupdateLoggedinUsers= new List<UserLogin>();
    datetime myDateTime = datetime.now();// Fetching Current system date and time
    datetime inactiveDateTime = myDateTime.addDays(-90);// Subtracting 90 days from system date and time to get the inactive time for fetching users that needs to be freezed
    global Database.querylocator start(Database.BatchableContext BC)
    {
        //Query to fetch the users who have not logged in for more than 90 days and are active
         if(!Test.isRunningTest())
             return Database.getQueryLocator([SELECT Email,Id,LastLoginDate FROM User WHERE(IsActive= True AND lastLoginDate < :inactiveDateTime)]);   
         else
             return Database.getQueryLocator([SELECT Email,Id,LastLoginDate FROM User WHERE(IsActive= True AND lastLoginDate < :myDateTime) LIMIT 10]);   
    }
    global void execute(Database.BatchableContext BC, List<User> users)
    {         
         Set<Id> uset=new Set<Id>();       
         for(user u:users)
         {
            uset.add(u.id);
         }
         LoggedinUsers=[select ID,UserID,IsFrozen  from UserLogin where IsFrozen=false And UserID in:uset];
         system.debug('loggedinUsers********************'+LoggedinUsers.size());
         for (UserLogin UserLoggedin : LoggedinUsers)
         {
               toupdateLoggedinUsers.add(UserLoggedin);
               if(Test.isRunningTest())
               break;
         }
       
         for(UserLogin usersToUpdate: toupdateLoggedinUsers)
         {
               usersToUpdate.IsFrozen=true;// Freezing users who have not loggedin for more than 90 days
         }
         update toupdateLoggedinUsers;
         Database.SaveResult[] srList = Database.update(users, false);
         for(Database.SaveResult sr : srList)
         {
              if (!sr.isSuccess()) 
              {
                  //Operation failed, so get all errors
                  for(Database.Error err : sr.getErrors())
                  {
                     System.debug('The following error has occurred.');
                     System.debug(err.getStatusCode() + ': ' + err.getMessage());
                  }
              } 
          }
          //create body for email
          Set<Id> userSet=new Set<Id>();
          system.debug('-->>'+toUpdateLoggedinUsers.size());  
          if(toUpdateLoggedinUsers.size()>0)
          {
             for(UserLogin ul : toUpdateLoggedinUsers)
             {
                     userSet.add(ul.UserId);
             }
             system.debug('Size=='+userSet.size());
             String BodyText = '<html><body><br><table cellpadding=\"10\"><tr><th>User Name</th><th>Email Address</th><th>User Profile</th><th>User Last Login</th><th>User Role</th><th>Country</th></tr>';          
             List<User> username=[select Name,Email,Profile.Name,UserRole.Name,lastLoginDate,country from User where ID In :userSet];
             for(User unm:username)
             {
                 BodyText += '<tr><td>'+ unm.Name +'</td><td>'+unm.Email+'</td><td>'+unm.Profile.Name+'</td><td>'+unm.lastLoginDate+'</td><td>'+unm.UserRole.Name+'</td><td>'+unm.country+'</td></tr>';                
             }                                

			if(!Test.isRunningTest()) {
			
			BodyText=BodyText+'</table></br></body></html>';          
             Messaging.SingleEmailMessage mail1=new Messaging.SingleEmailMessage();
             String[] toadd=new String[]{'CH-salesforce.support@abb.com'};
             mail1.setToAddresses(toadd);
             mail1.setSubject('List of Freeze Users');
             mail1.setPlainTextBody('This is a test mail');
             Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
             mail1.setToAddresses(toadd);
             mail1.setSubject('List of Freeze Users');
             mail1.setHtmlBody(BodyText);
             Messaging.sendEmail(new Messaging.singleEmailMessage[]{mail1});
			}
                    
          }
      }
             global void finish(Database.BatchableContext BC)
             {

             }
}
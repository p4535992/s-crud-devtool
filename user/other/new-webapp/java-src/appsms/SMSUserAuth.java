package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
import  com.webapp.db.* ;

public class SMSUserAuth
{
    

     public static String getAccountAuth(String dsn, String grp, int uid )
     throws java.sql.SQLException
		 {
             String ret="" ;		  
		     String qry = " SELECT * FROM  `sms_auth` WHERE `ExecuteBy` = '"+grp+"' AND `ExecutorID` = "+uid+" " ;
      	     GenericQuery genqry = new GenericQuery(dsn, "MYSQL" );
	         java.sql.ResultSet rslt = genqry.openQuery(qry);
			 if(rslt!=null && rslt.next()) ret= rslt.getString("Accounts");
      	     genqry.closeQuery();

	       return ret;
         } // End method getAccountAuth
		 
		 
		 public static int getAuthAccountCount(String dsn, String grp, int uid)
		 throws java.sql.SQLException
		 {
			  String[] str = getAccountAuth(dsn, grp, uid).split(",") ;
        return str !=null ? str.length : 0;			 
		 }
		 

		 public static void  setAccountAuth(String dsn, String grp, int uid, String acts)
		 throws java.sql.SQLException
		 {
		  	  GenericQuery genqry = new  GenericQuery(dsn, "MYSQL" );
	          if( genqry.recordCount("sms_auth", "  WHERE `ExecuteBy` = '"+grp+"' AND `ExecutorID` = "+uid+" ") > 0 )
              {
				   // Record exists, update record
					 genqry.execute(" UPDATE  `sms_auth` SET `Accounts` = '"+acts+"' WHERE `ExecuteBy` = '"+grp+"' AND `ExecutorID` = "+uid+" " );
			   }
			   else
			   {
				   // Record does not exists, create record 
					 genqry.execute(" INSERT INTO   `sms_auth` ( `ExecuteBy`, `ExecutorID`, `Accounts` ) VALUES ( '"+grp+"', "+uid+", '"+acts+"' ) ");
		       }
		 } // End method setAccountAuth




} // End class definition
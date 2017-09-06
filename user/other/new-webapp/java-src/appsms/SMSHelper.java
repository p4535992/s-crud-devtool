package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
import javax.servlet.* ;


public class SMSHelper
{
   public static String getDSN(ServletContext cntx )
   {
       String dsn  = cntx.getInitParameter("WEBSMS-DATASOURCE");
			 if( dsn==null ) dsn = "jdbc/$WEBAPP" ; // Assume defualt value if not set
			 return dsn;
   }
   
	 public static SMSService getService(ServletContext cntx)
	 {
	     return (SMSService)cntx.getAttribute("WEBSMS-SERVICE") ;
	 }
	 
	 
	 public static boolean checkNumber(String number, ServletContext cntx  )
		{ 
		     SMSSetting st = new SMSSetting(cntx );
		     String RegExp =  st.getValue("NUMBER-CHECK-REGEXP");
         if (number==null|| RegExp==null) return false ;
         return number.matches(RegExp) ;
		}
		
	 public static String  getValidNumberAdvice( ServletContext cntx)
	 {
	     SMSSetting st = new SMSSetting(cntx );
	     String RetVal = "?" ;
		   if( st.lookup("NUMBER-CHECK-REGEXP"))RetVal =  st.URL;
		   return RetVal;
	 }
   
	 public static boolean getServiceStatus( ServletContext cntx )
	 {
	     SMSSetting  st = new SMSSetting(cntx );
	     String val =  st.getValue("START-SMS-SERVICE");
			 return ( "YES".equalsIgnoreCase(val)  ) ? true : false ;
	 }
	 
	
 
	 


} // end class definition
 




package com.$WEBAPP.appmail;
import javax.servlet.* ;
import javax.servlet.http.* ;

public class MailHelper
{
   public static String getDSN(ServletContext cntx )
   {
       String dsn  = cntx.getInitParameter("MAIL-DATASOURCE");
			 if( dsn==null ) dsn = "jdbc/$WEBAPP" ; // Assume defualt value if not explicitly set
			 return dsn;
   }
   
	 public static MailServiceProvider  getService(ServletContext cntx)
	 {
	     return (MailServiceProvider)cntx.getAttribute("MAIL-SERVICE-PROVIDER") ;
	 }

		public static boolean checkEmailFormat(String email )
		{
       if (email == null) return false ;
       return email.matches("([a-zA-Z0-9_\\-\\.]+)@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})") ;
	  }
		
	  public static boolean getServiceStatus( ServletContext cntx )
	  {
	     MailSetting st = new MailSetting(cntx );
			 return st.getServiceStatus();
	  }

} // End class definition - MailHelper


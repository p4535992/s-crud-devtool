package com.$WEBAPP.appmail;
import javax.servlet.* ;

public class GenericMailContextListner implements javax.servlet.ServletContextListener
{

   public static void startMailServiceThread( javax.servlet.ServletContext cntx)
   {
        MailServiceInitThread th = new  MailServiceInitThread(cntx);
	      th.start();
	 }

 /* Mehods below are implementation of Interface:ServletContextListener */
	 public void contextInitialized(ServletContextEvent sce)
   {
				startMailServiceThread(sce.getServletContext());
	 }
	 
	 public void contextDestroyed(ServletContextEvent sce)
   {
     // Empty facade just required to complete the interfact implementation
   }  // contextDestroyed(ServletContextEvent sce)

}

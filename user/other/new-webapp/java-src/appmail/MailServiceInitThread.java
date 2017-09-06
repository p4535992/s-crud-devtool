package com.$WEBAPP.appmail;
import javax.servlet.* ;

public class MailServiceInitThread extends Thread
{
    private  ServletContext context = null;
		
		public MailServiceInitThread(ServletContext cntx)
    {
		     this.context = cntx;
    }				 

    public void run()
    {
         MailServiceProvider.createService(this.context );
	   // Create Service 

    }  // End method run	 
     
}  // End class definition: MailServiceInitThread


package com.$WEBAPP ;
import javax.servlet.*; 

public   class $WEBAPPContextListener
implements javax.servlet.ServletContextListener
{
   public  $WEBAPPContextListener()
   {
      //  default constructor
   }
   public void contextInitialized(ServletContextEvent sce)
   {
       // Obtain web application servlet context
			 
       javax.servlet.ServletContext context = sce.getServletContext();
		
       /* 
          Code to initialize IP based Access Control
          com.$WEBAPP.ClientIPCheck ip_chk = new  com.$WEBAPP.ClientIPCheck() ;
          ip_chk.init(context);
           
          String object_id = context.getInitParameter("CLIENT-IP-ACCESS-CONTROL");
 
         context.setAttribute(object_id , ip_chk ) ;
       */	 


       /* Initialize InitThread object 
          Start web application star-up thread in back ground 
          Tasks which take longer time should be started in Init thread 
          otherwise entire application may take too much time to startup.
       InitThread initthread = new InitThread(context);
       initthread.start();
		*/
	   
			com.validation.AppValidator vld = new com.validation.AppValidator();
			vld.init(context);
			vld.validate();
		   
        synchronized(context)
        {

			context.setAttribute("VALIDATOR", vld );
        }
	   
		// Initialize Checkload and ShowItem which requires value of static variable for Servlet Context to be set 
			
			ShowItem.init(context);
        
			 
   } // End method  contextInitialized(ServletContextEvent sce)     

   public void contextDestroyed(ServletContextEvent sce)
   {
      // Empty facade just required to complete the class
		 
   }  // contextDestroyed(ServletContextEvent sce)

   
} // end class definition

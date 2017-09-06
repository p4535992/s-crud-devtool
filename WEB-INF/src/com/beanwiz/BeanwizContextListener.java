package com.beanwiz ;
import javax.servlet.*; 

public   class BeanwizContextListener
implements javax.servlet.ServletContextListener
{
   public  BeanwizContextListener()
   {
     //  default constructor
   }
   public void contextInitialized(ServletContextEvent sce)
   {
       javax.servlet.ServletContext context = sce.getServletContext();
       com.validation.AppValidator vld = new com.validation.AppValidator();
       vld.init(context);
       vld.validate();
       synchronized (context) 
      {
	        context.setAttribute("VALIDATOR", vld );
      } 
	
			 
			 
   } // End method  contextInitialized(ServletContextEvent sce)     
  

   public void contextDestroyed(ServletContextEvent sce)
   {
     // Empty facade just required to complete the class
		 
   }  // contextDestroyed(ServletContextEvent sce)

} // end class definition

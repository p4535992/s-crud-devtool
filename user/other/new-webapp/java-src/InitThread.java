
package com.$WEBAPP ;

import javax.servlet.ServletContext;

public class InitThread extends Thread
{
    
  // private variable that stores reference to servlet context

    private ServletContext context;
    
  // Thread Object constructor
    public InitThread(ServletContext servletcontext )
    {
        context = servletcontext;
    }

    // run() will be called on thread start-up
    
    public void run()
    {
			com.validation.AppValidator vld = new com.validation.AppValidator();
			vld.init(context);
			vld.validate();
		   
        synchronized(context)
        {
           /*
             Typical things to do: 
             Application wise object available through servlet context.
             create some class object
             com.$WEBAPP.FooClass foo = new com.$WEBAPP.FooClass() ;
             put that class in the context as attribute so it is available to all
	         context.setAttribute("FOO-OBJECT", foo);
           */
 			context.setAttribute("VALIDATOR", vld );
       }
    }

    
    
} // end class definition
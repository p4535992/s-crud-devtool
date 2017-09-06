/*
 *  Hello Servlet for sanity check
 */
package com.beanwiz ; 
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.* ;
import com.webapp.utils.* ;


/**
 * Servlet definition
 * @author  Kelkar
 * @version 
 */
public class MakeBean extends HttpServlet 
{
      private RequestDispatcher rd = null ;
      private String fwd = null ;   
			private javax.servlet.ServletContext theApp =null;
			private com.validation.AppValidator vld = null;
			public void init()
      {
          theApp=this.getServletContext()	;
 	    }
			
			
			public void doGet( HttpServletRequest request , HttpServletResponse response)
      throws ServletException, IOException
      {
			     fwd=null;
		       boolean bOldCode = ( request.getParameter("OldBeanCode") != null )? true : false  ; 
           String DriverName= request.getParameter("DriverName");
				   if ( request.getParameter("GenericDriver") !=null )
           {
					     // Default Driver if explicitely requested.
							 
               fwd = "/user/newbeans/default-driver.jsp" ;
           }
					 else
					 {  
					      short sqlEng = PortableSQL.getEngineFromDriverName(DriverName);
								switch( sqlEng )
								{
								    case PortableSQL.MYSQL:
										    fwd = "/user/newbeans/mysql.jsp" ;
										break ;
	
								    case PortableSQL.POSTGRE:
										     fwd = "/user/newbeans/postgres.jsp" ;
										break ;

								    case PortableSQL.DB2:
										     fwd = "/user/newbeans/ibmdb2.jsp"  ;
										break ;

								    case PortableSQL.MSSQL:
										     fwd = "/user/newbeans/mssql.jsp"  ; 
										break ;

								    case PortableSQL.ORACLE:
										     fwd = "/user/newbeans/oracle.jsp"  ;
										break ;
										
								    case PortableSQL.H2:
										   	 fwd = "/user/newbeans/h2db.jsp"  ;
										break ;
										
								    case PortableSQL.SQLITE:
										     fwd = "/user/newbeans/sqlite.jsp" ;
										break ;

								
								    default: 
									    fwd = "/user/newbeans/default-driver.jsp"  ;
									  break;
								} // end case switch( sqlEng )
					} // end   if ( request.getParameter("GenericDriver") !=null )
				
	 		  com.validation.AppValidator vld  = (com.validation.AppValidator)theApp.getAttribute("VALIDATOR");
				if(vld==null  ) fwd = "/licence-error.jsp" ;
			  if( !vld.bValidApp )
				{
				   if(! vld.validate() )fwd = "/licence-error.jsp" ; 
				}
	       rd = request.getRequestDispatcher(fwd);
	       rd.forward(request, response );	

     }  // end method doGet()

     public void doPost( HttpServletRequest request , HttpServletResponse response)
     throws ServletException, IOException
     {
         doGet(request, response);
     }

}  // END CLASS DEFINITION


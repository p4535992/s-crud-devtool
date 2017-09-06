/*
 *  Hello Servlet for sanity check
 */
package com.beanwiz ; 
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;



/**
 *
 * @author  Kelkar
 * @version 
 */
public class GetJSP extends HttpServlet 
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
		doPost(request, response);
    }
		
		

 public void doPost( HttpServletRequest request , HttpServletResponse response)
    throws ServletException, IOException
    {
    //doGet(request, response);
	
         String OuputPage=request.getParameter("OuputPage");
         if ("AllInOne".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/get-all-in-one.jsp" ;
		 else if("Listpage".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-Listpage.jsp";
		 else if("Listpage-P".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-Listpage-P.jsp";
		 else if("S-R-D-P".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-S-R-D-P.jsp";
		 else if("S-R-D".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-S-R-D.jsp";
		 else if("S-R-D-QryObj".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-S-R-D-QryObj.jsp";
		 else if("R-D".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-R-D.jsp";
		 else if("R-D-P".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-R-D-P.jsp";
		 else if("R-D-POPUP".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-R-D-POPUP.jsp";
		 else if("DataMatrix".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-data-matrix.jsp";
/*
				 else if("SearchMultipleOld".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/oldstyle/getsearchmultipage.jsp" ;
	       else if("SearchSingle".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/getsearchsinglepage.jsp" ;
				 else if("SearchSingleOld".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/oldstyle/getsearchsinglepage.jsp" ;
	       else if("List".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/getlistpage.jsp" ;
				 else if("ListOld".equalsIgnoreCase(OuputPage)) fwd = "/user/jsp/oldstyle/getlistpage.jsp" ;
	       else if("SearchPopup".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/getpopuppage.jsp";
		     else if("OnlyTableData".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/getonlytabledata.jsp";
		     else if("PaginatedTableData".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-paginated-tabledata.jsp";
		     else if("SelectionActivity".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/get-selection-activity-page.jsp";
		     else if("QuickFieldUpdate".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/quickedit/get-quick-field-update-form.jsp";
				 else if("SelectionDataUpdate".equalsIgnoreCase(OuputPage))fwd = "/user/jsp/bulkdataupdate/get-selection-data-update-page.jsp";			 
 */				 
				 
				 
				 
				 
	       else fwd = "/user/jsppageerror.jsp";
				// Check Authentication
    		com.validation.AppValidator vld  = (com.validation.AppValidator)theApp.getAttribute("VALIDATOR");
		    if(vld==null  ) fwd = "/licence-error.jsp" ;
			  if( !vld.bValidApp )
				{
				   if(! vld.validate() )fwd = "/licence-error.jsp" ; 
				}
	      rd = request.getRequestDispatcher(fwd);
	      rd.forward(request, response );	
    }



}


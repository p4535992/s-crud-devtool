/*
 *  Hello Servlet for sanity check
 */
package com.beanwiz ; 
import java.io.*;
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.naming.* ;
import javax.sql.* ;
import com.webapp.utils.* ;
/**
 *
 * @author  Kelkar
 * @version 
 */
public class TableFields extends HttpServlet {


public void doGet( HttpServletRequest request , HttpServletResponse response)
    throws ServletException, IOException
{
 response.setContentType("text/plain");
 String JNDIDSN = request.getParameter("JNDIDSN");
 String TableName = request.getParameter("TableName");
 String Element = request.getParameter("Element");
 String Selected = request.getParameter("Select");
 if(Selected==null)Selected="";
 PrintWriter out = response.getWriter();
 out.println("<select name=\""+Element+"\" id=\""+Element+"\" class=\"form-control selectpicker\" >");
 try
 {
 java.sql.Connection conn =  null ;

 try 
 {
 Context env = (Context) new InitialContext().lookup("java:comp/env");
 DataSource source = (DataSource) env.lookup(JNDIDSN);
 source.getConnection();
 
  
   conn = source.getConnection();
	 com.webapp.utils.PortableSQL psql = new  com.webapp.utils.PortableSQL(conn);  
	 String query = psql.SQL(" SELECT * FROM `"+TableName+"` ") ;
   java.sql.Statement stmt = conn.createStatement();
   java.sql.ResultSet rslt = stmt.executeQuery(query);
   java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
   int count  = rsmd.getColumnCount();	
   String SelTag=null;
	 
	 
	 int sqltype=0;
   for(int n = 1 ; n <= count ; n++ )
   {	
	    sqltype = rsmd.getColumnType(n);
	    String ColName = rsmd.getColumnName(n) ;
			SelTag = (ColName.equalsIgnoreCase(Selected)) ? " selected=\"selected\"": " " ;
			out.println("<option value=\""+ColName+"\" "+SelTag+">"+ColName+"</option>"); 
   }// end for(int n = 1 ; n <= count ; n++ ) 
	 stmt.close();
 }
 finally
 {
 	 conn.close();
 }
 out.println("</select>"); 
 }
 catch(javax.naming.NamingException ex1)
 {
   out.println("Error:"+ex1.toString());
 }
 catch(java.sql.SQLException ex1)
 {
  out.println("Error:"+ex1.toString());
 }
	
} // end do get

   public void doPost( HttpServletRequest request , HttpServletResponse response)
    throws ServletException, IOException
    {
    doGet(request, response);
    }


}

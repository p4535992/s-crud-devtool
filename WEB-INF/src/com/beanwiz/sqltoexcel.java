package com.beanwiz ; 
import java.io.*;
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.poi.ss.usermodel.* ;
import org.apache.poi.xssf.usermodel.* ;
import org.apache.poi.hssf.usermodel.* ;
import com.webapp.utils.*;
import com.webapp.db.*;
import com.webapp.base64.*;
import com.webapp.poi.*;


public class sqltoexcel extends HttpServlet
{
    private String dsn = null ;
		private String sqlengine = null ;
	  private String checkboxname=null;
		private String checkboxclass = null;
	 /*
		private String url = null;
	 */
	 	
		public void init()
		{
		      this.dsn = getInitParameter("DSN");
					this.sqlengine = getInitParameter("SQL-ENGINE");
					this.checkboxname = getInitParameter("CHECKBOXNAME");
					if(this.sqlengine == null )
          {
            // As fallback, try to look in application context parameters 
		        // if servlet init parameters are missing
			         this.sqlengine = getServletContext().getInitParameter("SQL-ENGINE");
          }
					if(this.checkboxname==null) this.checkboxname = "COLUMNS" ;
					this.checkboxclass = getInitParameter("CHECKBOXCLASS");
					if(this.checkboxclass ==null) this.checkboxclass = "chkbx" ;
					
          // if sqlengine is still null as last resort try obtain from connection
		}
		

    public void doGet( HttpServletRequest request , HttpServletResponse response)
    throws ServletException, IOException
    {
	       String ParamSQL = request.getParameter("SQL");
				 String ParamDSN = request.getParameter("DSN");
				 String ParamENG = request.getParameter("SQL-ENGINE");
				 String TableID = request.getParameter("TABLEID");
				 if(TableID==null) TableID="column_list" ;
				 String ParamCHECKBOXNAME = request.getParameter("CHECKBOXNAME");
				 String ParamCHECKBOXCLASS = request.getParameter("CHECKBOXCLASS");
				 
				 String fieldname = ( ParamCHECKBOXNAME !=null )? ParamCHECKBOXNAME : this.checkboxname ;
				 String clsname =   ( ParamCHECKBOXCLASS !=null)? ParamCHECKBOXCLASS: this.checkboxclass;
				 
				 String qry_dsn = (ParamDSN!=null) ? ParamDSN: this.dsn ;
				 String qry_eng = (ParamENG!=null) ? ParamENG: this.sqlengine ;
				 GenericQuery genqry = new GenericQuery(qry_dsn, qry_eng); 
				
				 
				 
				 response.setContentType("text/html");
         // Disable caching at all levels
	       response.setDateHeader("Expires", 0 );
         response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
         response.setHeader("Pragma", "no-cache"); 
				
				 PrintWriter out = response.getWriter();
		     if(ParamSQL==null)
		     {
		            out.println("<font color=\"red\" ><b>Error in servlet parameters.</font></b><br/>Servlet invoked without mandatory request parameter: SQL");
		            out.println("<br/>This is unexpected behaviour. Please report this error.");
								out.flush();
		            out.close();
			          return ;
		     } 
				 String SQL = new String(UrlBase64.decode( ParamSQL ));
         
         try
				 {
				      /*
							String thisFile = request.getContextPath()+this.url ;
				      out.println("<form action=\""+thisFile+"\" method=\"post\" id=\"select_column_form\" >");
				      out.println("<input type=\"hidden\" name=\"SQL\" value=\""+ParamSQL+"\" />");
				      if( ParamDSN != null )
				      {
				           out.println("<input type=\"hidden\" name=\"DSN\" value=\""+ParamDSN+"\" />");
				      } 
				      if(ParamENG !=null )
				      {
				     out.println("<input type=\"hidden\" name=\"SQL-ENGINE\" value=\""+ParamENG+"\" />");
				      }
							*/
				      out.println("<div class=\"table-responsive attn_div\"><table border=\"1\" cellpadding=\"4\" cellspacing=\"0\"  id=\""+TableID+"\" class=\"table table-striped table-bordered table-condensed \"  >");
					  out.println("<thead><tr><th width=\"7%\">#</th><th width=\"7%\" valign=\"middle\"><span class=\"checkbox checkbox-inline checkbox-primary\" ><input type=\"checkbox\" name=\"chk_tablefeld\" id=\"chk_tablefeld\" /><label for=\"chk_tablefeld\">&nbsp;</label></span></th><th>Tale Column Name</th></tr></thead>");
					  out.println("<tbody>");    
              ResultSet rslt = genqry.openQuery(SQL);
				      ResultSetMetaData rsmd = rslt.getMetaData();
				      for(int n = 1 ; n < rsmd.getColumnCount() ; n++)
				      {
				          
					        out.println("<tr>");
							out.println("<td>"+(n)+"</td>");
					        out.println("<td valign=\"middle\"><span class=\"checkbox checkbox-inline checkbox-primary\"><input type=\"checkbox\" name=\""+fieldname+"\" id=\""+fieldname+"_"+n+"\" class=\""+clsname+"\" value=\""+n+"\" /><label for=\""+fieldname+"_"+n+"\">&nbsp;</label></span></td>"); 
							
					        out.println("<td>"+rsmd.getColumnLabel(n)+"</td>");
							out.println("</tr>");
							/*
							if(n%(rsmd.getColumnCount()/2) ==0 ) 
							{	
							out.println("</table></div>");
							out.println("<div class=\"table-responsive attn_div\"><table border=\"1\" cellpadding=\"4\" cellspacing=\"0\"  id=\""+TableID+"\" class=\"table table-striped table-bordered table-condensed \"  >");
					  out.println("<thead><tr><th width=\"10%\" valign=\"middle\"><span class=\"checkbox checkbox-inline checkbox-primary\"><input type=\"checkbox\" name=\"chk_tablefeld\" id=\"chk_tablefeld\"/><label for=\"chk_tablefeld\">&nbsp;</label></span></th><th width=\"10%\">#</th><th>Tale Column Name</th></tr></thead>");
					  out.println("<tbody>");
					        }
						    */	
				      }
							
							out.println("</tbody></table></div>");
				      genqry.closeQuery();
							
							/*
				      out.println("<tr>");
					    out.println("<td>Submit</td>");
					    out.println("<td colspan=\"2\" ><button type=\"submit\">OK, Submit</button> </td>"); 
					    out.println("</tr>");
              out.println("</table>");
				      out.println("</form>");
							*/
         }
				 catch(SQLException ex)
				 {
				     out.println(dumpException(ex));
				 }	         			  
				 out.flush();
		     out.close();
				 
				 
	  } // END method do get
	
	
	  public void doPost( HttpServletRequest request , HttpServletResponse response)
    throws ServletException, IOException
    {
		   
         String ParamSQL = request.getParameter("SQL");
				 String ParamDSN = request.getParameter("DSN");
				 String ParamENG = request.getParameter("SQL-ENGINE");
				 String qry_dsn = (ParamDSN!=null) ? ParamDSN: this.dsn ;
				 String qry_eng = (ParamENG!=null) ? ParamENG: this.sqlengine ;
				 GenericQuery genqry = new GenericQuery(qry_dsn, qry_eng); 
				 String SQL = new String(UrlBase64.decode( ParamSQL ));
				 String ParamCHECKBOXNAME = request.getParameter("CHECKBOXNAME");
				 String fieldname = ( ParamCHECKBOXNAME !=null )? ParamCHECKBOXNAME : this.checkboxname ;
				 String ParamCHECKBOXCLASS = request.getParameter("CHECKBOXCLASS");
				 String clsname =   ( ParamCHECKBOXCLASS !=null)? ParamCHECKBOXCLASS: this.checkboxclass;
				 
	
	       String xls = request.getParameter("xls");
				 if(xls ==null ) xls="None";
	
          // Disable caching at all levels
	       response.setDateHeader("Expires", 0 );
         response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
         response.setHeader("Pragma", "no-cache"); 
				
		     if(ParamSQL==null)
		     {      PrintWriter out = response.getWriter();
				        response.setContentType("text/html");
		            out.println("<font color=\"red\" ><b>Error in servlet parameters.</font></b><br/>Servlet invoked without required paramter SQL");
			          out.flush();
		            out.close();
			          return ;
		     } 
				 
				 
				 String[] str_cols = request.getParameterValues(fieldname) ;
				 if(str_cols==null || str_cols.length==0)
		     {      PrintWriter out = response.getWriter();
				        response.setContentType("text/html");
		            out.println("<font color=\"red\" ><b>Error in column selection.</font></b><br/>Not a single colum was selected, at least check few columns.");
			          out.flush();
		            out.close();
			          return ;
		     } 

				 POIHelper poih = new  POIHelper();
				 Workbook book =null;
				 String MimeType="";
         String ContentDisp = "";
					
				 if("true".equalsIgnoreCase(xls)||"yes".equalsIgnoreCase(xls) )
				 {
				       book = new HSSFWorkbook() ;
							 MimeType=POIHelper.MIME_XLS ; 
							 ContentDisp = "attachment; filename=report.xls" ;
				 }
				 else
				 {
              book = new XSSFWorkbook() ;
							MimeType=POIHelper.MIME_XLSX ;
							ContentDisp = "attachment; filename=report.xlsx" ;
				 }

				 try
				 {
           CreationHelper hlpr = book.getCreationHelper();
           Sheet sheet =  book.createSheet() ;
           Row hdrrow = sheet.createRow(0);
					 ResultSet rslt = genqry.openQuery(SQL);
					 ResultSetMetaData rsmd = rslt.getMetaData();
					 int[] cols = new int[str_cols.length] ;
				   int[] sql_types = new int[str_cols.length] ;
					 for( int i =0; i < str_cols.length ; i++)
					 {
					    cols[i]  = Integer.parseInt(str_cols[i]);
							sql_types[i] = rsmd.getColumnType(cols[i]+1);
					 }
					 
					 poih.createHeaderRowFromResultSet( hdrrow, rslt, cols);
					 int n = 0;
					 while(rslt.next())
					 {
					     n++;
							 Row datarow = sheet.createRow(n);
							 poih.createDataRowFromResultSet( datarow, rslt, cols , sql_types);
					 }
		       genqry.closeQuery();
				 }
				 catch(Exception ex)
				 {
				        PrintWriter out = response.getWriter();
				        response.setContentType("text/html");
								out.println(dumpException(ex));
								out.flush();
		            out.close();
			          return ;
				 }	 
				
         response.setContentType(MimeType);
         response.setHeader("Content-Disposition", ContentDisp);
         response.setDateHeader("Expires", 0 );
         response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
         response.setHeader("Pragma", "no-cache"); 	 
			   ServletOutputStream sout = response.getOutputStream(); 
			   book.write(sout);
				 sout.close();
					 
     
    } // END method to post

		
		private String dumpException(Exception ex )
		{
		  StringBuilder sb = new StringBuilder();
			sb.append("<p><b><span style=\"color:red;\">Error: </span>"+ex.getMessage()+"</b></p>");
		  sb.append("<b>Dump of stack trace:</b><br/>");
      ByteArrayOutputStream bout = new ByteArrayOutputStream();
      ex.printStackTrace(new PrintStream(bout));
      sb.append(bout.toString().replace("\r\n", "\r\n<br />") );
			return sb.toString();
		}
		
		 
		
		
}  // END class definition sqltoexcel

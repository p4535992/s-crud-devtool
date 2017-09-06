package com.$WEBAPP.apputil ;
import java.io.*;
import java.util.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

import javax.servlet.*;
import javax.servlet.http.*;
import com.webapp.utils.*;

public class dbdroplist extends HttpServlet
{
  boolean bOK = true;
  private String dsn = null;
  private String table = null;
  private String idfield = null;
  private String optionvalue = null;
  private String fields[] = null;
  private String format = null;
  private String fieldstring = null;
  private javax.sql.DataSource source = null;

  private com.webapp.utils.PortableSQL psql = null;
  public void init()
  {
    int i = 0;
    dsn = getInitParameter("DSN");

    if (dsn == null) bOK = false;
    table = getInitParameter("TABLE");

    if (table == null) bOK = false;
    idfield = getInitParameter("IDFIELD");
	
    if (table == null) bOK = false;
    optionvalue = getInitParameter("OPTIONVALUE");

    if (idfield == null) bOK = false;
    fieldstring = getInitParameter("FIELDS");

    if (fieldstring == null) bOK = false;
    format = getInitParameter("FORMAT");
	
    if (fieldstring != null && fieldstring.length() > 0)
    {
      fields = fieldstring.split(",");
      if (fields == null || fields.length == 0) bOK = false;
    }

    if (format == null && fields != null)
    {
      for (i = 0; i < fields.length; i++)
      {
        fields[i] = fields[i].trim();
        format = (format != null ? format : " ") + fields[i] + " ";
      }
    }
    // First look For SQL-Engine value in servlet init parameters.
    String sqlengine = getInitParameter("SQL-ENGINE");
    if (sqlengine == null)
    {
      // As fallback, try to look in application context parameters 
      // if servlet init parameters are missing
      sqlengine = getServletContext().getInitParameter("SQL-ENGINE");
    }
    if (sqlengine != null)
    {
      psql = new com.webapp.utils.PortableSQL(sqlengine);
    }
    else
    {
      psql = new com.webapp.utils.PortableSQL();
    }

    try
    {
      javax.naming.Context env = (javax.naming.Context) new javax.naming.InitialContext().lookup("java:comp/env");
      source = (javax.sql.DataSource) env.lookup(dsn);
      // Handle worst case scenario of having no idea of SQL engine.
      if (source != null && psql != null && psql.getEngine() == PortableSQL.UNKNOWN)
      {

        try
        {
          java.sql.Connection con_temp = source.getConnection();
          psql.setEngineFromConnection(con_temp);
          con_temp.close();
        }
        catch (java.sql.SQLException exSql)
        {
          psql.setSQLEngine("UNKNOWN");
        }
      } // end if 
    }
    catch (javax.naming.NamingException exNaming)
    {
      source = null;
    }
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException
  {
    // Disable caching at all levels
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");


    response.setContentType("text/html");
    PrintWriter out = response.getWriter();
    if (!bOK)
    {
      out.println("<font color=\"red\" ><b>Error in application settings:</font>, Please inform application developers.</b>");
      //out.flush();
      //out.close();
      return;
    }

    String ElementName = request.getParameter("ElementName");
    if (ElementName == null) ElementName = idfield;

    String ElementID = request.getParameter("ElementID");
    // if(ElementID ==null)  ElementID=ElementName;


    String Select = request.getParameter("Select");
    String All = request.getParameter("All");
    String None = request.getParameter("None");
    String WhereClause = null;
    WhereClause = request.getParameter("WhereClause");
    String OrderBy = null;
    OrderBy = request.getParameter("OrderBy");
    String GroupBy = null;
    GroupBy = request.getParameter("GroupBy");
    String ClassName = request.getParameter("ClassName");
    String Multiple = request.getParameter("Multiple");
    String Plugin = request.getParameter("Plugin");

    ArrayList < String > sel_items = new ArrayList < String > ();
    String[] parts = null;
    if (Select != null && Select.length() > 0)
    {
      parts = Select.split(",");
      if (parts != null)
      {
        for (String st: parts) sel_items.add(st.trim());
      }

    }

    String cls = (ClassName != null) ? " class=\"" + ClassName + "\" " : "";
    String elmid = (ElementID != null) ? " id=\"" + ElementID + "\" " : "";
    String Plgn = (Plugin != null) ? " " + Plugin + " " : " ";
    String mul = "";
    if (Multiple != null)
    {
      if ("TRUE".equalsIgnoreCase(Multiple) || "YES".equalsIgnoreCase(Multiple) || "Multiple".equalsIgnoreCase(Multiple)) mul = " multiple data-selected-text-format='count > 3' data-actions-box='true'";
    }

    if (WhereClause != null && WhereClause.length() > 0) WhereClause = " " + WhereClause + " ";
    else WhereClause = "";
    if (OrderBy != null && OrderBy.length() > 0) OrderBy = " ORDER BY " + OrderBy;
    else OrderBy = "";
    if (GroupBy != null && GroupBy.length() > 0) GroupBy = " GROUP BY " + GroupBy;
    else GroupBy = "";

    String query = psql.SQL(" SELECT * FROM `" + table + "` " + WhereClause + " " + GroupBy + " " + OrderBy);
    String Ex = null;
    int i = 0;
	String optval = "";

    out.println("<select name=\"" + ElementName + "\" " + elmid + cls + mul + " " + Plgn + " >");
    if (All != null && "true".equalsIgnoreCase(All)) out.println("<option value=\"\"> -- ALL -- </option>");
    if (None != null && "true".equalsIgnoreCase(None)) out.println("<option value=\"\"> -- NONE -- </option>");

    java.sql.Connection conx = null;
    java.sql.Statement stmt = null;
    java.sql.ResultSet rslt = null;
    try
    {
      try
      {
        conx = source.getConnection();
        conx.createStatement();
        stmt = conx.createStatement();
        rslt = stmt.executeQuery(query);
        while (rslt.next())
        {
          String ID = rslt.getString(idfield);
		  if(!optionvalue.equalsIgnoreCase("null"))optval = rslt.getString(optionvalue);
		  else optval = null ;	
          String Show = format;
          String sel = "";
          if (Select != null)
          {
            // Old if(Select.equalsIgnoreCase(ID))  sel = "selected=\"selected\"" ;
            if (sel_items.contains(ID)) sel = "selected=\"selected\"";
          }
          for (i = 0; i < fields.length; i++)
          {
            Show = Show.replace(fields[i], rslt.getString(fields[i]));
          }
			if (optval != null && optval.length() > 0)
			{
				out.println("<option value=\"" + optval + "\" " + sel + "  >" + Show + "</option>");
			}
			else
			{
				out.println("<option value=\"" + ID + "\" " + sel + "  >" + Show + "</option>");				
			}
        }

      }
      finally
      {
        try
        {
          conx.close();
        }
        catch (Exception e)
        {};
      }
    }
    catch (java.sql.SQLException exSQL)
    {
      Ex = exSQL.toString();
    }
    out.println("</select>");
    if (Ex != null) out.println("<b><font color=\"red\">Exception: </font>" + Ex + "</b>");


    //out.flush();
    //out.close();
  }

  public void doPost(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException
  {
    doGet(request, response);
  }
}
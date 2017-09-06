<%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
response.setContentType("text/plain");
String appPath= request.getContextPath();
String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");
boolean   bAuto =( request.getParameter("IsAuto")!=null)? true:false ;
String IDField = request.getParameter("IDField");
String IDFieldType = request.getParameter("IDFieldType") ;
short nSQLEngine = PortableSQL.UNKNOWN ;
try
{
  nSQLEngine =  Short.parseShort(request.getParameter("SQLEngine"));
}catch(NumberFormatException ex){ nSQLEngine = PortableSQL.UNKNOWN ; }

String output = CreateTable.getTableCreateScript( nSQLEngine, JNDIDSN, TableName , IDField, bAuto, OverrideMap ) ;
%>
<%=output %>
<%@ page import="java.util.*"%><%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*" %><% 
String appPath= request.getContextPath();
String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");

 %>
-- Dumpling table: <%=TableName %>


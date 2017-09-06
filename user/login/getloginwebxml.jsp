<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %><%
String  DriverName= request.getParameter("DriverName");
String  BeanName = request.getParameter("BeanName");
String  BeanClass = request.getParameter("BeanClass");
String  BeanPackage = request.getParameter("BeanPackage");
String  JNDIDSN   = request.getParameter("JNDIDSN");
String  TableName = request.getParameter("TableName");
String  IDField = request.getParameter("IDField");
String  IDFieldType = request.getParameter("IDFieldType") ;
String  WebApp = request.getParameter("WebApp") ;
String  Title = request.getParameter("Title") ;
String  LoginClass = request.getParameter("LoginClass") ;
String  LoginObjectID = request.getParameter("LoginObjectID") ;
String  LoginIDField =  request.getParameter("LoginIDField") ;
String  LoginIDFieldType = request.getParameter("LoginIDFieldType") ;
String  PasswordField = request.getParameter("PasswordField") ;
String  DisplayFields = request.getParameter("DisplayFields") ;
String  LoginForm  = request.getParameter("LoginForm")  ;
String  LogoutPage = request.getParameter("LogoutPage") ;
String  LoginServlet = request.getParameter("LoginServlet") ;
String  LoginServletPath = request.getParameter("LoginServletPath") ;
String  LoginFilter = request.getParameter("LoginFilter") ;
String  AccessPath = request.getParameter("AccessPath") ;
String  LoginSuccesPath = request.getParameter("LoginSuccesPath") ;
String  LoginFailurePath = request.getParameter("LoginFailurePath") ;
String  LoginRole = request.getParameter("LoginRole") ;

boolean bIpAccessControl = false;
if( request.getParameter("IPAccessControl") !=null ) bIpAccessControl = true  ;


boolean   bIntegerIDField=true;
String	 Quotes="";

String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename=add-to-login-roles-xml-"+TableName+".txt";	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
 
// response.setContentType("text/plain");
if("INT".equalsIgnoreCase(LoginIDFieldType))
{
   // ID field is Integer quotes not needed in SQL expression.
   bIntegerIDField=true;
	 Quotes="";
}
else
{
   // ID field is Character type, quotes needed in SQL expression
 		bIntegerIDField=false;
	  Quotes="'";
}
     String SQLEngine = null ;
     if( "MySQL-AB JDBC Driver".equalsIgnoreCase(DriverName) )
     {
           SQLEngine = "MYSQL" ;
     }
		 else if( "MySQL Connector Java".equalsIgnoreCase(DriverName) )
     {
           SQLEngine = "MYSQL" ;
     }
		 else if( "SQLite/JDBC".equalsIgnoreCase(DriverName) )
     {
           SQLEngine = "SQLITE" ;
     }
		 else if( "PostgreSQL Native Driver".equalsIgnoreCase(DriverName) )
     {
          SQLEngine = "POSTGRE" ;
     }
		 else
     {
          SQLEngine = "UNKNOWN" ;
     }
%><!-- Login Setup For <%=Title %> BEGIN {{ -->

    <servlet servlet-name="<%=LoginServlet %>" servlet-class="com.webapp.login.LoginServlet" >
        <init-param LOGIN-HOME="<%=LoginSuccesPath %>" />
        <init-param LOGIN-ERROR="<%=LoginFailurePath %>" />
        <init-param LOGIN-OBJECT-CLASS="<%=WebApp %>.<%=LoginClass %>" />
        <init-param LOGIN-OBJECT-ID="<%=LoginObjectID %>"  />
        <init-param LOGIN-ROLE="<%=LoginRole %>" /><%if( bIpAccessControl ){ %>
				<init-param CLIENT-IPCHECK="true"/><% } %>
        <init-param SQL-ENGINE="<%=SQLEngine %>" />
    </servlet>
    <servlet-mapping url-pattern="*<%=LoginServletPath %>*" servlet-name="<%=LoginServlet %>"/>
		
    <filter filter-name="<%=LoginFilter %>" filter-class="com.webapp.login.LoginFilter" >
         <init-param LOGIN-HOME="<%=LoginSuccesPath %>"/>
         <init-param LOGIN-FORM="<%=LoginForm %>"/>
         <init-param LOGIN-OBJECT-ID="<%=LoginObjectID %>" />
         <init-param LOGIN-ROLE="<%=LoginRole %>" /><% if( bIpAccessControl ){%>
				 <init-param CLIENT-IPCHECK="true" /><% } %>
    </filter>
    <filter-mapping url-pattern="<%=AccessPath %>" filter-name="<%=LoginFilter %>"/> 

<!-- }} END Login Setup For <%=Title %>  -->


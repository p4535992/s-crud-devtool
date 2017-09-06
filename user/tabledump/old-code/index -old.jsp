<%@ page import="java.util.*"%><%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*, com.webapp.jsp.*" %><% 
String appPath= request.getContextPath();
String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");

 String fwd="";
 short sqlEng = PortableSQL.getEngineFromDriverName(DriverName);
								switch( sqlEng )
								{
								    case PortableSQL.MYSQL:
										    fwd = "mysql-tabledump.jsp" ;
										break ;
	
								    case PortableSQL.POSTGRE:
										     fwd = "postgre-tabledump.jsp" ;
										break ;

								    case PortableSQL.DB2:
										     fwd = "ibmdb2-tabledump.jsp"  ;
										break ;

								    case PortableSQL.MSSQL:
										     fwd = "mssql-tabledump.jsp"  ; 
										break ;

								    case PortableSQL.ORACLE:
										     fwd = "oracle-tabledump.jsp"  ;
										break ;
										
								    case PortableSQL.H2:
										   	 fwd = "h2-tabledump.jsp"  ;
										break ;
										
								    case PortableSQL.SQLITE:
										     fwd = "sqlite-tabledump.jsp" ;
										break ;
 
								} // end case switch( sqlEng )
    String redirct = appPath+JSPUtils.jspPageFolder(request)+"/"+fwd+"?"+request.getQueryString();
    response.sendRedirect(response.encodeRedirectURL(redirct));
 %>
Redirecting to  <%=redirct %>...<br/>  
If the browser is not redirected than there is a system error.<br/> 
please report this error to application vendor.

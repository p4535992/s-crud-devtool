<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*, nu.xom.*" %><%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %>
<% 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();


 %>
<!DOCTYPE HTML >
<html>
<head>
<title>The Bean Wizard</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />

</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<table summary="" border="1" cellpadding="4"  cellspacing="0"  width="100%">
<tr>
     <td width="60%"><span class="title">New Web Application Wizard</span></td>
		 <td width="20%" align="center"><a href="<%=appPath %>/user/index.jsp">Go to JNDI DSN List</a></td>
     <td width="20%" align="right"><a href="<%=appPath %>/user/other/index.jsp">&#x25C4;&nbsp;Go Back&nbsp;&nbsp;</a></td>
		 
</tr>
</table>
<div style="padding:1em;">
</div>
</body>
</html>

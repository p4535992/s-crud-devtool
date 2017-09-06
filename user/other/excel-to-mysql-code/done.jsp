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
<div style="padding:1em;">
 <a href="index.jsp">&#x25C4; Done Go Back </a>

</div>
</body>
</html>

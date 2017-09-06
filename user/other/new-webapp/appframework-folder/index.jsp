<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%> 
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();
 %>
<!DOCTYPE html>
<html>
<head>
<title>Welcome Page</title>
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
</head>
<body>

<div id="maindiv" style="padding:1em;">

<ul>
<li><a href="<%=appPath %>/AdminLoginForm.jsp">Admin login</a></li>
</ul>

</div><!-- End #maindiv -->

</body>
</html>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<% 
String key = "One:Two:Three:" ; 
String[] parts = key.split(":");
%>
<html>
<head>
<title>Untitled</title>
</head>
<body>
Original string: <%=key %><br />
After call to split, string divided into <%=parts.length %><br />
<% for(int n=0; n< parts.length; n++) 
{
%>
(<%=n+1 %>)&nbsp;&nbsp;Index[<%=n %>]&nbsp;&nbsp;<%=parts[n] %><br />
<%
}
%>
</body>
</html>

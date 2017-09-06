<%@ page import="com.webapp.utils.*, " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%! 

 
%>
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String Message = request.getParameter("Message");
 
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<link rel="stylesheet" href="<%=appPath %>/style.css" type ="text/css" />
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<script language="JavaScript" type="text/javascript">
<!--

function NavigateTo(url)
{ 
    document.location.href = url ;
}

function InitPage()
{


}
 
  
$(document).ready(function() {
	
});
 


// -->
</script>

<body>
<div class="banner" id="page_banner">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="32">
    <tr>
      <td width="20%" align="left" ><img border="0" src="<%=appPath %>/images/vc-logo.gif" ></td>
      <td width="60%" align="center" ><span class="title">Bean Wizard For Java / JSP Web Developers</span></td>
      <td width="20%" align="right" ><a href="<%=appPath %>/index.jsp" title="Go to home page."><img border="0" src="<%=appPath %>/images/home.gif" width="40" height="40"></a></td>
    </tr>
</table>
</div>
<div class="block">
<table border="0"  width="100%">
<tr>
<td width="70%" align="left"><span class="title">User Login</span></td>
<td width="30%"  align="right"><a href="<%=appPath %>/index.jsp"  ><b>&#x25C4; Done Go Back</b></a>
</td>
</tr>
</table>
</div>

<% 
if(Message!=null)
{ 
%>
<div  id="msg_block" style="width:100%; border: 1px outset;background-color: #ddfecf; ">
<table summary=""  cellpadding="4" cellspacing="0"  width="100%">
<tr>
<td width="90%" align="left">
<span style="color:maroon;"><%=Message %></span>
</td>
<td width="10%" align="right">
[ <a href="javascript:void(0)"  onclick="{ $('#msg_block').hide(); }  ">&times;</a> ]
&nbsp;&nbsp;
</td>

</tr>
</table>
</div>
<% 
} 
%>



<div style="padding:1em;">
<!-- Page content begin -->   

<form action="<%=appPath %>/user_login_check/" method="post">
<table border="0" cellpadding="4" cellspacing="0" summary="">
<tr><td>Login ID:</td><td><input type="text" name="LoginID" value="" /></td></tr>
<tr><td>Password:</td><td><input type="password"  name="Password"/></td></tr>
<tr><td>Submit:</td><td><button type="submit"> Ok Submit Form</button></td></tr>


</table>
</form>  
</div><!-- Page content end -->
</body>
</html>


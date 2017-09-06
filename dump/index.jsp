<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*, com.beanwiz.* "%>
<%@ taglib uri="validation" prefix="chk" %>
<%/* do not change this line */ %>
<chk:validate/>

<% 
String appPath = request.getContextPath() ;
LoggedUser LogUsr = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser") ;
boolean bAutoLogin = false;
if(LogUsr == null )
{
   LogUsr =  LoginHelper.autoLoginCheck(application,session,request );
	 if(LogUsr!=null) bAutoLogin=true;
}
%>
<!DOCTYPE html >
<html>
<head>
<title>Bean Wizard Tool</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
</head>
<body>
<div class="block" >

<div align="center">
<div align="center"  class="round_corner" style="width:60%;"  > 
<img alt="vc-logo (3K)" src="images/vc-logo.gif" height="31" width="192" /><br/>
<span class="title"><span style="color:#cc0099;">Bean Wizard:</span> a tool for  web application development in Java / JSP</span><br />
<span class="label">Application code last updated on:</span> <span class="item">26<sup>th</sup>May 2015</span>
</div>
</div>

<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
<td width="20%">&nbsp;</td>
<td width="60%">
<ul>
<li>This wizard  simplifies the tedious job of writing boilerplate,  repetitive code to access databases tables from Java Servlets or Java Server Pages ( JSP ).</li>
<li>This wizard  generated Java / JSP code allows you to work with any of <span  style="color:navy; font-weight: bold; " >MySQL, PostgreSQL, Microsoft SQL, Oracle, and IBM DB2</span> SQL servers as well as <span  style="color:navy; font-weight: bold; " >  SQlite and H2 </span>  embedded database libraries.</li> 

</ul>
</td>
<td width="20%">&nbsp;</td>

</tr>
</table>
</div>

<% 
if(LogUsr !=null)
{ 
%>
  <%  
   if(bAutoLogin)
    { 
  %> 
         <p><b>( Automatic login permitted for <span class="label">IP Addr:</span> <span class="item"><%=  request.getRemoteAddr() %> </span> )</b>  </p>
  <%  
    }
  %>

<p><span class="label">Logged User:</span> <span class="item"><%=LogUsr.getUserName() %></span>&nbsp;&nbsp;</p>
<ul>
<li><p><a href="<%=appPath %>/user/index.jsp"><big>Start Wizard</big></a>&nbsp;&nbsp;&nbsp;&nbsp; Client (Host) Using Wizard: <%= request.getRemoteHost() %> ( IP Addr: <%=  request.getRemoteAddr() %>   )</p></li>
<li><p><a href="<%=appPath %>/user/other/index.jsp"><big>Other Useful Tools</big></a></p></li>
<li><p><a href="<%=appPath %>/userlogout.jsp"><big>Logout From Session</big></a></p></li>
</ul>
<% 
}
else
{ 
%>
<!-- <li><p><a href="<%=appPath %>/loginform.jsp"><big>Please Login</big></a></p></li> -->
<br/>
<div style="padding:1em; border-style:solid; border-width: 1px ; border-color: navy ;border-radius: 15px; width:25% " >
<!-- Page content begin -->   
<span class="title">Please Login</span><br/>
<form action="<%=appPath %>/user_login_check/" method="post">
<table border="0" cellpadding="4" cellspacing="0" summary="">
<tr><td>Login ID:</td><td><input type="text" name="LoginID" value="" /></td></tr>
<tr><td>Password:</td><td><input type="password"  name="Password"/></td></tr>
<tr><td>Submit:</td><td><button type="submit"> Ok Submit Form</button></td></tr>


</table>
</form>  
</div><!-- Page content end -->

<% 
} 
%>

<div style="padding:1em ;">
For updating <b>older applications</b> your may need <a href="/oldbeanwiz">OLD BEAN WIZARD</a> ( Older Style JSP Pages )
</div>

<div style="padding:1em ;">
If you are behind the ADSL router ( firewall ) than to use this tool, forward inbound port 3306 (mysql)
of your router to your machine.<br />
The machine which hosts the database server must be reachable over network from the machine which hosts the wizard.
</div>
</body>
</html>

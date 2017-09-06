<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %>
<%
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
String  LoginServletPath = request.getParameter("LoginServletPath");
String  LoginFilter = request.getParameter("LoginFilter") ;
String  AccessPath = request.getParameter("AccessPath") ;
String  LoginSuccesPath = request.getParameter("LoginSuccesPath") ;
String  LoginFailurePath = request.getParameter("LoginFailurePath") ;
String  ScriptFolder = request.getParameter("ScriptFolder") ;

boolean   bIntegerIDField=true;
String	 Quotes="";


String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename=changepassword.jsp" ;
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

//response.setContentType("text/plain");
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
String usrpath = null;
if( AccessPath!=null && AccessPath.length() > 0 ) usrpath = AccessPath.replace("*", "");
else usrpath="" ;

%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=WebApp %>.*"%>
<\%@ page import="<%=BeanPackage %>.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n");
%>
<\% 
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath();
<%=WebApp %>.<%=LoginClass %> LogUsr =  (<%=WebApp %>.<%=LoginClass %>)session.getAttribute("<%=LoginObjectID %>") ;
String LogUsrName = "" ;
if(LogUsr != null)
{
  LogUsrName= LogUsr.getUserName();
}
<%=BeanName %>.locateRecord(LogUsr.<%=IDField %>);

String Action = request.getParameter("Action") ;
if(Action==null) Action="Form" ; // Other action Update


%>
<!DOCTYPE html>
<html>
<head>
<title>Change Login Password</title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
 %>
<script type="text/javascript">
<!--
function NavigateTo(url)
{ 
   document.location.href = url ;
}

$(document).ready(function(){
 // Init jQuery 
// Update Form validation code: for validation plugin
  $("#change_pass_form").validate({ 
    rules: 
    {
       Password : "required",
       NewPassword1 : "required",
       NewPassword2 : "required" 
    } 
 }); // End form validation code.

 
 // End init
});


// --> 
</script>
</head>
<body  class="main">
<% out.print("<jsp:include page=\""+usrpath+"banner.jsp\" flush=\"true\" />"); %>
<div class="block"><!-- title block begin -->
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
   <td valign="top" align="left" width="25%">
	 <span class="title">Change Your Login Password:</span>
	 
	 </td>
	 <td align="center" valign="top" width="50%" >
	 <span class="label" ><\%=LogUsrName %> </span> <span class="dataitem">( <%=Title %> )</span> 
	 </td>
	 <td valign="top" align="right" width="25%">
           <a href="<\%=appPath %><%=usrpath %>index.jsp">&#x25C4; Go Back</a>&nbsp;&nbsp;
   </td>
</tr>
</table> 
</div><!-- title block end -->
<div style="padding:1em">
<!-- Main div start -->




<\% 
if(("Form").equalsIgnoreCase(Action))
{
  // Show the change password form
%>
<!-- Show Form Start -->
    <form action="<\%=thisFile %>" method="post" id="change_pass_form" >
		<input type="hidden" name="Action" value="Update" />
    <table border="0" cellpadding="6" cellspacing="0" summary=""  align="center">
        <tr>
		       <td width="50%"><span class="label">Old Password:</span></td>
		       <td width="50%"><input type="password"  name="Password"/></td>
        </tr>
        <tr>
		       <td width="50%"><span class="label">New Password:</span></td>
		       <td width="50%"><input type="password"  name="NewPassword1"/></td>
        </tr>
        <tr>
		        <td width="50%"><span class="label">Retype New Password:</span></td>
		        <td width="50%"><input type="password"  name="NewPassword2"/></td>
        </tr>
        <tr>
		        <td width="50%"><span class="label">Submit Form</span></td>
		        <td width="50%"><button type="submit">Update Password</button>&nbsp;&nbsp; <button type="button" onclick="NavigateTo('<\%=appPath %><%=usrpath %>index.jsp')">Cancel Update</button></td>
       </tr>
    </table>
    </form>
<!-- Show Form End -->
<\% 
}
else if(("Update").equalsIgnoreCase(Action))
{
     // Update password from submitted form
     boolean bSuccess=false;
     String Message="";
     String Password = request.getParameter("Password");
     String NewPassword1 = request.getParameter("NewPassword1");
     String NewPassword2 = request.getParameter("NewPassword2");
     if(NewPassword1.equals(NewPassword2))
     {
          if(Password.equals(<%=BeanName %>.<%=PasswordField %>))
	        {
	             <%=BeanName %>.<%=PasswordField %>= NewPassword1;
			         <%=BeanName %>.updateRecord(LogUsr.<%=IDField %>);
			         bSuccess=true;
	        }
	        else // Invalid Old Password
	        {
	             bSuccess=false;
               Message="Invalid Old Password";
	        }
      }
      else
      {
          bSuccess=false;
          Message="Both entries in new password and retype password do not match";
      } // end else of if(NewPassword1.equals(NewPassword2))


%>

     <\% 
     if(bSuccess)
     { 
		   // Update successfull show success message
     %>
         <div align="center" style="padding:1em"><b>Your Login Password Changed Successfully </b><br />
              <a href="<\%=appPath %><%=usrpath %>index.jsp"><b>Click here</b></a>to go to main page ...
         </div>
    <\%   
     }
     else // FAILURE
     { 
		   // Update failed, show error and update form again.
    %>
        <p align="center"><span class="error">Error:</span> <b><\%=Message %></b></p>
         
        <form action="<\%=thisFile %>" method="post" id="change_pass_form" >
				<input type="hidden" name="Action" value="Update" />
        <table border="0" cellpadding="6" cellspacing="0" summary=""  align="center">
          <tr>
		            <td width="50%"><span class="label">Old Password:</span></td>
		            <td width="50%"><input type="password"  name="Password"/></td>
          </tr>
          <tr>
		            <td width="50%"><span class="label">New Password:</span></td>
		            <td width="50%"><input type="password"  name="NewPassword1"/></td>
          </tr>
          <tr>
		           <td width="50%"><span class="label">Retype New Password:</span></td>
		           <td width="50%"><input type="password"  name="NewPassword2"/></td>
          </tr>
          <tr>
		           <td width="50%"><span class="label">Submit Form:</span></td>
		           <td width="50%"><button type="submit">Update Password</button>&nbsp;&nbsp; <button type="button" onclick="NavigateTo('<\%=appPath %><%=usrpath %>index.jsp')">Cancel Update</button></td>
          </tr>
       </table>
     </form>

<\% 
		 } // end else of if(bSuccess)
%>




<!-- Update Page End -->
<\%
}  
else // end else if(("Update").equalsIgnoreCase(Action))
{
%>

<div style="padding:1em">
  <span class="error">Error: </span> The page is invoked with invalid action parameter.<br/>
	Please report this error.

</div>

<\% 
} 
%>

<!-- Main div end -->
</div>
</body>
</html>


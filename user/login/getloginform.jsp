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
String  LoginServletPath = request.getParameter("LoginServletPath");
String  LoginFilter = request.getParameter("LoginFilter") ;
String  AccessPath = request.getParameter("AccessPath") ;
String  LoginSuccesPath = request.getParameter("LoginSuccesPath") ;
String  LoginFailurePath = request.getParameter("LoginFailurePath") ;
char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;

String tmp = IDField.replace("ID", "");
String IDFieldL = tmp.toLowerCase().trim();
String IDFieldU = tmp.toUpperCase().trim();

boolean   bIntegerIDField=true;
String	 Quotes="";

String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+LoginForm.substring(1);
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
%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=WebApp %>.*, com.<%=WebApp %>.apputil.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<\% 
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath() ;
String Message = request.getParameter("Message");

java.sql.Date today = DateTimeHelper.today();
int cYear = today.getYear()+1900;

<%=WebApp %>.AppSetting  si = new <%=WebApp %>.AppSetting( application ); 
boolean b<%=CTableName %>Login =  ( "YES".equalsIgnoreCase( si.getValue("<%=IDFieldU %>-LOGIN-ENABLE")  ) )? true:false ;

int <%=TableName %>_login_type =0;
try
{
  <%=TableName %>_login_type = Integer.parseInt(si.getValue("<%=IDFieldU %>-LOGIN-TYPE"));
}
catch(NumberFormatException ex)
{
  <%=TableName %>_login_type = 1;
}
String LoginIDLabel[] = {"Username","<%=IDField %>","Employment Code","Mobile","Email","Username"};


String menuType = "topbar";
%>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
<% out.print("<jsp:include page =\"/include-page/common/meta-tag.jsp\" flush=\"true\" />"); %>
<title><%=CTableName %> Login Form</title>
  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
<style type="text/css">
.fa-stack{display:none;}
.page-login-v2{height:100%}.page-login-v2:before{background-image:url(<\%=appPath %>/images/bg-login.jpg)}.page-login-v2.page-dark.layout-full:after{background-color:rgba(38,50,56,.6)}.page-login-v2 .page-brand-info{margin:120px 100px 0 90px}.page-login-v2 .page-brand-info .brand-img{vertical-align:middle}.page-login-v2 .page-brand-info .brand-text{display:inline-block;vertical-align:middle;margin:11px 0 11px 20px}.page-login-v2 .page-brand-info p{opacity:.6;max-width:650px}.page-login-v2 .page-login-main{position:absolute;right:0;top:0;height:auto;min-height:100%;padding:70px 60px 180px;color:#76838f;background:#fff}.page-login-v2 .page-login-main .brand{margin-bottom:60px}.page-login-v2 .page-login-main .brand-img{vertical-align:middle}.page-login-v2 .page-login-main .brand-text{display:inline-block;vertical-align:middle;margin:11px 0 11px 20px;color:#62a8ea}.page-login-v2 form{width:350px;margin:45px 0 20px}.page-login-v2 form>button{margin-top:38px}.page-login-v2 form a{margin-left:20px}.page-login-v2 footer{position:absolute;bottom:0;left:0;right:0;margin:50px 60px;text-align:center}.page-login-v2 .social .icon,.page-login-v2 .social .icon:active,.page-login-v2 .social .icon:hover{color:#fff}@media (min-width:992px){.page-login-v2 .page-content{padding-right:500px}}@media (max-width:768px){.page-login-v2 .page-login-main{padding-top:60px}}@media (min-width:768px) and (max-width:991px){.page-login-v2 .page-login-main{padding-top:80px}.page-login-v2 .page-brand-info{margin:160px 0 0 35px}.page-login-v2 .page-brand-info>p{opacity:0;color:transparent}}@media (max-width:767px){.page-login-v2 .page-login-main{padding-top:60px;width:100%}.page-login-v2 form{width:auto}}@media (max-width:480px){.page-login-v2 .page-brand-info{margin:220px 0 0}.page-login-v2 .page-login-main{padding:50px 30px 180px}.page-login-v2 form{width:auto}.page-login-v2 footer{margin:50px 30px}}
</style>
	<% out.print("<jsp:include page =\"/include-page/css/formValidation-css.jsp\" flush=\"true\" />"); %>
  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>

</head>
<body class="page-login-v2 layout-full page-dark">
    <!--[if lt IE 9]>
        <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->


  <!-- Page -->
  <div class="page animsition" data-animsition-in="fade-in" data-animsition-out="fade-out">
    <div class="page-content">
      <div class="page-brand-info">
        <div class="brand">
          <img class="brand-img" src="<\%=appPath %>/images/logo/original/logo@2x.png" alt="...">
          <h2 class="brand-text font-size-40 text-uppercase"><\%=ApplicationResource.ProductName %></h2>
        </div>
        <p class="font-size-20">Your Title, Subtitle, Tagline anything</p>
      </div>

      <div class="page-login-main">
        <div class="brand visible-xs">
          <img class="brand-img" src="<\%=appPath %>/images/logo/original/logo-blue@2x.png" alt="...">
          <h3 class="brand-text font-size-40 text-uppercase"><\%=ApplicationResource.ProductName %></h3>
        </div>
        <h3 class="font-size-24"><span class=""><%=CTableName %></span> Login</h3>
<\% 
if(b<%=CTableName %>Login) 
{
%>
        <form method="post" action="<\%=appPath %><%=LoginServletPath %>" id="<%=TableName %>_loginForm" autocomplete="off">
          <div class="form-group form-material floating">
            <input type="text" class="form-control" id="<%=TableName %>_<%=LoginIDField %>" name="<%=TableName %>_<%=LoginIDField %>" autofocus>
						<label for="<%=LoginIDField %>" class="floating-label"><\%=LoginIDLabel[<%=TableName %>_login_type] %></label><!-- class="sr-only" -->
          </div>
          <div class="form-group form-material floating">
            <input type="password" class="form-control" id="<%=TableName %>_<%=PasswordField %>" name="<%=TableName %>_<%=PasswordField %>"  data-toggle="tooltip" data-trigger="manual" data-title="Caps lock is on">
            <label for="<%=PasswordField %>" class="floating-label"><%=PasswordField %></label><!-- class="sr-only" -->
					</div>
          <div class="form-group clearfix">
            <div class="checkbox-custom checkbox-inline checkbox-primary pull-left">
              <input type="checkbox" id="rememberMe" name="rememberMe">
              <label for="rememberMe">Remember me</label>
            </div>
          </div>
          <button type="submit" class="btn btn-raised btn-primary btn-block btn-lg"><i class="fa fa-sign-in" aria-hidden="true"></i>&nbsp;Sign in</button>        
				</form>
				<p><a href="<%=CTableName %>-forgot-password.jsp" class="pull-right">Forgot password ?</a></p>
				
<\%
}
else
{ 
%>

<div class="well well-sm" align="left">
  <ul class="list-group list-group-full">
    <li class="list-group-item active" style="color: #ff0000;">Login is currently Disabled by the system administrator.</li>
    <li class="list-group-item active" style="color: #ff0000;">will not be able to login until system administrator enables login access.</li>
    <li class="list-group-item active" style="color: #ff0000;">Inquire from system administrator about when the user login will be enabled.</li>
  </ul>
</div>

<\%  
}
%>
        <footer class="page-copyright">
          <p>DEVELOP BY <span class="text-uppercase"><\%=ApplicationResource.CompanyName %></span></p>
          <p>&copy; <\%=cYear %>. All RIGHT RESERVED.</p>
          <div class="social">
            <a class="btn btn-icon btn-round social-twitter" href="javascript:void(0)">
              <i class="icon bd-twitter" aria-hidden="true"></i>
            </a>
            <a class="btn btn-icon btn-round social-facebook" href="javascript:void(0)">
              <i class="icon bd-facebook" aria-hidden="true"></i>
            </a>
            <a class="btn btn-icon btn-round social-google-plus" href="javascript:void(0)">
              <i class="icon bd-google-plus" aria-hidden="true"></i>
            </a>
          </div>
        </footer>
      </div>

    </div>
  </div>
  <!-- End Page -->
	 
  <% out.print("<jsp:include page =\"/include-page/js/main-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.println("<jsp:include page=\"/include-page/js/formValidation-js.jsp\" flush=\"true\" />"); %>
	<script src="<\%=appPath %>/global/js/components/material.min.js"></script>
	
<script>

$(function(){
if(localStorage.getItem("<%=TableName %>_userName") != null && localStorage.getItem("<%=TableName %>_userName").length > 0 && localStorage.getItem("<%=TableName %>_password") != null && localStorage.getItem("<%=TableName %>_password").length > 0)
{
 if(localStorage[localStorage.key(0)].length > 0 ) $('#<%=TableName %>_<%=LoginIDField %>').removeClass("empty");
 if(localStorage[localStorage.key(1)].length > 0 ) $('#<%=TableName %>_<%=PasswordField %>').removeClass("empty");
}
});

$(document).ready(function() {

  //caps lock warning
  $("[type=password]").keypress(function(o){var t=$(this),i=$(".tooltip").is(":visible"),e=String.fromCharCode(o.which);e.toUpperCase()!==e||e.toLowerCase()===e||o.shiftKey?i&&t.tooltip("hide"):i||t.tooltip("show"),t.blur(function(o){t.tooltip("hide")})});		


    $('#<%=TableName %>_loginForm').formValidation({
        framework: 'bootstrap',
        fields: {
            <%=TableName %>_<%=LoginIDField %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=LoginIDField %> is required'
                    }
                }
            },
            <%=TableName %>_<%=PasswordField %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=PasswordField %> is required'
                    }
                }
            }
        }
    });


    if (localStorage.<%=TableName %>_checkBoxValidation && localStorage.<%=TableName %>_checkBoxValidation != '') {
        $('#rememberMe').attr('checked', 'checked');
        $('#<%=TableName %>_<%=LoginIDField %>').val(localStorage.<%=TableName %>_userName);
        $('#<%=TableName %>_<%=PasswordField %>').val(localStorage.<%=TableName %>_password);
    } else {
        $('#rememberMe').removeAttr('checked');
        $('#<%=TableName %>_<%=LoginIDField %>').val('');
        $('#<%=TableName %>_<%=PasswordField %>').val('');
    }

    $('#<%=TableName %>_loginForm').on('submit', function() {

        if ($('#rememberMe').is(':checked')) {
            // save username and password
            localStorage.<%=TableName %>_userName = $('#<%=TableName %>_<%=LoginIDField %>').val();
            localStorage.<%=TableName %>_password = $('#<%=TableName %>_<%=PasswordField %>').val();
            localStorage.<%=TableName %>_checkBoxValidation = $('#rememberMe').val();
        } else {
            localStorage.<%=TableName %>_userName = '';
            localStorage.<%=TableName %>_password = '';
            localStorage.<%=TableName %>_checkBoxValidation = '';
        }
    });		
		
<\% 
if(Message!=null)
{ 
%>
		
toastr.error("<\%=Message %>", "", {'timeOut': 0,'closeButton': true,'positionClass': "toast-top-right"})	
<\% 
} 
%>
		
});

</script>	
<% out.print("<jsp:include page =\"/include-page/common/Google-Analytics.jsp\" flush=\"true\" />"); %>
</body>
</html>


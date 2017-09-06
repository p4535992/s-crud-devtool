<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<% 
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath() ;
String Message = request.getParameter("Message");

java.sql.Date today = DateTimeHelper.today();
int cYear = today.getYear()+1900;

com.$WEBAPP.AppSetting  si = new com.$WEBAPP.AppSetting( application ); 
boolean bAdminLogin =  ( "YES".equalsIgnoreCase( si.getValue("ADMIN-LOGIN-ENABLE")  ) )? true:false ;

int admin_login_type =0;
try
{
  admin_login_type = Integer.parseInt(si.getValue("ADMIN-LOGIN-TYPE"));
}
catch(NumberFormatException ex)
{
  admin_login_type = 5;
}
String LoginIDLabel[] = {"Username","AdminID","Employment Code","Mobile","Email","Username"};


String menuType = "topbar";
%>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
<jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />

<title>Sitemanager Login Form</title>
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
<style type="text/css">
<!--
.fa-stack{display:none;}
.page-login-v3:before{position:fixed;top:0;left:0;content:'';width:100%;height:100%;background-position:center top;-webkit-background-size:cover;background-size:cover;z-index:-1;background:#62a8ea;background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzYyYThlYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMxNTcxYjEiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);background-image:-webkit-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-o-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-webkit-gradient(linear,left top,left bottom,from(#62a8ea),to(#3583ca));background-image:linear-gradient(to bottom,#62a8ea 0,#3583ca 100%);background-repeat:repeat-x;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff62a8ea', endColorstr='#ff3583ca', GradientType=0)}.page-login-v3 .panel{width:400px;margin-bottom:45px;background:#fff;border-radius:4px}.page-login-v3 .panel .panel-body{padding:50px 40px 40px}.page-login-v3 .panel .brand-text{margin-top:8px}.page-login-v3 form{margin:45px 0 30px}.page-login-v3 form a{margin-left:20px}.page-login-v3 form .form-material.floating+.page-login-v3 form .form-material.floating{margin-top:30px}.page-login-v3 form .form-material label{color:#a3afb7;font-weight:300}@media (max-width:480px){.page-login-v3 .page-content{padding:30px 10px}.page-login-v3 .panel{width:auto;padding:10px}.page-login-v3 .panel .panel-body{padding:35px 60px 35px}}
-->
</style>	
	<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
</head>
<body class="page-login-v3 layout-full">
  <!-- Page -->

  <div class="page animsition vertical-align text-center" data-animsition-in="fade-in" data-animsition-out="fade-out">
    <div class="page-content vertical-align-middle">
     
		  <div class="panel">
        <div class="panel-body">
				
          <div class="brand">
            <a href="index.jsp"><img class="brand-img" src="<%=appPath %><%=ApplicationResource.ProductLogo %>" alt="..."></a>
            <h2 class="brand-text font-size-18 text-uppercase"><%=ApplicationResource.ProductName %></h2>
          </div>
					<h3>Admin Login</h3>
<% 
if(bAdminLogin) 
{
%>
          <form method="post" action="<%=appPath %>/admin_login_check/" id="loginForm" autocomplete="off">
            <div class="form-group"><!--  form-material floating -->
              <input type="text" name="Username" id="Username" class="form-control" placeholder="<%=LoginIDLabel[admin_login_type] %>" autofocus/>
              <!-- <label class="floating-label"><%=LoginIDLabel[admin_login_type] %></label> -->
            </div>
            <div class="form-group"><!--  form-material floating -->
              <input type="password" class="form-control" name="Password" id="Password" placeholder="Password" data-toggle="tooltip" data-trigger="manual" data-title="Caps lock is on"/>
              <!-- <label class="floating-label">Password</label> -->
            </div>
            <div class="form-group clearfix">
              <div class="checkbox-custom checkbox-inline checkbox-primary pull-left">
                <input type="checkbox" id="rememberMe" name="remember">
                <label for="rememberMe">Remember me</label>
              </div>
            </div>
            <button type="submit" class="btn btn-raised btn-primary btn-block btn-lg margin-top-30"><i class="fa fa-sign-in" aria-hidden="true"></i>&nbsp;Sign in</button>
						<a class="pull-right margin-top-10" href="Admin-forgot-password.jsp">Forgot password?</a>
          </form>
<%
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

<%  
}
%>
        </div>
      </div>
      <footer class="page-copyright page-copyright-inverse">
        <p>DEVELOP BY <span class="text-uppercase"><%=ApplicationResource.CompanyName %></span></p>
        <p>&copy; <%=cYear %>. All RIGHT RESERVED.</p>
        <div class="social">
          <a class="btn btn-icon btn-pure" href="javascript:void(0)">
            <i class="icon bd-twitter" aria-hidden="true"></i>
          </a>
          <a class="btn btn-icon btn-pure" href="javascript:void(0)">
            <i class="icon bd-facebook" aria-hidden="true"></i>
          </a>
          <a class="btn btn-icon btn-pure" href="javascript:void(0)">
            <i class="icon bd-google-plus" aria-hidden="true"></i>
          </a>
        </div>
      </footer>
    </div>
  </div>
  <!-- End Page -->
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
  <jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
  <script src="<%=appPath %>/global/js/components/material.min.js"></script>
	
<script>

/* for material input
$(function(){
if(localStorage.getItem("userName") != null && localStorage.getItem("password") != null)
{
 if(localStorage[localStorage.key(0)].length > 0 ) $('#Username').removeClass("empty");
 if(localStorage[localStorage.key(1)].length > 0 ) $('#Password').removeClass("empty");
}
});
*/

$(document).ready(function() {

  //caps lock warning
  $("[type=password]").keypress(function(o){var t=$(this),i=$(".tooltip").is(":visible"),e=String.fromCharCode(o.which);e.toUpperCase()!==e||e.toLowerCase()===e||o.shiftKey?i&&t.tooltip("hide"):i||t.tooltip("show"),t.blur(function(o){t.tooltip("hide")})});		


    $('#loginForm').formValidation({
        framework: 'bootstrap',
        fields: {
            Username: {
                validators: {
                    notEmpty: {
                        message: 'The username is required'
                    }
                }
            },
            Password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required'
                    }
                }
            }
        }
    });


    if (localStorage.checkBoxValidation && localStorage.checkBoxValidation != '') {
        $('#rememberMe').attr('checked', 'checked');
        $('#Username').val(localStorage.userName);
        $('#Password').val(localStorage.password);
    } else {
        $('#rememberMe').removeAttr('checked');
        $('#Username').val('');
        $('#Password').val('');
    }

    $('#loginForm').on('submit', function() {

        if ($('#rememberMe').is(':checked')) {
            // save username and password
            localStorage.userName = $('#Username').val();
            localStorage.password = $('#Password').val();
            localStorage.checkBoxValidation = $('#rememberMe').val();
        } else {
            localStorage.userName = '';
            localStorage.password = '';
            localStorage.checkBoxValidation = '';
        }
    });
		
<% 
if(Message!=null)
{ 
%>
		
toastr.error("<%=Message %>", "", {'timeOut': 0,'closeButton': true,'positionClass': "toast-top-right"})	
<% 
} 
%>
		
});

</script>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>


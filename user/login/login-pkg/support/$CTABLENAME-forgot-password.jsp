<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath() ;

java.sql.Date today = DateTimeHelper.today();
int cYear = today.getYear()+1900;

String menuType = "topbar";
%>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
<jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />

<title>$CTABLENAME Forgot Password</title>
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
	<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />

<style type="text/css">
<!-- 
.fa-stack{display:none;}
.page-login-v3:before{position:fixed;top:0;left:0;content:'';width:100%;height:100%;background-position:center top;-webkit-background-size:cover;background-size:cover;z-index:-1;background:#62a8ea;background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzYyYThlYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMxNTcxYjEiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);background-image:-webkit-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-o-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-webkit-gradient(linear,left top,left bottom,from(#62a8ea),to(#3583ca));background-image:linear-gradient(to bottom,#62a8ea 0,#3583ca 100%);background-repeat:repeat-x;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff62a8ea', endColorstr='#ff3583ca', GradientType=0)}.page-login-v3 .panel{width:400px;margin-bottom:45px;background:#fff;border-radius:4px}.page-login-v3 .panel .panel-body{padding:50px 40px 40px}.page-login-v3 .panel .brand-text{margin-top:8px}.page-login-v3 form{margin:45px 0 30px}.page-login-v3 form a{margin-left:20px}.page-login-v3 form .form-material.floating+.page-login-v3 form .form-material.floating{margin-top:30px}.page-login-v3 form .form-material label{color:#a3afb7;font-weight:300}@media (max-width:480px){.page-login-v3 .page-content{padding:15px 5px}.page-login-v3 .panel{width:auto;padding:50px}.page-login-v3 .panel .panel-body{padding:10px 0px 10px}.h3, h3 {font-size: 17px;}}
-->
</style>

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
					<h3>Forgot Your Password ?</h3>
          <!-- <p>Input your registered email to reset your password</p> -->


      <form method="post" role="form" id="$CTABLENAME_FP" autocomplete="off">
        <div class="form-group">
          <input type="text" class="form-control" id="email" name="email" placeholder="Your Email">
        </div>
        <div class="form-group">
          <button type="submit" class="btn btn-raised btn-primary btn-block btn-lg">Reset Your Password</button>
        </div>
        <div class="form-group">
      <a class="btn btn-primary btn-round" href="javascript:history.back();"><i class="icon wb-arrow-left" aria-hidden="true"></i>&nbsp;GO BACK</a>
			&nbsp;
			<a class="btn btn-icon btn-primary btn-round" href="index.jsp" data-toggle="tooltip" data-placement="auto bottom" title="Home"><i class="fa fa-home fa-lg" aria-hidden="true"></i></a>
        </div>
      </form>

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

<script>
$(document).ready(function() {

    $('#$CTABLENAME_FP').formValidation({
        framework: 'bootstrap',
        fields: {
            email: {
						    trigger: 'blur',
                validators: {
                    notEmpty: {
                        message: 'The Email is required'
                    },
                    emailAddress: {
                        message: 'The Email is not a valid email address'
                    }
                }
            }
        }
    });
});

</script>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>


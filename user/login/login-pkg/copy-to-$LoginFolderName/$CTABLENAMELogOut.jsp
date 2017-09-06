<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath = request.getContextPath();
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
if($BeanName.locateRecord(LogUsr.$IDField))
{
	$BeanName.LoginStatus = $WEBAPP.LoginStatusFlag.NOT_LOGGED ;
	$BeanName.updateRecord(LogUsr.$IDField);
}
String LogUsrName = "" ;
if(LogUsr != null)
{
  LogUsr.invalidate();
  session.removeAttribute("$LoginObjectID") ;
	session.invalidate() ;
}

java.sql.Date today = DateTimeHelper.today();
int cYear = today.getYear()+1900;

String menuType = "topbar";
%>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
<jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />

<title>$CTABLENAME Logout</title>
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	  
<style type="text/css">
.fa-stack{display:none;}
.example {
    background-color: #f3f7fa;
    border: 1px solid #eee;
    padding: 50px 15px 15px 50px;
    position: relative;
}
.page-login-v3:before{position:fixed;top:0;left:0;content:'';width:100%;height:100%;background-position:center top;-webkit-background-size:cover;background-size:cover;z-index:-1;background:#62a8ea;background-image:url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzYyYThlYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMxNTcxYjEiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);background-image:-webkit-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-o-linear-gradient(top,#62a8ea 0,#3583ca 100%);background-image:-webkit-gradient(linear,left top,left bottom,from(#62a8ea),to(#3583ca));background-image:linear-gradient(to bottom,#62a8ea 0,#3583ca 100%);background-repeat:repeat-x;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff62a8ea', endColorstr='#ff3583ca', GradientType=0)}.page-login-v3 .panel{width:400px;margin-bottom:45px;background:#fff;border-radius:4px}.page-login-v3 .panel .panel-body{padding:50px 40px 40px}.page-login-v3 .panel .brand-text{margin-top:8px}.page-login-v3 form{margin:45px 0 30px}.page-login-v3 form a{margin-left:20px}.page-login-v3 form .form-material.floating+.page-login-v3 form .form-material.floating{margin-top:30px}.page-login-v3 form .form-material label{color:#a3afb7;font-weight:300}@media (max-width:480px){.page-login-v3 .page-content{padding:15px 5px}.page-login-v3 .panel{width:auto;padding:50px}.page-login-v3 .panel .panel-body{padding:10px 0px 10px}}
</style>	

  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  	
</head>
<body class="page-login-v3 layout-full <%=$BeanName.LoginRole %>">

  <div class="page animsition vertical-align text-center" data-animsition-in="fade-in" data-animsition-out="fade-out">
    <div class="page-content vertical-align-middle">
     
		  <div class="panel">
        <div class="panel-body">
				
          <div class="brand">
            <a href="index.jsp"><img class="brand-img" src="<%=appPath %><%=ApplicationResource.ProductLogo %>" alt="..."></a>
            <h2 class="brand-text font-size-18 text-uppercase"><%=ApplicationResource.ProductName %></h2>
          </div>
					 
					 <h3><%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></h3>
           logged out  from current browser session

					     <div class="row row-lg">
                  <div class="col-sm-6">
									<a href="<%=appPath %>/index.jsp">
                    <div class="example example-reverse">
                      <div class="ribbon ribbon-clip ribbon-primary">
                        <span class="ribbon-inner">Home</span>
                      </div>
                      <i class="fa fa-home fa-5x"></i>
                    </div>
									</a>	
                  </div>
                  <div class="col-sm-6">
									<a href="<%=appPath %>/$CTABLENAMELoginForm.jsp">
                    <div class="example">
                      <div class="ribbon ribbon-clip ribbon-primary">
                        <span class="ribbon-inner">Login again</span>
                      </div>
                      <i class="fa fa-sign-in fa-5x"></i></a>
                    </div>
									</a>	
                  </div>
					    </div>

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

<script type="text/javascript">
<!--
$(document).ready(function(){
toastr.success('Logout Successfully !');
});
// -->
</script>

<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>

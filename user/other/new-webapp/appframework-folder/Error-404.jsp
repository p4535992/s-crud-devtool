<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%>
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

<title>404 - Page Not Found</title>
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
<style type="text/css">
<!-- 
.fa-stack{display:none;}
.page-error .error-mark{margin-bottom:33px}.page-error header h1{font-size:10em;font-weight:400}.page-error header p{margin-bottom:30px;font-size:30px;text-transform:uppercase}.page-error h2{margin-bottom:30px}.page-error .error-advise{margin-bottom:25px;color:#A9AFB5}
-->
</style>
	
</head>
<body class="page-error page-error-404 layout-full">

  <!-- Page -->
  <div class="page animsition vertical-align text-center" data-animsition-in="fade-in"
  data-animsition-out="fade-out">
    <div class="page-content vertical-align-middle">
      <header>
        <h1 class="animation-slide-top">404</h1>
        <p>Page Not Found !</p>
      </header>
      <!-- <p class="error-advise">YOU SEEM TO BE TRYING TO FIND HIS WAY HOME</p> -->
      <a class="btn btn-primary btn-round" href="javascript:history.back();"><i class="icon wb-arrow-left" aria-hidden="true"></i>&nbsp;GO BACK</a>
			&nbsp;&nbsp;

			<a class="btn btn-icon btn-primary btn-round" href="index.jsp" data-toggle="tooltip" data-placement="auto bottom" title="Home"><i class="fa fa-home fa-lg" aria-hidden="true"></i></a>
      <footer class="page-copyright">
        <p>DEVELOP BY <span class="text-uppercase"><%=ApplicationResource.CompanyName %></span></p>
        <p>&copy; 2016. All RIGHT RESERVED.</p>
        <div class="social">
          <a href="javascript:void(0)">
            <i class="icon bd-twitter" aria-hidden="true"></i>
          </a>
          <a href="javascript:void(0)">
            <i class="icon bd-facebook" aria-hidden="true"></i>
          </a>
          <a href="javascript:void(0)">
            <i class="icon bd-dribbble" aria-hidden="true"></i>
          </a>
        </div>
      </footer>
    </div>
  </div>
  <!-- End Page -->

  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>


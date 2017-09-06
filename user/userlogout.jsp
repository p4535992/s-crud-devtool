<%@ page import="com.webapp.utils.*, com.beanwiz.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser") ;
String UsrName = LogUsr.getUserName();
LogUsr.invalidate();
session.removeAttribute("theWizardUser");
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Repid Development Tool</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/header.jsp" flush="true" />	
<div class="container">
  <div class="jumbotron">
    <h4 class="text-info text-center">User : <span class="text-primary"><%=UsrName %></span></h4>
    <h5 class="text-info text-center">is logged out from current browser session.</h5>
    <div class="row">
      <div class="col-md-4 col-md-offset-4"> 
			   <a href="<%=appPath %>/index.jsp" class="list-group-item btn btn-primary btn-lg btn-block"><h3 class="text-primary"><i class="fa fa-home fa-lg"></i>&nbsp;&nbsp;Home</h3></a>
				 <a href="<%=appPath %>/loginform.jsp" class="list-group-item btn btn-primary btn-lg btn-block"><h3 class="text-primary"><i class="fa fa-sign-in fa-lg"></i>&nbsp;&nbsp;Login again</h3></a>
			</div>
    </div>
  </div>
</div>
<!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--
$(document).ready(function(){
toastr.success('Logout Successfully !');
});
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

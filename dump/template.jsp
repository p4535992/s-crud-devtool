<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.lang.*, java.util.*, com.beanwiz.* "%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
%>

<!DOCTYPE HTML>
<html class="no-js" lang="en">
<head>
  <jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />
  <title>Development Tool</title>
  <jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />
  <jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" /> 
</head>
<body>
<jsp:include page="/header.jsp" flush="true" />

<div class="container">
 Do what ever want to do man!!!
</div>
<!-- /container -->

<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
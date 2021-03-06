<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.*"%>

<% 
String appPath = request.getContextPath();
com.validation.AppValidator vld = new com.validation.AppValidator() ;
vld.init(application);
String message = null ;
short nStatus = (-1) ;
if(vld != null )
{ 
  
  try
	{
	  nStatus = java.lang.Short.parseShort(vld.getConfigItem("ActivationStatus"));
	
  }
	catch(NumberFormatException ex){  nStatus = (-1) ;}
}
else 
{
message = "Validator not initialized";
}
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Authorization Failure - Repid Development Tool</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/header.jsp" flush="true" />	

<div class="container-fluid">

<% if(message !=null ){ %>
<div class="row">
  <div class="col-md-12">
    <p><span class="bg-danger"><%=message %></span></p>
	</div>
</div>				
<% } %>			

<div class="row">
  <div class="col-md-12">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <h3 class="panel-title">Authorization Failure</h3>
        </div>
        <div class="panel-body">
          <ul class="list-group">
            <li class="list-group-item">The web server on which this application is hosted, does not have proper authorization.</li>
            <li class="list-group-item">It may be a application licence / registration related issue.</li>
            <li class="list-group-item">If this error persists than contact application vendor to resolve this issue.</li>
          </ul>
        </div>
      </div>			
	</div>
</div>				

    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>


<%@ page isErrorPage = "true" %>
<%@ page import="java.io.*"%> 
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%>
<% 
String appPath=request.getContextPath();
String exceptionType = request.getAttribute("javax.servlet.error.exception_type").toString();
String request_uri = request.getAttribute("javax.servlet.error.request_uri").toString();

String menuType = "topbar";
%>
<!DOCTYPE HTML>
<html class="no-js css-menubar" lang="en">
<head>
<jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
<title>Error Page</title>
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include> 
<style type="text/css">
<!-- 
@media (max-width:480px){
h3 {font-size: 18px;}
} 
-->
</style>	
	 
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
</head>
<body style="padding-top: 0px;">
<!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">

          <div class="brand text-center">
            <a href="index.jsp"><img class="brand-img" src="<%=appPath %><%=ApplicationResource.ProductLogo %>" alt="..."></a>
            <h2 class="brand-text font-size-18 text-uppercase"><%=ApplicationResource.ProductName %></h2>
          </div>

  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-exclamation-triangle" style="color: #f96868;"></i>Error Analysis</h3>
  	    </div>
        <div class="col-sm-6">
				
          <ol class="breadcrumb breadcrumb-res">
            <li><big><a href="javascript:history.back();"><i class="icon wb-arrow-left" aria-hidden="true"></i>&nbsp;GO BACK</a></big></li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />

			
    
    

<div class="row">


  <div class="col-md-12">

          <div class="panel panel-bordered panel-danger">
            <div class="panel-heading">
              <h3 class="panel-title">Requested URL</h3>
            </div>
            <div class="panel-body row-fluid-text">
							<%=request_uri %>
						</div>
          </div>
	</div>
	
  <div class="col-md-12">

          <div class="panel panel-bordered panel-danger">
            <div class="panel-heading">
              <h3 class="panel-title">Exception Type</h3>
            </div>
            <div class="panel-body row-fluid-text">
							<%=exceptionType %>
						</div>
          </div>
	</div>
	
  <div class="col-md-12">

          <div class="panel panel-bordered panel-danger">
            <div class="panel-heading">
              <h3 class="panel-title">Exception stack trace</h3>
            </div>
            <div class="panel-body row-fluid-text">
            <%  
              ByteArrayOutputStream bout = new ByteArrayOutputStream();
              exception.printStackTrace(new PrintStream(bout)); 
              out.println(bout.toString().replace("\r\n", "\r\n<br />"));
             %>
						</div>
          </div>
	</div>
	
</div>			

			
    </div>
  </div>
  <!-- End Page -->
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	
<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>

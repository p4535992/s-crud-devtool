<%@ page isErrorPage = "true" %>
<%@ page import="java.io.*"%> 
<%@ page import="com.beanwiz.*"%>
<% 
String appPath=request.getContextPath();
 
String statusCocde = request.getAttribute("javax.servlet.error.status_code").toString();
String exceptionType = request.getAttribute("javax.servlet.error.exception_type").toString();
String errorMsg = request.getAttribute("javax.servlet.error.message").toString().replace("\r\n", "\r\n<br />");

String exception1 = request.getAttribute("javax.servlet.error.exception").toString();
String request_uri = request.getAttribute("javax.servlet.error.request_uri").toString();
//String servlet_name = request.getAttribute("javax.servlet.error.servlet_name").toString();
%> 
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Error Page - Repid Development Tool</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/header.jsp" flush="true" />


    <div class="row page-header1">
    	<div class="col-md-6 col-xs-12 ">
        <h1 class="page-title1 text-danger"><i class="fa fa-chain-broken"></i>&nbsp;&nbsp;Application Error</h1>
      	
	    </div>
			<div class="col-md-6 col-xs-12 text-right">
            <ol class="breadcrumb">
               <li><a href="javascript:history.back();" class="btn btn-primary" style="font-size: 18px;"><i class="fa fa-angle-double-left fa-lg"></i>&nbsp;&nbsp;Go Back !</a></li>
            </ol>
			</div>
    </div>

    
<div class="container">
<div class="row">

<div class="col-md-12">
<div class="panel panel-danger">
  <!-- Default panel contents -->
  <div class="panel-heading">Error Analysis</div>

  <!-- Table -->
<div class="table-responsive">
  <table class="table table-bordered">
    <thead>
      <tr>
        <th width="15%">Error</th>
        <th>Error Detail</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Error Code</td>
        <td><%=response.getStatus() %></td>
      </tr>
      <tr>
        <td>Requested URL</td>
        <td><%=request_uri %></td>
      </tr>
      <tr>
        <td>Exception Type</td>
        <td><%=exceptionType %></td>
      </tr>
<!-- 
      <tr>
        <th scope="row">4</th>
        <td>Error Cause</td>
        <td><%=errorMsg %></td>
      </tr>
 -->
    </tbody>
  </table>
</div>

</div>
</div>

  <div class="col-md-12">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <h3 class="panel-title">Error is causesd by</h3>
        </div>
        <div class="panel-body row-fluid-text">
<p>				  
             <!-- exception1 --><%=exception.getMessage().replace("\r\n", "\r\n<br />") %>
</p>				  	
        </div>
      </div>			
	</div>
  <div class="col-md-12">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <h3 class="panel-title">Exception stack trace</h3>
        </div>
        <div class="panel-body row-fluid-text">
<p>          
            <%  
              ByteArrayOutputStream bout = new ByteArrayOutputStream();
              exception.printStackTrace(new PrintStream(bout)); 
              out.println(bout.toString().replace("\r\n", "\r\n<br />"));
             %>
</p>           
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

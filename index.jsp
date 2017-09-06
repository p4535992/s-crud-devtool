<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.lang.*, java.util.*, com.beanwiz.* "%>
<%@ taglib uri="validation" prefix="chk" %>
<chk:validate/>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );
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

<div class="row ">
  <div class="col-sm-12">
  <div class="jumbotron">
	  <div class="row ">
		  <div class="col-sm-8 animated slideInRight">
  			  <h2>Development Tool</h2>
  		    <h4><code>JSP / SERVLET</code></h4>
					<h4><code>IWGLVJ-623</code> | <code>QSZMNZ-1045</code></h4>
			</div>
		  <div class="col-sm-3 animated slideInLeft">
             <a class="btn btn-lg btn-primary btn-block" href="<%=appPath %>/user/index.jsp" role="button"><i aria-hidden="true" class="icon glyphicon glyphicon-check"></i>&nbsp;&nbsp;Let's Do It !</a>
             <!-- <a class="btn btn-lg btn-primary btn-block" href="<%=appPath %>/user/other/index.jsp" role="button"><i aria-hidden="true" class="icon glyphicon glyphicon-wrench"></i>&nbsp;&nbsp;Other Dev. Tools</a> -->
			</div>			
    </div>	
  </div>
  </div>
</div>	

<div class="row">
  <div class="col-sm-4 animated bounceInUp">
	<div class="panel panel-default">
        <div class="panel-heading text-center">
          <h4 class="text-primary text-left" ><span class="glyphicon glyphicon-star" aria-hidden="true"></span>&nbsp;&nbsp;What is It ?</h4>
				</div>	
        <div class="panel-body">
				  <p class="text-muted lead">
	           This Simplifies Tedious job of 
						 <ul class="list-group">
                <li class="list-group-item"><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span>&nbsp;&nbsp;Writing Boilerplate</li>
                <li class="list-group-item"><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span>&nbsp;&nbsp;Repetitive Code</li>
								<li class="list-group-item"><span class="glyphicon glyphicon-menu-right" aria-hidden="true"></span>&nbsp;&nbsp;Access Database</li>
             </ul>
	        </p>
				</div>
	</div>			
	</div>
	
  <div class="col-sm-4 animated bounceIn">
	<div class="panel panel-default">
        <div class="panel-heading text-center">
          <h4 class="text-primary text-left" ><span class="glyphicon glyphicon-tasks" aria-hidden="true"></span>&nbsp;&nbsp;CRUD Operation</h4>
				</div>	
        <div class="panel-body">
          <ul class="list-group">
            <li class="list-group-item"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span>&nbsp;&nbsp;CREATE</li>
            <li class="list-group-item"><span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>&nbsp;&nbsp;READ</li>
            <li class="list-group-item"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>&nbsp;&nbsp;UPDATE</li>
            <li class="list-group-item"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span>&nbsp;&nbsp;DELETE</li>
          	<li class="list-group-item list-group-item-info">& Include</li>
          	<li class="list-group-item"><span class="glyphicon glyphicon-search" aria-hidden="true"></span>&nbsp;&nbsp;SEARCH</li>
          </ul>					
				</div>
	</div>			
	</div>
	
  <div class="col-sm-4 animated bounceInDown">
	<div class="panel panel-default">
        <div class="panel-heading text-center">
          <h4 class="text-primary text-left" ><span class="glyphicon glyphicon-oil" aria-hidden="true"></span>&nbsp;&nbsp;Database</h4>
				</div>	
        <div class="panel-body">
          <ul class="list-group">
            <li class="list-group-item"><code>MySQL</code></li>
            <li class="list-group-item"><code>PostgreSQL</code></li>
            <li class="list-group-item"><code>Microsoft SQL</code></li>
            <li class="list-group-item"><code>Oracle</code></li>
            <li class="list-group-item"><code>IBM DB2</code></li>
          	<li class="list-group-item list-group-item-info">Embedded Database</li>
          	<li class="list-group-item"><code>SQlite</code></li>
          	<li class="list-group-item"><code>H2</code></li>
          </ul>			
	      </div>
	</div>				
	</div>	
</div>
		
</div>
<!-- /container -->

<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
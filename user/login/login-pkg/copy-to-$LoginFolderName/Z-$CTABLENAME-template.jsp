<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);
%>
<%@include file="/$LoginFolderName/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
		
	<title><%=ApplicationResource.webapp %></title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>
<body class="<%=menuTypeClass %> <%=$BeanName.LoginRole %>" >

  <jsp:include page ="/$LoginFolderName/include-page/nav-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

  <jsp:include page ="/$LoginFolderName/include-page/menu-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value="???"/>
		 <jsp:param  name="MenuLink" value="???"/>
	</jsp:include>


  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-dashboard iccolor"></i>Dashboard</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/$LoginFolderName/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">???</li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />

      <h2>Blank</h2>
      <p>Page content goes here</p>
			
			
    </div>
  </div>
  <!-- End Page -->

  <jsp:include page="/$LoginFolderName/include-page/footer.jsp" flush="true" />
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />
				
</body>
</html>


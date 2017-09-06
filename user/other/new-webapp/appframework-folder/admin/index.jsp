<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="org.apache.commons.lang3.*" %> 
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
		
	<title>Admin Home</title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" >

  <jsp:include page ="/admin/include-page/nav-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

  <jsp:include page ="/admin/include-page/menu-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value="DashboardTitle"/>
		 <jsp:param  name="MenuLink" value="DashboardLink1"/>
	</jsp:include>  

  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-dashboard iccolor"></i>Dashboard</h3>
  	    </div>
        <div class="col-sm-6">
  	    </div>
  		</div>	
			<hr class="hr-res" />

      <h2>Blank</h2>
      <p>Page content goes here</p>
			
      <ul>
       <li><p><b><a href="<%=appPath %>/admin/#">Link To Other Pages</a></b></p></li>
      </ul>

    </div>
  </div>
  <!-- End Page -->

  <jsp:include page="/admin/include-page/footer.jsp" flush="true" />
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>

	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>
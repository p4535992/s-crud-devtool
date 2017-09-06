<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;


int nAdminID = 0;
try
{
   nAdminID = Integer.parseInt(request.getParameter("AdminID"));
}
catch(NumberFormatException ex)
{ 
   nAdminID = 0;
}
SiMngrBn.locateRecord(nAdminID);

String Action = RequestHelper.paramValue(request, "Action", "Form");

String menuType = "topbar";
%>
<!-- @include file="/admin/nav_menu.inc" -->
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Reset Password Popup</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>
<body style="padding-top: 0px;" >
	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><%if(SiMngrBn.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male iccolor"></i><% }else{ %><i class="icon fa fa-female iccolor" aria-hidden="true"></i><% } %>&nbsp;<%=ShowItem.showAdminName(SiMngrBn.AdminID, 1) %></h3>
  	    </div>
        <div class="col-sm-6">
  	    </div>
  		</div>	
			<hr class="hr-res" />


<%
if("Form".equalsIgnoreCase(Action))
	{
 	%>
		
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="sitemanager_Add" id="sitemanager_Add"   >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="AdminID" value="<%=nAdminID %>" />
<div class="panel">
<div class="panel-body container-fluid">

<!-- $CHECK Look for chain --> 
<!-- INSERT ADD FROM -->
<!-- 
 <ul>
  <li>The new password set here will be treated as service password ( temporary password ).</li>
	<li>After login with service password, the student will be asked to set his/her  regular password.</li>
  <li>Untill the regular password is set, the student will not be able to access all parts of application.</li>

</ul>
 -->
<div class="row" > 
  <div class="form-group col-sm-6 col-sm-offset-3">
	  <label for="ResetPassword" class="control-label">Reset Password As</label>
	  <input type="text" name="ResetPassword" id="ResetPassword" class="form-control" />
	</div>
</div>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Reset"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Reset</button>
			<button type="button" class="btn btn-default btn-outline" title="Close Window" onclick="parent.closeModal()"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Close</button>
	  </div>
</div>

</div>
</div>

</form>
<%
}
else if("Update".equalsIgnoreCase(Action))
{
  SiMngrBn.Password = request.getParameter("ResetPassword");
	SiMngrBn.PasswordType = PasswordType.SERVICE ;
	SiMngrBn.LoginStatus = LoginStatusFlag.NOT_LOGGED ;
  SiMngrBn.updateRecord(nAdminID);
%>
<div class="panel">
<div class="panel-body container-fluid">


<div class="row text-center">
    <div class="form-group col-sm-6 col-sm-offset-3"> 
<div class="well well-sm well-success">The password reset successfully.</div>
	  </div>
</div>


</div>

<div class="panel-form-box-footer text-center">
      <button type="button" class="btn btn-default btn-outline" title="Close Window" onclick="parent.closeModal()"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Close</button>
	  </div>
</div>

</div>
</div>

<%
}
else
{
%>
<p>&nbsp;</p>
<p>
<div class="well well-sm well-error">Request parameter error</div>
</p> 

<%
}
%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
  <jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>


<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, org.apache.commons.io.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="Sms_GtWysBn" scope="page" class="com.db.$DATABASE.Sms_gatewayaccountsBean" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

String Action = request.getParameter("Action") ;
if(Action == null ) Action ="Form" ; // Other action = Import
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Import SMS Account</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
  	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>

<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >

  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
		 <jsp:param name="MenuTitle" value="SuperAdmin" />
  </jsp:include>

  <jsp:include page ="/admin/include-page/menu-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
	 	 <jsp:param name="MenuTitle" value="???" />
	 	 <jsp:param name="MenuLink" value="???" />
  </jsp:include>
	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Import SMS Account</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
						<li><a href="<%=appPath %>/admin/superadmin/sms/managesmsgatewayaccounts.jsp?Action=Result">Gateway Account</a></li>
            <li class="active">Import Account</li>
          </ol>			
  	    </div>
  		</div>	

<%
if("Form".equalsIgnoreCase(Action))
{ 
%>
  <form action="<%=thisFile %>" method="post" class="form-horizontal" enctype="multipart/form-data" >
	
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Import
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=appPath %>/admin/superadmin/sms/managesmsgatewayaccounts.jsp?Action=Result')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

    <div class="form-group">
	     <label for="XMLFile" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">XML file for import : </label>
			  <div class="col-md-4 col-sm-4 col-xs-12">
					<input type="file" enctype="multipart/form-data" name="XMLFile" id="XMLFile" class="form-control filestyle" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" title="Please select File."/>
				</div>
		</div>	
</div>
<div class="panel-form-box-footer text-center">
    <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Submit</button>
    <button type="button" class="btn btn-default btn-outline" title="Cancel" onclick="NavigateTo('<%=appPath %>/admin/superadmin/sms/managesmsgatewayaccounts.jsp?Action=Result')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
    <!-- onclick="NavigateTo('<%=appPath %>/admin/index.jsp')" -->	
</div>
	
</div>

</form>
<%
InputStream is =  ResinFileUpload.getInputStream(request, "XMLFile");
if(is != null)
{

	StringWriter writer = new StringWriter();
  IOUtils.copy(is, writer);
  String xml  = writer.toString();
	Sms_GtWysBn.AccountID=0;
	SMSAccountHelper.ImportFromXml(Sms_GtWysBn ,  xml);
	Sms_GtWysBn.LastSMSBalance = 0; 
	Sms_GtWysBn.BalanceCheckTime = new java.sql.Timestamp(System.currentTimeMillis()); 
	Sms_GtWysBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());
 
	Sms_GtWysBn.addRecord();
%>
<div role="alert" class="alert dark alert-info alert-dismissible">
<button aria-label="Close" data-dismiss="alert" class="close" type="button"><span aria-hidden="true">&times;</span></button>
One account: <b><%=Sms_GtWysBn.Title %></b> Imported.
</div>

<% 
  is.close();
  ResinFileUpload.deleteUploadFile(request, "XMLFile");
} 
%>

<%
}
else
{
%>
<div class="well well-sm well-danger">
  Error: The page is invoked with invalid action parameter.
</div>
<%
}
%>


</div>
</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
  <jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	<jsp:include page="/include-page/js/bootstrap-filestyle-js.jsp" flush="true" />
<script>

function InitPage()
{
// Do something on page init
}
</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

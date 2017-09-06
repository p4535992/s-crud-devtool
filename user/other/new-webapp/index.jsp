
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*" %>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

java.sql.Timestamp CT = new java.sql.Timestamp(System.currentTimeMillis()) ;

String Action = request.getParameter("Action") ;
if(Action ==null ) Action = "Form" ; //   Other action Update

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Web App Framework</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Get WebApp Framework</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">WebApp Framework</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />
<div class="row">
<% 
if("Form".equalsIgnoreCase(Action))
{
%>
  <div class="col-md-5">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;New WebApp Name</h3>
        </div>
        <div class="panel-body">
				
				
<form  action="<%=thisFile %>" method="get" class="form-horizontal">
  <div class="form-group">
    <label for="ExcelFile" class="col-sm-4 control-label">Web App Name</label>
    <div class="col-sm-8">
      <input type="text" name="AppName" class="form-control" id="AppName">
    </div>
  </div>
  <div class="form-group">
    <label for="JNDIDSN_DROP_LIST" class="col-sm-4 control-label">Database &amp; JNDI-DSN</label>
    <div class="col-sm-8">
       <input type="text" name="Database" class="form-control" id="Database">
		</div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-4 col-sm-8">
      <button type="submit" class="btn btn-primary">Get It!</button>
    </div>
  </div>
</form>				


     </div>		
  </div>			
</div>

<%
String AppName = request.getParameter("AppName");
String Database = request.getParameter("Database") ;
 
if(AppName != null)
{ 
%>
  <div class="col-md-7">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-download"></i>&nbsp;&nbsp;Download App</h3>
        </div>
        <div class="panel-body">
<%

String WebAppDir =  application.getRealPath("/user/other/new-webapp/root/"+AppName);
String OutputZipFile =  application.getRealPath("/user/other/new-webapp/root/"+AppName+"_App_Framework.zip");


String TemplateDir = application.getRealPath("/user/other/new-webapp/appframework-folder");

File flWebapp = new File(WebAppDir );
File flTempl  = new File(TemplateDir);

// Delete any existing directory with same name
FileUtils.deleteQuietly(flWebapp);

FileUtils.forceMkdir(flWebapp );
FileUtils.copyDirectory( flTempl, flWebapp );
FileUtils.forceMkdir(new File(WebAppDir+"/WEB-INF/src/com/"+AppName ) );
FileUtils.forceMkdir(new File(WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil" ) );
FileUtils.forceMkdir(new File(WebAppDir+"/WEB-INF/src/com/db/"+Database ) );
%>

  <!-- Bean -->
 
  <jsp:include page ="include-page/Bean.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>
	
	<!-- java-parent --> 

  <jsp:include page ="include-page/java-parent.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- java-apputil -->
	
  <jsp:include page ="include-page/java-apputil.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- java-appsms -->
	
  <jsp:include page ="include-page/java-appsms.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- java-appmail -->
	
  <jsp:include page ="include-page/java-appmail.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- WEB-INF/XML -->

  <jsp:include page ="include-page/web-inf-xml.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- WEB-INF/JSON-Entity -->

  <jsp:include page ="include-page/web-inf-jsonfile.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
<%

// WEB-INF/Backup
File ReplFile_BACKUPBAT = new File( WebAppDir+"/WEB-INF/Backup/BACKUP.BAT");
String StrBuf_BACKUPBAT = FileUtils.readFileToString(ReplFile_BACKUPBAT);
String RepStr_BACKUPBAT = StringUtils.replace(StrBuf_BACKUPBAT,"$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_BACKUPBAT ,RepStr_BACKUPBAT);

// WEB-INF/sql
File ReplFile_SQL = new File( WebAppDir+"/WEB-INF/sql/basic-data.sql");
String StrBuf_SQL = FileUtils.readFileToString(ReplFile_SQL);
String RepStr_SQL = StringUtils.replace(StrBuf_SQL,"$WEBAPP",AppName);
RepStr_SQL = StringUtils.replace(RepStr_SQL,"$DATABASE",Database);
RepStr_SQL = StringUtils.replace(RepStr_SQL,"$CURRENTTIME",""+CT);
FileUtils.writeStringToFile(ReplFile_SQL ,RepStr_SQL);
%>

	<!-- parent -->

  <jsp:include page ="include-page/parent.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 

	<!-- parent/include-page -->

  <jsp:include page ="include-page/parent-includepage.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 

	<!-- admin-parent -->

  <jsp:include page ="include-page/admin-parent.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include> 
	
	<!-- admin/master -->

  <jsp:include page ="include-page/admin-master.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>
	
	<!-- admin/sms -->

  <jsp:include page ="include-page/admin-sms.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>

	<!-- admin/include-page -->

  <jsp:include page ="include-page/admin-includepage.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>	 	

	<!-- admin/superadmin -->

  <jsp:include page ="include-page/admin-superadmin.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>	
	
	<!-- admin/superadmin/sms -->

  <jsp:include page ="include-page/admin-superadmin-sms.jsp" >	
	 	 <jsp:param name="AppName" value="<%=AppName %>" />
		 <jsp:param name="Database" value="<%=Database %>" />
  </jsp:include>	 	
	 	
	
<%  
BeanwizZipHelper.zipFolder(WebAppDir, OutputZipFile);

try
{
}
catch(Exception Ex)
{
 Ex.toString() ;
}

%>

<ul class="list-group">
  <li class="list-group-item">Creating web application : <big><b><%=AppName %></b></big></li>
  <li class="list-group-item">Database : <big><b><%=Database %></b></big></li>
</ul>

<a href="root/<%=AppName %>_App_Framework.zip" class="btn btn-primary btn-lg"><i class="fa fa-download"></i>&nbsp;&nbsp;<%=AppName %>_App_Framework.zip</a>

     </div>		
  </div>			
</div>

<% 
} //end if(AppName != null)
%>

<%
}
else
{
// Action parameter error
%>
<span class="error">Error:</span> Invalid request parameter:<b>Action</b> in page invocation.<br/>
<%
}
%>
</div>				

</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

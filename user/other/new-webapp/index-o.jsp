<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*" %>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

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


String TemplateDir = application.getRealPath("/user/other/new-webapp/template-folder");

File flWebapp = new File(WebAppDir );
File flTempl  = new File(TemplateDir);

// Delete any existing directory with same name
FileUtils.deleteQuietly(flWebapp);



FileUtils.forceMkdir(flWebapp );
FileUtils.copyDirectory( flTempl, flWebapp );
FileUtils.forceMkdir(new File(WebAppDir+"/WEB-INF/src/com/"+AppName ) );
FileUtils.forceMkdir(new File(WebAppDir+"/WEB-INF/src/com/db/"+Database ) );

// Copy java scource file to proper locations
File DestSrcFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName);
File Src1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/ApplicationResource.java") ) ;
File Src2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/InitThread.java") ) ;
File Src3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/WebAppContextListener.java") ) ;

FileUtils.copyFileToDirectory(Src1,DestSrcFld);
FileUtils.copyFileToDirectory(Src2,DestSrcFld);
FileUtils.copyFileToDirectory(Src3,DestSrcFld);

File ReplFile1 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/ApplicationResource.java");
String StrBuf1 = FileUtils.readFileToString(ReplFile1);
String RepStr1 = StringUtils.replace(StrBuf1, "$WEBAPP",AppName);
RepStr1 = StringUtils.replace(RepStr1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile1 ,RepStr1);

File ReplFile2 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/InitThread.java");
String StrBuf2 = FileUtils.readFileToString(ReplFile2);
String RepStr2 = StringUtils.replace(StrBuf2, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile2 ,RepStr2);

File ReplFile3 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/WebAppContextListener.java");
String StrBuf3 = FileUtils.readFileToString(ReplFile3);
String RepStr3 = StringUtils.replace(StrBuf3, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile3 ,RepStr3);


File ReplFile_SQL = new File( WebAppDir+"/WEB-INF/sql/basic-data.sql");
String StrBuf_SQL = FileUtils.readFileToString(ReplFile_SQL);
String RepStr_SQL = StringUtils.replace(StrBuf_SQL, "$DATABASE",Database);
//RepStr_SQL = StringUtils.replace(RepStr_SQL, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SQL ,RepStr_SQL);


File ReplFile_CONF = new File( WebAppDir+"/WEB-INF/web.xml");
String StrBuf_CONF = FileUtils.readFileToString(ReplFile_CONF);
String RepStr_CONF = StringUtils.replace(StrBuf_CONF, "$WEBAPP",AppName);
RepStr_CONF = StringUtils.replace(RepStr_CONF, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_CONF ,RepStr_CONF);


File ReplFile_IDX = new File( WebAppDir+"/index.jsp");
String StrBuf_IDX = FileUtils.readFileToString(ReplFile_IDX);
String RepStr_IDX = StringUtils.replace(StrBuf_IDX, "$WEBAPP",AppName);
// RepStr_IDX = StringUtils.replace(RepStr_IDX, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_IDX ,RepStr_IDX);


File ReplFile_TMPL = new File( WebAppDir+"/template.jsp");
String StrBuf_TMPL = FileUtils.readFileToString(ReplFile_TMPL);
String RepStr_TMPL = StringUtils.replace(StrBuf_TMPL, "$WEBAPP",AppName);
RepStr_TMPL = StringUtils.replace(RepStr_TMPL, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_TMPL ,RepStr_TMPL);


File ReplFile_BNR = new File( WebAppDir+"/banner.jsp");
String StrBuf_BNR = FileUtils.readFileToString(ReplFile_BNR);
String RepStr_BNR = StringUtils.replace(StrBuf_BNR, "$WEBAPP",AppName);
// RepStr_BNR = StringUtils.replace(RepStr_BNR, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_BNR ,RepStr_BNR);

File ReplFile_ERPG = new File( WebAppDir+"/errorpage.jsp");
String StrBuf_ERPG = FileUtils.readFileToString(ReplFile_ERPG);
String RepStr_ERPG = StringUtils.replace(StrBuf_ERPG, "$WEBAPP",AppName);
// RepStr_ERPG = StringUtils.replace(RepStr_ERPG, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ERPG ,RepStr_ERPG);

BeanwizZipHelper.zipFolder(WebAppDir, OutputZipFile);

%>

<ul class="list-group">
  <li class="list-group-item">Creating web application : <big><b><%=AppName %></b></big></li>
  <li class="list-group-item">Database : <big><b><%=Database %></b></big></li>
<!-- 	
	<li class="list-group-item">New App. directory on server : <%=WebAppDir  %></li>
  <li class="list-group-item">Form directory : <%=TemplateDir %><br />copied to <br />New directory : <%=WebAppDir  %></li>
 -->
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

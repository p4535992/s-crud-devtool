<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.webapp.jsp.*, com.beanwiz.TableColumn" %><%
String  AppName = request.getParameter("AppName") ;
String  WebAppPkg = request.getParameter("WebAppPkg") ;
String  DbPkg = request.getParameter("DbPkg") ;
String LoginFolderName = request.getParameter("LoginFolderName") ;

String  Title = request.getParameter("Title") ;

String pkgimport = WebAppPkg+".* ";
if(DbPkg !=null && DbPkg.length() > 0)  pkgimport = pkgimport+", "+DbPkg+".* " ;

String HasActions = RequestHelper.paramValue(request, "HasActions", "false");



boolean bHasActions = ("true".equalsIgnoreCase(HasActions))? true:false;

String[] PageActions =   RequestHelper.getCsvStringArray(request, "PageActions");

if( bHasActions && PageActions ==null) PageActions = new String[]{ "Form" };

TreeMap<String,String> WebAppList = new TreeMap<String, String>();

WebAppList.put("JSP", "com.webapp.jsp.*");
WebAppList.put("UTILS", "com.webapp.utils.*");
WebAppList.put("DB","com.webapp.db.*" );
WebAppList.put("RESIN","com.webapp.resin.*" );
WebAppList.put("BARCODE","com.webapp.barcode.*" );
WebAppList.put("HTTP-TOOLS","com.webapp.httptools.*" );
WebAppList.put("PDF","com.webapp.pdf.*" );
WebAppList.put("POI","com.webapp.poi.*" );
WebAppList.put("MAIL","com.webapp.mail.*" );
WebAppList.put("SMS","com.webapp.sms.*" );




TreeMap<String,String> ThirdPartyList = new TreeMap<String, String>();

ThirdPartyList.put("APACHE-HTTP", "org.apache.http.*, org.apache.http.client.*, org.apache.http.client.utils.*, org.apache.http.client.fluent.*");
ThirdPartyList.put("JODA-TIME","org.joda.time.*" );
ThirdPartyList.put("SIMPLE-JSON","org.json.simple.*" );
ThirdPartyList.put("XOM" ,  "org.w3c.dom.*, nu.xom.*" );
ThirdPartyList.put("JSOUP", "org.jsoup.*, org.jsoup.helper.*, org.jsoup.nodes.*,  org.jsoup.select.*, org.jsoup.parser.*");
ThirdPartyList.put("POI-EXCEL", "org.apache.poi.ss.usermodel.*, org.apache.poi.xssf.usermodel.*, org.apache.poi.hssf.usermodel.*");
ThirdPartyList.put("POI-WORD-OLD" , "org.apache.poi.hwpf.*, org.apache.poi.hwpf.extractor.*, org.apache.poi.hwpf.model.*, org.apache.poi.hwpf.usermodel.*"); 
ThirdPartyList.put("POI-WORD-NEW" , "org.openxmlformats.schemas.wordprocessingml.x2006.main.*, org.apache.poi.xwpf.usermodel.*" );
ThirdPartyList.put("PDF-JET", "com.pdfjet.*");
ThirdPartyList.put("PDF-JPOD", "de.intarsys.tools.locator.*, de.intarsys.pdf.cos.*, de.intarsys.pdf.platform.cwt.image.awt.*, de.intarsys.pdf.pd.*, de.intarsys.pdf.content.common.* ");
ThirdPartyList.put("ZXING", "com.google.zxing.*, com.google.zxing.common.*, com.google.zxing.client.j2se.*, com.google.zxing.qrcode.*, com.google.zxing.oned.* ");

String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+AppName+"-template.jsp" ;
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

 String[]  WebAppLibs = request.getParameterValues("WebAppLibs");
 int l1 = WebAppLibs.length ;
 StringBuilder  ImportList = new StringBuilder("java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, org.apache.commons.lang3.* ") ;
 StringBuilder  thirdPartyImportList = new StringBuilder() ;
 int i1 = 0 ;
 for(String str: WebAppLibs )
 {  
    i1++;
    String webapp_lib = WebAppList.get(str);
		if(webapp_lib !=null) thirdPartyImportList.append(webapp_lib);
		if(i1 < l1) thirdPartyImportList.append(", ");
 }
%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=pkgimport.toString() %>" %>
<\%@ page import="<%=ImportList.toString() %>" %>
<\%@ page import="<%=thirdPartyImportList.toString() %>" %>
<% 
String[] ThirdPartyLibs = request.getParameterValues("ThirdPartyLibs");
if(ThirdPartyLibs !=null && ThirdPartyLibs.length > 0)
{
     for(String lib : ThirdPartyLibs)
		 {
		    String import_lib = ThirdPartyList.get(lib);
				if(import_lib !=null )
				{
				 %><\%@ page import="<%=import_lib %>" %><%		
				}
		 }
}
%><\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%  
if(LoginFolderName.equalsIgnoreCase("admin")) {
out.print("<jsp:useBean id=\"SiMngrBn\" scope=\"page\" class=\""+DbPkg+".SitemanagerBean\" />\r\n"); 
}else if(LoginFolderName.equalsIgnoreCase("student")) {
out.print("<jsp:useBean id=\"CanBn\" scope=\"page\" class=\""+DbPkg+".CandidateBean\" />\r\n");
}
%><\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<%=WebAppPkg %>.LoggedSitemanager LogUsr =  (<%=WebAppPkg %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<%=WebAppPkg %>.LoggedCandidate LogUsr =  (<%=WebAppPkg %>.LoggedCandidate)session.getAttribute("theCandidate") ;
CanBn.locateRecord(LogUsr.CandidateID);
<% }else{ %>
<%=WebAppPkg %>.LoggedSitemanager LogUsr =  (<%=WebAppPkg %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% } %>
StringBuffer ForeignKeyParam = new StringBuffer("");

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = false ;
boolean bAllowUpdate = false ;
boolean bAllowDelete = false;
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>%>
<\%@include file="/admin/authorization.inc"%>
<\%
//override Action authorization
//bAllowDelete = false;<% } %>

<% if(bHasActions){ %>String Action = RequestHelper.paramValue(request, "Action", "<%=PageActions[0] %>");<% } %>
%>
<\%@include file="/<%=LoginFolderName %>/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <% out.print("<jsp:include page =\"/include-page/common/meta-tag.jsp\" flush=\"true\" />"); %>
	<title><%=Title %></title>

  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>

</head>
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<body class="<\%=menuTypeClass %> <\%=CanBn.LoginRole %>" onload="InitPage()" >
<% }else{ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% } %>
  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/nav-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/menu-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuTitle\" value=\"???\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuLink\" value=\"???\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=Title  %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<\%=appPath %>/<%=LoginFolderName %>/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active"><%=Title  %></li>
          </ol>			
  	    </div>
  		</div>	
<% 
if(bHasActions)
{ 
  int nCount = PageActions.length;
  for(int i=0; i<nCount; i++ )
	{
      if(i==0){out.println("<"+"%"); } if(i>0){ %>else <% } %>if("<%=PageActions[i].trim() %>".equalsIgnoreCase(Action))
{
<% 
out.println("%"+">");   
%>
  <form action="<\%=thisFile %>" method="post">
	<% if(i<(nCount-1)) 
	{ 
	%><input type="hidden" name="Action" value="<%=PageActions[i+1].trim() %>" />
	<% 
	} 
	%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;<%=PageActions[i] %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
	
  <h3>Current Action : </h3> <h1><%=PageActions[i] %></h1>
	
</div>

<div class="panel-form-box-footer text-center">
    <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Submit</button>
    <button type="button" class="btn btn-default btn-outline" title="Cancel" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
    <!-- onclick="NavigateTo('<\%=appPath %>/<%=LoginFolderName %>/index.jsp')" -->	
</div>

</div>

	</form>
<%out.print("<"+"%");  %>
}
<%if( i == (nCount-1)) { %>else
{
<%out.print("%"+">");  %>
<div class="well well-sm well-danger">
  Error: The page is invoked with invalid action parameter.
</div>
<%out.print("<"+"%");  %>
}
<%out.print("%"+">");  %>
<%  
  } // end if( i == (nCount-1))
	
	
	} // end for 

} // end  if(bHasActions)
%>
    </div>
  </div>
  <!-- End Page -->
	<% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/footer.jsp\" flush=\"true\" />"); %>
	 
  <% out.print("<jsp:include page =\"/include-page/js/main-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
<script>
function InitPage()
{
// Do something on page init
}

// Initialize jQuery 
$(document).ready(function() {

});  
// end of jQuery Initialize block

</script>
	
<% out.print("<jsp:include page =\"/include-page/common/Google-Analytics.jsp\" flush=\"true\" />"); %>


</body>
</html>


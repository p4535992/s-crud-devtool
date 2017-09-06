<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String AppName = request.getParameter("AppName");
String Database = request.getParameter("Database") ;

String WebAppDir =  application.getRealPath("/user/other/new-webapp/root/"+AppName);

//admin Include Page

File ReplFile_footer = new File( WebAppDir+"/admin/include-page/footer.jsp");
String StrBuf_footer = FileUtils.readFileToString(ReplFile_footer);
String RepStr_footer = StringUtils.replace(StrBuf_footer, "$WEBAPP",AppName);
RepStr_footer = StringUtils.replace(RepStr_footer, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_footer ,RepStr_footer);

File ReplFile_nav_base = new File( WebAppDir+"/admin/include-page/assets/base/nav-body-base.jsp");
String StrBuf_nav_base = FileUtils.readFileToString(ReplFile_nav_base);
String RepStr_nav_base = StringUtils.replace(StrBuf_nav_base, "$WEBAPP",AppName);
RepStr_nav_base = StringUtils.replace(RepStr_nav_base, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_nav_base ,RepStr_nav_base);

File ReplFile_menu_base = new File( WebAppDir+"/admin/include-page/assets/base/menu-body-base.jsp");
String StrBuf_menu_base = FileUtils.readFileToString(ReplFile_menu_base);
String RepStr_menu_base = StringUtils.replace(StrBuf_menu_base, "$WEBAPP",AppName);
RepStr_menu_base = StringUtils.replace(RepStr_menu_base, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_menu_base ,RepStr_menu_base);


File ReplFile_nav_center = new File( WebAppDir+"/admin/include-page/assets/center/nav-body-center.jsp");
String StrBuf_nav_center = FileUtils.readFileToString(ReplFile_nav_center);
String RepStr_nav_center = StringUtils.replace(StrBuf_nav_center, "$WEBAPP",AppName);
RepStr_nav_center = StringUtils.replace(RepStr_nav_center, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_nav_center ,RepStr_nav_center);

File ReplFile_menu_center = new File( WebAppDir+"/admin/include-page/assets/center/menu-body-center.jsp");
String StrBuf_menu_center = FileUtils.readFileToString(ReplFile_menu_center);
String RepStr_menu_center = StringUtils.replace(StrBuf_menu_center, "$WEBAPP",AppName);
RepStr_menu_center = StringUtils.replace(RepStr_menu_center, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_menu_center ,RepStr_menu_center);


File ReplFile_nav_topbar = new File( WebAppDir+"/admin/include-page/assets/topbar/nav-body-topbar.jsp");
String StrBuf_nav_topbar = FileUtils.readFileToString(ReplFile_nav_topbar);
String RepStr_nav_topbar = StringUtils.replace(StrBuf_nav_topbar, "$WEBAPP",AppName);
RepStr_nav_topbar = StringUtils.replace(RepStr_nav_topbar, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_nav_topbar ,RepStr_nav_topbar);

File ReplFile_menu_topbar = new File( WebAppDir+"/admin/include-page/assets/topbar/menu-body-topbar.jsp");
String StrBuf_menu_topbar = FileUtils.readFileToString(ReplFile_menu_topbar);
String RepStr_menu_topbar = StringUtils.replace(StrBuf_menu_topbar, "$WEBAPP",AppName);
RepStr_menu_topbar = StringUtils.replace(RepStr_menu_topbar, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_menu_topbar ,RepStr_menu_topbar);

%>
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

File ReplFile_setregpw = new File( WebAppDir+"/admin/setregularpassword.jsp");
String StrBuf_setregpw = FileUtils.readFileToString(ReplFile_setregpw);
String RepStr_setregpw = StringUtils.replace(StrBuf_setregpw, "$WEBAPP",AppName);
RepStr_setregpw = StringUtils.replace(RepStr_setregpw, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_setregpw ,RepStr_setregpw);

File ReplFile_forbidden = new File( WebAppDir+"/admin/forbidden.jsp");
String StrBuf_forbidden = FileUtils.readFileToString(ReplFile_forbidden);
String RepStr_forbidden = StringUtils.replace(StrBuf_forbidden, "$WEBAPP",AppName);
RepStr_forbidden = StringUtils.replace(RepStr_forbidden, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_forbidden ,RepStr_forbidden);

File ReplFile_Adindx = new File( WebAppDir+"/admin/index.jsp");
String StrBuf_Adindx = FileUtils.readFileToString(ReplFile_Adindx);
String RepStr_Adindx = StringUtils.replace(StrBuf_Adindx, "$WEBAPP",AppName);
RepStr_Adindx = StringUtils.replace(RepStr_Adindx, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Adindx ,RepStr_Adindx);

File ReplFile_AdChngpw = new File( WebAppDir+"/admin/changepassword.jsp");
String StrBuf_AdChngpw = FileUtils.readFileToString(ReplFile_AdChngpw);
String RepStr_AdChngpw = StringUtils.replace(StrBuf_AdChngpw, "$WEBAPP",AppName);
RepStr_AdChngpw = StringUtils.replace(RepStr_AdChngpw, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_AdChngpw ,RepStr_AdChngpw);

File ReplFile_AdLogOut = new File( WebAppDir+"/admin/AdminLogOut.jsp");
String StrBuf_AdLogOut = FileUtils.readFileToString(ReplFile_AdLogOut);
String RepStr_AdLogOut = StringUtils.replace(StrBuf_AdLogOut, "$WEBAPP",AppName);
RepStr_AdLogOut = StringUtils.replace(RepStr_AdLogOut, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_AdLogOut ,RepStr_AdLogOut);

File ReplFile_adlog = new File( WebAppDir+"/admin/AdminSidebar.jsp");
String StrBuf_adlog = FileUtils.readFileToString(ReplFile_adlog);
String RepStr_adlog = StringUtils.replace(StrBuf_adlog, "$DATABASE",Database);
RepStr_adlog = StringUtils.replace(RepStr_adlog, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_adlog ,RepStr_adlog);

File ReplFile_adprofile = new File( WebAppDir+"/admin/AdminProfile.jsp");
String StrBuf_adprofile = FileUtils.readFileToString(ReplFile_adprofile);
String RepStr_adprofile = StringUtils.replace(StrBuf_adprofile, "$WEBAPP",AppName);
RepStr_adprofile = StringUtils.replace(RepStr_adprofile, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_adprofile ,RepStr_adprofile);

File ReplFile_Adtemp = new File( WebAppDir+"/admin/sitemanager-template.jsp");
String StrBuf_Adtemp = FileUtils.readFileToString(ReplFile_Adtemp);
String RepStr_Adtemp = StringUtils.replace(StrBuf_Adtemp, "$WEBAPP",AppName);
RepStr_Adtemp = StringUtils.replace(RepStr_Adtemp, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Adtemp ,RepStr_Adtemp);

File ReplFile_AdauthInc = new File( WebAppDir+"/admin/authorization.inc");
String StrBuf_AdauthInc = FileUtils.readFileToString(ReplFile_AdauthInc);
String RepStr_AdauthInc = StringUtils.replace(StrBuf_AdauthInc, "$WEBAPP",AppName);
RepStr_AdauthInc = StringUtils.replace(RepStr_AdauthInc, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_AdauthInc ,RepStr_AdauthInc); %>
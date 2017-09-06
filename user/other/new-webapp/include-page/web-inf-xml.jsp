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
 
// WEB-INF/xml File

File ReplFile_CONF = new File( WebAppDir+"/WEB-INF/web.xml");
String StrBuf_CONF = FileUtils.readFileToString(ReplFile_CONF);
String RepStr_CONF = StringUtils.replace(StrBuf_CONF, "$WEBAPP",AppName);
//RepStr_CONF = StringUtils.replace(RepStr_CONF, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_CONF ,RepStr_CONF);

File ReplFile_CONF_DBFile = new File( WebAppDir+"/WEB-INF/database.xml");
String StrBuf_CONF_DBFile = FileUtils.readFileToString(ReplFile_CONF_DBFile);
String RepStr_CONF_DBFile = StringUtils.replace(StrBuf_CONF_DBFile, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_CONF_DBFile ,RepStr_CONF_DBFile);

File ReplFile_CONF_loginFile = new File( WebAppDir+"/WEB-INF/login-roles.xml");
String StrBuf_CONF_loginFile = FileUtils.readFileToString(ReplFile_CONF_loginFile);
String RepStr_CONF_loginFile = StringUtils.replace(StrBuf_CONF_loginFile,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_CONF_loginFile ,RepStr_CONF_loginFile);

File ReplFile_CONF_loginphotoFile = new File( WebAppDir+"/WEB-INF/login-photo.xml");
String StrBuf_CONF_loginphotoFile = FileUtils.readFileToString(ReplFile_CONF_loginphotoFile);
String RepStr_CONF_loginphotoFile = StringUtils.replace(StrBuf_CONF_loginphotoFile,"$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_CONF_loginphotoFile ,RepStr_CONF_loginphotoFile);

File ReplFile_CONF_dropdownFile = new File( WebAppDir+"/WEB-INF/drop-down.xml");
String StrBuf_CONF_dropdownFile = FileUtils.readFileToString(ReplFile_CONF_dropdownFile);
String RepStr_CONF_dropdownFile = StringUtils.replace(StrBuf_CONF_dropdownFile,"$DATABASE",Database);
RepStr_CONF_dropdownFile = StringUtils.replace(RepStr_CONF_dropdownFile,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_CONF_dropdownFile ,RepStr_CONF_dropdownFile);

File ReplFile_CONF_KEY = new File( WebAppDir+"/WEB-INF/webapp.config");
String StrBuf_CONF_KEY = FileUtils.readFileToString(ReplFile_CONF_KEY);
String RepStr_CONF_KEY = StringUtils.replace(StrBuf_CONF_KEY,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_CONF_KEY ,RepStr_CONF_KEY);

File ReplFile_CONF_websms = new File( WebAppDir+"/WEB-INF/websms.xml");
String StrBuf_CONF_websms = FileUtils.readFileToString(ReplFile_CONF_websms);
String RepStr_CONF_websms = StringUtils.replace(StrBuf_CONF_websms,"$DATABASE",Database);
RepStr_CONF_websms = StringUtils.replace(RepStr_CONF_websms,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_CONF_websms ,RepStr_CONF_websms);

File ReplFile_CONF_webmail = new File( WebAppDir+"/WEB-INF/webmail.xml");
String StrBuf_CONF_webmail = FileUtils.readFileToString(ReplFile_CONF_webmail);
String RepStr_CONF_webmail = StringUtils.replace(StrBuf_CONF_webmail,"$DATABASE",Database);
RepStr_CONF_webmail = StringUtils.replace(RepStr_CONF_webmail,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_CONF_webmail ,RepStr_CONF_webmail);
%>
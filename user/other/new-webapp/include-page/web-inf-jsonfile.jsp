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

// WEB-INF/JSON-Entity

File ReplFile_JSON_Entity = new File( WebAppDir+"/WEB-INF/JSON-Entity/CurrentStatusFlag.txt");
String StrBuf_JSON_Entity = FileUtils.readFileToString(ReplFile_JSON_Entity);
String RepStr_JSON_Entity = StringUtils.replace(StrBuf_JSON_Entity,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_JSON_Entity ,RepStr_JSON_Entity);

File ReplFile_JSON_Entity1 = new File( WebAppDir+"/WEB-INF/JSON-Entity/PasswordType.txt");
String StrBuf_JSON_Entity1 = FileUtils.readFileToString(ReplFile_JSON_Entity1);
String RepStr_JSON_Entity1 = StringUtils.replace(StrBuf_JSON_Entity1,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_JSON_Entity1 ,RepStr_JSON_Entity1);

File ReplFile_JSON_Entity2 = new File( WebAppDir+"/WEB-INF/JSON-Entity/LoginStatusFlag.txt");
String StrBuf_JSON_Entity2 = FileUtils.readFileToString(ReplFile_JSON_Entity2);
String RepStr_JSON_Entity2 = StringUtils.replace(StrBuf_JSON_Entity2,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_JSON_Entity2 ,RepStr_JSON_Entity2);

File ReplFile_JSON_Entity3 = new File( WebAppDir+"/WEB-INF/JSON-Entity/BackupFlag.txt");
String StrBuf_JSON_Entity3 = FileUtils.readFileToString(ReplFile_JSON_Entity3);
String RepStr_JSON_Entity3 = StringUtils.replace(StrBuf_JSON_Entity3,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_JSON_Entity3 ,RepStr_JSON_Entity3);

File ReplFile_JSON_Entity4 = new File( WebAppDir+"/WEB-INF/JSON-Entity/LoginRole.txt");
String StrBuf_JSON_Entity4 = FileUtils.readFileToString(ReplFile_JSON_Entity4);
String RepStr_JSON_Entity4 = StringUtils.replace(StrBuf_JSON_Entity4,"$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_JSON_Entity4 ,RepStr_JSON_Entity4);

%>
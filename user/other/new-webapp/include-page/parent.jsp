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
 
//Parent Dir

File ReplFile_AdLogForm = new File( WebAppDir+"/AdminLoginForm.jsp");
String StrBuf_AdLogForm = FileUtils.readFileToString(ReplFile_AdLogForm);
String RepStr_AdLogForm = StringUtils.replace(StrBuf_AdLogForm, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_AdLogForm ,RepStr_AdLogForm);

File ReplFile_IDX = new File( WebAppDir+"/index.jsp");
String StrBuf_IDX = FileUtils.readFileToString(ReplFile_IDX);
String RepStr_IDX = StringUtils.replace(StrBuf_IDX, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile_IDX ,RepStr_IDX);

File ReplFile_ERPG = new File( WebAppDir+"/errorpage.jsp");
String StrBuf_ERPG = FileUtils.readFileToString(ReplFile_ERPG);
String RepStr_ERPG = StringUtils.replace(StrBuf_ERPG, "$WEBAPP",AppName);
// RepStr_ERPG = StringUtils.replace(RepStr_ERPG, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ERPG ,RepStr_ERPG);

File ReplFile_Error_404 = new File( WebAppDir+"/Error-404.jsp");
String StrBuf_Error_404 = FileUtils.readFileToString(ReplFile_Error_404);
String RepStr_Error_404 = StringUtils.replace(StrBuf_Error_404, "$WEBAPP",AppName);
// RepStr_Error_404 = StringUtils.replace(RepStr_Error_404, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Error_404 ,RepStr_Error_404);

File ReplFile_Adfgpw = new File( WebAppDir+"/Admin-forgot-password.jsp");
String StrBuf_Adfgpw = FileUtils.readFileToString(ReplFile_Adfgpw);
String RepStr_Adfgpw = StringUtils.replace(StrBuf_Adfgpw, "$WEBAPP",AppName);
// RepStr_Adfgpw = StringUtils.replace(RepStr_Adfgpw, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Adfgpw ,RepStr_Adfgpw);
%>
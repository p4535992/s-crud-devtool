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

File ReplFile_MAattlist = new File( WebAppDir+"/admin/master/attriblist.jsp");
String StrBuf_MAattlist = FileUtils.readFileToString(ReplFile_MAattlist);
String RepStr_MAattlist = StringUtils.replace(StrBuf_MAattlist, "$WEBAPP",AppName);
RepStr_MAattlist = StringUtils.replace(RepStr_MAattlist, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_MAattlist ,RepStr_MAattlist);

File ReplFile_MAitemlist = new File( WebAppDir+"/admin/master/itemlist.jsp");
String StrBuf_MAitemlist = FileUtils.readFileToString(ReplFile_MAitemlist);
String RepStr_MAitemlist = StringUtils.replace(StrBuf_MAitemlist, "$WEBAPP",AppName);
RepStr_MAitemlist = StringUtils.replace(RepStr_MAitemlist, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_MAitemlist ,RepStr_MAitemlist);

File ReplFile_MAitemtbl = new File( WebAppDir+"/admin/master/itemtables.jsp");
String StrBuf_MAitemtbl = FileUtils.readFileToString(ReplFile_MAitemtbl);
String RepStr_MAitemtbl = StringUtils.replace(StrBuf_MAitemtbl, "$WEBAPP",AppName);
RepStr_MAitemtbl = StringUtils.replace(RepStr_MAitemtbl, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_MAitemtbl ,RepStr_MAitemtbl);
%>
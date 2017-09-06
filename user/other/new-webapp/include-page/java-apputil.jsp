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
  
File DestSrcapputilFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil");
File Srcapputil1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/apputil/DateTimeHelper.java") ) ;
File Srcapputil2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/apputil/NumberSearchdroplist.java") ) ;
File Srcapputil3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/apputil/StringSearchdroplist.java") ) ;
File Srcapputil4 = new File ( application.getRealPath("/user/other/new-webapp/java-src/apputil/dbdroplist.java") ) ;
File Srcapputil5 = new File ( application.getRealPath("/user/other/new-webapp/java-src/apputil/appMakeQueryString.java") ) ;

FileUtils.copyFileToDirectory(Srcapputil1,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcapputil2,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcapputil3,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcapputil4,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcapputil5,DestSrcapputilFld);

File ReplFileapputil1 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil/DateTimeHelper.java");
String StrBufapputil1 = FileUtils.readFileToString(ReplFileapputil1);
String RepStrapputil1 = StringUtils.replace(StrBufapputil1, "$WEBAPP",AppName);
//RepStrapputil1 = StringUtils.replace(RepStrapputil1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileapputil1 ,RepStrapputil1);

File ReplFileapputil2 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil/NumberSearchdroplist.java");
String StrBufapputil2 = FileUtils.readFileToString(ReplFileapputil2);
String RepStrapputil2 = StringUtils.replace(StrBufapputil2, "$WEBAPP",AppName);
//RepStrapputil2 = StringUtils.replace(RepStrapputil2, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileapputil2 ,RepStrapputil2);

File ReplFileapputil3 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil/StringSearchdroplist.java");
String StrBufapputil3 = FileUtils.readFileToString(ReplFileapputil3);
String RepStrapputil3 = StringUtils.replace(StrBufapputil3, "$WEBAPP",AppName);
//RepStrapputil3 = StringUtils.replace(RepStrapputil3, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileapputil3 ,RepStrapputil3);

File ReplFileapputil4 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil/dbdroplist.java");
String StrBufapputil4 = FileUtils.readFileToString(ReplFileapputil4);
String RepStrapputil4 = StringUtils.replace(StrBufapputil4, "$WEBAPP",AppName);
//RepStrapputil4 = StringUtils.replace(RepStrapputil4, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileapputil4 ,RepStrapputil4);

File ReplFileapputil5 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/apputil/appMakeQueryString.java");
String StrBufapputil5 = FileUtils.readFileToString(ReplFileapputil5);
String RepStrapputil5 = StringUtils.replace(StrBufapputil5, "$WEBAPP",AppName);
//RepStrapputil5 = StringUtils.replace(RepStrapputil5, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileapputil5 ,RepStrapputil5);

%>
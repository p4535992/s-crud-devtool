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
File DestSrcapputilhandlerFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/handlers");

File Srcappsmshandler = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/handlers/DebugSMSHandler.java") ) ;

FileUtils.copyFileToDirectory(Srcappsmshandler,DestSrcapputilhandlerFld);

File ReplFileappsmshandler = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/handlers/DebugSMSHandler.java") ;
String StrBufappsmshandler = FileUtils.readFileToString(ReplFileappsmshandler);
String RepStrappsmshandler = StringUtils.replace(StrBufappsmshandler, "$WEBAPP",AppName);
RepStrappsmshandler = StringUtils.replace(RepStrappsmshandler, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsmshandler ,RepStrappsmshandler);

File DestSrcapputilFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms");

File Srcappsms1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/CustomSMSHandler.java") ) ;
File Srcappsms2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/MobileNumberStatus.java") ) ;
File Srcappsms3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/ProxySetting.java") ) ;
File Srcappsms4 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSAccountAuth.java") ) ;
File Srcappsms5 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSAccountHelper.java") ) ;
File Srcappsms6 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSAccountType.java") ) ;
File Srcappsms7 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSDispatchStatus.java") ) ;
File Srcappsms8 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSDispatchThread.java") ) ;
File Srcappsms9 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSErrorCodes.java") ) ;
File Srcappsms10 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSHelper.java") ) ;
File Srcappsms11 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSServerResponse.java") ) ;
File Srcappsms12 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSService.java") ) ;
File Srcappsms13 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSSetting.java") ) ;
File Srcappsms14 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appsms/SMSUserAuth.java") ) ;

FileUtils.copyFileToDirectory(Srcappsms1,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms2,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms3,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms4,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms5,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms6,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms7,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms8,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms9,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms10,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms11,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms12,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms13,DestSrcapputilFld);
FileUtils.copyFileToDirectory(Srcappsms14,DestSrcapputilFld);

File ReplFileappsms1 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/CustomSMSHandler.java");
String StrBufappsms1 = FileUtils.readFileToString(ReplFileappsms1);
String RepStrappsms1 = StringUtils.replace(StrBufappsms1, "$WEBAPP",AppName);
RepStrappsms1 = StringUtils.replace(RepStrappsms1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms1 ,RepStrappsms1);

File ReplFileappsms2 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/MobileNumberStatus.java");
String StrBufappsms2 = FileUtils.readFileToString(ReplFileappsms2);
String RepStrappsms2 = StringUtils.replace(StrBufappsms2, "$WEBAPP",AppName);
RepStrappsms2 = StringUtils.replace(RepStrappsms2, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms2 ,RepStrappsms2);

File ReplFileappsms3 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/ProxySetting.java");
String StrBufappsms3 = FileUtils.readFileToString(ReplFileappsms3);
String RepStrappsms3 = StringUtils.replace(StrBufappsms3, "$WEBAPP",AppName);
RepStrappsms3 = StringUtils.replace(RepStrappsms3, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms3 ,RepStrappsms3);

File ReplFileappsms4 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSAccountAuth.java");
String StrBufappsms4 = FileUtils.readFileToString(ReplFileappsms4);
String RepStrappsms4 = StringUtils.replace(StrBufappsms4, "$WEBAPP",AppName);
RepStrappsms4 = StringUtils.replace(RepStrappsms4, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms4 ,RepStrappsms4);

File ReplFileappsms5 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSAccountHelper.java");
String StrBufappsms5 = FileUtils.readFileToString(ReplFileappsms5);
String RepStrappsms5 = StringUtils.replace(StrBufappsms5, "$WEBAPP",AppName);
RepStrappsms5 = StringUtils.replace(RepStrappsms5, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms5 ,RepStrappsms5);

File ReplFileappsms6 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSAccountType.java");
String StrBufappsms6 = FileUtils.readFileToString(ReplFileappsms6);
String RepStrappsms6 = StringUtils.replace(StrBufappsms6, "$WEBAPP",AppName);
RepStrappsms6 = StringUtils.replace(RepStrappsms6, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms6 ,RepStrappsms6);

File ReplFileappsms7 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSDispatchStatus.java");
String StrBufappsms7 = FileUtils.readFileToString(ReplFileappsms7);
String RepStrappsms7 = StringUtils.replace(StrBufappsms7, "$WEBAPP",AppName);
RepStrappsms7 = StringUtils.replace(RepStrappsms7, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms7 ,RepStrappsms7);

File ReplFileappsms8 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSDispatchThread.java");
String StrBufappsms8 = FileUtils.readFileToString(ReplFileappsms8);
String RepStrappsms8 = StringUtils.replace(StrBufappsms8, "$WEBAPP",AppName);
RepStrappsms8 = StringUtils.replace(RepStrappsms8, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms8 ,RepStrappsms8);

File ReplFileappsms9 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSErrorCodes.java");
String StrBufappsms9 = FileUtils.readFileToString(ReplFileappsms9);
String RepStrappsms9 = StringUtils.replace(StrBufappsms9, "$WEBAPP",AppName);
RepStrappsms9 = StringUtils.replace(RepStrappsms9, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms9 ,RepStrappsms9);

File ReplFileappsms10 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSHelper.java");
String StrBufappsms10 = FileUtils.readFileToString(ReplFileappsms10);
String RepStrappsms10 = StringUtils.replace(StrBufappsms10, "$WEBAPP",AppName);
RepStrappsms10 = StringUtils.replace(RepStrappsms10, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms10 ,RepStrappsms10);

File ReplFileappsms11 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSServerResponse.java");
String StrBufappsms11 = FileUtils.readFileToString(ReplFileappsms11);
String RepStrappsms11 = StringUtils.replace(StrBufappsms11, "$WEBAPP",AppName);
RepStrappsms11 = StringUtils.replace(RepStrappsms11, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms11 ,RepStrappsms11);

File ReplFileappsms12 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSService.java");
String StrBufappsms12 = FileUtils.readFileToString(ReplFileappsms12);
String RepStrappsms12 = StringUtils.replace(StrBufappsms12, "$WEBAPP",AppName);
RepStrappsms12 = StringUtils.replace(RepStrappsms12, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms12 ,RepStrappsms12);

File ReplFileappsms13 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSSetting.java");
String StrBufappsms13 = FileUtils.readFileToString(ReplFileappsms13);
String RepStrappsms13 = StringUtils.replace(StrBufappsms13, "$WEBAPP",AppName);
RepStrappsms13 = StringUtils.replace(RepStrappsms13, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms13 ,RepStrappsms13);

File ReplFileappsms14 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appsms/SMSUserAuth.java");
String StrBufappsms14 = FileUtils.readFileToString(ReplFileappsms14);
String RepStrappsms14 = StringUtils.replace(StrBufappsms14, "$WEBAPP",AppName);
RepStrappsms14 = StringUtils.replace(RepStrappsms14, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappsms14 ,RepStrappsms14);

%>
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
File DestSrcappmailFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail");

File Srcappmail1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/DbUtils.java") ) ;
File Srcappmail2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/GenericMailContextListner.java") ) ;
File Srcappmail3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/JavaMailBean.java") ) ;
File Srcappmail4 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailAttachment.java") ) ;
File Srcappmail5 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailAuth.java") ) ;
File Srcappmail6 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailDispatchStatus.java") ) ;
File Srcappmail7 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailDispatchThread.java") ) ;
File Srcappmail8 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailErrorCodes.java") ) ;
File Srcappmail9 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailHelper.java") ) ;
File Srcappmail10 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailServiceInitThread.java") ) ;
File Srcappmail11 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailServiceProvider.java") ) ;
File Srcappmail12 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/MailSetting.java") ) ;
File Srcappmail13 = new File ( application.getRealPath("/user/other/new-webapp/java-src/appmail/ResinMailUtils.java") ) ;

FileUtils.copyFileToDirectory(Srcappmail1,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail2,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail3,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail4,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail5,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail6,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail7,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail8,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail9,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail10,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail11,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail12,DestSrcappmailFld);
FileUtils.copyFileToDirectory(Srcappmail13,DestSrcappmailFld);

File ReplFileappmail1 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/DbUtils.java");
String StrBufappmail1 = FileUtils.readFileToString(ReplFileappmail1);
String RepStrappmail1 = StringUtils.replace(StrBufappmail1, "$WEBAPP",AppName);
RepStrappmail1 = StringUtils.replace(RepStrappmail1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail1 ,RepStrappmail1);

File ReplFileappmail2 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/GenericMailContextListner.java");
String StrBufappmail2 = FileUtils.readFileToString(ReplFileappmail2);
String RepStrappmail2 = StringUtils.replace(StrBufappmail2, "$WEBAPP",AppName);
RepStrappmail2 = StringUtils.replace(RepStrappmail2, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail2 ,RepStrappmail2);

File ReplFileappmail3 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/JavaMailBean.java");
String StrBufappmail3 = FileUtils.readFileToString(ReplFileappmail3);
String RepStrappmail3 = StringUtils.replace(StrBufappmail3, "$WEBAPP",AppName);
RepStrappmail3 = StringUtils.replace(RepStrappmail3, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail3 ,RepStrappmail3);

File ReplFileappmail4 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailAttachment.java");
String StrBufappmail4 = FileUtils.readFileToString(ReplFileappmail4);
String RepStrappmail4 = StringUtils.replace(StrBufappmail4, "$WEBAPP",AppName);
RepStrappmail4 = StringUtils.replace(RepStrappmail4, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail4 ,RepStrappmail4);

File ReplFileappmail5 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailAuth.java");
String StrBufappmail5 = FileUtils.readFileToString(ReplFileappmail5);
String RepStrappmail5 = StringUtils.replace(StrBufappmail5, "$WEBAPP",AppName);
RepStrappmail5 = StringUtils.replace(RepStrappmail5, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail5 ,RepStrappmail5);

File ReplFileappmail6 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailDispatchStatus.java");
String StrBufappmail6 = FileUtils.readFileToString(ReplFileappmail6);
String RepStrappmail6 = StringUtils.replace(StrBufappmail6, "$WEBAPP",AppName);
RepStrappmail6 = StringUtils.replace(RepStrappmail6, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail6 ,RepStrappmail6);

File ReplFileappmail7 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailDispatchThread.java");
String StrBufappmail7 = FileUtils.readFileToString(ReplFileappmail7);
String RepStrappmail7 = StringUtils.replace(StrBufappmail7, "$WEBAPP",AppName);
RepStrappmail7 = StringUtils.replace(RepStrappmail7, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail7 ,RepStrappmail7);

File ReplFileappmail8 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailErrorCodes.java");
String StrBufappmail8 = FileUtils.readFileToString(ReplFileappmail8);
String RepStrappmail8 = StringUtils.replace(StrBufappmail8, "$WEBAPP",AppName);
RepStrappmail8 = StringUtils.replace(RepStrappmail8, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail8 ,RepStrappmail8);

File ReplFileappmail9 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailHelper.java");
String StrBufappmail9 = FileUtils.readFileToString(ReplFileappmail9);
String RepStrappmail9 = StringUtils.replace(StrBufappmail9, "$WEBAPP",AppName);
RepStrappmail9 = StringUtils.replace(RepStrappmail9, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail9 ,RepStrappmail9);

File ReplFileappmail10 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailServiceInitThread.java");
String StrBufappmail10 = FileUtils.readFileToString(ReplFileappmail10);
String RepStrappmail10 = StringUtils.replace(StrBufappmail10, "$WEBAPP",AppName);
RepStrappmail10 = StringUtils.replace(RepStrappmail10, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail10 ,RepStrappmail10);

File ReplFileappmail11 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailServiceProvider.java");
String StrBufappmail11 = FileUtils.readFileToString(ReplFileappmail11);
String RepStrappmail11 = StringUtils.replace(StrBufappmail11, "$WEBAPP",AppName);
RepStrappmail11 = StringUtils.replace(RepStrappmail11, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail11 ,RepStrappmail11);

File ReplFileappmail12 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/MailSetting.java");
String StrBufappmail12 = FileUtils.readFileToString(ReplFileappmail12);
String RepStrappmail12 = StringUtils.replace(StrBufappmail12, "$WEBAPP",AppName);
RepStrappmail12 = StringUtils.replace(RepStrappmail12, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail12 ,RepStrappmail12);

File ReplFileappmail13 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/appmail/ResinMailUtils.java");
String StrBufappmail13 = FileUtils.readFileToString(ReplFileappmail13);
String RepStrappmail13 = StringUtils.replace(StrBufappmail13, "$WEBAPP",AppName);
RepStrappmail13 = StringUtils.replace(RepStrappmail13, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFileappmail13 ,RepStrappmail13);


%>
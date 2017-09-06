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

// Copy java scource file to proper locations

File DestSrcFld = new File( WebAppDir+"/WEB-INF/src/com/"+AppName);
File Src1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/ApplicationResource.java") ) ;
File Src2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/InitThread.java") ) ;
File Src3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/WebAppContextListener.java") ) ;
File Src4 = new File ( application.getRealPath("/user/other/new-webapp/java-src/AppSetting.java") ) ;
File Src5 = new File ( application.getRealPath("/user/other/new-webapp/java-src/DebugLogger.java") ) ;
File Src6 = new File ( application.getRealPath("/user/other/new-webapp/java-src/LoggedSitemanager.java") ) ;
File Src7 = new File ( application.getRealPath("/user/other/new-webapp/java-src/CurrentStatusFlag.java") ) ;
File Src8 = new File ( application.getRealPath("/user/other/new-webapp/java-src/PasswordType.java") ) ;
File Src9 = new File ( application.getRealPath("/user/other/new-webapp/java-src/ShowItem.java") ) ;
File Src10 = new File ( application.getRealPath("/user/other/new-webapp/java-src/UpdateAdminPhoto.java") ) ;
File Src11 = new File ( application.getRealPath("/user/other/new-webapp/java-src/LoginStatusFlag.java") ) ;
File Src12 = new File ( application.getRealPath("/user/other/new-webapp/java-src/BackupFlag.java") ) ;
File Src13 = new File ( application.getRealPath("/user/other/new-webapp/java-src/LoginRole.java") ) ;

FileUtils.copyFileToDirectory(Src1,DestSrcFld);
FileUtils.copyFileToDirectory(Src2,DestSrcFld);
FileUtils.copyFileToDirectory(Src3,DestSrcFld);
FileUtils.copyFileToDirectory(Src4,DestSrcFld);
FileUtils.copyFileToDirectory(Src5,DestSrcFld);
FileUtils.copyFileToDirectory(Src6,DestSrcFld);
FileUtils.copyFileToDirectory(Src7,DestSrcFld);
FileUtils.copyFileToDirectory(Src8,DestSrcFld);
FileUtils.copyFileToDirectory(Src9,DestSrcFld);
FileUtils.copyFileToDirectory(Src10,DestSrcFld);
FileUtils.copyFileToDirectory(Src11,DestSrcFld);
FileUtils.copyFileToDirectory(Src12,DestSrcFld);
FileUtils.copyFileToDirectory(Src13,DestSrcFld);

File ReplFile1 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/ApplicationResource.java");
String StrBuf1 = FileUtils.readFileToString(ReplFile1);
String RepStr1 = StringUtils.replace(StrBuf1, "$WEBAPP",AppName);
RepStr1 = StringUtils.replace(RepStr1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile1 ,RepStr1);

File ReplFile2 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/InitThread.java");
String StrBuf2 = FileUtils.readFileToString(ReplFile2);
String RepStr2 = StringUtils.replace(StrBuf2, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile2 ,RepStr2);

File ReplFile3 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/WebAppContextListener.java");
String StrBuf3 = FileUtils.readFileToString(ReplFile3);
String RepStr3 = StringUtils.replace(StrBuf3, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile3 ,RepStr3);
// rename file
File newNameReplFile3 = new File(WebAppDir+"/WEB-INF/src/com/"+AppName+"/"+AppName+"ContextListener.java");
ReplFile3.renameTo(newNameReplFile3);

File ReplFile4 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/AppSetting.java");
String StrBuf4 = FileUtils.readFileToString(ReplFile4);
String RepStr4 = StringUtils.replace(StrBuf4, "$WEBAPP",AppName);
RepStr4 = StringUtils.replace(RepStr4, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile4 ,RepStr4);

File ReplFile5 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/DebugLogger.java");
String StrBuf5 = FileUtils.readFileToString(ReplFile5);
String RepStr5 = StringUtils.replace(StrBuf5, "$WEBAPP",AppName);
RepStr5 = StringUtils.replace(RepStr5, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile5 ,RepStr5);

File ReplFile6 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/CurrentStatusFlag.java");
String StrBuf6 = FileUtils.readFileToString(ReplFile6);
String RepStr6 = StringUtils.replace(StrBuf6, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile6 ,RepStr6);

File ReplFile7 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/LoggedSitemanager.java");
String StrBuf7 = FileUtils.readFileToString(ReplFile7);
String RepStr7 = StringUtils.replace(StrBuf7, "$WEBAPP",AppName);
RepStr7 = StringUtils.replace(RepStr7, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile7 ,RepStr7);

File ReplFile8 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/PasswordType.java");
String StrBuf8 = FileUtils.readFileToString(ReplFile8);
String RepStr8 = StringUtils.replace(StrBuf8, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile8 ,RepStr8);

File ReplFile9 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/ShowItem.java");
String StrBuf9 = FileUtils.readFileToString(ReplFile9);
String RepStr9 = StringUtils.replace(StrBuf9, "$WEBAPP",AppName);
RepStr9 = StringUtils.replace(RepStr9, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile9 ,RepStr9);

File ReplFile10 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/UpdateAdminPhoto.java");
String StrBuf10 = FileUtils.readFileToString(ReplFile10);
String RepStr10 = StringUtils.replace(StrBuf10, "$WEBAPP",AppName);
RepStr10 = StringUtils.replace(RepStr10, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile10 ,RepStr10);

File ReplFile11 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/LoginStatusFlag.java");
String StrBuf11 = FileUtils.readFileToString(ReplFile11);
String RepStr11 = StringUtils.replace(StrBuf11, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile11 ,RepStr11);

File ReplFile12 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/BackupFlag.java");
String StrBuf12 = FileUtils.readFileToString(ReplFile12);
String RepStr12 = StringUtils.replace(StrBuf12, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile12 ,RepStr12);

File ReplFile13 = new File( WebAppDir+"/WEB-INF/src/com/"+AppName+"/LoginRole.java");
String StrBuf13 = FileUtils.readFileToString(ReplFile13);
String RepStr13 = StringUtils.replace(StrBuf13, "$WEBAPP",AppName);
FileUtils.writeStringToFile(ReplFile13 ,RepStr13);

%>
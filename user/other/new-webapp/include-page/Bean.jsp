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
 
// Copy java Bean to proper locations

File DestBeanFld = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database );
File SrcBean1 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/AppsettingBean.java") ) ;
File SrcBean2 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/DebuglogBean.java") ) ;
File SrcBean3 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/SitemanagerBean.java") ) ;
File SrcBean4 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/AccesslogofsitemanagerBean.java") ) ;
File SrcBean5 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sitemanager_photographBean.java") ) ;
File SrcBean6 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/MasterattributeBean.java") ) ;
File SrcBean7 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/MasteritemlistBean.java") ) ;
File SrcBean8 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/MasteritemtableBean.java") ) ;
File SrcBean9 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Daily_backupBean.java") ) ;
File SrcBean10 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sitemanager_authorizationBean.java") ) ;
File SrcBean11 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/ModuleBean.java") ) ;
File SrcBean12 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Module_activityBean.java") ) ;
File SrcBean13 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/State_cityBean.java") ) ;

FileUtils.copyFileToDirectory(SrcBean1,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean2,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean3,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean4,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean5,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean6,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean7,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean8,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean9,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean10,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean11,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean12,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean13,DestBeanFld);


File ReplFile_Bean1 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/AppsettingBean.java");
String StrBuf_Bean1 = FileUtils.readFileToString(ReplFile_Bean1);
String RepStr_Bean1 = StringUtils.replace(StrBuf_Bean1, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean1 ,RepStr_Bean1);

File ReplFile_Bean2 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/DebuglogBean.java");
String StrBuf_Bean2 = FileUtils.readFileToString(ReplFile_Bean2);
String RepStr_Bean2 = StringUtils.replace(StrBuf_Bean2, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean2 ,RepStr_Bean2);

File ReplFile_Bean3 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/SitemanagerBean.java");
String StrBuf_Bean3 = FileUtils.readFileToString(ReplFile_Bean3);
String RepStr_Bean3 = StringUtils.replace(StrBuf_Bean3, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean3 ,RepStr_Bean3);

File ReplFile_Bean4 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/AccesslogofsitemanagerBean.java");
String StrBuf_Bean4 = FileUtils.readFileToString(ReplFile_Bean4);
String RepStr_Bean4 = StringUtils.replace(StrBuf_Bean4, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean4 ,RepStr_Bean4);

File ReplFile_Bean5 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sitemanager_photographBean.java");
String StrBuf_Bean5 = FileUtils.readFileToString(ReplFile_Bean5);
String RepStr_Bean5 = StringUtils.replace(StrBuf_Bean5, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean5 ,RepStr_Bean5);

File ReplFile_Bean6 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/MasterattributeBean.java");
String StrBuf_Bean6 = FileUtils.readFileToString(ReplFile_Bean6);
String RepStr_Bean6 = StringUtils.replace(StrBuf_Bean6, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean6 ,RepStr_Bean6);

File ReplFile_Bean7 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/MasteritemlistBean.java");
String StrBuf_Bean7 = FileUtils.readFileToString(ReplFile_Bean7);
String RepStr_Bean7 = StringUtils.replace(StrBuf_Bean7, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean7 ,RepStr_Bean7);

File ReplFile_Bean8 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/MasteritemtableBean.java");
String StrBuf_Bean8 = FileUtils.readFileToString(ReplFile_Bean8);
String RepStr_Bean8 = StringUtils.replace(StrBuf_Bean8, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean8 ,RepStr_Bean8);

File ReplFile_Bean9 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Daily_backupBean.java");
String StrBuf_Bean9 = FileUtils.readFileToString(ReplFile_Bean9);
String RepStr_Bean9 = StringUtils.replace(StrBuf_Bean9, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean9 ,RepStr_Bean9);

File ReplFile_Bean10 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sitemanager_authorizationBean.java");
String StrBuf_Bean10 = FileUtils.readFileToString(ReplFile_Bean10);
String RepStr_Bean10 = StringUtils.replace(StrBuf_Bean10, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean10 ,RepStr_Bean10);

File ReplFile_Bean11 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/ModuleBean.java");
String StrBuf_Bean11 = FileUtils.readFileToString(ReplFile_Bean11);
String RepStr_Bean11 = StringUtils.replace(StrBuf_Bean11, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean11 ,RepStr_Bean11);

File ReplFile_Bean12 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Module_activityBean.java");
String StrBuf_Bean12 = FileUtils.readFileToString(ReplFile_Bean12);
String RepStr_Bean12 = StringUtils.replace(StrBuf_Bean12, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean12 ,RepStr_Bean12);

File ReplFile_Bean13 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/State_cityBean.java");
String StrBuf_Bean13 = FileUtils.readFileToString(ReplFile_Bean13);
String RepStr_Bean13 = StringUtils.replace(StrBuf_Bean13, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean13 ,RepStr_Bean13); 

//========SMS BEAN=========

File SrcBean14 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_authBean.java") ) ;
File SrcBean15 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_debuglogBean.java") ) ;
File SrcBean16 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_gatewayaccountsBean.java") ) ;
File SrcBean17 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_handlerBean.java") ) ;
File SrcBean18 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_joblogBean.java") ) ;
File SrcBean19 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_jobsBean.java") ) ;
File SrcBean20 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_settingsBean.java") ) ;
File SrcBean21 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_singlelogBean.java") ) ;
File SrcBean22 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Sms_templateBean.java") ) ;

FileUtils.copyFileToDirectory(SrcBean14,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean15,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean16,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean17,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean18,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean19,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean20,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean21,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean22,DestBeanFld);

File ReplFile_Bean14 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_authBean.java");
String StrBuf_Bean14 = FileUtils.readFileToString(ReplFile_Bean14);
String RepStr_Bean14 = StringUtils.replace(StrBuf_Bean14, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean14 ,RepStr_Bean14); 

File ReplFile_Bean15 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_debuglogBean.java");
String StrBuf_Bean15 = FileUtils.readFileToString(ReplFile_Bean15);
String RepStr_Bean15 = StringUtils.replace(StrBuf_Bean15, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean15 ,RepStr_Bean15); 

File ReplFile_Bean16 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_gatewayaccountsBean.java");
String StrBuf_Bean16 = FileUtils.readFileToString(ReplFile_Bean16);
String RepStr_Bean16 = StringUtils.replace(StrBuf_Bean16, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean16 ,RepStr_Bean16); 

File ReplFile_Bean17 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_handlerBean.java");
String StrBuf_Bean17 = FileUtils.readFileToString(ReplFile_Bean17);
String RepStr_Bean17 = StringUtils.replace(StrBuf_Bean17, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean17 ,RepStr_Bean17); 

File ReplFile_Bean18 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_joblogBean.java");
String StrBuf_Bean18 = FileUtils.readFileToString(ReplFile_Bean18);
String RepStr_Bean18 = StringUtils.replace(StrBuf_Bean18, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean18 ,RepStr_Bean18); 

File ReplFile_Bean19 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_jobsBean.java");
String StrBuf_Bean19 = FileUtils.readFileToString(ReplFile_Bean19);
String RepStr_Bean19 = StringUtils.replace(StrBuf_Bean19, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean19 ,RepStr_Bean19); 

File ReplFile_Bean20 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_settingsBean.java");
String StrBuf_Bean20 = FileUtils.readFileToString(ReplFile_Bean20);
String RepStr_Bean20 = StringUtils.replace(StrBuf_Bean20, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean20 ,RepStr_Bean20); 

File ReplFile_Bean21 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_singlelogBean.java");
String StrBuf_Bean21 = FileUtils.readFileToString(ReplFile_Bean21);
String RepStr_Bean21 = StringUtils.replace(StrBuf_Bean21, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean21 ,RepStr_Bean21); 

File ReplFile_Bean22 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Sms_templateBean.java");
String StrBuf_Bean22 = FileUtils.readFileToString(ReplFile_Bean22);
String RepStr_Bean22 = StringUtils.replace(StrBuf_Bean22, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean22 ,RepStr_Bean22); 

//========MAIL BEAN=========

File SrcBean23 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_bulkattachmentsBean.java") ) ;
File SrcBean24 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_bulkjobBean.java") ) ;
File SrcBean25 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_bulkjoblogBean.java") ) ;
File SrcBean26 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_debuglogBean.java") ) ;
File SrcBean27 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_settingsBean.java") ) ;
File SrcBean28 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_singleattachmentsBean.java") ) ;
File SrcBean29 = new File ( application.getRealPath("/user/other/new-webapp/java-src/bean/Mail_singlelogBean.java") ) ;

FileUtils.copyFileToDirectory(SrcBean23,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean24,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean25,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean26,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean27,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean28,DestBeanFld);
FileUtils.copyFileToDirectory(SrcBean29,DestBeanFld);

File ReplFile_Bean23 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_bulkattachmentsBean.java");
String StrBuf_Bean23 = FileUtils.readFileToString(ReplFile_Bean23);
String RepStr_Bean23 = StringUtils.replace(StrBuf_Bean23, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean23 ,RepStr_Bean23); 

File ReplFile_Bean24 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_bulkjobBean.java");
String StrBuf_Bean24 = FileUtils.readFileToString(ReplFile_Bean24);
String RepStr_Bean24 = StringUtils.replace(StrBuf_Bean24, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean24 ,RepStr_Bean24); 

File ReplFile_Bean25 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_bulkjoblogBean.java");
String StrBuf_Bean25 = FileUtils.readFileToString(ReplFile_Bean25);
String RepStr_Bean25 = StringUtils.replace(StrBuf_Bean25, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean25 ,RepStr_Bean25); 

File ReplFile_Bean26 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_debuglogBean.java");
String StrBuf_Bean26 = FileUtils.readFileToString(ReplFile_Bean26);
String RepStr_Bean26 = StringUtils.replace(StrBuf_Bean26, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean26 ,RepStr_Bean26); 

File ReplFile_Bean27 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_settingsBean.java");
String StrBuf_Bean27 = FileUtils.readFileToString(ReplFile_Bean27);
String RepStr_Bean27 = StringUtils.replace(StrBuf_Bean27, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean27 ,RepStr_Bean27); 

File ReplFile_Bean28 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_singleattachmentsBean.java");
String StrBuf_Bean28 = FileUtils.readFileToString(ReplFile_Bean28);
String RepStr_Bean28 = StringUtils.replace(StrBuf_Bean28, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean28 ,RepStr_Bean28); 

File ReplFile_Bean29 = new File( WebAppDir+"/WEB-INF/src/com/db/"+Database+"/Mail_singlelogBean.java");
String StrBuf_Bean29 = FileUtils.readFileToString(ReplFile_Bean29);
String RepStr_Bean29 = StringUtils.replace(StrBuf_Bean29, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_Bean29 ,RepStr_Bean29); 

%>
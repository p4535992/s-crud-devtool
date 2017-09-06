<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*" %>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.io.CopyUtils"%>

<%@ page import="org.apache.commons.lang3.StringUtils"%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String  BeanName = request.getParameter("BeanName");
String  BeanClass = request.getParameter("BeanClass");
String  BeanPackage = request.getParameter("BeanPackage");
String  LoginClass = request.getParameter("LoginClass") ;
String  LoginObjectID = request.getParameter("LoginObjectID") ;

String  Database = request.getParameter("Database") ;
String  TableName = request.getParameter("TableName");
String  IDField = request.getParameter("IDField");
String  WebApp = request.getParameter("WebApp") ;

String LoginFolderName = request.getParameter("LoginFolderName") ;

char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;

String loginpkgDir =  application.getRealPath("/user/login/root/login_pkg_"+TableName);
String OutputZipFile =  application.getRealPath("/user/login/root/login_pkg_"+TableName+".zip");

String loginpkgTemplateDir = application.getRealPath("/user/login/login-pkg");

File fllogin = new File( loginpkgDir );
File flliginTempl  = new File(loginpkgTemplateDir);
	 

// Delete any existing directory with same name
FileUtils.deleteQuietly(fllogin);

FileUtils.forceMkdir(fllogin );
FileUtils.copyDirectory( flliginTempl, fllogin );


//forgot-password.jsp

File forgotpasswordJSPFile = new File( loginpkgDir+"/support/$CTABLENAME-forgot-password.jsp");
String StrforgotpasswordJSPFileBuf = FileUtils.readFileToString(forgotpasswordJSPFile);
String RepforgotpasswordJSPFileStr = StringUtils.replace(StrforgotpasswordJSPFileBuf, "$WEBAPP",WebApp);
RepforgotpasswordJSPFileStr = StringUtils.replace(RepforgotpasswordJSPFileStr, "$BeanPackage",BeanPackage);
RepforgotpasswordJSPFileStr = StringUtils.replace(RepforgotpasswordJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(forgotpasswordJSPFile ,RepforgotpasswordJSPFileStr);
// rename file
File newNameforgotpasswordJSPFile = new File(loginpkgDir+"/support/"+CTableName+"-forgot-password.jsp");
forgotpasswordJSPFile.renameTo(newNameforgotpasswordJSPFile);

//****************** END FORGOT PASSWORD ****************************************


//excel-import.jsp

File excelimportJSPFile = new File( loginpkgDir+"/support/excelimport/excel-import-$TABLENAME.jsp");
String StrexcelimportJSPFileBuf = FileUtils.readFileToString(excelimportJSPFile);
String RepexcelimportJSPFileStr = StringUtils.replace(StrexcelimportJSPFileBuf, "$WEBAPP",WebApp);
RepexcelimportJSPFileStr = StringUtils.replace(RepexcelimportJSPFileStr, "$BeanPackage",BeanPackage);
RepexcelimportJSPFileStr = StringUtils.replace(RepexcelimportJSPFileStr, "$CTABLENAME",CTableName);
RepexcelimportJSPFileStr = StringUtils.replace(RepexcelimportJSPFileStr, "$TABLENAME",TableName);
RepexcelimportJSPFileStr = StringUtils.replace(RepexcelimportJSPFileStr, "$DATABASE",Database);
FileUtils.writeStringToFile(excelimportJSPFile ,RepexcelimportJSPFileStr);
// rename file
File newNameexcelimportJSPFile = new File(loginpkgDir+"/support/excelimport/excel-import-"+TableName+".jsp");
excelimportJSPFile.renameTo(newNameexcelimportJSPFile);

//User-$CTABLENAME.xlsx

File excelimportexcelFile = new File( loginpkgDir+"/support/excelimport/User-$CTABLENAME.xlsx");
// rename file
File newNameexcelimportexcelFile = new File(loginpkgDir+"/support/excelimport/User-"+CTableName+".xlsx");
excelimportexcelFile.renameTo(newNameexcelimportexcelFile);


//****************** END EXCEL IMPORT ****************************************

//ManageUser Folder

//manageUSER.jsp

File manageUSERJSPFile = new File( loginpkgDir+"/support/ManageUser/manage$TABLENAME.jsp");
String StrmanageUSERJSPFileBuf = FileUtils.readFileToString(manageUSERJSPFile);
String RepmanageUSERJSPFileStr = StringUtils.replace(StrmanageUSERJSPFileBuf, "$WEBAPP",WebApp);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$BeanPackage",BeanPackage);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$BeanName",BeanName);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$BeanClass",BeanClass);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$LoginClass",LoginClass);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$LoginObjectID",LoginObjectID);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$IDField",IDField);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$LoginFolderName",LoginFolderName);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$TABLENAME",TableName);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$CTABLENAME",CTableName);
RepmanageUSERJSPFileStr = StringUtils.replace(RepmanageUSERJSPFileStr, "$DATABASE",Database);
FileUtils.writeStringToFile(manageUSERJSPFile ,RepmanageUSERJSPFileStr);
// rename file
File newNamemanageUSERJSPFile = new File(loginpkgDir+"/support/ManageUser/manage"+TableName+".jsp");
manageUSERJSPFile.renameTo(newNamemanageUSERJSPFile);

//webcam folder

//capture.jsp
File ADcaptureJSPFile = new File( loginpkgDir+"/support/ManageUser/webcam/admin-$CTABLENAMEcapture.jsp");
String StrADcaptureJSPFileBuf = FileUtils.readFileToString(ADcaptureJSPFile);
String RepADcaptureJSPFileStr = StringUtils.replace(StrADcaptureJSPFileBuf, "$WEBAPP",WebApp);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$BeanPackage",BeanPackage);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$BeanName",BeanName);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$BeanClass",BeanClass);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$LoginClass",LoginClass);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$LoginObjectID",LoginObjectID);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$IDField",IDField);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$CTABLENAME",CTableName);
RepADcaptureJSPFileStr = StringUtils.replace(RepADcaptureJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(ADcaptureJSPFile ,RepADcaptureJSPFileStr);
// rename file
File newADcaptureJSPFile = new File(loginpkgDir+"/support/ManageUser/webcam/admin-"+CTableName+"capture.jsp");
ADcaptureJSPFile.renameTo(newADcaptureJSPFile);


//upload-image.jsp
File ADuploadimageJSPFile = new File( loginpkgDir+"/support/ManageUser/webcam/admin-$CTABLENAME-upload-image.jsp");
String StrADuploadimageJSPFileBuf = FileUtils.readFileToString(ADuploadimageJSPFile);
String RepADuploadimageJSPFileStr = StringUtils.replace(StrADuploadimageJSPFileBuf, "$WEBAPP",WebApp);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$BeanPackage",BeanPackage);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$BeanName",BeanName);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$BeanClass",BeanClass);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$LoginClass",LoginClass);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$LoginObjectID",LoginObjectID);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$IDField",IDField);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$CTABLENAME",CTableName);
RepADuploadimageJSPFileStr = StringUtils.replace(RepADuploadimageJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(ADuploadimageJSPFile ,RepADuploadimageJSPFileStr);
// rename file
File newADuploadimageJSPFile = new File(loginpkgDir+"/support/ManageUser/webcam/admin-"+CTableName+"-upload-image.jsp");
ADuploadimageJSPFile.renameTo(newADuploadimageJSPFile);

//****************** END ManageUser Folder ****************************************


//Link-to-admin-navbar.txt

File resetpwLINKFile = new File( loginpkgDir+"/support/resetpassword/Link-to-admin-navbar.txt");
String StrresetpwLINKFileBuf = FileUtils.readFileToString(resetpwLINKFile);
String RepresetpwLINKFileStr = StringUtils.replace(StrresetpwLINKFileBuf, "$TABLENAME",TableName);
RepresetpwLINKFileStr = StringUtils.replace(RepresetpwLINKFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(resetpwLINKFile ,RepresetpwLINKFileStr);


//resetpassword.jsp

File resetpwJSPFile = new File( loginpkgDir+"/support/resetpassword/resetpasswordof$TABLENAME.jsp");
String StrresetpwJSPFileBuf = FileUtils.readFileToString(resetpwJSPFile);
String RepresetpwJSPFileStr = StringUtils.replace(StrresetpwJSPFileBuf, "$WEBAPP",WebApp);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$BeanPackage",BeanPackage);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$BeanName",BeanName);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$BeanClass",BeanClass);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$LoginClass",LoginClass);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$LoginObjectID",LoginObjectID);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$IDField",IDField);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$LoginFolderName",LoginFolderName);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$TABLENAME",TableName);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$CTABLENAME",CTableName);
RepresetpwJSPFileStr = StringUtils.replace(RepresetpwJSPFileStr, "$DATABASE",Database);
FileUtils.writeStringToFile(resetpwJSPFile ,RepresetpwJSPFileStr);
// rename file
File newNameresetpwJSPFile = new File(loginpkgDir+"/support/resetpassword/resetpasswordof"+TableName+".jsp");
resetpwJSPFile.renameTo(newNameresetpwJSPFile);


//resetpasswordof-popup.jsp

File resetpwpopupJSPFile = new File( loginpkgDir+"/support/resetpassword/resetpasswordof$TABLENAME-popup.jsp");
String StrresetpwpopupJSPFileBuf = FileUtils.readFileToString(resetpwpopupJSPFile);
String RepresetpwpopupJSPFileStr = StringUtils.replace(StrresetpwpopupJSPFileBuf, "$WEBAPP",WebApp);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$BeanPackage",BeanPackage);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$BeanName",BeanName);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$BeanClass",BeanClass);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$LoginClass",LoginClass);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$LoginObjectID",LoginObjectID);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$IDField",IDField);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$LoginFolderName",LoginFolderName);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$TABLENAME",TableName);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$CTABLENAME",CTableName);
RepresetpwpopupJSPFileStr = StringUtils.replace(RepresetpwpopupJSPFileStr, "$DATABASE",Database);
FileUtils.writeStringToFile(resetpwpopupJSPFile ,RepresetpwpopupJSPFileStr);
// rename file
File newNameresetpwpopupJSPFile = new File(loginpkgDir+"/support/resetpassword/resetpasswordof"+TableName+"-popup.jsp");
resetpwpopupJSPFile.renameTo(newNameresetpwpopupJSPFile);



//****************** END RESET PASSWORD ****************************************

//Accesslog

File AccesslogSQLFile = new File( loginpkgDir+"/support/Accesslog/accesslog_SQL.txt");
String StrAccesslogSQLFileBuf = FileUtils.readFileToString(AccesslogSQLFile);
String RepAccesslogSQLFileStr = StringUtils.replace(StrAccesslogSQLFileBuf, "$DATABASE",Database);
RepAccesslogSQLFileStr = StringUtils.replace(RepAccesslogSQLFileStr, "$TABLENAME",TableName);
RepAccesslogSQLFileStr = StringUtils.replace(RepAccesslogSQLFileStr, "$IDFIELD",IDField);
FileUtils.writeStringToFile(AccesslogSQLFile ,RepAccesslogSQLFileStr);

File AccesslogBeanFile = new File( loginpkgDir+"/support/Accesslog/Accesslogof$TABLENAMEBean.java");
String StrAccesslogBeanFileBuf = FileUtils.readFileToString(AccesslogBeanFile);
String RepAccesslogBeanFileStr = StringUtils.replace(StrAccesslogBeanFileBuf, "$DATABASE",Database);
RepAccesslogBeanFileStr = StringUtils.replace(RepAccesslogBeanFileStr, "$TABLENAME",TableName);
RepAccesslogBeanFileStr = StringUtils.replace(RepAccesslogBeanFileStr, "$IDFIELD",IDField);
FileUtils.writeStringToFile(AccesslogBeanFile ,RepAccesslogBeanFileStr);
// rename file
File newNameAccesslogBeanFile = new File(loginpkgDir+"/support/Accesslog/Accesslogof"+TableName+"Bean.java");
AccesslogBeanFile.renameTo(newNameAccesslogBeanFile);

//accesslog.jsp

File AccesslogJSPFile = new File( loginpkgDir+"/support/Accesslog/accesslogof$TABLENAME.jsp");
String StrAccesslogJSPFileBuf = FileUtils.readFileToString(AccesslogJSPFile);
String RepAccesslogJSPFileStr = StringUtils.replace(StrAccesslogJSPFileBuf, "$WEBAPP",WebApp);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$BeanPackage",BeanPackage);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$BeanName",BeanName);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$BeanClass",BeanClass);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$LoginClass",LoginClass);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$LoginObjectID",LoginObjectID);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$IDField",IDField);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$LoginFolderName",LoginFolderName);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$TABLENAME",TableName);
RepAccesslogJSPFileStr = StringUtils.replace(RepAccesslogJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(AccesslogJSPFile ,RepAccesslogJSPFileStr);
// rename file
File newNameAccesslogJSPFile = new File(loginpkgDir+"/support/Accesslog/accesslogof"+TableName+".jsp");
AccesslogJSPFile.renameTo(newNameAccesslogJSPFile);

//Link-to-admin-navbar.txt

File AccesslogLINKFile = new File( loginpkgDir+"/support/Accesslog/Link-to-admin-navbar.txt");
String StrAccesslogLINKFileBuf = FileUtils.readFileToString(AccesslogLINKFile);
String RepAccesslogLINKFileStr = StringUtils.replace(StrAccesslogLINKFileBuf, "$TABLENAME",TableName);
RepAccesslogLINKFileStr = StringUtils.replace(RepAccesslogLINKFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(AccesslogLINKFile ,RepAccesslogLINKFileStr);

//searchUSER-popup.jsp

File searchUSERpopupJSPFile = new File( loginpkgDir+"/support/Accesslog/user_searchpopup/search$TABLENAME-popup.jsp");
String StrsearchUSERpopupJSPFileBuf = FileUtils.readFileToString(searchUSERpopupJSPFile);
String RepsearchUSERpopupJSPFileStr = StringUtils.replace(StrsearchUSERpopupJSPFileBuf, "$WEBAPP",WebApp);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$BeanPackage",BeanPackage);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$BeanName",BeanName);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$BeanClass",BeanClass);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$LoginClass",LoginClass);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$LoginObjectID",LoginObjectID);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$IDField",IDField);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$LoginFolderName",LoginFolderName);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$TABLENAME",TableName);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$CTABLENAME",CTableName);
RepsearchUSERpopupJSPFileStr = StringUtils.replace(RepsearchUSERpopupJSPFileStr, "$DATABASE",Database);
FileUtils.writeStringToFile(searchUSERpopupJSPFile ,RepsearchUSERpopupJSPFileStr);
// rename file
File newNamesearchUSERpopupJSPFile = new File(loginpkgDir+"/support/Accesslog/user_searchpopup/search"+TableName+"-popup.jsp");
searchUSERpopupJSPFile.renameTo(newNamesearchUSERpopupJSPFile);


//****************** END Accesslog ****************************************

//Photograph

File PhotographSQLFile = new File( loginpkgDir+"/support/Photograph/photograph_SQL.txt");
String StrPhotographSQLFileBuf = FileUtils.readFileToString(PhotographSQLFile);
String RepPhotographSQLFileStr = StringUtils.replace(StrPhotographSQLFileBuf, "$DATABASE",Database);
RepPhotographSQLFileStr = StringUtils.replace(RepPhotographSQLFileStr, "$TABLENAME",TableName);
RepPhotographSQLFileStr = StringUtils.replace(RepPhotographSQLFileStr, "$IDFIELD",IDField);
FileUtils.writeStringToFile(PhotographSQLFile ,RepPhotographSQLFileStr);

File PhotographBeanFile = new File( loginpkgDir+"/support/Photograph/$CTABLENAME_photographBean.java");
String StrPhotographBeanFileBuf = FileUtils.readFileToString(PhotographBeanFile);
String RepPhotographBeanFileStr = StringUtils.replace(StrPhotographBeanFileBuf, "$DATABASE",Database);
RepPhotographBeanFileStr = StringUtils.replace(RepPhotographBeanFileStr, "$CTABLENAME",CTableName);
RepPhotographBeanFileStr = StringUtils.replace(RepPhotographBeanFileStr, "$TABLENAME",TableName);
RepPhotographBeanFileStr = StringUtils.replace(RepPhotographBeanFileStr, "$IDFIELD",IDField);
FileUtils.writeStringToFile(PhotographBeanFile ,RepPhotographBeanFileStr);
// rename file
File newNamePhotographBeanFile = new File(loginpkgDir+"/support/Photograph/"+CTableName+"_photographBean.java");
PhotographBeanFile.renameTo(newNamePhotographBeanFile);

File PhotographXMLFile = new File( loginpkgDir+"/support/Photograph/photograph_XML.txt");
String StrPhotographXMLFileBuf = FileUtils.readFileToString(PhotographXMLFile);
String RepPhotographXMLFileStr = StringUtils.replace(StrPhotographXMLFileBuf, "$DATABASE",Database);
RepPhotographXMLFileStr = StringUtils.replace(RepPhotographXMLFileStr, "$CTABLENAME",CTableName);
RepPhotographXMLFileStr = StringUtils.replace(RepPhotographXMLFileStr, "$TABLENAME",TableName);
RepPhotographXMLFileStr = StringUtils.replace(RepPhotographXMLFileStr, "$IDFIELD",IDField);
FileUtils.writeStringToFile(PhotographXMLFile ,RepPhotographXMLFileStr);

File PhotographjavaFile = new File( loginpkgDir+"/support/Photograph/Update$CTABLENAMEPhoto.java");
String StrPhotographjavaFileBuf = FileUtils.readFileToString(PhotographjavaFile);
String RepPhotographjavaFileStr = StringUtils.replace(StrPhotographjavaFileBuf, "$DATABASE",Database);
RepPhotographjavaFileStr = StringUtils.replace(RepPhotographjavaFileStr, "$WEBAPP",WebApp);
RepPhotographjavaFileStr = StringUtils.replace(RepPhotographjavaFileStr, "$CTABLENAME",CTableName);
RepPhotographjavaFileStr = StringUtils.replace(RepPhotographjavaFileStr, "$IDFIELD",IDField);
RepPhotographjavaFileStr = StringUtils.replace(RepPhotographjavaFileStr, "$BeanName",BeanName);
FileUtils.writeStringToFile(PhotographjavaFile ,RepPhotographjavaFileStr);
// rename file
File newNamePhotographjavaFile = new File(loginpkgDir+"/support/Photograph/Update"+CTableName+"Photo.java");
PhotographjavaFile.renameTo(newNamePhotographjavaFile);

//****************** END Photograph ****************************************

//Include-Page

File IncludePagenavbodyFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/nav-body.jsp");
String StrIncludePagenavbodyFileBuf = FileUtils.readFileToString(IncludePagenavbodyFile);
String RepIncludePagenavbodyFileStr = StringUtils.replace(StrIncludePagenavbodyFileBuf, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(IncludePagenavbodyFile ,RepIncludePagenavbodyFileStr);

File IncludePagemenubodyFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/menu-body.jsp");
String StrIncludePagemenubodyFileBuf = FileUtils.readFileToString(IncludePagemenubodyFile);
String RepIncludePagemenubodyFileStr = StringUtils.replace(StrIncludePagemenubodyFileBuf, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(IncludePagemenubodyFile ,RepIncludePagemenubodyFileStr);

File IncludePagefooterFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/footer.jsp");
String StrIncludePagefooterFileBuf = FileUtils.readFileToString(IncludePagefooterFile);
String RepIncludePagefooterFileStr = StringUtils.replace(StrIncludePagefooterFileBuf, "$WEBAPP",WebApp);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$BeanPackage",BeanPackage);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$BeanName",BeanName);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$BeanClass",BeanClass);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$LoginClass",LoginClass);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagefooterFileStr = StringUtils.replace(RepIncludePagefooterFileStr, "$IDField",IDField);
FileUtils.writeStringToFile(IncludePagefooterFile ,RepIncludePagefooterFileStr);

//Base

File IncludePagenavbodyBASEFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/base/nav-body-base.jsp");
String StrIncludePagenavbodyBASEFileBuf = FileUtils.readFileToString(IncludePagenavbodyBASEFile);
String RepIncludePagenavbodyBASEFileStr = StringUtils.replace(StrIncludePagenavbodyBASEFileBuf, "$WEBAPP",WebApp);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$BeanPackage",BeanPackage);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$BeanName",BeanName);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$BeanClass",BeanClass);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$LoginClass",LoginClass);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$IDField",IDField);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$LoginFolderName",LoginFolderName);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$CTABLENAME",CTableName);
RepIncludePagenavbodyBASEFileStr = StringUtils.replace(RepIncludePagenavbodyBASEFileStr, "$TABLENAME",TableName);
FileUtils.writeStringToFile(IncludePagenavbodyBASEFile ,RepIncludePagenavbodyBASEFileStr);

File IncludePagemenubodyBASEFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/base/menu-body-base.jsp");
String StrIncludePagemenubodyBASEFileBuf = FileUtils.readFileToString(IncludePagemenubodyBASEFile);
String RepIncludePagemenubodyBASEFileStr = StringUtils.replace(StrIncludePagemenubodyBASEFileBuf, "$WEBAPP",WebApp);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$BeanPackage",BeanPackage);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$BeanName",BeanName);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$BeanClass",BeanClass);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$LoginClass",LoginClass);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagemenubodyBASEFileStr = StringUtils.replace(RepIncludePagemenubodyBASEFileStr, "$IDField",IDField);
FileUtils.writeStringToFile(IncludePagemenubodyBASEFile ,RepIncludePagemenubodyBASEFileStr);


//center

File IncludePagenavbodyCENTERFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/center/nav-body-center.jsp");
String StrIncludePagenavbodyCENTERFileBuf = FileUtils.readFileToString(IncludePagenavbodyCENTERFile);
String RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(StrIncludePagenavbodyCENTERFileBuf, "$WEBAPP",WebApp);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$BeanPackage",BeanPackage);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$BeanName",BeanName);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$BeanClass",BeanClass);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$LoginClass",LoginClass);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$IDField",IDField);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$LoginFolderName",LoginFolderName);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$CTABLENAME",CTableName);
RepIncludePagenavbodyCENTERFileStr = StringUtils.replace(RepIncludePagenavbodyCENTERFileStr, "$TABLENAME",TableName);
FileUtils.writeStringToFile(IncludePagenavbodyCENTERFile ,RepIncludePagenavbodyCENTERFileStr);

File IncludePagemenubodyCENTERFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/center/menu-body-center.jsp");
String StrIncludePagemenubodyCENTERFileBuf = FileUtils.readFileToString(IncludePagemenubodyCENTERFile);
String RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(StrIncludePagemenubodyCENTERFileBuf, "$WEBAPP",WebApp);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$BeanPackage",BeanPackage);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$BeanName",BeanName);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$BeanClass",BeanClass);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$LoginClass",LoginClass);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$IDField",IDField);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$TABLENAME",TableName);
RepIncludePagemenubodyCENTERFileStr = StringUtils.replace(RepIncludePagemenubodyCENTERFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(IncludePagemenubodyCENTERFile ,RepIncludePagemenubodyCENTERFileStr);

//topbar

File IncludePagenavbodyTOPBARFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/topbar/nav-body-topbar.jsp");
String StrIncludePagenavbodyTOPBARFileBuf = FileUtils.readFileToString(IncludePagenavbodyTOPBARFile);
String RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(StrIncludePagenavbodyTOPBARFileBuf, "$WEBAPP",WebApp);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$BeanPackage",BeanPackage);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$BeanName",BeanName);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$BeanClass",BeanClass);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$LoginClass",LoginClass);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$IDField",IDField);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$LoginFolderName",LoginFolderName);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$CTABLENAME",CTableName);
RepIncludePagenavbodyTOPBARFileStr = StringUtils.replace(RepIncludePagenavbodyTOPBARFileStr, "$TABLENAME",TableName);
FileUtils.writeStringToFile(IncludePagenavbodyTOPBARFile ,RepIncludePagenavbodyTOPBARFileStr);

File IncludePagemenubodyTOPBARFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/include-page/assets/topbar/menu-body-topbar.jsp");
String StrIncludePagemenubodyTOPBARFileBuf = FileUtils.readFileToString(IncludePagemenubodyTOPBARFile);
String RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(StrIncludePagemenubodyTOPBARFileBuf, "$WEBAPP",WebApp);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$BeanPackage",BeanPackage);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$BeanName",BeanName);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$BeanClass",BeanClass);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$LoginClass",LoginClass);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$LoginObjectID",LoginObjectID);
RepIncludePagemenubodyTOPBARFileStr = StringUtils.replace(RepIncludePagemenubodyTOPBARFileStr, "$IDField",IDField);
FileUtils.writeStringToFile(IncludePagemenubodyTOPBARFile ,RepIncludePagemenubodyTOPBARFileStr);

//****************** END Include-Page ****************************************

//index.jsp

File indexJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/index.jsp");
String StrindexJSPFileBuf = FileUtils.readFileToString(indexJSPFile);
String RepindexJSPFileStr = StringUtils.replace(StrindexJSPFileBuf, "$WEBAPP",WebApp);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$BeanPackage",BeanPackage);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$BeanName",BeanName);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$BeanClass",BeanClass);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$LoginClass",LoginClass);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$LoginObjectID",LoginObjectID);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$IDField",IDField);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$LoginFolderName",LoginFolderName);
RepindexJSPFileStr = StringUtils.replace(RepindexJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(indexJSPFile ,RepindexJSPFileStr);

//nav_menu.inc

File navmenuINCFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/nav_menu.inc");
String StrnavmenuINCFileBuf = FileUtils.readFileToString(navmenuINCFile);
String RepnavmenuINCFileStr = StringUtils.replace(StrnavmenuINCFileBuf, "$BeanName",BeanName);
FileUtils.writeStringToFile(navmenuINCFile ,RepnavmenuINCFileStr);

//Sidebar.jsp
File sidebarJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/$CTABLENAMESidebar.jsp");
String StrsidebarJSPFileBuf = FileUtils.readFileToString(sidebarJSPFile);
String RepsidebarJSPFileStr = StringUtils.replace(StrsidebarJSPFileBuf, "$WEBAPP",WebApp);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$BeanPackage",BeanPackage);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$BeanName",BeanName);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$BeanClass",BeanClass);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$LoginClass",LoginClass);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$LoginObjectID",LoginObjectID);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$IDField",IDField);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$LoginFolderName",LoginFolderName);
RepsidebarJSPFileStr = StringUtils.replace(RepsidebarJSPFileStr, "$TABLENAME",TableName);
FileUtils.writeStringToFile(sidebarJSPFile ,RepsidebarJSPFileStr);
// rename file
File newNamesidebarJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/"+CTableName+"Sidebar.jsp");
sidebarJSPFile.renameTo(newNamesidebarJSPFile);


//Profile.jsp

File ProfileJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/$CTABLENAMEProfile.jsp");
String StrProfileJSPFileBuf = FileUtils.readFileToString(ProfileJSPFile);
String RepProfileJSPFileStr = StringUtils.replace(StrProfileJSPFileBuf, "$WEBAPP",WebApp);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$BeanPackage",BeanPackage);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$BeanName",BeanName);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$BeanClass",BeanClass);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$LoginClass",LoginClass);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$LoginObjectID",LoginObjectID);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$IDField",IDField);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$LoginFolderName",LoginFolderName);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$TABLENAME",TableName);
RepProfileJSPFileStr = StringUtils.replace(RepProfileJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(ProfileJSPFile ,RepProfileJSPFileStr);
// rename file
File newNameProfileJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/"+CTableName+"Profile.jsp");
ProfileJSPFile.renameTo(newNameProfileJSPFile);



//setregularpassword.jsp
File setregularpasswordJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/setregularpassword.jsp");
String StrsetregularpasswordJSPFileBuf = FileUtils.readFileToString(setregularpasswordJSPFile);
String RepsetregularpasswordJSPFileStr = StringUtils.replace(StrsetregularpasswordJSPFileBuf, "$WEBAPP",WebApp);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$BeanPackage",BeanPackage);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$BeanName",BeanName);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$BeanClass",BeanClass);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$LoginClass",LoginClass);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$LoginObjectID",LoginObjectID);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$IDField",IDField);
RepsetregularpasswordJSPFileStr = StringUtils.replace(RepsetregularpasswordJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(setregularpasswordJSPFile ,RepsetregularpasswordJSPFileStr);

//changepassword.jsp

File changepasswordJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/changepassword.jsp");
String StrchangepasswordJSPFileBuf = FileUtils.readFileToString(changepasswordJSPFile);
String RepchangepasswordJSPFileStr = StringUtils.replace(StrchangepasswordJSPFileBuf, "$WEBAPP",WebApp);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$BeanPackage",BeanPackage);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$BeanName",BeanName);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$BeanClass",BeanClass);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$LoginClass",LoginClass);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$LoginObjectID",LoginObjectID);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$IDField",IDField);
RepchangepasswordJSPFileStr = StringUtils.replace(RepchangepasswordJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(changepasswordJSPFile ,RepchangepasswordJSPFileStr);

//LogOut.jsp

File logoutJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/$CTABLENAMELogOut.jsp");
String StrlogoutJSPFileBuf = FileUtils.readFileToString(logoutJSPFile);
String ReplogoutJSPFileStr = StringUtils.replace(StrlogoutJSPFileBuf, "$WEBAPP",WebApp);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$BeanPackage",BeanPackage);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$BeanName",BeanName);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$BeanClass",BeanClass);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$LoginClass",LoginClass);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$LoginObjectID",LoginObjectID);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$IDField",IDField);
ReplogoutJSPFileStr = StringUtils.replace(ReplogoutJSPFileStr, "$CTABLENAME",CTableName);
FileUtils.writeStringToFile(logoutJSPFile ,ReplogoutJSPFileStr);
// rename file
File newNamelogoutJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/"+CTableName+"LogOut.jsp");
logoutJSPFile.renameTo(newNamelogoutJSPFile);

//template.jsp

File templateJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/Z-$CTABLENAME-template.jsp");
String StrtemplateJSPFileBuf = FileUtils.readFileToString(templateJSPFile);
String ReptemplateJSPFileStr = StringUtils.replace(StrtemplateJSPFileBuf, "$WEBAPP",WebApp);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$BeanPackage",BeanPackage);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$BeanName",BeanName);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$BeanClass",BeanClass);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$LoginClass",LoginClass);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$LoginObjectID",LoginObjectID);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$IDField",IDField);
ReptemplateJSPFileStr = StringUtils.replace(ReptemplateJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(templateJSPFile ,ReptemplateJSPFileStr);
// rename file
File newNametemplateJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/Z-"+CTableName+"-template.jsp");
templateJSPFile.renameTo(newNametemplateJSPFile);

//webcam folder

//capture.jsp
File captureJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/webcam/$CTABLENAMEcapture.jsp");
String StrcaptureJSPFileBuf = FileUtils.readFileToString(captureJSPFile);
String RepcaptureJSPFileStr = StringUtils.replace(StrcaptureJSPFileBuf, "$WEBAPP",WebApp);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$BeanPackage",BeanPackage);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$BeanName",BeanName);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$BeanClass",BeanClass);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$LoginClass",LoginClass);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$LoginObjectID",LoginObjectID);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$IDField",IDField);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$CTABLENAME",CTableName);
RepcaptureJSPFileStr = StringUtils.replace(RepcaptureJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(captureJSPFile ,RepcaptureJSPFileStr);
// rename file
File newcaptureJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/webcam/"+CTableName+"capture.jsp");
captureJSPFile.renameTo(newcaptureJSPFile);


//upload-image.jsp
File uploadimageJSPFile = new File( loginpkgDir+"/copy-to-$LoginFolderName/webcam/$CTABLENAME-upload-image.jsp");
String StruploadimageJSPFileBuf = FileUtils.readFileToString(uploadimageJSPFile);
String RepuploadimageJSPFileStr = StringUtils.replace(StruploadimageJSPFileBuf, "$WEBAPP",WebApp);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$BeanPackage",BeanPackage);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$BeanName",BeanName);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$BeanClass",BeanClass);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$LoginClass",LoginClass);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$LoginObjectID",LoginObjectID);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$IDField",IDField);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$CTABLENAME",CTableName);
RepuploadimageJSPFileStr = StringUtils.replace(RepuploadimageJSPFileStr, "$LoginFolderName",LoginFolderName);
FileUtils.writeStringToFile(uploadimageJSPFile ,RepuploadimageJSPFileStr);
// rename file
File newuploadimageJSPFile = new File(loginpkgDir+"/copy-to-$LoginFolderName/webcam/"+CTableName+"-upload-image.jsp");
uploadimageJSPFile.renameTo(newuploadimageJSPFile);


File flliginfolder1  = new File(loginpkgDir+"/copy-to-$LoginFolderName");
File flfolder1 = new File(loginpkgDir+"/"+LoginFolderName+" ");
flliginfolder1.renameTo(flfolder1);


BeanwizZipHelper.zipFolder(loginpkgDir, OutputZipFile);

response.sendRedirect(response.encodeRedirectURL(appPath+"/user/login/root/login_pkg_"+TableName+".zip"));
         
%>


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

//superAdmin Folder

File ReplFile_SUPsmgr = new File( WebAppDir+"/admin/superadmin/managesitemanager.jsp");
String StrBuf_SUPsmgr = FileUtils.readFileToString(ReplFile_SUPsmgr);
String RepStr_SUPsmgr = StringUtils.replace(StrBuf_SUPsmgr, "$WEBAPP",AppName);
RepStr_SUPsmgr = StringUtils.replace(RepStr_SUPsmgr, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPsmgr ,RepStr_SUPsmgr);

File ReplFile_SUPsmgrauth = new File( WebAppDir+"/admin/superadmin/managesitemanager_authorization.jsp");
String StrBuf_SUPsmgrauth = FileUtils.readFileToString(ReplFile_SUPsmgrauth);
String RepStr_SUPsmgrauth = StringUtils.replace(StrBuf_SUPsmgrauth, "$WEBAPP",AppName);
RepStr_SUPsmgrauth = StringUtils.replace(RepStr_SUPsmgrauth, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPsmgrauth ,RepStr_SUPsmgrauth);

File ReplFile_SUPaps = new File( WebAppDir+"/admin/superadmin/appSetting.jsp");
String StrBuf_SUPaps = FileUtils.readFileToString(ReplFile_SUPaps);
String RepStr_SUPaps = StringUtils.replace(StrBuf_SUPaps, "$WEBAPP",AppName);
RepStr_SUPaps = StringUtils.replace(RepStr_SUPaps, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPaps ,RepStr_SUPaps);

File ReplFile_SUPaccesslgofsmngr = new File( WebAppDir+"/admin/superadmin/accesslog/accesslogofsitemanager.jsp");
String StrBuf_SUPaccesslgofsmngr = FileUtils.readFileToString(ReplFile_SUPaccesslgofsmngr);
String RepStr_SUPaccesslgofsmngr = StringUtils.replace(StrBuf_SUPaccesslgofsmngr, "$WEBAPP",AppName);
RepStr_SUPaccesslgofsmngr = StringUtils.replace(RepStr_SUPaccesslgofsmngr, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPaccesslgofsmngr ,RepStr_SUPaccesslgofsmngr);

File ReplFile_SUPsmngrsrchPopp = new File( WebAppDir+"/admin/user_searchpopup/searchsitemanager-popup.jsp");
String StrBuf_SUPsmngrsrchPopp = FileUtils.readFileToString(ReplFile_SUPsmngrsrchPopp);
String RepStr_SUPsmngrsrchPopp = StringUtils.replace(StrBuf_SUPsmngrsrchPopp, "$WEBAPP",AppName);
RepStr_SUPsmngrsrchPopp = StringUtils.replace(RepStr_SUPsmngrsrchPopp, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPsmngrsrchPopp ,RepStr_SUPsmngrsrchPopp);

File ReplFile_SUPresetpwsmngr = new File( WebAppDir+"/admin/superadmin/resetpassword/resetpasswordofSitemanager.jsp");
String StrBuf_SUPresetpwsmngr = FileUtils.readFileToString(ReplFile_SUPresetpwsmngr);
String RepStr_SUPresetpwsmngr = StringUtils.replace(StrBuf_SUPresetpwsmngr, "$WEBAPP",AppName);
RepStr_SUPresetpwsmngr = StringUtils.replace(RepStr_SUPresetpwsmngr, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPresetpwsmngr ,RepStr_SUPresetpwsmngr);

File ReplFile_SUPresetpwsmngrPopp = new File( WebAppDir+"/admin/superadmin/resetpassword/resetpasswordofSitemanager-popup.jsp");
String StrBuf_SUPresetpwsmngrPopp = FileUtils.readFileToString(ReplFile_SUPresetpwsmngrPopp);
String RepStr_SUPresetpwsmngrPopp = StringUtils.replace(StrBuf_SUPresetpwsmngrPopp, "$WEBAPP",AppName);
RepStr_SUPresetpwsmngrPopp = StringUtils.replace(RepStr_SUPresetpwsmngrPopp, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPresetpwsmngrPopp ,RepStr_SUPresetpwsmngrPopp);

File ReplFile_SUPdailybackup = new File( WebAppDir+"/admin/superadmin/backup/daily_backup.jsp");
String StrBuf_SUPdailybackup = FileUtils.readFileToString(ReplFile_SUPdailybackup);
String RepStr_SUPdailybackup = StringUtils.replace(StrBuf_SUPdailybackup, "$WEBAPP",AppName);
RepStr_SUPdailybackup = StringUtils.replace(RepStr_SUPdailybackup, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPdailybackup ,RepStr_SUPdailybackup);

File ReplFile_SUPmngdailybcp = new File( WebAppDir+"/admin/superadmin/backup/managedaily_backup.jsp");
String StrBuf_SUPmngdailybcp = FileUtils.readFileToString(ReplFile_SUPmngdailybcp);
String RepStr_SUPmngdailybcp = StringUtils.replace(StrBuf_SUPmngdailybcp, "$WEBAPP",AppName);
RepStr_SUPmngdailybcp = StringUtils.replace(RepStr_SUPmngdailybcp, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPmngdailybcp ,RepStr_SUPmngdailybcp);

File ReplFile_SUPmngmodule = new File( WebAppDir+"/admin/superadmin/module/managemodule.jsp");
String StrBuf_SUPmngmodule = FileUtils.readFileToString(ReplFile_SUPmngmodule);
String RepStr_SUPmngmodule = StringUtils.replace(StrBuf_SUPmngmodule, "$WEBAPP",AppName);
RepStr_SUPmngmodule = StringUtils.replace(RepStr_SUPmngmodule, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPmngmodule ,RepStr_SUPmngmodule);

File ReplFile_SUPmngmoduleact = new File( WebAppDir+"/admin/superadmin/module/managemodule_activity.jsp");
String StrBuf_SUPmngmoduleact = FileUtils.readFileToString(ReplFile_SUPmngmoduleact);
String RepStr_SUPmngmoduleact = StringUtils.replace(StrBuf_SUPmngmoduleact, "$WEBAPP",AppName);
RepStr_SUPmngmoduleact = StringUtils.replace(RepStr_SUPmngmoduleact, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPmngmoduleact ,RepStr_SUPmngmoduleact);

%>
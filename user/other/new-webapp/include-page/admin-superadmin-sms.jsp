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

File ReplFile_SUPSMS_chkconn = new File( WebAppDir+"/admin/superadmin/sms/checkconnection.jsp");
String StrBuf_SUPSMS_chkconn = FileUtils.readFileToString(ReplFile_SUPSMS_chkconn);
String RepStr_SUPSMS_chkconn = StringUtils.replace(StrBuf_SUPSMS_chkconn, "$WEBAPP",AppName);
RepStr_SUPSMS_chkconn = StringUtils.replace(RepStr_SUPSMS_chkconn, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_chkconn ,RepStr_SUPSMS_chkconn);

File ReplFile_SUPSMS_chkbal = new File( WebAppDir+"/admin/superadmin/sms/checksmsbalance.jsp");
String StrBuf_SUPSMS_chkbal = FileUtils.readFileToString(ReplFile_SUPSMS_chkbal);
String RepStr_SUPSMS_chkbal = StringUtils.replace(StrBuf_SUPSMS_chkbal, "$WEBAPP",AppName);
RepStr_SUPSMS_chkbal = StringUtils.replace(RepStr_SUPSMS_chkbal, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_chkbal ,RepStr_SUPSMS_chkbal);

File ReplFile_SUPSMS_expacc = new File( WebAppDir+"/admin/superadmin/sms/exportSMSAccount.jsp");
String StrBuf_SUPSMS_expacc = FileUtils.readFileToString(ReplFile_SUPSMS_expacc);
String RepStr_SUPSMS_expacc = StringUtils.replace(StrBuf_SUPSMS_expacc, "$WEBAPP",AppName);
RepStr_SUPSMS_expacc = StringUtils.replace(RepStr_SUPSMS_expacc, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_expacc ,RepStr_SUPSMS_expacc);

File ReplFile_SUPSMS_impacc = new File( WebAppDir+"/admin/superadmin/sms/importSMSAccount.jsp");
String StrBuf_SUPSMS_impacc = FileUtils.readFileToString(ReplFile_SUPSMS_impacc);
String RepStr_SUPSMS_impacc = StringUtils.replace(StrBuf_SUPSMS_impacc, "$WEBAPP",AppName);
RepStr_SUPSMS_impacc = StringUtils.replace(RepStr_SUPSMS_impacc, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_impacc ,RepStr_SUPSMS_impacc);

File ReplFile_SUPSMS_smstemp = new File( WebAppDir+"/admin/superadmin/sms/managesms_template.jsp");
String StrBuf_SUPSMS_smstemp = FileUtils.readFileToString(ReplFile_SUPSMS_smstemp);
String RepStr_SUPSMS_smstemp = StringUtils.replace(StrBuf_SUPSMS_smstemp, "$WEBAPP",AppName);
RepStr_SUPSMS_smstemp = StringUtils.replace(RepStr_SUPSMS_smstemp, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_smstemp ,RepStr_SUPSMS_smstemp);

File ReplFile_SUPSMS_getway = new File( WebAppDir+"/admin/superadmin/sms/managesmsgatewayaccounts.jsp");
String StrBuf_SUPSMS_getway = FileUtils.readFileToString(ReplFile_SUPSMS_getway);
String RepStr_SUPSMS_getway = StringUtils.replace(StrBuf_SUPSMS_getway, "$WEBAPP",AppName);
RepStr_SUPSMS_getway = StringUtils.replace(RepStr_SUPSMS_getway, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_getway ,RepStr_SUPSMS_getway);

File ReplFile_SUPSMS_prxset = new File( WebAppDir+"/admin/superadmin/sms/proxysetup.jsp");
String StrBuf_SUPSMS_prxset = FileUtils.readFileToString(ReplFile_SUPSMS_prxset);
String RepStr_SUPSMS_prxset = StringUtils.replace(StrBuf_SUPSMS_prxset, "$WEBAPP",AppName);
RepStr_SUPSMS_prxset = StringUtils.replace(RepStr_SUPSMS_prxset, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_prxset ,RepStr_SUPSMS_prxset);

File ReplFile_SUPSMS_qukupd = new File( WebAppDir+"/admin/superadmin/sms/quick-update-ajax.jsp");
String StrBuf_SUPSMS_qukupd = FileUtils.readFileToString(ReplFile_SUPSMS_qukupd);
String RepStr_SUPSMS_qukupd = StringUtils.replace(StrBuf_SUPSMS_qukupd, "$WEBAPP",AppName);
RepStr_SUPSMS_qukupd = StringUtils.replace(RepStr_SUPSMS_qukupd, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_qukupd ,RepStr_SUPSMS_qukupd);

File ReplFile_SUPSMS_rstsms = new File( WebAppDir+"/admin/superadmin/sms/restartsms.jsp");
String StrBuf_SUPSMS_rstsms = FileUtils.readFileToString(ReplFile_SUPSMS_rstsms);
String RepStr_SUPSMS_rstsms = StringUtils.replace(StrBuf_SUPSMS_rstsms, "$WEBAPP",AppName);
RepStr_SUPSMS_rstsms = StringUtils.replace(RepStr_SUPSMS_rstsms, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_rstsms ,RepStr_SUPSMS_rstsms);

File ReplFile_SUPSMS_setest = new File( WebAppDir+"/admin/superadmin/sms/sendtestsms.jsp");
String StrBuf_SUPSMS_setest = FileUtils.readFileToString(ReplFile_SUPSMS_setest);
String RepStr_SUPSMS_setest = StringUtils.replace(StrBuf_SUPSMS_setest, "$WEBAPP",AppName);
RepStr_SUPSMS_setest = StringUtils.replace(RepStr_SUPSMS_setest, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_setest ,RepStr_SUPSMS_setest);

File ReplFile_SUPSMS_appset = new File( WebAppDir+"/admin/superadmin/sms/smsappSetting.jsp");
String StrBuf_SUPSMS_appset = FileUtils.readFileToString(ReplFile_SUPSMS_appset);
String RepStr_SUPSMS_appset = StringUtils.replace(StrBuf_SUPSMS_appset, "$WEBAPP",AppName);
RepStr_SUPSMS_appset = StringUtils.replace(RepStr_SUPSMS_appset, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_appset ,RepStr_SUPSMS_appset);

File ReplFile_SUPSMS_sinlog = new File( WebAppDir+"/admin/superadmin/sms/smslogs/singlesmslog.jsp");
String StrBuf_SUPSMS_sinlog = FileUtils.readFileToString(ReplFile_SUPSMS_sinlog);
String RepStr_SUPSMS_sinlog = StringUtils.replace(StrBuf_SUPSMS_sinlog, "$WEBAPP",AppName);
RepStr_SUPSMS_sinlog = StringUtils.replace(RepStr_SUPSMS_sinlog, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_sinlog ,RepStr_SUPSMS_sinlog);

File ReplFile_SUPSMS_joblog = new File( WebAppDir+"/admin/superadmin/sms/smslogs/smsjoblog.jsp");
String StrBuf_SUPSMS_joblog = FileUtils.readFileToString(ReplFile_SUPSMS_joblog);
String RepStr_SUPSMS_joblog = StringUtils.replace(StrBuf_SUPSMS_joblog, "$WEBAPP",AppName);
RepStr_SUPSMS_joblog = StringUtils.replace(RepStr_SUPSMS_joblog, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_joblog ,RepStr_SUPSMS_joblog);

File ReplFile_SUPSMS_smsjob = new File( WebAppDir+"/admin/superadmin/sms/smslogs/smsjobs.jsp");
String StrBuf_SUPSMS_smsjob = FileUtils.readFileToString(ReplFile_SUPSMS_smsjob);
String RepStr_SUPSMS_smsjob = StringUtils.replace(StrBuf_SUPSMS_smsjob, "$WEBAPP",AppName);
RepStr_SUPSMS_smsjob = StringUtils.replace(RepStr_SUPSMS_smsjob, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPSMS_smsjob ,RepStr_SUPSMS_smsjob);

%>
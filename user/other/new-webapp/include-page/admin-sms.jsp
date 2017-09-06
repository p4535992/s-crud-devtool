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

File ReplFile_ADSMS_chkbal = new File( WebAppDir+"/admin/sms/chkbalancejson.jsp");
String StrBuf_ADSMS_chkbal = FileUtils.readFileToString(ReplFile_ADSMS_chkbal);
String RepStr_ADSMS_chkbal = StringUtils.replace(StrBuf_ADSMS_chkbal, "$WEBAPP",AppName);
RepStr_ADSMS_chkbal = StringUtils.replace(RepStr_ADSMS_chkbal, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_chkbal ,RepStr_ADSMS_chkbal);

File ReplFile_ADSMS_quksms = new File( WebAppDir+"/admin/sms/quicksms.jsp");
String StrBuf_ADSMS_quksms = FileUtils.readFileToString(ReplFile_ADSMS_quksms);
String RepStr_ADSMS_quksms = StringUtils.replace(StrBuf_ADSMS_quksms, "$WEBAPP",AppName);
RepStr_ADSMS_quksms = StringUtils.replace(RepStr_ADSMS_quksms, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_quksms ,RepStr_ADSMS_quksms);

File ReplFile_ADSMS_snglpo = new File( WebAppDir+"/admin/sms/singlesms-POPUP.jsp");
String StrBuf_ADSMS_snglpo = FileUtils.readFileToString(ReplFile_ADSMS_snglpo);
String RepStr_ADSMS_snglpo = StringUtils.replace(StrBuf_ADSMS_snglpo, "$WEBAPP",AppName);
RepStr_ADSMS_snglpo = StringUtils.replace(RepStr_ADSMS_snglpo, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_snglpo ,RepStr_ADSMS_snglpo);

File ReplFile_ADSMS_smsexl = new File( WebAppDir+"/admin/sms/smsfromexcel.jsp");
String StrBuf_ADSMS_smsexl = FileUtils.readFileToString(ReplFile_ADSMS_smsexl);
String RepStr_ADSMS_smsexl = StringUtils.replace(StrBuf_ADSMS_smsexl, "$WEBAPP",AppName);
RepStr_ADSMS_smsexl = StringUtils.replace(RepStr_ADSMS_smsexl, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_smsexl ,RepStr_ADSMS_smsexl);

File ReplFile_ADSMS_blksms = new File( WebAppDir+"/admin/sms/bulksms-POPUP.jsp");
String StrBuf_ADSMS_blksms = FileUtils.readFileToString(ReplFile_ADSMS_blksms);
String RepStr_ADSMS_blksms = StringUtils.replace(StrBuf_ADSMS_blksms, "$WEBAPP",AppName);
RepStr_ADSMS_blksms = StringUtils.replace(RepStr_ADSMS_blksms, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_blksms ,RepStr_ADSMS_blksms);

File ReplFile_ADSMS_blksmsRslt = new File( WebAppDir+"/admin/sms/bulksmsResult-POPUP.jsp");
String StrBuf_ADSMS_blksmsRslt = FileUtils.readFileToString(ReplFile_ADSMS_blksmsRslt);
String RepStr_ADSMS_blksmsRslt = StringUtils.replace(StrBuf_ADSMS_blksmsRslt, "$WEBAPP",AppName);
RepStr_ADSMS_blksmsRslt = StringUtils.replace(RepStr_ADSMS_blksmsRslt, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_ADSMS_blksmsRslt ,RepStr_ADSMS_blksmsRslt);

%>
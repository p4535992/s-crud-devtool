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

//include File
File ReplFile_meta_tag = new File( WebAppDir+"/include-page/common/meta-tag.jsp");
String StrBuf_meta_tag = FileUtils.readFileToString(ReplFile_meta_tag);
String RepStr_meta_tag = StringUtils.replace(StrBuf_meta_tag, "$WEBAPP",AppName);
// RepStr_meta_tag = StringUtils.replace(RepStr_meta_tag, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_meta_tag ,RepStr_meta_tag);

File ReplFile_footer_page = new File( WebAppDir+"/include-page/common/footer.jsp");
String StrBuf_footer_page = FileUtils.readFileToString(ReplFile_footer_page);
String RepStr_footer_page = StringUtils.replace(StrBuf_footer_page, "$WEBAPP",AppName);
// RepStr_footer_page = StringUtils.replace(RepStr_footer_page, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_footer_page ,RepStr_footer_page);

File ReplFile_main_js = new File( WebAppDir+"/include-page/js/main-js.jsp");
String StrBuf_main_js = FileUtils.readFileToString(ReplFile_main_js);
String RepStr_main_js = StringUtils.replace(StrBuf_main_js, "$WEBAPP",AppName);
// RepStr_main_js = StringUtils.replace(RepStr_main_js, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_main_js ,RepStr_main_js);

//include-page :- Master

File ReplFile_mail_sms_inc = new File( WebAppDir+"/include-page/master/mail-sms-check.inc");
String StrBuf_mail_sms_inc = FileUtils.readFileToString(ReplFile_mail_sms_inc);
String RepStr_mail_sms_inc = StringUtils.replace(StrBuf_mail_sms_inc, "$WEBAPP",AppName);
RepStr_mail_sms_inc = StringUtils.replace(RepStr_mail_sms_inc, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_mail_sms_inc ,RepStr_mail_sms_inc);

File ReplFile_get_list_items = new File( WebAppDir+"/include-page/master/getlistitems.jsp");
String StrBuf_get_list_items = FileUtils.readFileToString(ReplFile_get_list_items);
String RepStr_get_list_items = StringUtils.replace(StrBuf_get_list_items, "$WEBAPP",AppName);
RepStr_get_list_items = StringUtils.replace(RepStr_get_list_items, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_get_list_items ,RepStr_get_list_items);

File ReplFile_autocomplete_list = new File( WebAppDir+"/include-page/master/autocomplete-list.jsp");
String StrBuf_autocomplete_list = FileUtils.readFileToString(ReplFile_autocomplete_list);
String RepStr_autocomplete_list = StringUtils.replace(StrBuf_autocomplete_list, "$WEBAPP",AppName);
//RepStr_autocomplete_list = StringUtils.replace(RepStr_autocomplete_list, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_autocomplete_list ,RepStr_autocomplete_list);

File ReplFile_autocomplete_words = new File( WebAppDir+"/include-page/master/autocomplete-words.jsp");
String StrBuf_autocomplete_words = FileUtils.readFileToString(ReplFile_autocomplete_words);
String RepStr_autocomplete_words = StringUtils.replace(StrBuf_autocomplete_words, "$WEBAPP",AppName);
//RepStr_autocomplete_words = StringUtils.replace(RepStr_autocomplete_words, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_autocomplete_words ,RepStr_autocomplete_words);

File ReplFile_MAgetstate = new File( WebAppDir+"/include-page/master/getstate.jsp");
String StrBuf_MAgetstate = FileUtils.readFileToString(ReplFile_MAgetstate);
String RepStr_MAgetstate = StringUtils.replace(StrBuf_MAgetstate, "$WEBAPP",AppName);
RepStr_MAgetstate = StringUtils.replace(RepStr_MAgetstate, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_MAgetstate ,RepStr_MAgetstate);

File ReplFile_MAmnthdetlist = new File( WebAppDir+"/include-page/master/month-date-list.jsp");
String StrBuf_MAmnthdetlist = FileUtils.readFileToString(ReplFile_MAmnthdetlist);
String RepStr_MAmnthdetlist = StringUtils.replace(StrBuf_MAmnthdetlist, "$WEBAPP",AppName);
RepStr_MAmnthdetlist = StringUtils.replace(RepStr_MAmnthdetlist, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_MAmnthdetlist ,RepStr_MAmnthdetlist);


//include-page :- ajaxpage

File ReplFile_SUPadajaxuservalid = new File( WebAppDir+"/include-page/ajaxpage/admin-user-validation.jsp");
String StrBuf_SUPadajaxuservalid = FileUtils.readFileToString(ReplFile_SUPadajaxuservalid);
String RepStr_SUPadajaxuservalid = StringUtils.replace(StrBuf_SUPadajaxuservalid, "$WEBAPP",AppName);
RepStr_SUPadajaxuservalid = StringUtils.replace(RepStr_SUPadajaxuservalid, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_SUPadajaxuservalid ,RepStr_SUPadajaxuservalid);

File ReplFile_AJAXgetcity = new File( WebAppDir+"/include-page/ajaxpage/getcity.jsp");
String StrBuf_AJAXgetcity = FileUtils.readFileToString(ReplFile_AJAXgetcity);
String RepStr_AJAXgetcity = StringUtils.replace(StrBuf_AJAXgetcity, "$WEBAPP",AppName);
RepStr_AJAXgetcity = StringUtils.replace(RepStr_AJAXgetcity, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_AJAXgetcity ,RepStr_AJAXgetcity);

File ReplFile_AJAXgetexecuter = new File( WebAppDir+"/include-page/ajaxpage/get_Executor.jsp");
String StrBuf_AJAXgetexecuter = FileUtils.readFileToString(ReplFile_AJAXgetexecuter);
String RepStr_AJAXgetexecuter = StringUtils.replace(StrBuf_AJAXgetexecuter, "$WEBAPP",AppName);
RepStr_AJAXgetexecuter = StringUtils.replace(RepStr_AJAXgetexecuter, "$DATABASE",Database);
FileUtils.writeStringToFile(ReplFile_AJAXgetexecuter ,RepStr_AJAXgetexecuter);
%>
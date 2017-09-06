<%
String  sms_ds = application.getInitParameter("WEBSMS-DATASOURCE");
if( sms_ds ==null )   sms_ds ="jdbc/$DATABASE" ; // Assume defualt value if not set

String  mail_ds = application.getInitParameter("MAIL-DATASOURCE");
if( mail_ds ==null )   mail_ds ="jdbc/$DATABASE" ; // Assume defualt value if not set 
 
MailSetting SetMail = new MailSetting(application); 
boolean bMail = SetMail.getServiceStatus(); 

SMSSetting SetSms = new SMSSetting(application); 
boolean bSMS = SetSms.getServiceStatus();
%>
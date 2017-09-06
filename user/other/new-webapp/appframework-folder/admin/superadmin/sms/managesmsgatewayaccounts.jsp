<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="Sms_GtWysBn" scope="page" class="com.db.$DATABASE.Sms_gatewayaccountsBean" />
<jsp:useBean id="SmHanBn" scope="page" class="com.db.$DATABASE.Sms_handlerBean" />
<%! 
boolean CheckDuplicateEntry(com.db.$DATABASE.Sms_gatewayaccountsBean dbBean )
{
 /* 
   Enable this in case you do not want duplicate entried.
   Just set appropriate SQL WHERE condition, to avoid creating duplicate
	 entries in add or update
 	    
 try
 {
  return  ( dbBean.recordCount(" WHERE ? ")> 0) ? false : true ;
 }  catch( java.sql.SQLException exSQL ) {  return false ; }
 */
 return true ; // remove this line to enable

}
boolean CheckHandlerClass(String clsname)
{
   boolean bValid = false;
	 try
	 {
	     if(clsname!=null && clsname.length()> 0)
	     {
	           com.$WEBAPP.appsms.CustomSMSHandler handler = (com.$WEBAPP.appsms.CustomSMSHandler)Class.forName(clsname).newInstance();
		         if(handler!=null && handler instanceof CustomSMSHandler)
		         {
		            bValid = true;
		         }
	    }
	
	}catch(Exception e)
	{
	
	}
	return bValid ;
}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);


final int Sms_GtWysBn_AccountID = 0, Sms_GtWysBn_Title = 1, Sms_GtWysBn_AccountType = 2, Sms_GtWysBn_StartDate = 3, Sms_GtWysBn_EndDate = 4, Sms_GtWysBn_ProviderName = 5, Sms_GtWysBn_Website = 6, Sms_GtWysBn_ContactPerson = 7, Sms_GtWysBn_HelpNumbers = 8, Sms_GtWysBn_UserID = 9, Sms_GtWysBn_Password = 10, Sms_GtWysBn_BalanceCheckURL = 11, Sms_GtWysBn_BalanceCheckFormat = 12, Sms_GtWysBn_BalanceCheckUserIDParam = 13, Sms_GtWysBn_BalanceCheckPasswordParam = 14, Sms_GtWysBn_BalanceCheckOtherParam = 15, Sms_GtWysBn_BalanceCheckOtherValue = 16, Sms_GtWysBn_PingURL = 17, Sms_GtWysBn_PingResponse = 18, Sms_GtWysBn_SMSSendURL = 19, Sms_GtWysBn_SMSSendResponse = 20, Sms_GtWysBn_BatchSize = 21, Sms_GtWysBn_NumberDelimiter = 22, Sms_GtWysBn_ResponseDelimiter = 23, Sms_GtWysBn_MobileNumberParam = 24, Sms_GtWysBn_SMSTextParam = 25, Sms_GtWysBn_SendSMSUserIDParam = 26, Sms_GtWysBn_SendSMSPasswordParam = 27, Sms_GtWysBn_SenderIDParam = 28, Sms_GtWysBn_SenderIDValue = 29, Sms_GtWysBn_OtherParam1 = 30, Sms_GtWysBn_OtherValue1 = 31, Sms_GtWysBn_OtherParam2 = 32, Sms_GtWysBn_OtherValue2 = 33, Sms_GtWysBn_LastSMSBalance = 34, Sms_GtWysBn_BalanceCheckTime = 35 ;

String FieldLabel[] = {"AccountID", "Title", "Account Type", "Start Date", "End Date", 
                       "Provider Name", "Website", "Contact Person", "Help Numbers", "UserID", 
                       "Password", "Balance Check URL", "Balance Check Format", "Balance Check UserIDParam", "Balance Check PasswordParam", 
                       "Balance Check OtherParam", "Balance Check OtherValue", "Ping URL", "Ping Response", "SMS SendURL", 
                       "SMS Send Response", "Batch Size", "Number Delimiter", "Response Delimiter", "Mobile NumberParam", 
                       "SMS TextParam", "Send SMS UserIDParam", "Send SMS PasswordParam", "Sender IDParam", "Sender IDValue", 
                       "Other Param1", "Other Value1", "Other Param2", "Other Value2", "Last SMS Balance", 
                       "Balance CheckTime"} ;

   final int DEFAULT = 0 ;
   final int SEARCH_RESULT = 1;
   final int SHOW_RECORD = 2 ;
   final int NEW_FORM = 3 ;
   final int CHANGE_FORM = 4 ;
   final int ADD_RECORD = 5 ;
   final int UPDATE_RECORD = 6;
   final int DELETE_RECORD = 7 ;
   final int PROCESS_CHECKED= 8;

final String DEFAULT_ACTION ="Action=Default";
appMakeQueryString qStr =  null ;

int  default_cmd = DEFAULT ;
int nAction = DEFAULT ;
String DelWarning = "" ;
String PageTitle = null ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction = "Search" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
    else if (ParamAction.equalsIgnoreCase("New")) nAction = NEW_FORM ;
    else if (ParamAction.equalsIgnoreCase("Change")) nAction = CHANGE_FORM ;
    else if (ParamAction.equalsIgnoreCase("Add")) nAction = ADD_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Update")) nAction = UPDATE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Delete")) nAction = DELETE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("ProcessChecked")) nAction = PROCESS_CHECKED ;
}

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = false ;
boolean bAllowUpdate = false ;
boolean bAllowDelete = false;
%>
<%@include file="/admin/authorization.inc"%>
<%
//override Action authorization
bAllowDelete = true ;
bAllowUpdate = true ;
bAllowAdd = true ;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = false;

default_cmd = SEARCH_RESULT ;
if(nAction==DEFAULT) nAction = default_cmd ;

// ID field is Integer ( number ) type
int nAccountID = 0;
try
{
   nAccountID = Integer.parseInt(request.getParameter("AccountID"));
}
catch(NumberFormatException ex)
{ 
   nAccountID = 0;
}
Sms_GtWysBn.locateRecord(nAccountID);

if(nAction==ADD_RECORD)
{

     Sms_GtWysBn.AccountID= 0;

/* Auto increment column: 
     try  
      {
           Sms_GtWysBn.AccountID = Integer.parseInt(request.getParameter("AccountID")) ;
      } catch( NumberFormatException ex)
     { 
         Sms_GtWysBn.AccountID = 0 ;
     }
*/
     Sms_GtWysBn.Title = request.getParameter("Title");
    try 
     { 
          Sms_GtWysBn.AccountType = Short.parseShort(request.getParameter("AccountType")) ;
    } catch( NumberFormatException ex)
     {     
         Sms_GtWysBn.AccountType = 0 ;
    }
      Sms_GtWysBn.StartDate = DateTimeHelper.requestDatePicker( request, "StartDate" );
      Sms_GtWysBn.EndDate = DateTimeHelper.requestDatePicker( request, "EndDate" );
     Sms_GtWysBn.ProviderName = request.getParameter("ProviderName");
     Sms_GtWysBn.Website = request.getParameter("Website");
     Sms_GtWysBn.ContactPerson = request.getParameter("ContactPerson");
     Sms_GtWysBn.HelpNumbers = request.getParameter("HelpNumbers");
     Sms_GtWysBn.UserID = request.getParameter("UserID");
     Sms_GtWysBn.Password = request.getParameter("Password");
     Sms_GtWysBn.BalanceCheckURL = request.getParameter("BalanceCheckURL");
     Sms_GtWysBn.BalanceCheckFormat = request.getParameter("BalanceCheckFormat");
     Sms_GtWysBn.BalanceCheckUserIDParam = request.getParameter("BalanceCheckUserIDParam");
     Sms_GtWysBn.BalanceCheckPasswordParam = request.getParameter("BalanceCheckPasswordParam");
     Sms_GtWysBn.BalanceCheckOtherParam = request.getParameter("BalanceCheckOtherParam");
     Sms_GtWysBn.BalanceCheckOtherValue = request.getParameter("BalanceCheckOtherValue");
     Sms_GtWysBn.PingURL = request.getParameter("PingURL");
     Sms_GtWysBn.PingResponse = request.getParameter("PingResponse");
     Sms_GtWysBn.SMSSendURL = request.getParameter("SMSSendURL");
     Sms_GtWysBn.SMSSendResponse = request.getParameter("SMSSendResponse");
    try 
     { 
          Sms_GtWysBn.BatchSize = Short.parseShort(request.getParameter("BatchSize")) ;
    } catch( NumberFormatException ex)
     {     
         Sms_GtWysBn.BatchSize = 0 ;
    }
     Sms_GtWysBn.NumberDelimiter = request.getParameter("NumberDelimiter");
     Sms_GtWysBn.ResponseDelimiter = request.getParameter("ResponseDelimiter");
     Sms_GtWysBn.MobileNumberParam = request.getParameter("MobileNumberParam");
     Sms_GtWysBn.SMSTextParam = request.getParameter("SMSTextParam");
     Sms_GtWysBn.SendSMSUserIDParam = request.getParameter("SendSMSUserIDParam");
     Sms_GtWysBn.SendSMSPasswordParam = request.getParameter("SendSMSPasswordParam");
     Sms_GtWysBn.SenderIDParam = request.getParameter("SenderIDParam");
     Sms_GtWysBn.SenderIDValue = request.getParameter("SenderIDValue");
     Sms_GtWysBn.OtherParam1 = request.getParameter("OtherParam1");
     Sms_GtWysBn.OtherValue1 = request.getParameter("OtherValue1");
     Sms_GtWysBn.OtherParam2 = request.getParameter("OtherParam2");
     Sms_GtWysBn.OtherValue2 = request.getParameter("OtherValue2");
		 Sms_GtWysBn.LastSMSBalance = 0 ;
    Sms_GtWysBn.BalanceCheckTime = null ; 
    Sms_GtWysBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( Sms_GtWysBn ))
        {
           Sms_GtWysBn.addRecord();
           MessageText = "One record added. New ID = "+Sms_GtWysBn._autonumber ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "<span class=\"error\">Duplicate Entry Found!</span><br>No new record created." ;
        }
    }
		else
		{
		     MessageText="Record addition not permitted."; 
		} // if( bAllowAdd == true )

     // Revert nAction to default value
	  nAction=default_cmd ;

} // End if (nAction==ADD_RECORD )

if(nAction==UPDATE_RECORD )
{
         Sms_GtWysBn.locateRecord(nAccountID);
    //  $CHECK Sms_GtWysBn.AccountID= nAccountID ;
    /* Auto increment column: 
     try  
      {
           Sms_GtWysBn.AccountID = Integer.parseInt(request.getParameter("AccountID")) ;
      } catch( NumberFormatException ex)
     { 
         Sms_GtWysBn.AccountID = 0 ;
     }
*/
     Sms_GtWysBn.Title = request.getParameter("Title");
    try 
     { 
          Sms_GtWysBn.AccountType = Short.parseShort(request.getParameter("AccountType")) ;
    } catch( NumberFormatException ex)
     {     
         Sms_GtWysBn.AccountType = 0 ;
    }
      Sms_GtWysBn.StartDate = DateTimeHelper.requestDatePicker( request, "StartDate" );
      Sms_GtWysBn.EndDate = DateTimeHelper.requestDatePicker( request, "EndDate" );
     Sms_GtWysBn.ProviderName = request.getParameter("ProviderName");
     Sms_GtWysBn.Website = request.getParameter("Website");
     Sms_GtWysBn.ContactPerson = request.getParameter("ContactPerson");
     Sms_GtWysBn.HelpNumbers = request.getParameter("HelpNumbers");
     Sms_GtWysBn.UserID = request.getParameter("UserID");
     Sms_GtWysBn.Password = request.getParameter("Password");
     Sms_GtWysBn.BalanceCheckURL = request.getParameter("BalanceCheckURL");
     Sms_GtWysBn.BalanceCheckFormat = request.getParameter("BalanceCheckFormat");
     Sms_GtWysBn.BalanceCheckUserIDParam = request.getParameter("BalanceCheckUserIDParam");
     Sms_GtWysBn.BalanceCheckPasswordParam = request.getParameter("BalanceCheckPasswordParam");
     Sms_GtWysBn.BalanceCheckOtherParam = request.getParameter("BalanceCheckOtherParam");
     Sms_GtWysBn.BalanceCheckOtherValue = request.getParameter("BalanceCheckOtherValue");
     Sms_GtWysBn.PingURL = request.getParameter("PingURL");
     Sms_GtWysBn.PingResponse = request.getParameter("PingResponse");
     Sms_GtWysBn.SMSSendURL = request.getParameter("SMSSendURL");
     Sms_GtWysBn.SMSSendResponse = request.getParameter("SMSSendResponse");
    try 
     { 
          Sms_GtWysBn.BatchSize = Short.parseShort(request.getParameter("BatchSize")) ;
    } catch( NumberFormatException ex)
     {     
         Sms_GtWysBn.BatchSize = 0 ;
    }
     Sms_GtWysBn.NumberDelimiter = request.getParameter("NumberDelimiter");
     Sms_GtWysBn.ResponseDelimiter = request.getParameter("ResponseDelimiter");
     Sms_GtWysBn.MobileNumberParam = request.getParameter("MobileNumberParam");
     Sms_GtWysBn.SMSTextParam = request.getParameter("SMSTextParam");
     Sms_GtWysBn.SendSMSUserIDParam = request.getParameter("SendSMSUserIDParam");
     Sms_GtWysBn.SendSMSPasswordParam = request.getParameter("SendSMSPasswordParam");
     Sms_GtWysBn.SenderIDParam = request.getParameter("SenderIDParam");
     Sms_GtWysBn.SenderIDValue = request.getParameter("SenderIDValue");
     Sms_GtWysBn.OtherParam1 = request.getParameter("OtherParam1");
     Sms_GtWysBn.OtherValue1 = request.getParameter("OtherValue1");
     Sms_GtWysBn.OtherParam2 = request.getParameter("OtherParam2");
     Sms_GtWysBn.OtherValue2 = request.getParameter("OtherValue2");
		 /*
     try  
      {
           Sms_GtWysBn.LastSMSBalance = Integer.parseInt(request.getParameter("LastSMSBalance")) ;
      } catch( NumberFormatException ex)
     { 
         Sms_GtWysBn.LastSMSBalance = 0 ;
     }
    Sms_GtWysBn.BalanceCheckTime = new java.sql.Timestamp(System.currentTimeMillis()); // DateTimeHelper.requestDateTimePicker( request, "BalanceCheckTime" ) ; 
    */
		Sms_GtWysBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());
   
	  if(bAllowUpdate == true)
		{
	      Sms_GtWysBn.updateRecord(nAccountID);
        MessageText = "One record updated. Updated ID = "+nAccountID ;
		}
		else
		{
		    MessageText="Record update not permitted."; 
		}		
    // Revert nAction to default value
    nAction=default_cmd ;
		
}  // End if (nAction==UPDATE_RECORD)

if(nAction==DELETE_RECORD )
{
    // Get more information about record to deleted (optional) .
    Sms_GtWysBn.locateRecord(nAccountID);
    // $CHECK
		if(bAllowDelete == true)
		{
       Sms_GtWysBn.deleteRecord(nAccountID);
		    MessageText = "Record Deleted. ID = "+nAccountID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nAccountID ;
        // Sms_GtWysBn.executeUpdate(DelRef);	
		}
		else
    {
         MessageText="Record deletion not permitted."; 
	       nAction=default_cmd ;
    }
      // Revert nAction to default value
      nAction=default_cmd ;
}  // End  if(nAction==DELETE_RECORD )





 if(nAction == PROCESS_CHECKED)
 {
    qStr  = new appMakeQueryString( request, application );
		//  qStr  = new com.$WEBAPP.MakeQueryString( request, "MYSQL" );
	  qStr.addMultiSelectParam(Sms_GtWysBn._tablename, "AccountID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("AccountID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `sms_gatewayaccounts` "+ WhrCls + " ORDER BY `sms_gatewayaccounts`.`AccountID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   Sms_GtWysBn.openTable(WhrCls, " ORDER BY `AccountID` ");
           while(Sms_GtWysBn.nextRow())
           {
					   
           }
					 Sms_GtWysBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = Sms_GtWysBn.executeUpdate( qStr.SQL( "DELETE FROM `sms_gatewayaccounts` "+WhrCls+" ") );
				 MessageText = " ( "+del_cnt+" ) records are deleted." ;
				}
				else
				{
				  MessageText = "Record deletion not permitted." ;
				}
		}
		
		if("Activity".equalsIgnoreCase(CheckedAction) && chk_count > 0 )
		{
		      String WhereParam  = RequestHelper.encodeBase64( WhrCls.getBytes()) ;
          String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
          String redirect  = "sms_gatewayaccounts-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
          response.sendRedirect(response.encodeRedirectURL(redirect)); 
		}

		/* 
		  // Forwared Base64 encoded sql to other page if relevent
		   String SQLPARAM = new String( com.webapp.base64.UrlBase64.encode(ChkQuery.getBytes() ) );
       String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile ).getBytes() ) );
       String redirect  = appPath+"/$PATH.jsp?Count="+chk_count+"&SQL="+SQLPARAM+"&ReturnPath="+ReturnPath; //  &Target=Target&MobileField=Mobile&EmailField=Email  
       response.sendRedirect(response.encodeRedirectURL(redirect)); 
		
		*/
     nAction=default_cmd ;
 }

 if(ParamAction.equalsIgnoreCase("UpdateHander"))
 {
	 String HandlerClass = request.getParameter("HandlerClass");

      	  if(CheckHandlerClass(HandlerClass) )
      		{
        			 if(SmHanBn.locateRecord(nAccountID) )
      			   {
      			  // Update
      			   SmHanBn.HandlerClass = HandlerClass ;
      				 SmHanBn.updateRecord(nAccountID);
      			   }
      			   else
      			   {
      			    // Create
      				  SmHanBn.AccountID = nAccountID;
      				  SmHanBn.HandlerClass = HandlerClass ;
      			    SmHanBn.addRecord();
      			   }
      		     MessageText = "Custom SMS Handler Updated.";
      		 }
      		 else
      		 { 
      		    MessageText = "Handler Class Name:"+HandlerClass+" is INVALID ";
      	   }
   nAction=SHOW_RECORD;
 }
 
 if(ParamAction.equalsIgnoreCase("RemoveHander"))
 {
	 SmHanBn.deleteRecord(nAccountID);
	 MessageText = "Custom SMS Handler Removed.";

   nAction=SHOW_RECORD;
 }
 

 

// Redirect if not authorized for add or update activity.

if(nAction==NEW_FORM && bAllowAdd==false)
{
   MessageText="Record addition is not permitted.";
   java.lang.StringBuffer rdAdd = request.getRequestURL();
   rdAdd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdAdd.toString()));
}
if(nAction==CHANGE_FORM && bAllowUpdate==false)
{
   MessageText="Record update is not permitted.";
   java.lang.StringBuffer rdUpd = request.getRequestURL();
   rdUpd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdUpd.toString()));
}




// Set the correct page title according to Action Flag
if(nAction==NEW_FORM)  PageTitle="<i class='fa fa-plus iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Add Record";
else if (nAction==CHANGE_FORM) PageTitle="<i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Update Record" ;
else if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;List Of Records" ;
else if(nAction==SHOW_RECORD) PageTitle= "<i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Record Detail " ;
else PageTitle="" ;

boolean bRetPath=false;
String ReturnPath = "";
String ReturnPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{	 bRetPath=true;

   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
}
else  // Default return path
{
   ReturnPath = appPath+"/admin/index.jsp" ;
}
        com.$WEBAPP.appsms.SMSSetting si = new com.$WEBAPP.appsms.SMSSetting(application);
        int sms_charater_limit =0;
        try
        {
            sms_charater_limit = Integer.parseInt(si.getValue("SMS-CHARACTER-LIMIT"));
        }
        catch(NumberFormatException ex)
        {
            sms_charater_limit = 0;
        }
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>SMS Gateway Accounts</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  <jsp:include page ="/include-page/css/bootstrap-datepicker-css.jsp" flush="true" />
  	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>

<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >


  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
		 <jsp:param name="MenuTitle" value="SuperAdmin" />
  </jsp:include>

  <jsp:include page ="/admin/include-page/menu-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
	 	 <jsp:param name="MenuTitle" value="???" />
	 	 <jsp:param name="MenuLink" value="???" />
  </jsp:include>
	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>SMS Gateway Account</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Gateway Account</li>
          </ol>			
  	    </div>
  		</div>	

<% if(nAction==NEW_FORM)
{
%>			
<form action="<%=thisFile %>" method="POST" name="sms_gatewayaccounts_Add" id="sms_gatewayaccounts_Add" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Add" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Basic A/c Profile</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row">
    <div class="form-group col-sm-6">
	     <label for="Title" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Title] %></label>
       <input type="text" name="Title" id="Title" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="AccountType" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_AccountType] %></label>
       <input type="text" name="AccountType" id="AccountType" class="form-control"  />
	  </div>
</div>
<div class="row" >

	  <div class="form-group col-sm-6">
	  <label for="StartDate" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_StartDate] %></label>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="StartDate" id="StartDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span>
			</div>	
	 </div>

	  <div class="form-group col-sm-6">
	  <label for="EndDate" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_EndDate] %></label>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="EndDate" id="EndDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span>
			</div>	
	 </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="ProviderName" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ProviderName] %></label>
       <input type="text" name="ProviderName" id="ProviderName" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Website" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Website] %></label>
       <input type="text" name="Website" id="Website" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="ContactPerson" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ContactPerson] %></label>
       <input type="text" name="ContactPerson" id="ContactPerson" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="HelpNumbers" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_HelpNumbers] %></label>
       <input type="text" name="HelpNumbers" id="HelpNumbers" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="UserID" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_UserID] %></label>
       <input type="text" name="UserID" id="UserID" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Password" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Password] %></label>
       <input type="text" name="Password" id="Password" class="form-control"  />
	  </div>
</div>

</div>
</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Balance Check</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckURL] %></label>
       <input type="text" name="BalanceCheckURL" id="BalanceCheckURL" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckFormat" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckFormat] %></label>
       <input type="text" name="BalanceCheckFormat" id="BalanceCheckFormat" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckUserIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckUserIDParam] %></label>
       <input type="text" name="BalanceCheckUserIDParam" id="BalanceCheckUserIDParam" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckPasswordParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckPasswordParam] %></label>
       <input type="text" name="BalanceCheckPasswordParam" id="BalanceCheckPasswordParam" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckOtherParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherParam] %></label>
       <input type="text" name="BalanceCheckOtherParam" id="BalanceCheckOtherParam" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckOtherValue" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherValue] %></label>
       <input type="text" name="BalanceCheckOtherValue" id="BalanceCheckOtherValue" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="PingURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_PingURL] %></label>
       <input type="text" name="PingURL" id="PingURL" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="PingResponse" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_PingResponse] %></label>
       <input type="text" name="PingResponse" id="PingResponse" class="form-control"  />
	  </div>
</div>

</div>
</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp; Send SMS Param</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SMSSendURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSSendURL] %></label>
       <input type="text" name="SMSSendURL" id="SMSSendURL" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SMSSendResponse" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSSendResponse] %></label>
       <input type="text" name="SMSSendResponse" id="SMSSendResponse" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-4">
	     <label for="BatchSize" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BatchSize] %></label>
       <input type="text" name="BatchSize" id="BatchSize" class="form-control"  />
	  </div>

    <div class="form-group col-sm-4">
	     <label for="NumberDelimiter" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_NumberDelimiter] %></label>
       <input type="text" name="NumberDelimiter" id="NumberDelimiter" class="form-control"  />
	  </div>
    <div class="form-group col-sm-4">
	     <label for="ResponseDelimiter" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ResponseDelimiter] %></label>
       <input type="text" name="ResponseDelimiter" id="ResponseDelimiter" class="form-control"  />
	  </div>
</div>
<div class="row" >


    <div class="form-group col-sm-6">
	     <label for="MobileNumberParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_MobileNumberParam] %></label>
       <input type="text" name="MobileNumberParam" id="MobileNumberParam" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SMSTextParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSTextParam] %></label>
       <input type="text" name="SMSTextParam" id="SMSTextParam" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SendSMSUserIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SendSMSUserIDParam] %></label>
       <input type="text" name="SendSMSUserIDParam" id="SendSMSUserIDParam" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SendSMSPasswordParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SendSMSPasswordParam] %></label>
       <input type="text" name="SendSMSPasswordParam" id="SendSMSPasswordParam" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SenderIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SenderIDParam] %></label>
       <input type="text" name="SenderIDParam" id="SenderIDParam" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SenderIDValue" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SenderIDValue] %></label>
       <input type="text" name="SenderIDValue" id="SenderIDValue" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="OtherParam1" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherParam1] %></label>
       <input type="text" name="OtherParam1" id="OtherParam1" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="OtherValue1" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherValue1] %></label>
       <input type="text" name="OtherValue1" id="OtherValue1" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="OtherParam2" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherParam2] %></label>
       <input type="text" name="OtherParam2" id="OtherParam2" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="OtherValue2" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherValue2] %></label>
       <input type="text" name="OtherValue2" id="OtherValue2" class="form-control"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="LastSMSBalance" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_LastSMSBalance] %></label>
       <input type="text" name="LastSMSBalance" id="LastSMSBalance" class="form-control"  />
	  </div>
</div>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for Addition"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Addition" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
</div>

</div>

</form>

<%
 } 
%>

<% if(nAction==CHANGE_FORM)
{

Sms_GtWysBn.locateRecord(nAccountID);
%>
<form action="<%=thisFile %>" method="POST" name="sms_gatewayaccounts_Update" id="sms_gatewayaccounts_Update" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="AccountID" value="<%=nAccountID %>" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Basic A/c Profile</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
 <div class="row">
    <div class="form-group col-sm-6">
	     <label for="Title" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Title] %></label>
       <input type="text" name="Title" id="Title" class="form-control" value="<%=StrValue(Sms_GtWysBn.Title) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="AccountType" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_AccountType] %></label>
			 <%=SMSAccountType.getDropList("AccountType", "AccountType", Sms_GtWysBn.AccountType, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
	  </div>
</div>

<div class="row" >

	  <div class="form-group col-sm-6">
	  <label for="StartDate" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_StartDate] %></label>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="StartDate" id="StartDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker(Sms_GtWysBn.StartDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span>
			</div>	
	 </div>

	  <div class="form-group col-sm-6">
	  <label for="EndDate" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_EndDate] %></label>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="EndDate" id="EndDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker(Sms_GtWysBn.EndDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span>
			</div>	
	 </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="ProviderName" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ProviderName] %></label>
       <input type="text" name="ProviderName" id="ProviderName" class="form-control" value="<%=StrValue(Sms_GtWysBn.ProviderName) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Website" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Website] %></label>
       <input type="text" name="Website" id="Website" class="form-control" value="<%=StrValue(Sms_GtWysBn.Website) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="ContactPerson" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ContactPerson] %></label>
       <input type="text" name="ContactPerson" id="ContactPerson" class="form-control" value="<%=StrValue(Sms_GtWysBn.ContactPerson) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="HelpNumbers" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_HelpNumbers] %></label>
       <input type="text" name="HelpNumbers" id="HelpNumbers" class="form-control" value="<%=StrValue(Sms_GtWysBn.HelpNumbers) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="UserID" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_UserID] %></label>
       <input type="text" name="UserID" id="UserID" class="form-control" value="<%=StrValue(Sms_GtWysBn.UserID) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Password" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_Password] %></label>
       <input type="text" name="Password" id="Password" class="form-control" value="<%=StrValue(Sms_GtWysBn.Password) %>"  />
	  </div>
</div>

</div>
</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Balance Check</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckURL] %></label>
       <input type="text" name="BalanceCheckURL" id="BalanceCheckURL" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckURL) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckFormat" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckFormat] %></label>
       <input type="text" name="BalanceCheckFormat" id="BalanceCheckFormat" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckFormat) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckUserIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckUserIDParam] %></label>
       <input type="text" name="BalanceCheckUserIDParam" id="BalanceCheckUserIDParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckUserIDParam) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckPasswordParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckPasswordParam] %></label>
       <input type="text" name="BalanceCheckPasswordParam" id="BalanceCheckPasswordParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckPasswordParam) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckOtherParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherParam] %></label>
       <input type="text" name="BalanceCheckOtherParam" id="BalanceCheckOtherParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckOtherParam) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="BalanceCheckOtherValue" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherValue] %></label>
       <input type="text" name="BalanceCheckOtherValue" id="BalanceCheckOtherValue" class="form-control" value="<%=StrValue(Sms_GtWysBn.BalanceCheckOtherValue) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="PingURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_PingURL] %></label>
       <input type="text" name="PingURL" id="PingURL" class="form-control" value="<%=StrValue(Sms_GtWysBn.PingURL) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="PingResponse" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_PingResponse] %></label>
       <input type="text" name="PingResponse" id="PingResponse" class="form-control" value="<%=StrValue(Sms_GtWysBn.PingResponse) %>"  />
	  </div>
</div>

</div>
</div>

<div class="panel panel-form-box">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Send SMS Param</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SMSSendURL" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSSendURL] %></label>
       <input type="text" name="SMSSendURL" id="SMSSendURL" class="form-control" value="<%=StrValue(Sms_GtWysBn.SMSSendURL) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SMSSendResponse" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSSendResponse] %></label>
       <input type="text" name="SMSSendResponse" id="SMSSendResponse" class="form-control" value="<%=StrValue(Sms_GtWysBn.SMSSendResponse) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-4">
	     <label for="BatchSize" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_BatchSize] %></label>
       <input type="text" name="BatchSize" id="BatchSize" class="form-control" value="<%=StrValue(Sms_GtWysBn.BatchSize) %>"  />
	  </div>

    <div class="form-group col-sm-4">
	     <label for="NumberDelimiter" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_NumberDelimiter] %></label>
       <input type="text" name="NumberDelimiter" id="NumberDelimiter" class="form-control" value="<%=StrValue(Sms_GtWysBn.NumberDelimiter) %>"  />
	  </div>

    <div class="form-group col-sm-4">
	     <label for="ResponseDelimiter" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_ResponseDelimiter] %></label>
       <input type="text" name="ResponseDelimiter" id="ResponseDelimiter" class="form-control" value="<%=StrValue(Sms_GtWysBn.ResponseDelimiter) %>"  />
	  </div>

</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="MobileNumberParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_MobileNumberParam] %></label>
       <input type="text" name="MobileNumberParam" id="MobileNumberParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.MobileNumberParam) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SMSTextParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SMSTextParam] %></label>
       <input type="text" name="SMSTextParam" id="SMSTextParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.SMSTextParam) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SendSMSUserIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SendSMSUserIDParam] %></label>
       <input type="text" name="SendSMSUserIDParam" id="SendSMSUserIDParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.SendSMSUserIDParam) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SendSMSPasswordParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SendSMSPasswordParam] %></label>
       <input type="text" name="SendSMSPasswordParam" id="SendSMSPasswordParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.SendSMSPasswordParam) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="SenderIDParam" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SenderIDParam] %></label>
       <input type="text" name="SenderIDParam" id="SenderIDParam" class="form-control" value="<%=StrValue(Sms_GtWysBn.SenderIDParam) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="SenderIDValue" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_SenderIDValue] %></label>
       <input type="text" name="SenderIDValue" id="SenderIDValue" class="form-control" value="<%=StrValue(Sms_GtWysBn.SenderIDValue) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="OtherParam1" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherParam1] %></label>
       <input type="text" name="OtherParam1" id="OtherParam1" class="form-control" value="<%=StrValue(Sms_GtWysBn.OtherParam1) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="OtherValue1" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherValue1] %></label>
       <input type="text" name="OtherValue1" id="OtherValue1" class="form-control" value="<%=StrValue(Sms_GtWysBn.OtherValue1) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="OtherParam2" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherParam2] %></label>
       <input type="text" name="OtherParam2" id="OtherParam2" class="form-control" value="<%=StrValue(Sms_GtWysBn.OtherParam2) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="OtherValue2" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_OtherValue2] %></label>
       <input type="text" name="OtherValue2" id="OtherValue2" class="form-control" value="<%=StrValue(Sms_GtWysBn.OtherValue2) %>"  />
	  </div>
</div>
<div class="row" >

    <div class="form-group col-sm-6">
	     <label for="LastSMSBalance" class="control-label blue-grey-600" ><%=FieldLabel[Sms_GtWysBn_LastSMSBalance] %></label>
       <input type="text" name="LastSMSBalance" id="LastSMSBalance" class="form-control" value="<%=StrValue(Sms_GtWysBn.LastSMSBalance) %>"  />
	  </div>
</div>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for update"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Update" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
</div>

</div>

</form>


<%
 } //end if(nAction==CHANGE_FORM)
%>

<% 
if(nAction==SEARCH_RESULT)
{ 
int sno = 0 ;
String WhereClause = "";
String OrderByClause = "";
int RecordCount = Sms_GtWysBn.recordCount(WhereClause);
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %> ( <%=RecordCount %> )
				<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=ReturnPath %>')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
<% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>
<table class="table table-curved table-condensed Rslt-Act-nav-tbl">
<tr>
<td align="center" class="col-sm-12"><i aria-hidden="true" class="icon fa fa-arrow-down iccolor"></i>&nbsp;<a href="importSMSAccount.jsp">Import SMS Account</a></td>
</tr>
</table>


<% 
if(RecordCount > 0)  
{ 
%>
<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="sms_gatewayaccounts_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="sms_gatewayaccounts_Result_checkall" id="sms_gatewayaccounts_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>&nbsp;
</th>
<th><%=FieldLabel[Sms_GtWysBn_Title] %></th>
<th><%=FieldLabel[Sms_GtWysBn_AccountType] %></th>
<th><%=FieldLabel[Sms_GtWysBn_ProviderName] %></th>
<th><%=FieldLabel[Sms_GtWysBn_SenderIDValue] %></th>
<th>Update</th>

<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<th class="text-center">
<!-- for multiselect action -->
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-info"></i></button>
<% if(bAllowDelete == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="left" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-trash"></i></button>
<% } %>&nbsp;
</th>
<% } %>
</tr>
</thead>
<tbody>

<% 
// joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
Sms_GtWysBn.openTable(WhereClause, OrderByClause );  
while(Sms_GtWysBn.nextRow())
{
sno++;
DelWarning = "Really want to Delete AccountID : "+Sms_GtWysBn.AccountID+" " ;
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="AccountID" id="AccountID_<%=Sms_GtWysBn.AccountID %>"  value="<%=Sms_GtWysBn.AccountID %>"><label for="AccountID_<%=Sms_GtWysBn.AccountID %>"> <%=sno %></label></span><% }else{ %>
<%=sno %><% } %>
<!-- 
<button onclick="NavigateTo('<%=thisFile %>?Action=Show&AccountID=<%=Sms_GtWysBn.AccountID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
 -->
</td>
	<td><a href="<%=thisFile %>?Action=Show&AccountID=<%=Sms_GtWysBn.AccountID %><%=ForeignKeyParam %><%=ReturnPathLink %>"><%=Sms_GtWysBn.Title %></a></td>
	<td><%=SMSAccountType.getLabel(Sms_GtWysBn.AccountType) %></td>
	<td><%=Sms_GtWysBn.ProviderName %></td>
	<td><%=Sms_GtWysBn.SenderIDValue %></td>
	<td><button class="btn btn-primary btn-outline" data-target="#FormModal_<%=Sms_GtWysBn.AccountID %>" data-toggle="modal" type="button">Quick Update</button></td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&AccountID=<%=Sms_GtWysBn.AccountID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AccountID=<%=Sms_GtWysBn.AccountID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
</td>
<% } %>
</tr>

                  <!-- Modal -->
                  <div class="modal fade modal-primary" id="FormModal_<%=Sms_GtWysBn.AccountID %>" aria-hidden="false" aria-labelledby="SMS_Gateway_FormModalLabel_<%=Sms_GtWysBn.AccountID %>" role="dialog" tabindex="-1">
                    <div class="modal-dialog modal-center">
										
<form action="<%=thisFile %>" method="POST" class="form-horizontal" accept-charset="UTF-8" name="SMS_Gateway_Update_<%=Sms_GtWysBn.AccountID %>" id="SMS_Gateway_Update_<%=Sms_GtWysBn.AccountID %>">
<input type="hidden" name="AccountID" value="<%=Sms_GtWysBn.AccountID %>" />

                        <div class="modal-header">
                          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                          </button>
                          <h4 class="modal-title" id="SMS_Gateway_FormModalLabel_<%=Sms_GtWysBn.AccountID %>">Quick Update</h4>
                        </div>
                        <div class="modal-body" style="background-color: #ffffff;">
												
      <div class="form-group row">
        <label class="col-md-3 col-md-offset-2 col-sm-4 col-xs-12 control-label blue-grey-600">Account :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><h4 class="form-control-static"><%=Sms_GtWysBn.Title %></h4></div>
      </div>										
      <div class="form-group row">
        <label class="col-md-3 col-md-offset-2 col-sm-4 col-xs-12 control-label blue-grey-600" for="UserID_<%=Sms_GtWysBn.AccountID %>"><%=FieldLabel[Sms_GtWysBn_UserID] %> :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><input type="text" name="UserID_<%=Sms_GtWysBn.AccountID %>" id="UserID_<%=Sms_GtWysBn.AccountID %>" class="form-control" value="<%=Sms_GtWysBn.UserID %>"></div>
      </div>	
      <div class="form-group row">
        <label class="col-md-3 col-md-offset-2 col-sm-4 col-xs-12 control-label blue-grey-600" for="Password_<%=Sms_GtWysBn.AccountID %>"><%=FieldLabel[Sms_GtWysBn_Password] %> :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><input type="text" name="Password_<%=Sms_GtWysBn.AccountID %>" id="Password_<%=Sms_GtWysBn.AccountID %>" class="form-control" value="<%=Sms_GtWysBn.Password %>"></div>
      </div>	
      <div class="form-group row">
        <label class="col-md-3 col-md-offset-2 col-sm-4 col-xs-12 control-label blue-grey-600" for="SenderIDValue_<%=Sms_GtWysBn.AccountID %>"><%=FieldLabel[Sms_GtWysBn_SenderIDValue] %> :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><input type="text" name="SenderIDValue_<%=Sms_GtWysBn.AccountID %>" id="SenderIDValue_<%=Sms_GtWysBn.AccountID %>" class="form-control" value="<%=Sms_GtWysBn.SenderIDValue %>"></div>
      </div>
			<hr />

                            <div class="form-group row">
                              <button class="btn btn-primary col-md-offset-4" data-dismiss="modal" type="button" onclick="updateSet('<%=Sms_GtWysBn.AccountID %>')"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
															<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>

                        </div>
                      </form>
                    </div>
                  </div>
                  <!-- End Modal -->			 
													
<% 
} // end while( Sms_GtWysBn.nextRow());
Sms_GtWysBn.closeTable();
 %>
</tbody>
</table>
</div>

<% 
}
else // else of if(RecordCount > 0) 
{
//  Records are not found
%>
<p>&nbsp;</p>
<p align="center" ><big>Records not found ! </big></p>

<% 
} // end  if(RecordCount > 0) 
%>
</div>
</div>

<% 
} // end if (nAction==SEARCH_RESULT)
%>

<% if(nAction==SHOW_RECORD)
{
String DelHandlerWarning = "";
Sms_GtWysBn.locateRecord(nAccountID);
DelWarning = "Really want to Delete AccountID : "+Sms_GtWysBn.AccountID+" " ;
DelHandlerWarning = "Really want to Delete Handler" ;

String CustomHandler = "Not Defined";
try
{
 if( SmHanBn.locateRecord(nAccountID)) CustomHandler = SmHanBn.HandlerClass;
}catch(Exception e)
{
   CustomHandler = "<span class=\"error\">Error: "+e.getMessage()+"</span>";
}

%>
		<% if(bAllowAdd == true){ %>
  	<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  	<% } %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AccountID=<%=Sms_GtWysBn.AccountID %>','<%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&AccountID=<%=Sms_GtWysBn.AccountID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">


<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-4">
    <!--  --> <h4>Record Related Menu : <%=Sms_GtWysBn.AccountID %></h4> 
    <!--  uncomment this -->
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="exportSMSAccount.jsp?AccountID=<%=Sms_GtWysBn.AccountID %>" target="_blank" >Export Account</a> ( XML )
      </li>
    </ul>		
    </div>	

	<div class="well well-sm">
  <div class="table-responsive">
    <table class="table table-bordered" style="background-color: #ffffff;margin-bottom: 0px;" >
    <tr>    
     <td><span class="blue-grey-700">Connection ?</span></td>
     <td><span id="CONNECTION_STATUS"><span class="label label-default" style="font-size: 13px;">Not Checked</span></span></td>
		 <td><button type="button" class="btn btn-outline btn-primary btn-sm" value="" onclick="{ $('#CONNECTION_STATUS').html('checking...'); $('#CONNECTION_STATUS').load('checkconnection.jsp?AccountID=<%=Sms_GtWysBn.AccountID %>');}">Check Now</button></td>
     </tr>
     <tr>    	 
     <td><span class="blue-grey-700">SMS Balance</span></td>
     <td><span id="BALANCE_CHECK"><%=Sms_GtWysBn.LastSMSBalance %></span></td>
		 <td><button type="button" class="btn btn-outline btn-primary btn-sm" onclick="{ $('#BALANCE_CHECK').load('checksmsbalance.jsp?AccountID=<%=Sms_GtWysBn.AccountID %>');}">Check Balance</button></td>
     </tr>
     <tr>    	 
     <td><span class="blue-grey-700">Last Bal. Check</span></td>
     <td colspan="2"><%=DateTimeHelper.showDateTimePicker(Sms_GtWysBn.BalanceCheckTime) %></td>
     </tr>
		 </table>
  </div>
  </div>
	
	  <h4>Send Test SMS</h4>
    <div class="well well-sm">

<div class="row">
  <div class="form-group col-sm-12">
	  <label for="Number" class="control-label blue-grey-600" >Mobile No.</label>
	  <input type="text" name="Number" id="Number" class="form-control" />
	</div>

  <div class="form-group col-sm-12">
	  <label for="Text" class="control-label blue-grey-600" >Text</label>
		<textarea name="Text" id="Text" class="form-control" data-plugin="maxlength" maxlength="<%=sms_charater_limit %>">Test SMS</textarea>
	</div>
	
  <div class="form-group col-sm-12">
		<button type="button" class="btn btn-primary" onclick="sendSMS('<%=Sms_GtWysBn.AccountID %>')">Send SMS</button>
	</div>

  <div class="form-group col-sm-12">
	  <label for="Text" class="control-label blue-grey-600" >Send SMS Response</label>
		<div id="SMS_RESP"><span class="label label-default" style="font-size: 13px;">Not Yet</span></div>
	</div>
	
</div>

			</div>	

	  <h4>Custom SMS Handler</h4><span class=""><%=CustomHandler %> [ <a href="javascript:void(0)" onclick="{ $('#handler_form_div').slideToggle(); }">Update</a> ]</span>
    <div class="well well-sm" id="handler_form_div" style="display:none">

<form action="<%=thisFile %>" method="post">

<input type="hidden" name="Action" value="UpdateHander" />
<input type="hidden" name="AccountID" value="<%=Sms_GtWysBn.AccountID %>" />
    
<div class="row">
  <div class="form-group col-sm-12">
	  <label for="HandlerClass" class="control-label blue-grey-600" >Handler</label>
	  <input type="text" name="HandlerClass" id="HandlerClass" class="form-control" value="<%=StrValue(SmHanBn.HandlerClass) %>" />
	</div>
	
  <div class="form-group col-sm-12">
		<button type="submit" class="btn btn-primary"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
		<% if(SmHanBn.HandlerClass!=null && SmHanBn.HandlerClass.length()> 0 ){ %>
		<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=RemoveHander<%=ForeignKeyParam %><%=ReturnPathLink %>&AccountID=<%=Sms_GtWysBn.AccountID %>','<%=DelHandlerWarning %>')" class="btn btn-icon btn-default btn-outline pull-right" type="button" style="padding: 5px;color: #f96868;" data-original-title="Remove Hander" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-trash"></i></button>
		<% } %>
	</div>
	
</div>
</form>

			</div>	

</div>
  <div class="col-sm-8">
	<h4><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Basic A/c Profile</h4>
	<div class="well well-sm">
  <div class="table-responsive">
    <table class="table table-bordered" style="background-color: #ffffff;margin-bottom: 0px;" >
    <tr>
<!--     
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_AccountID] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.AccountID) %></td>
 -->		 
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_Title] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.Title) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_AccountType] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.AccountType) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_StartDate] %></span></td>
     <td><%=DateTimeHelper.showDatePicker(Sms_GtWysBn.StartDate) %></td> 
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_EndDate] %></span></td>
     <td><%=DateTimeHelper.showDatePicker(Sms_GtWysBn.EndDate) %></td>  
     </tr>
     <tr>    	 
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_ProviderName] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.ProviderName) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_Website] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.Website) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_ContactPerson] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.ContactPerson) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_HelpNumbers] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.HelpNumbers) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_UserID] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.UserID) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_Password] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.Password) %></td>
     </tr>
		 </table>
  </div>
  </div>
	
	  	<h4><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Balance Check</h4>
			<div class="well well-sm">

    <div class="table-responsive">
    <table class="table table-bordered" style="background-color: #ffffff;margin-bottom: 0px;" >
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckURL] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckURL) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckFormat] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckFormat) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckUserIDParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckUserIDParam) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckPasswordParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckPasswordParam) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckOtherParam) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckOtherValue] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BalanceCheckOtherValue) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_PingURL] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.PingURL) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_PingResponse] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.PingResponse) %></td>
     </tr>
		 </table>
  </div>
  </div>
	
	  	<h4><i class="fa fa-bookmark iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Send SMS Params</h4>
			<div class="well well-sm">

    <div class="table-responsive">
    <table class="table table-bordered" style="background-color: #ffffff;margin-bottom: 0px;" >
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SMSSendURL] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SMSSendURL) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SMSSendResponse] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SMSSendResponse) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BatchSize] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.BatchSize) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_NumberDelimiter] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.NumberDelimiter) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_ResponseDelimiter] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.ResponseDelimiter) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_MobileNumberParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.MobileNumberParam) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SMSTextParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SMSTextParam) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SendSMSUserIDParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SendSMSUserIDParam) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SendSMSPasswordParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SendSMSPasswordParam) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SenderIDParam] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SenderIDParam) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_SenderIDValue] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.SenderIDValue) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_OtherParam1] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.OtherParam1) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_OtherValue1] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.OtherValue1) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_OtherParam2] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.OtherParam2) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_OtherValue2] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.OtherValue2) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_LastSMSBalance] %></span></td>
     <td><%=StrValue(Sms_GtWysBn.LastSMSBalance) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[Sms_GtWysBn_BalanceCheckTime] %></span></td>
     <td><%=DateTimeHelper.showDateTimePicker(Sms_GtWysBn.BalanceCheckTime) %></td> 
    	 
     </tr>
     <tr>
     <td><span class="blue-grey-700">Update DateTime</span></td>
     <td colspan="3"><%=DateTimeHelper.showDateTimePicker(Sms_GtWysBn.UpdateDateTime) %></td> 
     </tr>
    </table>
    </div>
		 </div>
    <!--}} Showing Single Record Data End -->

  </div>
</div>

</div>
</div>
<%
}//end if(nAction==SHOW_RECORD) 
%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
  <jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/js/jfield-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-datepicker-js.jsp" flush="true" />
  <jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-maxlength-js.jsp" flush="true" />

<script>
<% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<%= Notify %>');
<% 
} 
%> 

function updateSet(Acid)
{
 	var dataObj = $('#SMS_Gateway_Update_'+Acid).serialize();
		
  $.ajax({
   type: "POST",
   url: "quick-update-ajax.jsp",
   data: dataObj,
   success: function(){
	    NavigateTo('<%=thisFile %>?Action=Result');
			//alert("success");
    },
   error: function(){
   	  alert("failure");
   }
  });
}
function sendSMS(ActID)
{
 var num = $('#Number').val();
 var txt = $('#Text').val();
 var url = "sendtestsms.jsp?AccountID="+ActID+"&Number="+num+"&Text="+txt;
 $.ajax(url, { 
  success:function(data)
	{ 
	    $('#SMS_RESP').html(data);
	}
	});
}

// Support for check boxes in data list.


$("#sms_gatewayaccounts_Result_checkall").click(function () {
   if ($("#sms_gatewayaccounts_Result_checkall").is(':checked')) {
        $("#sms_gatewayaccounts_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
        $("#sms_gatewayaccounts_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='AccountID']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Really want to Delete ( "+sel_count+" ) checked items ?" ;
		
		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item for Deletion !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Are you sure?',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Delete");
            $('#sms_gatewayaccounts_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 

function CheckedActivity()
{
     var sel_items_actv = $("input[name='AccountID']").fieldArray();
	   var sel_count_actv = ( sel_items_actv !=null ) ?  sel_items_actv.length: 0 ;
		 var msg = "Activity for ( "+sel_count_actv+" ) checked items ?" ;
		 
		 if(sel_count_actv==0)
		 {
		   swal({title: '',text: 'You must check at least one item for checked activity !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Please confirm !',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Activity");
            $('#sms_gatewayaccounts_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 
function InitPage()
{
}

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here

/* Form validation code Start : for validation plugin */
<% 
if(nAction==NEW_FORM ) 
{
%>
// New Entry Form  

  //fetch_Course(1,<%=nModuleID %>,'NewAct')
  $("#sms_gatewayaccounts_Add").validate(); // Please put class="required" in mandatory fields

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
//fetch_Course(1,<%=nModuleID %>,'ChngAct')
  $("#sms_gatewayaccounts_Update").validate(); // Please put class="required" in mandatory fields

<%
 }
%>


/* Form validation code End */

});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>


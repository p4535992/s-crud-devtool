
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SMS_ApBn" scope="page" class="com.db.$DATABASE.Sms_settingsBean" />
<%! 
boolean CheckDuplicateEntry(com.db.$DATABASE.Sms_settingsBean dbBean )
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
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

   final int DEFAULT = 0 ;
   final int SEARCH_RECORDS = 1 ;
   final int SEARCH_RESULT = 2;
   final int SHOW_RECORD = 3 ;
   final int NEW_FORM = 4 ;
   final int CHANGE_FORM = 5 ;
   final int ADD_RECORD = 6 ;
   final int UPDATE_RECORD = 7;
   final int DELETE_RECORD = 8 ;
   final int PROCESS_CHECKED=9;
	 final int CHANGE_VALUE_FORM=10;
	 final int CHANGE_VALUE=11;

final String DEFAULT_ACTION ="Action=Result";
final String QUERY_OBJECT_ID = "appsettingQuery" ;

int  default_cmd = SEARCH_RESULT ;
// Show data flag
com.webapp.utils.MakeQueryString qStr =  null ;


int nAction = DEFAULT ;
String DelWarning = "" ;
String PageTitle = null ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction = "Result" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Search")) nAction = SEARCH_RECORDS ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
    else if (ParamAction.equalsIgnoreCase("New")) nAction = NEW_FORM ;
    else if (ParamAction.equalsIgnoreCase("Change")) nAction = CHANGE_FORM ;
    else if (ParamAction.equalsIgnoreCase("Add")) nAction = ADD_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Update")) nAction = UPDATE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Delete")) nAction = DELETE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("ProcessChecked")) nAction = PROCESS_CHECKED ;
		else if (ParamAction.equalsIgnoreCase("ChangeValueForm")) nAction = CHANGE_VALUE_FORM ;
		else if (ParamAction.equalsIgnoreCase("ChangeValue")) nAction = CHANGE_VALUE ;

}

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = true ;
boolean bAllowUpdate = true;
boolean bAllowDelete = false;

//footer Page Navigation
boolean bAllowFooterPageNavigation = true;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = false;


com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd = SEARCH_RESULT ;
else default_cmd = SEARCH_RESULT ;
if(nAction==DEFAULT) nAction = default_cmd ;


// ID field is Integer ( number ) type
int nSmsSettingID = 0;
try
{
   nSmsSettingID = Integer.parseInt(request.getParameter("SmsSettingID"));
}
catch(NumberFormatException ex)
{ 
   nSmsSettingID = 0;
}

String ItemTypes[] = {"Unknown" , "Yes/No", "Integer No.", "Decimal No.", "Date", "Time", "Text"  } ;
final byte NONE = 0 ;
final byte BOOLVAL = 1;
final byte INTVAL  = 2;
final byte NUMVAL  = 3;
final byte DATEVAL = 4;
final byte TIMEVAL = 5;
final byte CHARVAL = 6;

if(nAction==CHANGE_VALUE)
{
  SMS_ApBn.locateRecord(nSmsSettingID);
  SMS_ApBn.Value = request.getParameter("Value");
  SMS_ApBn.URL = request.getParameter("URL");
  SMS_ApBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
	SMS_ApBn.updateRecord(nSmsSettingID);
	
    MessageText = "One record updated. Updated ID = "+nSmsSettingID ;
    // Revert nAction to default value
    nAction=default_cmd ;
}
 

if(nAction==ADD_RECORD)
{

     SMS_ApBn.SmsSettingID= 0;

/* Auto increment column: 
     try  
      {
           SMS_ApBn.SmsSettingID = Integer.parseInt(request.getParameter("SmsSettingID")) ;
      } catch( NumberFormatException ex)
     { 
         SMS_ApBn.SmsSettingID = 0 ;
     }
*/
    try 
     { 
          SMS_ApBn.Type = Short.parseShort(request.getParameter("Type")) ;
    } catch( NumberFormatException ex)
     {     
         SMS_ApBn.Type = 0 ;
    }
     SMS_ApBn.Name = request.getParameter("Name");
     SMS_ApBn.Description = request.getParameter("Description");
     SMS_ApBn.Value = "";
     SMS_ApBn.URL = "";
    SMS_ApBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
 

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( SMS_ApBn ))
        {
           SMS_ApBn.addRecord();
           MessageText = "One record added. New ID = "+SMS_ApBn._autonumber ;
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
         SMS_ApBn.locateRecord(nSmsSettingID);
    //  $CHECK SMS_ApBn.SmsSettingID= nSmsSettingID ;
    /* Auto increment column: 
     try  
      {
           SMS_ApBn.SmsSettingID = Integer.parseInt(request.getParameter("SmsSettingID")) ;
      } catch( NumberFormatException ex)
     { 
         SMS_ApBn.SmsSettingID = 0 ;
     }
*/
    try 
     { 
          SMS_ApBn.Type = Short.parseShort(request.getParameter("Type")) ;
    } catch( NumberFormatException ex)
     {     
         SMS_ApBn.Type = 0 ;
    }
     SMS_ApBn.Name = request.getParameter("Name");
     SMS_ApBn.Description = request.getParameter("Description");
     //SMS_ApBn.Value = "";
     //SMS_ApBn.URL = "";
    SMS_ApBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
 
   
	  if(bAllowUpdate == true)
		{
	      SMS_ApBn.updateRecord(nSmsSettingID);
        MessageText = "One record updated. Updated ID = "+nSmsSettingID ;
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
    SMS_ApBn.locateRecord(nSmsSettingID);
    // $CHECK
		if(bAllowDelete == true)
		{
       SMS_ApBn.deleteRecord(nSmsSettingID);
		    MessageText = "Record Deleted. ID = "+nSmsSettingID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nSmsSettingID ;
        // SMS_ApBn.executeUpdate(DelRef);

				
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
    qStr  = new com.webapp.utils.MakeQueryString( request, application );
		//  qStr  = new com.webapp.utils.MakeQueryString( request, "MYSQL" );
	  qStr.addMultiSelectParam("SmsSettingID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("SmsSettingID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `appsetting` "+ WhrCls + " ORDER BY `SmsSettingID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   SMS_ApBn.openTable(WhrCls, " ORDER BY `SmsSettingID` ");
           while(SMS_ApBn.nextRow())
           {
					   
           }
					 SMS_ApBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = SMS_ApBn.executeUpdate( qStr.SQL( "DELETE FROM `appsetting` "+WhrCls+" ") );
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
          String redirect  = "appsetting-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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
else if (nAction==SEARCH_RECORDS) PageTitle="<i class='fa fa-search iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Record" ;
else if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Result Record" ;
else if(nAction==SHOW_RECORD) PageTitle= "<i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Record Detail " ;
else if (nAction==CHANGE_VALUE_FORM) PageTitle="<i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Update Value" ;
else PageTitle="" ;

boolean bRetPath=false;
String ReturnPath = "";
String ReturnPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{
   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
	 bRetPath=true;
}
else  // Default return path
{
   ReturnPath = appPath+"/admin/index.jsp" ;
}
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Application Setting</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" >

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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Application Setting</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Application Setting</li>
          </ol>			
  	    </div>
  		</div>			
			
<% if(nAction==CHANGE_VALUE_FORM)
{	
SMS_ApBn.locateRecord(nSmsSettingID);		
%>	

<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="changeValue_Add" id="changeValue_Add" class="form-horizontal" >
<input type="hidden" name="Action" value="ChangeValue" />
<input type="hidden" name="SmsSettingID" value="<%=nSmsSettingID %>" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

    <div class="form-group">
	     <label for="URL" class="col-sm-3 control-label blue-grey-600" >For :</label>
			 <p class="col-sm-4 form-control-static"><%=SMS_ApBn.Name %></p>
	  </div>

      <div class="form-group">
        <label for="Value" class="col-sm-3 control-label blue-grey-600">Value :</label>
				<div class="col-sm-4">
<% if(SMS_ApBn.Type == 1 ){%>
         <select name="Value" id="Value" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
				 <option value=""> -- Unknown --</option>
         <option value="YES" <% if(SMS_ApBn.Value.equalsIgnoreCase("YES")) out.print("selected"); %> >YES</option>
         <option value="NO" <% if(SMS_ApBn.Value.equalsIgnoreCase("NO")) out.print("selected"); %> >NO</option>
         </select>  
<% }if(SMS_ApBn.Type == 2 || SMS_ApBn.Type == 3 || SMS_ApBn.Type == 4 || SMS_ApBn.Type == 5 || SMS_ApBn.Type == 6){%>
       <input type="text" name="Value" id="Value" value="<%=SMS_ApBn.Value %>" class="form-control" >
<% } %>
			  </div>
		</div>	
		
    <div class="form-group">
	     <label for="URL" class="col-sm-3 control-label blue-grey-600" >URL :</label>
			 <div class="col-sm-4"><input type="text" name="URL" id="URL" class="form-control" value="<%=SMS_ApBn.URL %>" /></div>
			 <!-- <textarea rows="2" name="URL" id="URL" class="form-control" ></textarea> -->
	  </div>
		

<hr size="1" />

      <div class="form-group">
			  <div class="col-sm-offset-3" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit for update"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Change</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
				</div>
      </div>	


</div>
</div>

</form>
		
<%
 } 
%>

<% if(nAction==NEW_FORM)
{
 
// Uncoment for New Date: java.sql.Date Now = new java.sql.Date(System.currentTimeMillis() );

/* 
Hint: Use this to get form values in case new form is called from serach result.
Place value of form field as item before each field
String item=null;
if(QryObj!=null)item=QryObj.getKey("$Field") ; 
else item="";

*/


%>			
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="appsetting_Add" id="appsetting_Add" class="form-horizontal" >
<input type="hidden" name="Action" value="Add" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<!-- $CHECK Look for chain --> 
<!-- INSERT ADD FROM -->

      <div class="form-group">
        <label for="Name" class="col-sm-3 control-label blue-grey-600">Name :</label>
				<div class="col-sm-4"><input type="text" name="Name" id="Name" class="form-control" /></div>
			</div>
			
    <div class="form-group">
	     <label for="Description" class="col-sm-3 control-label blue-grey-600" >Description :</label>
			 <div class="col-sm-4"><textarea rows="2" name="Description" id="Description" class="form-control" ></textarea></div>
	  </div>
		
    <div class="form-group">
	     <label for="Type" class="col-sm-3 control-label blue-grey-600" >Value Type :</label>
			 <div class="col-sm-4">
			<select name="Type" id="Type" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false" onchange="showValue(this.value);">
        <option value="">Unknown</option>
        <option value="1">Yes/No</option>
        <option value="2">Integer No.</option>
        <option value="3">Text</option>
      </select>
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

SMS_ApBn.locateRecord(nSmsSettingID);
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="appsetting_Update" id="appsetting_Update" class="form-horizontal">
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="SmsSettingID" value="<%=nSmsSettingID %>" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
 
<!-- $CHECK Look for chain --> 
<!-- INSERT UPDATE FORM  --> 




      <div class="form-group">
        <label for="Name" class="col-sm-3 control-label blue-grey-600">Name :</label>
				<div class="col-sm-4"><input type="text" name="Name" id="Name" class="form-control"  value="<%=SMS_ApBn.Name %>" /></div>
			</div>
			
    <div class="form-group">
	     <label for="Description" class="col-sm-3 control-label blue-grey-600" >Description :</label>
			 <div class="col-sm-4"><textarea rows="2" name="Description" id="Description" class="form-control" ><%=SMS_ApBn.Description %></textarea></div>
	  </div>
		
    <div class="form-group">
	     <label for="Type" class="col-sm-3 control-label blue-grey-600" >Value Type :</label>
			 <div class="col-sm-4">
			<select name="Type" id="Type" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false" onchange="showValue(this.value);">
        <option value="" <% if(SMS_ApBn.Type == 0) out.print("selected") ;%> >Unknown</option>
        <option value="1" <% if(SMS_ApBn.Type == 1) out.print("selected") ;%> >Yes/No</option>
        <option value="2" <% if(SMS_ApBn.Type == 2) out.print("selected") ;%> >Integer No.</option>
        <option value="3" <% if(SMS_ApBn.Type == 6) out.print("selected") ;%> >Text</option>
      </select>
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
<% if(nAction==SEARCH_RECORDS)
{ 
   session.removeAttribute(QUERY_OBJECT_ID);
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" class="form-horizontal" id="appsetting_Search">
<input type="hidden" name="Action" value="Result" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-left: 5px;margin-top: -5px;" data-original-title="Go To Result Page" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-arrow-right" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

      <div class="form-group">
        <label class="control-label blue-grey-600 col-sm-3">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="SmsSettingID_RNG_CHK" id="SmsSettingID_RNG_CHK" onchange="CheckSearchRange('SmsSettingID')"><label for="SmsSettingID_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="SmsSettingID_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("SmsSettingID_OPERATOR", "SmsSettingID_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="SmsSettingID" id="SmsSettingID" class="form-control" /></div>
      	<label class="control-label blue-grey-600 col-sm-1 text-center" id="SmsSettingID_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="SmsSettingID_RNG_BLK" style="display:none"><input type="text" name="SmsSettingID_TO" id="SmsSettingID_TO" class="form-control" /></div>
      </div>			

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Type :</label>
        <div class="col-sm-2"><input type="text" name="Type" id="Type" class="form-control" /></div>
      </div>	
<!-- 
      <div class="form-group">
        <label class="control-label blue-grey-600 col-sm-3">Type :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="Type_RNG_CHK" id="Type_RNG_CHK" onchange="CheckSearchRange('Type')"><label for="Type_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="Type_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("Type_OPERATOR", "Type_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="Type" id="Type" class="form-control" /></div>
      	<label class="control-label blue-grey-600 col-sm-1 text-center" id="Type_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="Type_RNG_BLK" style="display:none"><input type="text" name="Type_TO" id="Type_TO" class="form-control" /></div>
      </div>	
 -->					
	  
<!-- 
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Name :</label>
        <div class="col-sm-2"><input type="text" name="Name" id="Name" class="form-control" /></div>
      </div>	
 -->
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Name :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("Name_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="Name" id="Name" class="form-control" /></div>
      </div>		
		 
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Description :</label>
        <div class="col-sm-2"><input type="text" name="Description" id="Description" class="form-control" /></div>
      </div>	

<!-- 
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Value :</label>
        <div class="col-sm-2"><input type="text" name="Value" id="Value" class="form-control" /></div>
      </div>	
 -->
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Value :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("Value_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="Value" id="Value" class="form-control" /></div>
      </div>		
		

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="SmsSettingID" >SmsSettingID</option>
      		  <option value="Type" >Type</option>
      		  <option value="Name" >Name</option>
      		  <option value="Title" >Title</option>
      		  <option value="Value" >Value</option>		
      		</select>
        </div>
				<span class="visible-xs-block" style="line-height: 0.5;">&nbsp;</span>
				<div class="col-sm-3">
				  <div class="radio-custom radio-inline radio-primary" data-original-title="Ascending" data-placement="bottom" data-toggle="tooltip" data-trigger="hover">
            <input type="radio" name="Sort" id="ASC" value="ASC" checked="checked">
            <label for="ASC"><i aria-hidden="true" class="icon wb-sort-asc" style="font-size: 18px;"></i></label>
          </div>
				  <div class="radio-custom radio-inline radio-primary" style="margin-left: 20px;" data-original-title="Descending" data-placement="bottom" data-toggle="tooltip" data-trigger="hover">
            <input type="radio" name="Sort" id="DESC" value="DESC">
            <label for="DESC"><i aria-hidden="true" class="icon wb-sort-des" style="font-size: 18px;"></i></label>
          </div>
				</div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	
			
</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
  				<% if(bAllowAdd == true){ %>
  				<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  				<% } %>
				</div>
</div>

</div>

</form>


<% 
}// end if (nAction==SEARCH_RECORDS)
%>

<% 
if(nAction==SEARCH_RESULT)
{ 

session.removeAttribute(QUERY_OBJECT_ID);

int sno = 0 ;
int LastBlock=0;
String WhereClause=null;
String OrderByClause=null;
int RePaginateCount = 0 ;
try
{
  RePaginateCount=java.lang.Integer.parseInt(request.getParameter("RePaginateCount"));
}
catch (NumberFormatException ex )
{
  RePaginateCount=0;
}


  if(QryObj != null )
	{
	  // Query found in session use that instead of making new one.
		
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;
if(RePaginateCount > 0)
{
     QryObj.offset = 0 ;
		 QryObj.pagesize = RePaginateCount ;
}
else
{
  	 try
		 {
		     QryObj.offset = java.lang.Integer.parseInt( request.getParameter("OFFSET") );
     }
     catch (NumberFormatException ex )
     {
	      
     }
}		 
	
	}
	else // else of  if(QryObj != null )
	{
	  // Query not is session create new one from submitted search form.
		 qStr = new com.webapp.utils.MakeQueryString( request, application );
		 // qStr = new com.webapp.utils.MakeQueryString( request, "MYSQL" );
		 
		 
     QryObj = new com.webapp.login.SearchQuery();
     qStr.setTablename(SMS_ApBn._tablename);
     // qStr.setOrderByClause(" ORDERBY ? ");
     
    // Automatically add Foreign Keys in Search Creterion

    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam("$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/
	
	 
 		 QryObj.jndidsn  = "jdbc/$DATABASE" ;
     QryObj.table = "appsetting"  ;
		 
		 String exWhereClause = "";
		 if(qStr.getWhereClause().length()==0) 
		 {
		 	 exWhereClause = "" ;//WHERE `SmsSettingID` NOT IN ('2','3') 
		 }		 
		 else
		 {
		   exWhereClause = qStr.getWhereClause(); //+" AND `SmsSettingID` NOT IN ('2','3') " ;
		 }
		 String Sort  = request.getParameter("Sort") ;
	   if(Sort==null ) Sort="ASC" ;
		  
     QryObj.whereclause = exWhereClause ; 
		 QryObj.orderbyclause  = qStr.getOrderByClause("OrderBy");
		 QryObj.query =  qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause;

     QryObj.count = SMS_ApBn.recordCount(WhereClause); 
     QryObj.offset = 0 ;
     QryObj.pagesize = 0 ;
		 try
		 {
		     QryObj.pagesize=java.lang.Integer.parseInt(request.getParameter("ROWS"));
     }
     catch (NumberFormatException ex )
     {
	       QryObj.pagesize=20;
     }
		 session.setAttribute(QUERY_OBJECT_ID, QryObj ) ;


 } // end if
  
  String WhrParam  = RequestHelper.encodeBase64( WhereClause.getBytes()) ;
  String RetPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
         

%>
<!-- RECORDS FOUND -->

 <div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %> ( <%=QryObj.count %> )
		<!-- <a href="<%=thisFile %>?Action=Search<%=ForeignKeyParam %><%=ReturnPathLink %>" class="pull-right" style="text-decoration: none;"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a> -->
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
<table class="table table-curved table-condensed Rslt-Act-nav-tbl">
<tr>
<td align="center" class="col-sm-12"><i aria-hidden="true" class="icon fa fa-anchor iccolor"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/restartsms.jsp">Restart SMS Service</a></td>
</tr>
</table>

<!-- $CHECK Look for chain -->
<!-- NAVIGATION BAR BEGIN -->
<%@include file="/include-page/master/pagination-header.inc"%>
<!-- NAVIGATION BAR END -->
<% 
if(QryObj.count > 0)  
{ 
//  Records are there
%>
 
		

<% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>

<form action="<%=thisFile %>"  accept-charset="UTF-8" id="appsetting_list" method="post">
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>



<div class="table-responsive">
<table class="table table-bordered table-striped Rslt-Act-tbl" id="appsetting_Result_tbl">
<thead>
<tr>
<!-- 
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="top" data-toggle="tooltip"><input type="checkbox" name="appsetting_Result_checkall" id="appsetting_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>
</th>
 -->
<th>Name</th>
<th>Description</th>
<th>Type</th>
<th>Value</th>

<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<th class="text-center">
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-info"></i></button>
<% if(bAllowDelete == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="top" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-trash"></i></button>
<% } %>
</th>
<% } %>
</tr>
</thead>
<tbody>
<% 

/** Check for pagination support 
  if pagination is supported by SQL implementation ( LIMIT and OFFSET key words ) 
	than call :  SMS_ApBn.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( SMS_ApBn.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/

SMS_ApBn.openTable(WhereClause, OrderByClause );  //"WHERE `SmsSettingID` NOT IN ('2','3')"
//SMS_ApBn.openTable(" ", "" );
int n=0;
while(n< QryObj.offset)
{
 n++ ;
 SMS_ApBn.skipRow();
} 
 n=0;
sno=QryObj.offset;

while(SMS_ApBn.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "Really want to Delete SmsSettingID : "+SMS_ApBn.SmsSettingID+" " ;
// $CHECK
%>
<tr>
<!-- 
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="SmsSettingID" id="SmsSettingID_<%=SMS_ApBn.SmsSettingID %>"  value="<%=SMS_ApBn.SmsSettingID %>"><label></label></span>&nbsp;&nbsp;
<% } %>
<%=sno %> 
</td>
 -->
	<td><%=SMS_ApBn.Name %></td>
	<td><%=SMS_ApBn.Description %></td>
	<td><%=ItemTypes[SMS_ApBn.Type] %></td>
	<td><%=SMS_ApBn.Value %><br>[<a href="<%=thisFile %>?Action=ChangeValueForm&SmsSettingID=<%=SMS_ApBn.SmsSettingID %><%=ForeignKeyParam %><%=ReturnPathLink %>" > Set New Value </a>]</td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<button onclick="NavigateTo('<%=thisFile %>?Action=Show&SmsSettingID=<%=SMS_ApBn.SmsSettingID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;margin-right: 7px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&SmsSettingID=<%=SMS_ApBn.SmsSettingID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&SmsSettingID=<%=SMS_ApBn.SmsSettingID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( SMS_ApBn.nextRow());
SMS_ApBn.closeTable();
 %>
</tbody>
</table>
</div>
</form>

<% if(bAllowFooterPageNavigation == true)
{ 
%>
<!-- Footer Pagination-->
<% 
if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  ) 
{
%>

<!-- NAVIGATION BAR BEGIN -->
<%@include file="/include-page/master/pagination-footer.inc"%>
<!-- NAVIGATION BAR END -->


<%  
} // END if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  )
%>
<!-- END Footer Pagination-->

<% 
} // END if(bAllowFooterPageNavigation == true)
%>

<!-- RECORDS FOUND NOT FOUNT-->
<% 
}
else // else of if(QryObj.count > 0) 
{
//  Records are not found
%>
<p align="center" ><big>Records satisfying search criteria not found! </big></p>

<% 
} // end  if(QryObj.count > 0) 
%>
</div>
</div>

<% 
} // end if (nAction==SEARCH_RESULT)
%>

<% if(nAction==SHOW_RECORD)
{
// $CHECK
SMS_ApBn.locateRecord(nSmsSettingID);
DelWarning = "Really want to Delete SmsSettingID : "+SMS_ApBn.SmsSettingID+" " ;
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&SmsSettingID=<%=SMS_ApBn.SmsSettingID %>','<%=DelWarning %>')"><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&SmsSettingID=<%=SMS_ApBn.SmsSettingID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	


<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-3">
    <h4>ID : <%=SMS_ApBn.SmsSettingID %></h4>
    <!--  uncomment this 
    <ul>
    <li><a href="#?SmsSettingID=<%=SMS_ApBn.SmsSettingID %>">Menu Item 1</a></li>
    <li><a href="#?SmsSettingID=<%=SMS_ApBn.SmsSettingID %>">Menu Item 2</a></li>
    </ul>
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
    <tr>
    
     <td><span class="blue-grey-700">SmsSettingID</span></td>
     <td><%=StrValue(SMS_ApBn.SmsSettingID) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">Type</span></td>
     <td><%=StrValue(ItemTypes[SMS_ApBn.Type]) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">Name</span></td>
     <td><%=StrValue(SMS_ApBn.Name) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">Description</span></td>
     <td><%=StrValue(SMS_ApBn.Description) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">Value</span></td>
     <td><%=StrValue(SMS_ApBn.Value) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">URL</span></td>
     <td><%=StrValue(SMS_ApBn.URL) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700">Update DateTime</span></td>
     <td valign="top" > <%=DateTimeHelper.showDateTimePicker(SMS_ApBn.UpdateDateTime) %></td> 
    </tr>
    </table>
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
  
	<jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />


<script language="JavaScript" type="text/javascript">
<!--
<% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<%= Notify %>');
<% 
} 
%> 

function GoToBlock()
{
   var obj = document.getElementById("block") ;
   var val = obj.options[obj.selectedIndex].value ;
   var moveto = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET="+val ;
   NavigateTo(moveto);
}

function RePaginate()
{
  var nrows = parseInt( $("#RowCount").val() );
	if(isNaN(nrows) || nrows <= 0 )
	{
	  alert("Invalid record number entered.");
		return;
	}
	
  var RepaginateURL = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&RePaginateCount="+nrows ;
	NavigateTo(RepaginateURL);
}


function showValue(val)
{
  if(val == 1) 
  {
    $("#span0").hide(); 
    $("#span1").show();
    $("#span2").hide();  
  }
  else if(val == 2 || val == 3)
  {
    $("#span0").hide(); 
    $("#span1").hide();
    $("#span2").show(); 
  }
  else
  {
    $("#span0").show(); 
    $("#span1").hide();
    $("#span2").hide(); 
  }
}

// Support for check boxes in data list.


$("#appsetting_Result_checkall").click(function () {
   if ($("#appsetting_Result_checkall").is(':checked')) {
        $("#appsetting_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $("#appsetting_Result_tbl input[type=checkbox]").each(function () {
        $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='SmsSettingID']").fieldArray();
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
            $('#appsetting_list' ).submit();
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
     var sel_items_actv = $("input[name='SmsSettingID']").fieldArray();
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
            $('#appsetting_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 



function CheckSearchRange(search_field)
{
  var rng_chk = search_field+"_RNG_CHK" ;
	var opr_blk   = search_field+"_OPR_BLK" ;
	var rng_blk   = search_field+"_RNG_BLK" ;
	var rng_lbl   = search_field+"_RNG_LBL" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show();
		$("#"+rng_lbl).show(); 
		$("#"+opr_blk).hide(); 
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide();
		$("#"+rng_lbl).hide();
		$("#"+opr_blk).show(); 
	}

}

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here
/*   Form validation code Start : for validation plugin */
<% 
if(nAction==NEW_FORM ) 
{
%>
// New Entry Form  
 $("#appsetting_Add").validate({ 
   rules: 
   {
    Type:"required",
    Name:"required",
    Description:"required",
    Value:"required"
   } 
 });  

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
 $("#appsetting_Update").validate({ 
   rules: 
   {
    Type:"required",
    Name:"required",
    Description:"required",
    Value:"required"
   } 
 }); // End form validation code.
 
 
$(function() {

   $('#span0').hide();
	 $('#span1').hide();
	 $('#span2').hide();	 
	
	 
var chk_val =  $('#Type').val();
  if(chk_val == 1) 
  {
    $("#span0").hide(); 
    $("#span1").show();
    $("#span2").hide();  
  }
  else if(chk_val == 2 || val == 3)
  {
    $("#span0").hide(); 
    $("#span1").hide();
    $("#span2").show(); 
  }
  else
  {
    $("#span0").show(); 
    $("#span1").hide();
    $("#span2").hide(); 
  }


});		 
 
<%
 }
else if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  

  $("#appsetting_Search").validate(); // Please put class="required" in mandatory fields
<%
 } 
%>

/* Form validation code End */

/* Search autocomplete support -Start */
  // JSP Block Start
  <%  
	if( nAction==SEARCH_RECORDS ) 
	{ 
	%>
	  /* un comment this to enable
	  $('#?FieldID').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"appsetting",field:"?FieldName"} 
	  });
    */
	
	<% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block
// -->
</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>


<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SiAuthBn" scope="page" class="com.db.$DATABASE.Sitemanager_authorizationBean" />
<jsp:useBean id="ModBn" scope="page" class="com.db.$DATABASE.ModuleBean" />
<%! 
boolean CheckDuplicateEntry(int AID,int MID)
{ 
com.db.$DATABASE.Sitemanager_authorizationBean SiAthBn = new com.db.$DATABASE.Sitemanager_authorizationBean();

 try
 {
  return  ( SiAthBn.recordCount(" WHERE `AdminID` = "+AID+" AND `ModuleID` = "+MID+" ") > 0) ? false : true ;
 }  catch( java.sql.SQLException exSQL ) {  return false ; }

}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);


final int SiMngrBn_AuthorizationID = 0, SiMngrBn_AdminID = 1, SiMngrBn_ModuleID = 2, SiMngrBn_ModuleName = 3, SiMngrBn_ModuleActivityID = 4, SiMngrBn_UpdateDateTime = 5 ;

String FieldLabel[] = {"AuthorizationID", "Admin", "Module", "Module Name", "Module Activity", 
                       "Update DateTime"} ;

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
boolean bAllowAdd = true ;
boolean bAllowUpdate = true ;
boolean bAllowDelete = false;


//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = false;

default_cmd = SEARCH_RESULT ;
if(nAction==DEFAULT) nAction = default_cmd ;

// ID field is Integer ( number ) type
int nAuthorizationID = 0;
try
{
   nAuthorizationID = Integer.parseInt(request.getParameter("AuthorizationID"));
}
catch(NumberFormatException ex)
{ 
   nAuthorizationID = 0;
}
SiAuthBn.locateRecord(nAuthorizationID);
String AdminID = request.getParameter("AdminID");
if(AdminID==null) AdminID = ""; 
ForeignKeyParam.append("&AdminID="+AdminID) ;

int nAdminID = 0;
try
{
   nAdminID = Integer.parseInt(request.getParameter("AdminID"));
}
catch(NumberFormatException ex)
{ 
   nAdminID = 0;
}

if(nAction==ADD_RECORD)
{

     SiAuthBn.AuthorizationID= 0;
     try  
      {
           SiAuthBn.AdminID = Integer.parseInt(request.getParameter("AdminID")) ;
      } catch( NumberFormatException ex)
     { 
         SiAuthBn.AdminID = 0 ;
     }
     try  
      {
           SiAuthBn.ModuleID = Integer.parseInt(request.getParameter("ModuleID")) ;
      } catch( NumberFormatException ex)
     { 
         SiAuthBn.ModuleID = 0 ;
     }
		 ModBn.locateRecord(SiAuthBn.ModuleID);
		 SiAuthBn.ModuleName = ModBn.ModuleName ;
		 String ABC = CSVHelper.csvFromRequest(request, "ModuleActivityID");
		 if(ABC.length()==0)SiAuthBn.ModuleActivityID = "";
		 else SiAuthBn.ModuleActivityID = ABC;
    SiAuthBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); // DateTimeHelper.requestDateTimePicker( request, "UpdateDateTime" ) ; 
 

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry(SiAuthBn.AdminID,SiAuthBn.ModuleID))
        {
           SiAuthBn.addRecord();
           MessageText = "One record added. New ID = "+SiAuthBn._autonumber ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "Duplicate Entry Found!<br>No new record created." ;
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
         SiAuthBn.locateRecord(nAuthorizationID);
    //  $CHECK SiAuthBn.AuthorizationID= nAuthorizationID ;
    /* Auto increment column: 
     try  
      {
           SiAuthBn.AuthorizationID = Integer.parseInt(request.getParameter("AuthorizationID")) ;
      } catch( NumberFormatException ex)
     { 
         SiAuthBn.AuthorizationID = 0 ;
     }
*/
     try  
      {
           SiAuthBn.AdminID = Integer.parseInt(request.getParameter("AdminID")) ;
      } catch( NumberFormatException ex)
     { 
         SiAuthBn.AdminID = 0 ;
     }
     try  
      {
           SiAuthBn.ModuleID = Integer.parseInt(request.getParameter("ModuleID")) ;
      } catch( NumberFormatException ex)
     { 
         SiAuthBn.ModuleID = 0 ;
     }
		 ModBn.locateRecord(SiAuthBn.ModuleID);
		 SiAuthBn.ModuleName = ModBn.ModuleName ;
		 String ABC = CSVHelper.csvFromRequest(request, "ModuleActivityID");
		 if(ABC.length()==0)SiAuthBn.ModuleActivityID = "";
		 else SiAuthBn.ModuleActivityID = ABC;
    SiAuthBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); // DateTimeHelper.requestDateTimePicker( request, "UpdateDateTime" ) ; 

		  boolean bupdate = false ;
			if(SiAuthBn.AdminID == Integer.parseInt(request.getParameter("AdminID")) && SiAuthBn.ModuleID == Integer.parseInt(request.getParameter("ModuleID")) )
			{
			  bupdate = true ;
			}
 
	  if(bAllowUpdate == true)
		{

			  if(bupdate)
				{
				  SiAuthBn.updateRecord(nAuthorizationID);
          MessageText = "One record updated. Updated ID = "+nAuthorizationID ;
				}
				else
			  {
    			  if(CheckDuplicateEntry(SiAuthBn.AdminID,SiAuthBn.ModuleID))
            {
    	        SiAuthBn.updateRecord(nAuthorizationID);
              MessageText = "Record updated." ;
    				}
    				else
    				{
    				  MessageText ="Duplicate Record Founded..!!!";
    				}
				}		
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
    SiAuthBn.locateRecord(nAuthorizationID);
    // $CHECK
		if(bAllowDelete == true)
		{
       SiAuthBn.deleteRecord(nAuthorizationID);
		    MessageText = "Record Deleted. ID = "+nAuthorizationID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nAuthorizationID ;
        // SiAuthBn.executeUpdate(DelRef);	
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
	  qStr.addMultiSelectParam(SiAuthBn._tablename, "AuthorizationID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("AuthorizationID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `sitemanager_authorization` "+ WhrCls + " ORDER BY `sitemanager_authorization`.`AuthorizationID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   SiAuthBn.openTable(WhrCls, " ORDER BY `AuthorizationID` ");
           while(SiAuthBn.nextRow())
           {
					   
           }
					 SiAuthBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = SiAuthBn.executeUpdate( qStr.SQL( "DELETE FROM `sitemanager_authorization` "+WhrCls+" ") );
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
          String redirect  = "sitemanager_authorization-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Module Authorization</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>

<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >


  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Module Authorization</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li><a href="<%=appPath %>/admin/superadmin/managesitemanager.jsp?Action=Show<%=ForeignKeyParam %>">SiteManager</a></li>
						<li class="active">Authorization</li>
          </ol>			
  	    </div>
  		</div>	
 
<blockquote class="blockquote blockquote-success appblockquote">
<span class=" blue-grey-700">For : </span><%=ShowItem.showAdminName(nAdminID, 1) %>
</blockquote>			


<% if(nAction==NEW_FORM)
{
%>			
<form action="<%=thisFile %>" method="POST" name="sitemanager_authorization_Add" id="sitemanager_authorization_Add" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Add" />

<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>


<input type="hidden" name="AdminID" value="<%=AdminID %>" />

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row">
    <div class="form-group col-sm-6">
	     <label for="ModuleID" class="control-label blue-grey-600" ><%=FieldLabel[SiMngrBn_ModuleID] %></label>
			  <jsp:include page ="/modulelist/" >
			     <jsp:param name="ElementName" value="ModuleID" />
					 <jsp:param name="ElementID" value="ModuleID" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="WhereClause" value="" />
					 <jsp:param name="OrderBy" value="" />
					 <jsp:param name="GroupBy" value="" />
					 <jsp:param name="ClassName" value="form-control show-tick" />
					 <jsp:param name="Plugin" value="data-plugin='selectpicker' data-container='body' data-live-search='false'" />
					 <jsp:param name="Multiple" value="false" />
				</jsp:include>
	  </div>

    <div class="form-group col-sm-6">
	     <label for="ModuleActivityID" class="control-label blue-grey-600" ><%=FieldLabel[SiMngrBn_ModuleActivityID] %></label>
			  <jsp:include page ="/activitylist/" >
			     <jsp:param name="ElementName" value="ModuleActivityID" />
					 <jsp:param name="ElementID" value="ModuleActivityID" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="false" />
					 <jsp:param name="WhereClause" value="" />
					 <jsp:param name="OrderBy" value="" />
					 <jsp:param name="GroupBy" value="" />
					 <jsp:param name="ClassName" value="form-control show-tick" />
					 <jsp:param name="Plugin" value="data-plugin='selectpicker' data-container='body' data-live-search='false'" />
					 <jsp:param name="Multiple" value="true" />
				</jsp:include>

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

SiAuthBn.locateRecord(nAuthorizationID);
%>
<form action="<%=thisFile %>" method="POST" name="sitemanager_authorization_Update" id="sitemanager_authorization_Update" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="AuthorizationID" value="<%=nAuthorizationID %>" />

<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>


<input type="hidden" name="AdminID" value="<%=AdminID %>" />

 
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
 
<!-- INSERT UPDATE FORM  --> 



<div class="row">
    <div class="form-group col-sm-6">
	     <label for="ModuleID" class="control-label blue-grey-600" ><%=FieldLabel[SiMngrBn_ModuleID] %></label>
			  <jsp:include page ="/modulelist/" >
			     <jsp:param name="ElementName" value="ModuleID" />
					 <jsp:param name="ElementID" value="ModuleID" />
					 <jsp:param name="Select" value="<%=SiAuthBn.ModuleID %>" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="false" />
					 <jsp:param name="WhereClause" value="" />
					 <jsp:param name="OrderBy" value="" />
					 <jsp:param name="GroupBy" value="" />
					 <jsp:param name="ClassName" value="form-control show-tick" />
					 <jsp:param name="Plugin" value="data-plugin='selectpicker' data-container='body' data-live-search='false'" />
					 <jsp:param name="Multiple" value="false" />
				</jsp:include>
	  </div>

    <div class="form-group col-sm-6">
	     <label for="ModuleActivityID" class="control-label blue-grey-600" ><%=FieldLabel[SiMngrBn_ModuleActivityID] %></label>
			  <jsp:include page ="/activitylist/" >
			     <jsp:param name="ElementName" value="ModuleActivityID" />
					 <jsp:param name="ElementID" value="ModuleActivityID" />
					 <jsp:param name="Select" value="<%=SiAuthBn.ModuleActivityID %>" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="false" />
					 <jsp:param name="WhereClause" value="" />
					 <jsp:param name="OrderBy" value="" />
					 <jsp:param name="GroupBy" value="" />
					 <jsp:param name="ClassName" value="form-control show-tick" />
					 <jsp:param name="Plugin" value="data-plugin='selectpicker' data-container='body' data-live-search='false'" />
					 <jsp:param name="Multiple" value="true" />
				</jsp:include>
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
String WhereClause = "WHERE `AdminID` = "+nAdminID+"";
String OrderByClause = "";
int RecordCount = SiAuthBn.recordCount(WhereClause);
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
<% 
if(RecordCount > 0)  
{ 
%>
 
		

<form action="<%=thisFile %>" method="post" id="sitemanager_authorization_list" accept-charset="UTF-8" >
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

<input type="hidden" name="AdminID" value="<%=AdminID %>" />

<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="sitemanager_authorization_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="sitemanager_authorization_Result_checkall" id="sitemanager_authorization_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>&nbsp;
</th>
<th><%=FieldLabel[SiMngrBn_ModuleName] %></th>
<th><%=FieldLabel[SiMngrBn_ModuleActivityID] %></th>

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
SiAuthBn.openTable(WhereClause, OrderByClause );  
while(SiAuthBn.nextRow())
{
sno++;
DelWarning = "Really want to Delete AuthorizationID : "+SiAuthBn.AuthorizationID+" " ;
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="AuthorizationID" id="AuthorizationID_<%=SiAuthBn.AuthorizationID %>"  value="<%=SiAuthBn.AuthorizationID %>"><label for="AuthorizationID_<%=SiAuthBn.AuthorizationID %>"> <%=sno %></label></span><% }else{ %>
<%=sno %><% } %>

<button onclick="NavigateTo('<%=thisFile %>?Action=Show&AuthorizationID=<%=SiAuthBn.AuthorizationID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
</td>
	<td><%=SiAuthBn.ModuleName %></td>
	<td><%=ShowItem.showActivityFullName(SiAuthBn.ModuleActivityID) %></td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&AuthorizationID=<%=SiAuthBn.AuthorizationID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AuthorizationID=<%=SiAuthBn.AuthorizationID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( SiAuthBn.nextRow());
SiAuthBn.closeTable();
 %>
</tbody>
</table>
</div>
</form>

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
// $CHECK
SiAuthBn.locateRecord(nAuthorizationID);
DelWarning = "Really want to Delete AuthorizationID : "+SiAuthBn.AuthorizationID+" " ;
%>
		<% if(bAllowAdd == true){ %>
  	<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  	<% } %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AuthorizationID=<%=SiAuthBn.AuthorizationID %>','<%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&AuthorizationID=<%=SiAuthBn.AuthorizationID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">


<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-3">
    <h4>ID : <%=SiAuthBn.AuthorizationID %></h4>
    <!--  uncomment this 
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?AuthorizationID=<%=SiAuthBn.AuthorizationID %>">Menu Link 1</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?AuthorizationID=<%=SiAuthBn.AuthorizationID %>">Menu Link 2</a>
      </li>
    </ul>		
    </div>		
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
<!-- 		
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_AuthorizationID] %></span></td>
     <td><%=StrValue(SiAuthBn.AuthorizationID) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_AdminID] %></span></td>
     <td><%=StrValue(SiAuthBn.AdminID) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_ModuleID] %></span></td>
     <td><%=StrValue(SiAuthBn.ModuleID) %></td>
     </tr>
 -->		 
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_ModuleName] %></span></td>
     <td><%=StrValue(SiAuthBn.ModuleName) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_ModuleActivityID] %></span></td>
     <td><%=StrValue(ShowItem.showActivityFullName(SiAuthBn.ModuleActivityID)) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SiMngrBn_UpdateDateTime] %></span></td>
     <td><%=DateTimeHelper.showDateTimePicker(SiAuthBn.UpdateDateTime) %></td> 
    	 
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

function InitPage()
{
// Do something on page init
}


// Support for check boxes in data list.


$("#sitemanager_authorization_Result_checkall").click(function () {
   if ($("#sitemanager_authorization_Result_checkall").is(':checked')) {
        $("#sitemanager_authorization_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
        $("#sitemanager_authorization_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='AuthorizationID']").fieldArray();
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
            $('#sitemanager_authorization_list' ).submit();
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
     var sel_items_actv = $("input[name='AuthorizationID']").fieldArray();
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
            $('#sitemanager_authorization_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
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

  
  $("#sitemanager_authorization_Add").validate(); // Please put class="required" in mandatory fields

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  

  $("#sitemanager_authorization_Update").validate(); // Please put class="required" in mandatory fields

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


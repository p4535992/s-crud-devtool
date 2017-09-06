<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@include file="/portablesql.inc"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="MoBn" scope="page" class="com.db.$DATABASE.ModuleBean" />
<jsp:useBean id="InCourseBn" scope="page" class="com.db.$DATABASE.Institute_courseBean" />
<jsp:useBean id="SiAuthBn" scope="page" class="com.db.$DATABASE.Sitemanager_authorizationBean" />
<%! 
boolean CheckDuplicateEntry(com.db.$DATABASE.ModuleBean dbBean )
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

String getCsvFromQuery(String query, boolean isInt)
throws SQLException
{
com.webapp.db.GenericQuery genqry = new com.webapp.db.GenericQuery(ApplicationResource.database, _SQL_ENGINE );
genqry.beginExecute(); 

			 int i =0;
			 StringBuilder sb = new StringBuilder();
      genqry.continueExecute(query);
      java.sql.ResultSet rslt= genqry.getLastResultSet();
      while(rslt.next())
      {			 
			   if(i>0)sb.append(",");
				 if(isInt) sb.append(rslt.getInt(1)); 
				 else sb.append(rslt.getString(1)); 
			   i++;
			}
genqry.endExecute();	

return sb.toString();		 
}

%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);


final int MoBn_ModuleID = 0, MoBn_ModuleName = 1, MoBn_UpdateDateTime = 2 ;

String FieldLabel[] = {"ModuleID", "Module Name", "Update DateTime"} ;

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

final String DEFAULT_ACTION ="Action=Result";
final String QUERY_OBJECT_ID = "moduleQuery" ;

int  default_cmd = DEFAULT ;
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

}

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = true ;
boolean bAllowUpdate = false;
boolean bAllowDelete = false;

//footer Page Navigation
boolean bAllowFooterPageNavigation = true;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = false ;


com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd=SEARCH_RESULT ;
else default_cmd = SEARCH_RESULT ;
if(nAction==DEFAULT) nAction = default_cmd ;


// ID field is Integer ( number ) type
int nModuleID = 0;
try
{
   nModuleID = Integer.parseInt(request.getParameter("ModuleID"));
}
catch(NumberFormatException ex)
{ 
   nModuleID = 0;
}

if(nAction==ADD_RECORD)
{
    MoBn.ModuleID = 0;
    MoBn.ModuleName = request.getParameter("ModuleName");
    MoBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( MoBn ))
        {
           MoBn.addRecord();
           MessageText = "One record added. New ID = "+MoBn._autonumber ;
					 
					 
			 SiAuthBn.beginInsert();
			 String coursecsv = getCsvFromQuery("SELECT SQL_CACHE `CourseID` FROM `institute_course`", true) ;
			 String superAdmincsv = getCsvFromQuery("SELECT SQL_CACHE `AdminID` FROM `sitemanager` WHERE `SuperAdminRight` = 1", true) ;
			 for(String s:CSVHelper.stringArrayFromCsv(coursecsv))
       {
			   InCourseBn.locateRecord(Integer.parseInt(s));
    			 for(String sAd:CSVHelper.stringArrayFromCsv(superAdmincsv))
           {
					    SiMngrBn.locateRecord(Integer.parseInt(sAd));
        			SiAuthBn.AuthorizationID= 0;
        			SiAuthBn.InstituteID = InCourseBn.InstituteID;
              SiAuthBn.AdminID = Integer.parseInt(sAd) ;
        		  SiAuthBn.CourseID = Integer.parseInt(s) ;
              SiAuthBn.ModuleID = MoBn._autonumber ;
        			SiAuthBn.ModuleName = MoBn.ModuleName ;
              SiAuthBn.ModuleActivityID = "1,2,3";
        			SiAuthBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
							SiAuthBn.continueInsert();
					 }
			 }	
			 SiAuthBn.endInsert();				 
			 

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
         MoBn.locateRecord(nModuleID);
    //  $CHECK MoBn.ModuleID= nModuleID ;
    /* Auto increment column: 
     try  
      {
           MoBn.ModuleID = Integer.parseInt(request.getParameter("ModuleID")) ;
      } catch( NumberFormatException ex)
     { 
         MoBn.ModuleID = 0 ;
     }
*/
     MoBn.ModuleName = request.getParameter("ModuleName");
    MoBn.UpdateDateTime =  new java.sql.Timestamp(System.currentTimeMillis()); 
 
   
	  if(bAllowUpdate == true)
		{
	      MoBn.updateRecord(nModuleID);
        MessageText = "One record updated. Updated ID = "+nModuleID ;
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
    MoBn.locateRecord(nModuleID);
    // $CHECK
		if(bAllowDelete == true)
		{
       MoBn.deleteRecord(nModuleID);
		    MessageText = "Record Deleted. ID = "+nModuleID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nModuleID ;
        // MoBn.executeUpdate(DelRef);

				
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
	  qStr.addMultiSelectParam("ModuleID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("ModuleID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `module` "+ WhrCls + " ORDER BY `ModuleID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   MoBn.openTable(WhrCls, " ORDER BY `ModuleID` ");
           while(MoBn.nextRow())
           {
					   
           }
					 MoBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = MoBn.executeUpdate( qStr.SQL( "DELETE FROM `module` "+WhrCls+" ") );
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
          String redirect  = "module-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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
else if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;List Of Record" ;
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
	<title>Manage Module</title>

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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Manage Module</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Module</li>
          </ol>			
  	    </div>
  		</div>	

<% if(nAction==NEW_FORM)
{
/* 
Hint: Use this to get form values in case new form is called from serach result.
Place value of form field as item before each field
String item=null;
if(QryObj!=null)item=QryObj.getKey("$Field") ; 
else item="";

*/


%>			
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="module_Add" id="module_Add"   >
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

<div class="row" align="center">
    <div class="form-group col-sm-4 col-sm-offset-4">
	     <label for="ModuleName" class="control-label blue-grey-600" ><%=FieldLabel[MoBn_ModuleName] %></label>
       <input type="text" name="ModuleName" id="ModuleName" class="form-control"  />
	  </div>
 <!-- 
    <div class="form-group col-sm-6">
	    <label for="UpdateDateTime" class="control-label blue-grey-600" ><%=FieldLabel[MoBn_UpdateDateTime] %></label>
		  <input type="text" name="UpdateDateTime" id="UpdateDateTime" class="form-control" />
		</div> -->
<!--  
    <div class="form-group col-sm-6">
    <label for="FirstName" class="control-label blue-grey-600"><%=FieldLabel[MoBn_UpdateDateTime] %></label>
      <div class="input-group input-group-icon" >
        <input type='text' name="UpdateDateTime" id="UpdateDateTime" class="form-control datetimepicker" />
          <span class="input-group-addon"><span class="icon fa fa-clock-o" aria-hidden="true"></span></span>
      </div>
    </div>
-->

</div>
<div class="row" >

</div> <!-- End div class=row -->





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

MoBn.locateRecord(nModuleID);
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="module_Update" id="module_Update"    >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="ModuleID" value="<%=nModuleID %>" />
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



<div class="row">
    <div class="form-group col-sm-6">
	     <label for="ModuleName" class="control-label blue-grey-600" ><%=FieldLabel[MoBn_ModuleName] %></label>
       <input type="text" name="ModuleName" id="ModuleName" class="form-control" value="<%=MoBn.ModuleName %>"  />
	  </div>
 <!-- 
    <div class="form-group col-sm-6">
	    <label for="UpdateDateTime" class="control-label blue-grey-600" ><%=FieldLabel[MoBn_UpdateDateTime] %></label>
		  <input type="text" name="UpdateDateTime" id="UpdateDateTime" class="form-control" value="<%=DateTimeHelper.showDateTimePicker(MoBn.UpdateDateTime) %>"  />
		</div> -->
<!--  
    <div class="form-group col-sm-6">
    <label for="FirstName" class="control-label blue-grey-600"><%=FieldLabel[MoBn_UpdateDateTime] %></label>
      <div class="input-group input-group-icon" >
        <input type='text' name="UpdateDateTime" id="UpdateDateTime" class="form-control datetimepicker" value="<%=DateTimeHelper.showDateTimePicker(MoBn.UpdateDateTime) %>"  />
          <span class="input-group-addon"><span class="icon fa fa-clock-o" aria-hidden="true"></span></span>
      </div>
    </div>
-->

</div>
<div class="row" >

</div> <!-- End div class=row -->





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
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" class="form-horizontal" id="module_Search">
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
<!-- 
      <div class="form-group">
        <label class="control-label blue-grey-600 col-sm-3">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="ModuleID_RNG_CHK" id="ModuleID_RNG_CHK" onchange="CheckSearchRange('ModuleID')"><label for="ModuleID_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="ModuleID_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("ModuleID_OPERATOR", "ModuleID_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="ModuleID" id="ModuleID" class="form-control" /></div>
      	<label class="control-label blue-grey-600 col-sm-1 text-center" id="ModuleID_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="ModuleID_RNG_BLK" style="display:none"><input type="text" name="ModuleID_TO" id="ModuleID_TO" class="form-control" /></div>
      </div>			
 -->

<!-- 
      <div class="form-group">
        <label for="ModuleName" class="col-sm-3 control-label blue-grey-600"><%=FieldLabel[MoBn_ModuleName] %> :</label>
        <div class="col-sm-2"><input type="text" name="ModuleName" id="ModuleName" class="form-control" /></div>
      </div>	
 -->
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600"><%=FieldLabel[MoBn_ModuleName] %> :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("ModuleName_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="ModuleName" id="ModuleName" class="form-control" /></div>
      </div>		
		

      <div class="form-group">
        <label for="OrderBy" class="col-sm-3 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="ModuleID" >ModuleID</option>
      		  <option value="ModuleName" ><%=FieldLabel[MoBn_ModuleName] %></option>		
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
        <label for="ROWS" class="col-sm-3 control-label blue-grey-600">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	
			
</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
					<!-- <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="NavigateTo('<%=appPath %>/admin/index.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
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
     qStr.setTablename(MoBn._tablename);
     // qStr.setOrderByClause(" ORDERBY ? ");
     
		 // Old Code: qStr.addNumberParam("ModuleID") ;
	   if(request.getParameter("ModuleID_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam("ModuleID", "ModuleID", "ModuleID_TO")  ;
		 }
		 else
		 {
		    String  ModuleID_OPERATOR = request.getParameter("ModuleID_OPERATOR");
				qStr.addNumberParam("ModuleID", ModuleID_OPERATOR );
				
		 }
    // Automatically add Foreign Keys in Search Creterion

    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam("$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/
		
		

	 // Old Code: qStr.addStringParam("ModuleName", false);
	  short ModuleName_SEARCHTYPE = RequestHelper.getShort(request, "ModuleName_SEARCHTYPE");
	  qStr.addStringParam("ModuleName", ModuleName_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("ModuleName", true );
	
	 
 		 QryObj.jndidsn  = "jdbc/$DATABASE" ;
     QryObj.table = "module"  ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause  = qStr.getOrderByClause("OrderBy") ;
		 String Sort  = request.getParameter("Sort") ;
	   if(Sort==null ) Sort="ASC" ;
		 QryObj.query =  qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause + Sort ;

     QryObj.count = MoBn.recordCount(WhereClause); 
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


<!-- $CHECK Look for chain -->
<!-- NAVIGATION BAR BEGIN -->
<%@include file="/include-page/master/pagination-header.inc"%>
<!-- NAVIGATION BAR END -->
<% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>

<% 
if(QryObj.count > 0)  
{ 
//  Records are there
%>
 
		

<form action="<%=thisFile %>"  accept-charset="UTF-8" id="module_list" method="post">
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
<table class="table table-bordered table-striped Rslt-Act-tbl" id="module_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="top" data-toggle="tooltip"><input type="checkbox" name="module_Result_checkall" id="module_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>
</th>
<th><%=FieldLabel[MoBn_ModuleName] %></th>

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
	than call :  MoBn.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( MoBn.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/

MoBn.openTable("","");  //WhereClause, OrderByClause 

int n=0;
while(n< QryObj.offset)
{
 n++ ;
 MoBn.skipRow();
} 
 n=0;
sno=QryObj.offset;

while(MoBn.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "Really want to Delete ModuleID : "+MoBn.ModuleID+" " ;
// $CHECK
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="ModuleID" id="ModuleID_<%=MoBn.ModuleID %>"  value="<%=MoBn.ModuleID %>"><label></label></span>&nbsp;&nbsp;
<% } %>

<%=sno %> 
<!-- <button onclick="NavigateTo('<%=thisFile %>?Action=Show&ModuleID=<%=MoBn.ModuleID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button> -->
</td>
<td><%=MoBn.ModuleName %></td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&ModuleID=<%=MoBn.ModuleID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&ModuleID=<%=MoBn.ModuleID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( MoBn.nextRow());
MoBn.closeTable();
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
MoBn.locateRecord(nModuleID);
DelWarning = "Really want to Delete ModuleID : "+MoBn.ModuleID+" " ;
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<!-- <button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button> -->
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&ModuleID=<%=MoBn.ModuleID %>','<%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&ModuleID=<%=MoBn.ModuleID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>
<div class="panel-body panel-form-box-body container-fluid">	



<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-3">
    <h4>ID : <%=MoBn.ModuleID %></h4>
    <!--  uncomment this 
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?ModuleID=<%=MoBn.ModuleID %>">Menu Link 1</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?ModuleID=<%=MoBn.ModuleID %>">Menu Link 2</a>
      </li>
    </ul>		
    </div>		
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
    <tr>
    
     <td><span class="blue-grey-700"><%=FieldLabel[MoBn_ModuleID] %></span></td>
     <td><%=StrValue(MoBn.ModuleID) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[MoBn_ModuleName] %></span></td>
     <td><%=StrValue(MoBn.ModuleName) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[MoBn_UpdateDateTime] %></span></td>
     <td valign="top" > <%=DateTimeHelper.showDateTimePicker(MoBn.UpdateDateTime) %></td> 
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
function ShowNewForm( bVal)
{
  if(bVal)
  {
     $("#new_label").hide();
		 $("#new_form").show();
  }
	else
	{
	  $("#new_label").show();
		$("#new_form").hide();
	}
} 
 

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
	  swal({title: '',text: 'Invalid number entered !',type: 'error',confirmButtonText:'OK'})
		return;
	}
	
  var RepaginateURL = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&RePaginateCount="+nrows ;
	NavigateTo(RepaginateURL);
}




// Support for check boxes in data list.


$("#module_Result_checkall").click(function () {
   if ($("#module_Result_checkall").is(':checked')) {
        $("#module_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $("#module_Result_tbl input[type=checkbox]").each(function () {
        $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='ModuleID']").fieldArray();
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
            $('#module_list' ).submit();
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
     var sel_items_actv = $("input[name='ModuleID']").fieldArray();
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
            $('#module_list' ).submit();
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

  $("#module_Add").validate(); // Please put class="required" in mandatory fields

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  

  $("#module_Update").validate(); // Please put class="required" in mandatory fields

<%
 }
else if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  

  $("#module_Search").validate(); // Please put class="required" in mandatory fields
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
		params: {table:"module",field:"?FieldName"} 
	  });
    */
	
	<% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>


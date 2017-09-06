<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SmBn" scope="page" class="com.db.$DATABASE.Sms_templateBean" />
<%! 
boolean CheckDuplicateEntry(com.db.$DATABASE.Sms_templateBean dbBean )
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


final int SmBn_TemplateID = 0, SmBn_Name = 1, SmBn_Text = 2 ;

String FieldLabel[] = {"TemplateID", "Name", "Text"} ;

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
int nTemplateID = 0;
try
{
   nTemplateID = Integer.parseInt(request.getParameter("TemplateID"));
}
catch(NumberFormatException ex)
{ 
   nTemplateID = 0;
}
SmBn.locateRecord(nTemplateID);

if(nAction==ADD_RECORD)
{

     SmBn.TemplateID= 0;

/* Auto increment column: 
     try  
      {
           SmBn.TemplateID = Integer.parseInt(request.getParameter("TemplateID")) ;
      } catch( NumberFormatException ex)
     { 
         SmBn.TemplateID = 0 ;
     }
*/
     SmBn.Name = request.getParameter("Name");
     SmBn.Text = request.getParameter("Text");


		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( SmBn ))
        {
           SmBn.addRecord();
           MessageText = "One record added. New ID = "+SmBn._autonumber ;
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
         SmBn.locateRecord(nTemplateID);
    //  $CHECK SmBn.TemplateID= nTemplateID ;
    /* Auto increment column: 
     try  
      {
           SmBn.TemplateID = Integer.parseInt(request.getParameter("TemplateID")) ;
      } catch( NumberFormatException ex)
     { 
         SmBn.TemplateID = 0 ;
     }
*/
     SmBn.Name = request.getParameter("Name");
     SmBn.Text = request.getParameter("Text");

   
	  if(bAllowUpdate == true)
		{
	      SmBn.updateRecord(nTemplateID);
        MessageText = "One record updated. Updated ID = "+nTemplateID ;
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
    SmBn.locateRecord(nTemplateID);
    // $CHECK
		if(bAllowDelete == true)
		{
       SmBn.deleteRecord(nTemplateID);
		    MessageText = "Record Deleted. ID = "+nTemplateID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nTemplateID ;
        // SmBn.executeUpdate(DelRef);	
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
	  qStr.addMultiSelectParam(SmBn._tablename, "TemplateID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("TemplateID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `sms_template` "+ WhrCls + " ORDER BY `sms_template`.`TemplateID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   SmBn.openTable(WhrCls, " ORDER BY `TemplateID` ");
           while(SmBn.nextRow())
           {
					   
           }
					 SmBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = SmBn.executeUpdate( qStr.SQL( "DELETE FROM `sms_template` "+WhrCls+" ") );
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
          String redirect  = "sms_template-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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
	<title>SMS Template</title>

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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>SMS Template</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Sms Template</li>
          </ol>			
  	    </div>
  		</div>	

<% if(nAction==NEW_FORM)
{
%>			
<form action="<%=thisFile %>" method="POST" name="sms_template_Add" id="sms_template_Add" accept-charset="UTF-8" >
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

<div class="panel-body panel-form-box-body container-fluid">

<!-- INSERT ADD FROM -->



<div class="row">
    <div class="form-group col-sm-6">
	     <label for="Name" class="control-label blue-grey-600" ><%=FieldLabel[SmBn_Name] %></label>
       <input type="text" name="Name" id="Name" class="form-control"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Text" class="control-label blue-grey-600" ><%=FieldLabel[SmBn_Text] %></label>
			 <textarea rows="2" name="Text" id="Text" class="form-control" data-plugin="maxlength" maxlength="<%=sms_charater_limit %>"></textarea>
	  </div>
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

SmBn.locateRecord(nTemplateID);
%>
<form action="<%=thisFile %>" method="POST" name="sms_template_Update" id="sms_template_Update" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="TemplateID" value="<%=nTemplateID %>" />
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

<div class="panel-body panel-form-box-body container-fluid">
 
<!-- INSERT UPDATE FORM  --> 



<div class="row">
    <div class="form-group col-sm-6">
	     <label for="Name" class="control-label blue-grey-600" ><%=FieldLabel[SmBn_Name] %></label>
       <input type="text" name="Name" id="Name" class="form-control" value="<%=StrValue(SmBn.Name) %>"  />
	  </div>

    <div class="form-group col-sm-6">
	     <label for="Text" class="control-label blue-grey-600" ><%=FieldLabel[SmBn_Text] %></label>
			 <textarea rows="2" name="Text" id="Text" class="form-control" data-plugin="maxlength" maxlength="<%=sms_charater_limit %>"><%=SmBn.Text %></textarea>
	  </div>
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

<% 
if(nAction==SEARCH_RESULT)
{ 
int sno = 0 ;
String WhereClause = "";
String OrderByClause = "";
int RecordCount = SmBn.recordCount(WhereClause);
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
 
		

<form action="<%=thisFile %>" method="post" id="sms_template_list" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>


<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="sms_template_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="sms_template_Result_checkall" id="sms_template_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>&nbsp;
</th>
<th><%=FieldLabel[SmBn_Name] %></th>
<th><%=FieldLabel[SmBn_Text] %></th>

<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>

<th class="text-center">
<!-- for multiselect action -->
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-info"></i></button>
<% if(bAllowDelete == true){ %>
<% if(bResultActionCheckbox == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="left" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-trash"></i></button>
<% } %>
<% } %>&nbsp;
</th>
<% } %>
</tr>
</thead>
<tbody>

<% 
// joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
SmBn.openTable(WhereClause, OrderByClause );  
while(SmBn.nextRow())
{
sno++;
DelWarning = "Really want to Delete TemplateID : "+SmBn.TemplateID+" " ;
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="TemplateID" id="TemplateID_<%=SmBn.TemplateID %>"  value="<%=SmBn.TemplateID %>"><label for="TemplateID_<%=SmBn.TemplateID %>"> <%=sno %></label></span><% }else{ %>
<%=sno %><% } %>

<button onclick="NavigateTo('<%=thisFile %>?Action=Show&TemplateID=<%=SmBn.TemplateID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
</td>
<td><%=SmBn.Name %></td>
	<td><%=SmBn.Text %></td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&TemplateID=<%=SmBn.TemplateID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&TemplateID=<%=SmBn.TemplateID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( SmBn.nextRow());
SmBn.closeTable();
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
SmBn.locateRecord(nTemplateID);
DelWarning = "Really want to Delete TemplateID : "+SmBn.TemplateID+" " ;
%>
		<% if(bAllowAdd == true){ %>
  	<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  	<% } %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&TemplateID=<%=SmBn.TemplateID %>','<%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&TemplateID=<%=SmBn.TemplateID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">


<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-3">
    <h4>ID : <%=SmBn.TemplateID %></h4>
    <!--  uncomment this 
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?TemplateID=<%=SmBn.TemplateID %>">Menu Link 1</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?TemplateID=<%=SmBn.TemplateID %>">Menu Link 2</a>
      </li>
    </ul>		
    </div>		
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
    <tr>
    
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_TemplateID] %></span></td>
     <td><%=StrValue(SmBn.TemplateID) %></td>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_Name] %></span></td>
     <td><%=StrValue(SmBn.Name) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_Text] %></span></td>
     <td><%=StrValue(SmBn.Text) %></td>

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

function InitPage()
{
// Do something on page init
}


// Support for check boxes in data list.


$("#sms_template_Result_checkall").click(function () {
   if ($("#sms_template_Result_checkall").is(':checked')) {
        $("#sms_template_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
        $("#sms_template_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='TemplateID']").fieldArray();
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
            $('#sms_template_list' ).submit();
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
     var sel_items_actv = $("input[name='TemplateID']").fieldArray();
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
            $('#sms_template_list' ).submit();
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

  //fetch_Course(1,<%=nModuleID %>,'NewAct')
  $("#sms_template_Add").validate(); // Please put class="required" in mandatory fields

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
//fetch_Course(1,<%=nModuleID %>,'ChngAct')
  $("#sms_template_Update").validate(); // Please put class="required" in mandatory fields

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


<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page  import="com.webapp.utils.*, com.webapp.jsp.*,com.webapp.db.* " %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%



String appPath = request.getContextPath() ;
String thisFile =appPath+request.getServletPath() ;

String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String IDField  =  request.getParameter("IDField").replace((char)32, '_' );
String IDFieldType = request.getParameter("IDFieldType") ;
String IsAuto = request.getParameter("IsAuto") ;
String WebApp =  request.getParameter("WebApp");
String PageTitle =  request.getParameter("PageTitle") ;
String EntityName = request.getParameter("EntityName") ;
String ScriptFolder = request.getParameter("ScriptFolder");
String AltTxt = request.getParameter("AltTxt") ;
boolean bCheckBox = (request.getParameter("CheckBox") !=null )? true : false ;
String OutputFileName = request.getParameter("OutputFileName") ;
String Action = RequestHelper.paramValue(request, "Action", "Form");

	 String AjaxURL = TableName+"-ajax-quick-update.jsp" ;
	 String JavscriptURL = TableName+"-javascript-quick-update.jsp" ;



  boolean bDataOK = false;
  int count = 0;
	boolean bDateSupport=false;
	boolean  bTimestampSupport=false;
	String PK = "";
	String Database = "";
	
	
	ArrayList<String> DateCols = new ArrayList<String>();
	ArrayList<String> col_list = new ArrayList<String>();
	TreeMap<String, Integer> col_type = new TreeMap<String, Integer>();
	TreeMap<String, String>  col_type_name = new TreeMap<String, String>();
	
  Context env = (Context) new InitialContext().lookup("java:comp/env");
  DataSource source = (DataSource) env.lookup(JNDIDSN);
  Connection conn = source.getConnection();
  // Database=conn.getCatalog();
  String query = BeanwizHelper.openTableSQL(conn, TableName);
  try 
  {
        java.sql.Statement stmt = conn.createStatement();
        java.sql.ResultSet rslt = stmt.executeQuery(query);
        java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
        count  = rsmd.getColumnCount();
				for(int n = 1 ; n <= count ; n++ )
        {	
	         String ColName = rsmd.getColumnName(n) ;
	         String ColType = rsmd.getColumnTypeName(n);
	         int ColSQLType = rsmd.getColumnType(n);
	         if( rsmd.isAutoIncrement(n))PK=ColName; ;
	         if(ColSQLType==java.sql.Types.DATE)
					 {
					    bDateSupport=true;
							DateCols.add(ColName);
					
					 }
	         if(ColSQLType==java.sql.Types.TIMESTAMP)bTimestampSupport=true;
					 col_list.add(ColName);
					 col_type.put(ColName, new Integer(ColSQLType));
					 col_type_name.put(ColName, ColType);
			  }
				
				bDataOK = true;
	}catch(Exception e)
	{
	  %>
		<!DOCTYPE html>

       <html>
        <head>
         <title>ERROR</title>
        </head>
        <body>
       <h2><span class="error">Data Access Error:</span></h2><br/>
		    <%=  e.getMessage() %>
      </body>
</html>

		
		
	  <%
	}
	finally
	{
	  conn.close();
	}
  


if(bDataOK )
{
 // Page generate Code
   
   String ContentType = "application/x-download" ;
   String ContentDisp = "attachment; filename="+TableName+"-quick-field-update.jsp";	
   response.setContentType(ContentType);
   response.setHeader("Content-Disposition", ContentDisp);
   
   String[] ShowColumnNames = request.getParameterValues("ShowColumnNames");
	 String[] UpdateColumnNames = request.getParameterValues("UpdateColumnNames");
	 
	 
	 

 %>
<jsp:include page="../directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /></jsp:include>
<% out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n"); %>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String WaitCur=appPath+"/scripts/jedit/wait.gif" ;
String CalendarImage=appPath+"/scripts/datepicker/calendar.gif" ;
String WhereClause = RequestHelper.getBase64param(request, "WhereClause"); 
if(WhereClause == null) WhereClause = " ";

int nCount = RequestHelper.getInteger(request, "Count" );

 %> 
<!DOCTYPE html>

<html>
<head>
<title>Update Fields Quickly</title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
<!-- 
 
 /* jEditable classes for each editable column */
 <% 
 for(String s:UpdateColumnNames)
 { 
    s=s.replace(" ", "_"); 
 %>.edit_<%=s %> {  background-color: #ffebd7;}
 <% 
 } 
 %>
 
 
 .datalist th { font-size:10pt ;}
 .datalist td { font-size:10pt ;}
 .displaycol { background-color: #e1e1e1;}
 .updatecol {background-color: #ffebd7; }
 
-->
</style>
<% 
out.println("<jsp:include page=\"/scripts/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\"/scripts/jvalidate/jvalidate.jsp\" flush=\"true\" />");
if(bDateSupport) out.println("<jsp:include page=\"/scripts//datepicker/datepicker.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\"/scripts/jedit/jedit.jsp\" flush=\"true\" />");
 %>
 
<% 
if(bDateSupport)
{ 
%>
<!-- {{ Date Control Support in jEditable Start -->

  <script type="text/javascript">
  <!--
  // Extend jEditable with Date Picker
  jQuery.expr[':'].focus = function( elem ) {
    return elem === document.activeElement && ( elem.type || elem.href );
  };
  
  $.editable.addInputType( 'datepicker', {
  
      /* create input element */
      element: function( settings, original ) {
        var form = $( this ),
            input = $( '<input />' );
        input.attr( 'autocomplete','off' );
        form.append( input );
        return input;
      },
      
      /* attach jquery.ui.datepicker to the input element */
      plugin: function( settings, original ) {
        var form = this,
            input = form.find( "input" );
  
        // Don't cancel inline editing onblur to allow clicking datepicker
        settings.onblur = 'nothing';
  
        datepicker = {
          onSelect: function() {
            // clicking specific day in the calendar should
            // submit the form and close the input field
            form.submit();
          },
          dateFormat: 'dd/mm/yy',
  				yearRange: '1950:2100',
          onClose: function() {
            setTimeout( function() {
              if ( !input.is( ':focus' ) ) {
                // input has NO focus after 150ms which means
                // calendar was closed due to click outside of it
                // so let's close the input field without saving
                original.reset( form );
              } else {
                // input still HAS focus after 150ms which means
                // calendar was closed due to Enter in the input field
                // so lets submit the form and close the input field
                form.submit();
              }
              
              // the delay is necessary; calendar must be already
              // closed for the above :focus checking to work properly;
              // without a delay the form is submitted in all scenarios, which is wrong
            }, 150 );
          }
        };
      
        if (settings.datepicker) {
          jQuery.extend(datepicker, settings.datepicker);
        }
  
        input.datepicker(datepicker);
      }
  } );
  
  
  // -->
  </script>

<!-- }} Date Control Support in jEditable End   -->
<% 
} 
%>
 
 
 
<script type="text/javascript">
<!--

function NavigateTo(url)
{ 
    document.location.href = url ;
}
/* 
   Javascripts for in place edit controls 
   Create seperate editable function for each table field
*/
<% 
 int itr=0;
 for(String s:UpdateColumnNames)
 { 
   String col_name =s.replace(" ", "_"); 
  itr++ ;
 %>
 /* --------- ( <%=itr %> ) Edit Functions For Column:- <%=s %> Start */
 function CreateEdit<%=s %>()
 {
 
   $(".edit_<%=col_name %>").editable(OnEdit<%=col_name %>, { 
               indicator : "<img src='<\%=WaitCur %>'>",
               tooltip   : "Please click here to edit the result ...",
               event     : "dblclick",
							 <% if(DateCols.contains(col_name)) { %>type      : "datepicker", <% } %>
			         width : '80',
			         height :'20',
			         submit  : "OK",
			         placeholder: "No data ...",
               style  : "display: inline"  
	      });
 
 } // End function - CreateEdit<%=s %>()
 
 
 function OnEdit<%=col_name %>(value, setting)
 {
      var ID="#"+this.id ;
	    var oldval = $(ID).data("OldVal");
	    var field  = $(ID).data("Field");
	    var idvalue  = $(ID).data("<%=IDField %>");
		  if( value==null && value.length ==0 )
		  {
		       alert("Field value can not be blank!");
			     return oldval ;
		  }
		  
			<% 
			if(DateCols.contains(col_name)) 
			{ 
			%>
       var dateval ="";
			 var parts = value.split("/");
			 if(parts.length!=3)
			 {
			    alert("Invalid date value entered.")
			 }
			 dateval=parts[2]+"-"+parts[1]+"-"+parts[0];
		   var ajaxurl = "members-ajax-quick-update.jsp?MemberID="+idvalue+"&Field="+field+"&Value="+dateval  ;
			<% 
			}
			else
			{ 
			%>
		  var ajaxurl = "<%=AjaxURL %>?<%=IDField %>="+idvalue+"&Field="+field+"&Value="+value  ;
		  <% 
			} 
			%>
		  var retval = oldval ;
	    $.ajax(ajaxurl, {
                 dataType: 'json',
                 async: false
                 }).done(function(data){
					            if(data.Status == "Ok")
    			            {
    			                retval = value ;
    			            }
    			            else
    			            {
    			                 alert("Update error: "+data.Error);
    			            }
					      }).fail(function(data){
					             alert("HTTP Ajax request failed.");
					      });
		  return retval;
 }  // End function - OnEdit<%=s %>(value, setting)
 
/* ------- ( <%=itr %> )  Edit Functions For Column :- <%=s %> End */ 
 
 <% 
 } 
 %>


$(document).ready(function(){
// {{ Begin Init jQuery 
	   
// ------- Call in place edit creator functions for each editable column
<% 
 for(String s:UpdateColumnNames)
 { 
    s=s.replace(" ", "_"); 
%>   CreateEdit<%=s %>();
<% 
 } 
 %>
//------- 
      
			 
 // }} End Init jQuery 
});

// -->
</script>
</head>
<body class="main">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block"> 
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
<td valign="top" width="70%"><span class="title">Update Data Fields</span><br/>
<b>Double click on <span style=" background-color: #ffebd7; ">&nbsp;highlighted&nbsp;</span> field to update.</b>
</td>
<!-- <td valign="top" width="30%">?</td> -->
<td valign="top" width="30%">&nbsp;</td>
</tr>
</table>
<div>
<div id="maindiv">
<table border="1" cellpadding="6" cellspacing="0" summary="" class="datalist" width="100%">
<thead>
<tr>
 <th valign="top">S.No</th>
  <!-- Display fields -->
 <% 
 if(ShowColumnNames!=null)
 {
    for(int i =0 ; i < ShowColumnNames.length; i++)
    { %><th valign="top" class="displaycol"><%=ShowColumnNames[i] %></th><%
    }
 } %>
 <!-- Update Fields -->
  
 <% 
 if(UpdateColumnNames!=null)
 {
    for(int i =0 ; i < UpdateColumnNames.length; i++)
    { %><th valign="top" class="updatecol"><%=UpdateColumnNames[i] %></th><%
    }
 } %>


</tr>

</thead>
<tbody>
<\% 
   int no=0;
	 String FLDID = "" ;
	 <%=BeanName %>.openTable(WhereClause, " ");
	 while(<%=BeanName %>.nextRow())
	 {
	   no++;
 %>
    <tr>
		   <td><\%=no %></td>
			  <!-- Display fields -->
        <% 
				
				  String ColVarName = "" ;
					

          if(ShowColumnNames!=null)
          {
					 
						
           for(int i =0 ; i < ShowColumnNames.length; i++)
           {
					  ColVarName =  BeanName+"."+ShowColumnNames[i];
						ColVarName = ColVarName.replace(" ", "_");
						
					 
					  %>
					 <td valign="top" class="displaycol"><\%=<%=ColVarName %> %></td>
					 <%
           }
          } %>
 <!-- Update Fields -->
  
         <% 
         if(UpdateColumnNames!=null)
         {
            for(int i =0 ; i < UpdateColumnNames.length; i++)
            { 
				         ColVarName =  BeanName+"."+UpdateColumnNames[i];
						     ColVarName = ColVarName.replace(" ", "_");  
								 
								 String ColName =  UpdateColumnNames[i].replace(" ", "_");
						
						       
						
						     if(DateCols.contains(UpdateColumnNames[i])) 
			           { 
						     %>
						      <\% 
						        FLDID = ""+<%=BeanName %>.<%=IDField %>+"_<%=UpdateColumnNames[i] %>";
										String Show_<%=ColName %> = DateHelper.showDate(<%=ColVarName %>);
						      %>
                  <td valign="top" class="updatecol"><span class="edit_<%=ColName %>" id="<\%=FLDID %>"><\%=Show_<%=ColName %>%></span></td>
                  <script type="text/javascript">
                  <!--
                  $("#<\%=FLDID %>").data("Field","<%=UpdateColumnNames[i] %>");
                  $("#<\%=FLDID %>").data("<%=IDField %>","<\%=<%=BeanName %>.<%=IDField %> %>");
                  $("#<\%=FLDID %>").data("OldVal","<\%=Show_<%=ColName %> %>");
                 // -->
                 </script>
                 <%						
						     }
                 else
                 {
                 %>
						      <\% 
						        FLDID = ""+<%=BeanName %>.<%=IDField %>+"_<%=UpdateColumnNames[i] %>";
						      %>
                  <td valign="top" class="updatecol"><span class="edit_<%=ColName %>" id="<\%=FLDID %>"><\%=<%=ColVarName %> %></span></td>
                  <script type="text/javascript">
                  <!--
                  $("#<\%=FLDID %>").data("Field","<%=UpdateColumnNames[i] %>");
                  $("#<\%=FLDID %>").data("<%=IDField %>","<\%=<%=BeanName %>.<%=IDField %> %>");
                  $("#<\%=FLDID %>").data("OldVal","<\%=<%=ColVarName %> %>");
                 // -->
                 </script>
                 <%								 
                 }
						
            }
         } 
				 %>
</tr>
   
 <\% 
   } // end while
	 <%=BeanName %>.closeTable();
  %>

</tbody>
</table>

</div><!-- end div # maindiv -->
</body>
</html>


 
<%

}
else 
{

%>
<!DOCTYPE html>

       <html>
        <head>
         <title>ERROR</title>
        </head>
        <body>
       <h2><span class="error">Data Access Error:</span></h2><br/>
		     
				This error should not occur, please report.
      </body>
</html>

<% 
} 
%>
 
<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page  import="com.webapp.utils.*, com.webapp.jsp.*,com.webapp.db.* " %><jsp:useBean id="FieldLabelMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%


String appPath = request.getContextPath() ;
String thisFile =appPath+request.getServletPath() ;


String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;
String IDField  =  request.getParameter("IDField").replace((char)32, '_' );
String IDFieldType = request.getParameter("IDFieldType") ;
String IsAuto = request.getParameter("IsAuto") ;
String WebApp =  request.getParameter("WebApp");
String PageTitle =  request.getParameter("PageTitle") ;
String EntityName = request.getParameter("EntityName") ;
boolean bCheckBox = (request.getParameter("CheckBox") !=null )? true : false ;
String OutputFileName = request.getParameter("OutputFileName") ;
String LoginFolderName = request.getParameter("LoginFolderName") ;
boolean bConfigSMS = (request.getParameter("ConfigSMS") !=null )? true : false ;

String Action = RequestHelper.paramValue(request, "Action", "Form");
boolean bDataOK = false;
  int count = 0;
	boolean bDateSupport=false;
	boolean  bTimestampSupport=false;
	String PK = "";
	String Database = "";
	
	ArrayList<String> col_list = new ArrayList<String>();
	TreeMap<String, Integer> col_type = new TreeMap<String, Integer>();
	TreeMap<String, String>  col_type_name = new TreeMap<String, String>();
	
  Context env = (Context) new InitialContext().lookup("java:comp/env");
  DataSource source = (DataSource) env.lookup(JNDIDSN);
  Connection conn = source.getConnection();
  Database=conn.getCatalog();
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
	         if(ColSQLType==java.sql.Types.DATE) bDateSupport=true;
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
       <h2><span class="error">Error:</span></h2><br/>
		    <%=  e.getMessage() %>
      </body>
    </html>

		
		
	  <%
	}
	finally
	{
	  conn.close();
	}



if("Generate".equalsIgnoreCase(Action) && bDataOK )
{
   String ContentType = "application/x-download" ;
   String ContentDisp = "attachment; filename="+TableName+"-data-matrix.jsp";	
   response.setContentType(ContentType);
   response.setHeader("Content-Disposition", ContentDisp);
 
  String MatrixColumnNames[] = request.getParameterValues("MatrixColumnNames");

%><jsp:include page="include-page/directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /><jsp:param name="ConfigSMS" value="<%=bConfigSMS %>" /></jsp:include>
<% 
if(LoginFolderName.equalsIgnoreCase("admin")) 
{
out.print("<jsp:useBean id=\"SiMngrBn\" scope=\"page\" class=\""+BeanPackage+".SitemanagerBean\" />\r\n"); 
out.print("<jsp:useBean id=\"InCourseBn\" scope=\"page\" class=\""+BeanPackage+".Institute_courseBean\" />\r\n");
out.print("<jsp:useBean id=\"SemBn\" scope=\"page\" class=\""+BeanPackage+".Institute_course_semesterBean\" />\r\n");
}
else if(LoginFolderName.equalsIgnoreCase("student")) 
{
out.print("<jsp:useBean id=\"CanBn\" scope=\"page\" class=\""+BeanPackage+".CandidateBean\" />\r\n");
}
out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n");
// out.print("<jsp:useBean id=\"AppRes\" scope=\"application\" class=\""+WebApp+".ApplicationResource\" />\r\n");
%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<%=WebApp %>.LoggedSitemanager LogUsr =  (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<%=WebApp %>.LoggedCandidate LogUsr =  (<%=WebApp %>.LoggedCandidate)session.getAttribute("theCandidate") ;
CanBn.locateRecord(LogUsr.CandidateID);
<% }else{ %>
<%=WebApp %>.LoggedSitemanager LogUsr =  (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% } %>
String WhereClause = RequestHelper.getBase64param(request, "WhereClause"); 
if(WhereClause == null) WhereClause = " ";

String ParamWhere = request.getParameter("WhereClause");
int nCount = RequestHelper.getInteger(request, "Count" );

String Action = RequestHelper.paramValue(request, "Action", "Form"); // Other action: Update
%>
<\%@include file="/<%=LoginFolderName %>/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <% out.print("<jsp:include page =\"/include-page/common/meta-tag.jsp\" flush=\"true\" />"); %>
<title><%=PageTitle%></title>
  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>

  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
</head>
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<body class="<\%=menuTypeClass %> <\%=CanBn.LoginRole %>" onload="InitPage()" >
<% }else{ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% } %>

  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/nav-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/menu-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuTitle\" value=\"???\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuLink\" value=\"???\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=PageTitle%></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<\%=appPath %>/<%=LoginFolderName %>/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active"><%=CTableName %></li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />


<!-- // ICON fa fa-area-chart | fa fa-bar-chart | fa fa-bar-chart-o | fa fa-line-chart | fa fa-pie-chart -->			
<div class="row" >
<\%  
GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
genqry.beginExecute();
%>
<% 
for(int i=0 ; i < MatrixColumnNames.length ; i++)
{ 
  String ColName = MatrixColumnNames[i] ;
%>
    <div class="col-sm-6">
    	<div class="panel panel-bordered panel-primary" data-mh="my-group">
    		<div class="panel-heading">
    			<h3 class="panel-title"><i aria-hidden="true" class="icon fa fa-bar-chart"></i><%=ColName %></h3>
          <div class="panel-actions">
						<a class="panel-action icon wb-close" aria-hidden="true" data-toggle="panel-close"></a>
          </div>
    		</div>
    		<div class="panel-body">
           <div class="table-responsive">
           <table class="table table-bordered table-striped table-hover">
					 <thead>					 
				   <tr>
				   <th>Item</th>
				   <th>Count</th>
				   </tr>
					 </thead>
					 <tbody>
           <\% 
           String Qry_<%=ColName %> = " SELECT `<%=ColName %>`, COUNT(*) AS `CNT` FROM `<%=TableName %>` "+WhereClause+" GROUP BY `<%=ColName %>` " ;
           genqry.continueExecute(Qry_<%=ColName %>);
           ResultSet rs_<%=ColName %> = genqry.getLastResultSet();
			      
     			 while(rs_<%=ColName %>.next())
           {
              String item = rs_<%=ColName %>.getString(1);
              int count = rs_<%=ColName %>.getInt(2);
           %>
              <tr>
                  <td  valign="top"  ><\%=item %></td>
                  <td  valign="top"  ><\%=count %></td>
              </tr>
	         <\%
           } // end while
		 			 %>
					 </tbody>
           </table>
					 </div>
    		</div>
    	</div>
		</div>
<% 
} 
%> 
 
<\% 
genqry.beginExecute();
%>
</div>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/footer.jsp\" flush=\"true\" />"); %>
	 
  <% out.print("<jsp:include page =\"/include-page/js/main-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
	<% out.print("<jsp:include page =\"/include-page/js/matchheight-js.jsp\" flush=\"true\" />"); %>
	<script src="<\%=appPath %>/global/js/components/panel.min.js"></script>
	
<script>
function InitPage()
{
// Do something on page init
}
</script>
	<% out.print("<jsp:include page =\"/include-page/common/Google-Analytics.jsp\" flush=\"true\" />"); %>


</body>
</html> 
<%
}
else if ("Form".equalsIgnoreCase(Action) && bDataOK )
{
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Generate Data Matrix Page</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />

</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">

<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Generate Data Matrix Page</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
  </div>
</div>
<hr class="pageheaderHR" />

<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Table : </span><span class="text-muted"><%=Database %>.<%=TableName %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>

</div>		
			
<div class="row">
  <div class="col-md-6 col-md-offset-3">

      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Data Matrix Page</h3>
        </div>
        <div class="panel-body">

<form class="form-horizontal" action="<%=thisFile %>" method="post">
<input type="hidden" name="Action" value="Generate" />
				<input type="hidden" name="BeanClass" value="<%=BeanClass%>" />
				<input type="hidden" name="WebApp" value="<%=WebApp%>" />
				<input type="hidden" name="BeanPackage" value="<%=BeanPackage%>" />
				<input type="hidden" name="TableName" value="<%=TableName%>" />
				<input type="hidden" name="IsAuto" value="<%=IsAuto%>" />
				<input type="hidden" name="IDField" value="<%=IDField%>" />
				<input type="hidden" name="OutputFileName" value="<%=OutputFileName%>" />
				<input type="hidden" name="PageTitle" value="<%=PageTitle%>" />
				<input type="hidden" name="EntityName" value="<%=EntityName%>" />
				<input type="hidden" name="DriverName" value="<%=DriverName%>" />
				<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN%>" />
				<input type="hidden" name="IDFieldType" value="<%=IDFieldType%>" />
				<input type="hidden" name="BeanName" value="<%=BeanName%>" />
				<input type="hidden" name="LoginFolderName" value="<%=LoginFolderName%>" />
				

  <div class="form-group">
    <label for="MatrixColumnNames" class="col-sm-3 control-label">Table Field List</label>
    <div class="col-sm-9">
						 				 <select name="MatrixColumnNames" id="MatrixColumnNames" class="form-control selectpicker" multiple="multiple" >
				               <% 
					                 for(int i=0; i<col_list.size(); i++)
					                 {
					                    String cname = col_list.get(i);
						                  String ctyp = col_type_name.get(cname);
						               %><option value="<%=cname %>"><%=cname %>&nbsp;&nbsp;[ <%=ctyp %> ]</option>
						               <%
					                 }// end for
					             %>
				   
				             </select>
    </div>
  </div>
				
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button type="submit" class="btn btn-primary"><i class="fa fa-check"></i>&nbsp;&nbsp;Generate</button>
    </div>
  </div>
				
</form>

      </div>			
	  </div>
  </div>
</div>
</div>
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

</body>
</html>
<% 

} // end if("Generate".equalsIgnoreCase(Action))

%>

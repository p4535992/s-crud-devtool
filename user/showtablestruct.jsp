<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" />

<%
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String Database = null ;
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
try 
{
   Database=conn.getCatalog();
	 if(Database == null )
   {
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
   }
	 //if(Database ==null) 
   java.sql.Statement stmt = conn.createStatement();
   java.sql.ResultSet rslt = null ;
   String OpenTableQry = BeanwizHelper.openTableSQL(conn, TableName);
   rslt = stmt.executeQuery(OpenTableQry); 
   java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
   int count  = rsmd.getColumnCount();
%>

<div class="table-responsive">
<table class="table table-striped table-bordered">
<tr>
<thead>
<th>#</th>
<th>Column Name</th>
<th>Data Type</th>
<th>Size</th>
<th>JDBC Type</th>
<th>Set as ID</th>
</thead>
</tr>
<tbody>

<%

for(int n = 1 ; n <= count ; n++ )
{	
	 String ColName = rsmd.getColumnName(n) ;
	 String ColSQLType = rsmd.getColumnTypeName(n);
	 int nJdbcType =  rsmd.getColumnType(n);
	 int Pr = rsmd.getPrecision(n);
	 int Sc = rsmd.getScale(n);
	 String Auto =  ( rsmd.isAutoIncrement(n)) ? "<span class='label label-default'>AUTO</span>" : " " ;
   boolean bOverride = false;
	 String col_key = Database+"."+TableName+"."+ColName ;
	 if( OverrideMap !=null && OverrideMap.containsKey(col_key))
	 {
	    bOverride=true;
			try
			{
			    nJdbcType = Integer.parseInt( (String)OverrideMap.get(col_key) );
			}catch(NumberFormatException ex)
			{
			  // revert back to original type
			   nJdbcType = rsmd.getColumnType(n);
			}
			ColSQLType=ColTypeOverride.typeLabel(nJdbcType) ;
	 }
   
	 
	  
%>

<tr <% if(bOverride){ %> style="background-color: #eaffd5;"  <%}%> >
<td><%=n %></td>
<td><%=ColName %>&nbsp;&nbsp;<%=Auto %></td>
<td><a href="javascript:void(0)" onclick="ShowOverrideDialog('<%=ColName %>' , '<%=col_key %>' , '<%=ColSQLType %>')"> <small><%=ColSQLType %></small></a></td>
<td><% if(bOverride){ %> <small>Overridden</small> <% }else{ %> <%=Pr %> , <%=Sc %> <% } %></td>
<td><%=nJdbcType %></td>
<td><a href="#" onclick="{  $('#IDField').val('<%=ColName %>') ; } ">Set as Id</a></td>
</tr>
<%	 
}// end for(int n = 1 ; n <= count ; n++ ) 
}	 
finally
{
conn.close();
} 
%>
</tbody>
</table>
</div>


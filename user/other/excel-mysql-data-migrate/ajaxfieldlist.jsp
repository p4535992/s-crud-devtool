<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.sql.*, javax.sql.*, javax.naming.*, com.beanwiz.*, com.webapp.utils.*, com.webapp.resin.*, com.webapp.jsp.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<% 
    response.setDateHeader("Expires", 0 );
    response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
    response.setHeader("Pragma", "no-cache"); 

		
		String JNDIDSN = request.getParameter("JNDIDSN");
	  String TableName = request.getParameter("TableName") ;
		
		Context env = (Context) new InitialContext().lookup("java:comp/env");
    DataSource source = (DataSource) env.lookup(JNDIDSN);
    Connection conn = source.getConnection();
   // com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
    String query =  BeanwizHelper.openTableSQL(conn, TableName);
		
		java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet rslt = stmt.executeQuery(query);
	  java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
		int count  = rsmd.getColumnCount();	
%>
<div class="table-responsive">	
<table class="table table-striped table-bordered table-condensed">
<tr>
<%  
		for(int n = 1 ; n <= count ; n++ )
    {	
	     String ColName = rsmd.getColumnName(n) ;
			 String TypName = rsmd.getColumnTypeName(n);
       int Len = rsmd.getPrecision(n);
%>

<td><b><%=ColName %></b></td>
<td><%=TypName %></td>
<td><%=Len %></td>

<% if(n%3 ==0 ) out.print("</tr><tr>");  %> 		 
<%  
    }
%>
</tr>
</table>
</div>
<%  			
		rslt.close();
		stmt.close();
		conn.close();               
%>
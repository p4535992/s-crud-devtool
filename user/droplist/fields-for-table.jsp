<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, javax.sql.*, nu.xom.*, com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %><%@ page import="javax.naming.*" %><% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String ElementID = request.getParameter("ElementID");

String ElementName = request.getParameter("ElementName");
if(ElementName == null) ElementName = "TableField" ;
String ElementClass = request.getParameter("ElementClass");
String Cls = ( ElementClass!=null )? " class=\""+ElementClass+"\" " : " ";
String JNDIDSN =  request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");

if(ElementID == null) ElementID = ElementName+"_DROP_LIST" ;

%>
<select name="<%=ElementName %>" id="<%=ElementID %>" <%=Cls %> >
 <option value="">-- None Selected --</option>
<% 
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
String query =  BeanwizHelper.openTableSQL(conn, TableName);
String Select = request.getParameter("Select");


try 
{
      java.sql.Statement stmt = conn.createStatement();
      java.sql.ResultSet rslt = stmt.executeQuery(query);
      java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
      int count  = rsmd.getColumnCount();	
      
      for(int n = 1 ; n <= count ; n++ )
      {	
	         int sqltype = rsmd.getColumnType(n);
	         String GetMethod = "";
	         String ColName = rsmd.getColumnName(n) ;
					 String ColTypName = rsmd.getColumnTypeName(n);
					 String sel_string = " ";
					 if(Select!=null && Select.equalsIgnoreCase(ColName)) sel_string = "selected=\"selected\"" ;

 %>     <option value="<%=ColName %>" <%= sel_string %> ><%=ColName %> ( <%=ColTypName %> )</option>
<% 
      }// end for(int n = 1 ; n <= count ; n++ ) 
      stmt.close();
	
}
finally
{
 	 conn.close();
}

 %>

</select>

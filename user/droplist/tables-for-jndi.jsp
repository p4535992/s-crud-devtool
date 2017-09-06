<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, javax.sql.*, nu.xom.*, com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %><%@ page import="javax.naming.*" %>
<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String ElementID = request.getParameter("ElementID");
if(ElementID == null) ElementID = "TABLE_DROP_LIST" ;
String ElementName = request.getParameter("ElementName");
if(ElementName == null) ElementName = "TableName" ;
String ElementClass = request.getParameter("ElementClass");
if(ElementClass == null) ElementClass = "form-control" ;
//String Cls = ( ElementClass!=null )? " class=\""+ElementClass+"\" " : "  ";
String JNDIDSN =  request.getParameter("JNDIDSN");
String[] exld = null ;

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn) ;
try
{

 DatabaseMetaData md=conn.getMetaData();

switch(psql.getEngine())
{
  case PortableSQL.ORACLE:
  exld =  new String[]  { "DR$", 	"WWV_" , "BIN$", "OGIS_" , "SDO_", "AUDIT_ACTIONS", "ODCI_",	"OL$" , 
	"XDB$", "DUAL", "IMPDP_STATS", "KU$NOEXP_TAB", "PLAN_TABLE$", "PSTUBTBL",  "STMT_AUDIT_OPTION_MAP", 
	"SYSTEM_PRIVILEGE_MAP", "TABLE_PRIVILEGE_MAP", "WRI$_ADV_ASA_RECO_DATA" , "DEF$_TEMP$LOB", "HELP"  } ;
	
  break ;
}




 %>
 <select class="<%=ElementClass %>" name="<%=ElementName %>" id="<%=ElementID %>"    >
  <option value="">-- None Selected --</option>
 <% 
 String[] tbl_types = {"TABLE"} ;
java.sql.ResultSet rsltList = md.getTables(null,null,null,tbl_types );
int no=0;
while(rsltList.next())
   { 
	      
		String TableName = rsltList.getString("TABLE_NAME");	
		// Check in exlusion list
		boolean bNotThere = true ;
		  
			if(exld != null)
			{
		           for(int i=0 ; i< exld.length ; i++) 
			         {
			            if( TableName.startsWith(exld[i]) ) bNotThere = false ;
			         }
		  }
		
		
	          if(bNotThere)
		        {	
			           no++;

 
  %>      <option value="<%=TableName %>">  <%=TableName %> </option>
 <% 
          } // end if (bNotThere)
    } // end while while(rsltList.next())
rsltList.close();		

 
  %>
 
 </select>
<% 

  
}
finally
{
conn.close();
}

%>



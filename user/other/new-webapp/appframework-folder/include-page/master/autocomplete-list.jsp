<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%><%@ page import="java.sql.*, org.json.simple.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*" %>
<% 

ResponseHelper.nocache(response);

String dsn = request.getParameter("DSN");
if(dsn==null || dsn.length()==0) dsn = ApplicationResource.database ;
String table = request.getParameter("table");
String field = request.getParameter("field");
String query = request.getParameter("query");

boolean bOK = (dsn!=null && dsn.length()>0 && table!=null && table.length()>0 && field!=null && field.length() > 0 && query!=null && query.length()>0  )?true:false;
JSONArray list = new JSONArray();
String sqlquery = "";

if(bOK)
{
    try
    {
      GenericQuery genqry = new GenericQuery(dsn, application);
    	sqlquery = " SELECT SQL_CACHE DISTINCT(`"+field+"`)  FROM `"+table+"`  WHERE `"+field+"` LIKE '"+query+"%' ORDER BY `"+field+"` "; 
    	ResultSet rslt = genqry.openQuery(sqlquery);
			while(rslt.next())
			{
			  String item = rslt.getString(1);
				list.add(item);
			
			}
			
			genqry.closeQuery();
			
    
    
    }
    catch(Exception ex)
    {
     out.print( ex.getMessage());
    
    }
}

 

JSONObject obj=new JSONObject();
obj.put("suggestions",list);
obj.writeJSONString(out);


 %>
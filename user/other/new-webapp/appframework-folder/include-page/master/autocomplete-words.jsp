<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%><%@ page import="java.sql.*,java.util.*, org.apache.commons.lang3.*, org.json.simple.*, com.webapp.utils.*, com.webapp.jsp.* com.webapp.db.*" %>
<% 

ResponseHelper.nocache(response);

String dsn = request.getParameter("DSN");
if(dsn==null || dsn.length()==0) dsn = ApplicationResource.database ;
String table = request.getParameter("table");
String field = request.getParameter("field");
String query = request.getParameter("query");

String[] fields = null;
if(field !=null) fields = field.split(",");
int i =0;
for(i=0; i<fields.length; i++) fields[i] = fields[i].trim();


String regxp = "[\\s\\.,\\&\\(\\)':]+" ;

boolean bOK = (dsn!=null && dsn.length()>0 && table!=null && table.length()>0 && field!=null && field.length() > 0 && query!=null && query.length()>0  )?true:false;
JSONArray list = new JSONArray();
String sqlquery = "";



if(bOK)
{
    try
    {
      GenericQuery genqry = new GenericQuery(dsn, application);
			
			StringBuilder sbWhere = new StringBuilder(" WHERE ");
			StringBuilder sbFlds = new StringBuilder();
			for(i=0; i<fields.length ; i++)
			{
			  if(i>0) sbWhere.append(" OR ");
				if(i>0) sbFlds.append(" , ");
				sbWhere.append(" `"+fields[i]+"` LIKE '%"+query+"%' ");
				sbFlds.append("`"+fields[i]+"`");
			}
			
			
    	sqlquery = " SELECT "+sbFlds.toString()+"   FROM `"+table+"` "+sbWhere.toString()+"   "; 
    	ResultSet rslt = genqry.openQuery(sqlquery);
			while(rslt.next())
			{
			  StringBuilder  fieldvalue = new StringBuilder();
				for(i=0; i<fields.length ; i++)
			  {
				  fieldvalue.append(" ");
					fieldvalue.append( rslt.getString(fields[i]) );
			  }
				
				
				String[] items = fieldvalue.toString().split(regxp);
				for(String item:items)
				{
				  if( StringUtils.startsWithIgnoreCase( item,  query) ) //contains - item.startsWith(query)
					{
					   if(!list.contains(item)) list.add(item); 
					} 
				}
			
			}
			
			genqry.closeQuery();
			
    
    
    }
    catch(Exception ex)
    {
     out.print( ex.getMessage());
    
    }
}
Collections.sort(list);
 

JSONObject obj=new JSONObject();
obj.put("suggestions",list);
obj.writeJSONString(out);


 %>
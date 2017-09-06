<%@ page import="java.io.*"%><%@ page import="java.util.*, org.json.simple.*, org.json.simple.parser.*,"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><jsp:useBean id="ItemList" scope="session" class="TreeMap<Integer, JSONObject>" /><%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String ClassName = request.getParameter("ClassName");
String PackageName = request.getParameter("PackageName");
response.setContentType("text/plain");
 %>package <%=PackageName %> ;
import java.util.* ;
 
public class <%=ClassName %>
{
<% 
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
%>     public static final short <%=Fld %> = <%=Val %> ;
<%     
      }
%>
     
     public static String getLabel(short item)
     {
          String ret="";
          switch(item)
          {
<% 
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
%>            case  <%=Fld %>:
                ret = "<%=Lbl %>" ;
            break;
<%     
      }
%>				 
          } // end switch case
          return ret ;
     } // End  getLabel(short item)
		 
		 
		 
		 
     public static String getDropList(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\""+Elm+"\"  >\r\n");
          sb.append("    <option value=\"\"> [ None Selected ] </option>\r\n");				
<% 
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 %>          sb.append("<option value=\""+<%=Fld %>+"\""+( (item ==  <%=Fld %> ) ? sel :" " )+" ><%=Lbl %></option>\r\n") ;     
<% 
			} 
%>          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item)		 

     public static String getDropList(String Elm, short item, String none_label )		 
     {
		      String nonelbl = (none_label!=null)? none_label: "None Selected" ;
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\""+Elm+"\"  >\r\n");
          sb.append("    <option value=\"\"> [ "+nonelbl+" ] </option>\r\n");				
<% 
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 %>          sb.append("<option value=\""+<%=Fld %>+"\""+( (item ==  <%=Fld %> ) ? sel :" " )+" ><%=Lbl %></option>\r\n") ;     
<% 
			} 
%>          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
		 
		 
		 
     public static String getRadioButtons(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
<% 
      int i=0;
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 
			 if(i>0){%>          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
<%}			 %>          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+<%=Fld %>+"\""+( (item ==  <%=Fld %> ) ? chk :" " )+"  />&nbsp;<%=Lbl %>\r\n");   
<% 
		   i++;
			} 
%>          return sb.toString();				
     }	// End method: getRadioButtons(String Elm, short item)		 

     public static String getCheckBoxes(String Elm, String selCsv)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          HashSet<Short> hs = new HashSet();
          if(selCsv!=null && selCsv.length()>0)
          {
              String[] parts = selCsv.split(",");
              if(parts !=null && parts.length > 0)
              {
                   for(String it : parts)
                   {
                       try{  hs.add(Short.valueOf(it)); }catch( NumberFormatException ex ){ }  											
                   }	// End for loop								 									 							
              }	 // End   if(parts !=null && parts.length > 0)													
              			
          } // End   if(selCsv!=null && selCsv.length()>0)
<% 
       
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 
			 	 %>          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+<%=Fld %>+"\""+(  (hs.contains(new Short(<%=Fld %>))) ? chk :" " )+"  />&nbsp;<%=Lbl %><br />\r\n");   
<% 
		   i++;
			} 
%>          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

} // End Class Definition
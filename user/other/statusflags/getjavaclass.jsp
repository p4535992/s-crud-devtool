<%@ page import="java.io.*"%>
<%@ page import="java.util.*, org.json.simple.*, org.json.simple.parser.*,"%>
<%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<jsp:useBean id="ItemList" scope="session" class="TreeMap<Integer, JSONObject>" />
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String ClassName = request.getParameter("ClassName");
String PackageName = request.getParameter("PackageName");

 %>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Status Flag POJO</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />

  <!-- The follwing are the files that must be added for using SHJS-Extended -->
  <!-- Common Styles -->
  <link rel="stylesheet" href="<%=appPath %>/assets/vendor/shjs-highlight-code/shx_main.min.css" />
  <!-- Theme file. There are many more themes in the css folder -->
  <link rel="stylesheet" href="<%=appPath %>/assets/vendor/shjs-highlight-code/css/sh_acid.min.css" />
  <!-- Main JS file -->
  <script type="text/javascript" src="<%=appPath %>/assets/vendor/shjs-highlight-code/sh_main.js"></script>
	
  <script type="text/javascript">
	function init() { //body onload
		var start=new Date();
		sh_highlightDocument('<%=appPath %>/assets/vendor/shjs-highlight-code/', '.min.js');		
		var stop=new Date();
		document.getElementById('processTime').appendChild(document.createTextNode('Time taken to complete process: '+(stop-start)+' ms'));
	}
  </script>

</head>
<body onload="init();" style="padding-top: 0px;">  
<div id="processTime" class="well well-sm"></div>
<pre class="sh_java"  title="<%=ClassName %>.java">
package <%=PackageName %> ;
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
%>          case  <%=Fld %>:
               ret = "<%=Lbl %>" ;
            break;
<%}%>        } // end switch case
         return ret ;
     } // End  getLabel(short item)
		 
  	public static String getLabelFromCsv(String csv)
  	{
  	   if(csv==null || csv.length()==0) return null;
  		 int i =0;
  		 StringBuilder sb = new StringBuilder();
  		 String[] parts = csv.split(",");
  		 for(String str:parts)
  		 { 
  		  if(i>0)sb.append(", ");
  			 sb.append(getLabel(Short.valueOf(str))); 
  		   i++;
  		 }
  		 return sb.toString();
  	} // End getLabelFromCsv(String csv)
		 
    public static String getDropList(String ElmName, String ElmID, short item, boolean all_label, boolean none_label, String cls, String plugin)		 
     {
          String nonelbl = (none_label == true)? "-- None --" : " " ;
					String alllbl = (all_label == true)? "-- All --" : " " ;
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
					String plgn = (plugin !=null)? " "+plugin+" " : " " ;
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("&lt;select name=\"" + ElmName + "\" id=\"" + ElmID + "\" "+cls_name+" "+plgn+"  &gt;\r\n");
					if(all_label == true) sb.append("&lt;option value=\"\"&gt; [ " + alllbl + " ] &lt;/option&gt;\r\n");
          if(none_label == true) sb.append("&lt;option value=\"\"&gt; [ " + nonelbl + " ] &lt;/option&gt;\r\n");		  

          			
<% 
      for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 %>          sb.append("&lt;option value=\"" + <%=Fld %> + "\"" + ((item == <%=Fld %>) ? sel : " ") + " &gt; <%=Lbl %> &lt;/option&gt;\r\n");     
<% 
			} 
%>          sb.append("&lt;/select&gt;\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
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
<%}			 %>          sb.append("&lt;input type=\"radio\" name=\"" + Elm + "\" value=\"" + <%=Fld %> + "\"" + ((item == <%=Fld %>) ? chk : " ") + " " + cls_name + "  /&gt;&nbsp;<%=Lbl %>\r\n");
<% 
		   i++;
			} 
%>          return sb.toString();				
     }	// End method: getRadioButtons(String Elm, short item)		 

     public static String getCheckBoxes(String ElmName, String ElmID, String selCsv, String cls, String plugin)		 
     {
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
					String plgn = (plugin !=null)? " "+plugin+" " : " " ;
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
			 	 %>							         
        sb.append("&lt;span " + cls_name + "&gt;\r\n");
        		sb.append("&lt;input type='checkbox' name=\"" + ElmName + "\" id=\"" + ElmID + "_" + <%=Fld %> + "\" value=\"" + <%=Fld %> + "\"" + ((hs.contains(new Short(<%=Fld %>))) ? chk : " ") + " /&gt;\r\n");
        		sb.append("&lt;label for=\"" + ElmID + "_" + <%=Fld %> + "\" &gt;<%=Lbl %>&lt;/label&gt;\r\n");
        sb.append("&lt;/span&gt;\r\n");			 
<% 
		   i++;
			} 
%>
			return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {<% 	
			StringBuilder sb = new StringBuilder();
			JSONObject jout = new JSONObject();
			for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {   
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
			 jout.put(Val, Lbl);	
			}
			String jsonout = jout.toString().replace("\"", "\\\"");
			%>
         return "<%=jsonout %>" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ <%  int itr=0; 
			for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
		    
       Integer Key = (Integer)entry.getKey(); JSONObject item = (JSONObject)entry.getValue();  String Fld = (String)item.get("Field");
		   if(itr>0)out.print(", "); 
			 itr++; out.print(Fld);
			} %> } ;
     } // End method items()
		 
     public static TreeMap<Short,String> itemMap()
     {
         TreeMap<Short,String> mp = new TreeMap<Short,String>();
       <%  
			 for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
       {
		    
       Integer Key = (Integer)entry.getKey(); 
			 JSONObject item = (JSONObject)entry.getValue();  
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label"); 
       %>  mp.put( new Short(<%=Fld %>), "<%=Lbl %>");
       <%
		    
			} 
			%>	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition
</pre>
</body>
</html>

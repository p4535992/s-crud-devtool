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
<title>Status Flag JSON-Object</title>	
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
<pre class="sh_java"  title="<%=ClassName %>.txt">
{ "PackageName":"<%=PackageName %>", "ClassName":"<%=ClassName %>" , "FieldItems": [ <% 
      int i=0;
			for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
      {
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
			 if(i>0) out.print(", ");
       out.print(item.toJSONString());	
			 i++;	   
      }
%> ] }
</pre>
</body>
</html>

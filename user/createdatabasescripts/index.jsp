<%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><% 
 %><jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%
  
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
String appPath= request.getContextPath();
String thisFile = appPath+request.getServletPath();
String JNDIDSN= request.getParameter("JNDIDSN");
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Select Database</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<style type="text/css">
<!-- 
#table_struct_details td, th { font-size:10pt;}
-->
</style>
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<script type="text/javascript">
<!--
$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
 
 // End init
});


// -->
</script>


</head>
<body>	
<div align="center">
<span class="title">JNDI DataSource:&nbsp;&nbsp;<span class="highlight"><%=JNDIDSN %></span></span><br />
</div> 

<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">
<tr><td width="75%"> <span class="title">Generate Database and Table Strctures Script</span></td>
<td width="25%" valign="top"  align="right">
<a href="../tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">&laquo;&laquo; Table List (back)</a></b>

</td>
</tr>
</table>

<div align="justify">This wizard page will generate <b>SQL Script</b> for creating tables for various database
 engines.
</div>
<hr size="1">



<table border="0" cellpadding="0" cellspacing="0" summary="">
<tr>
<td width="35%" >
 



<div style="padding:1em;">

<table border="1" cellpadding="4" cellspacing="0" summary="">
<tr>
    <td><span class="item">MySQL </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MYSQL %>" target="_blank" >Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MYSQL %>" target="_blank" >Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">Postgre SQL </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.POSTGRE %>" target="_blank">Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.POSTGRE %>" target="_blank">Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">IBM DB2 </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.DB2 %>" target="_blank" >Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.DB2 %>" target="_blank" >Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">MS SQL </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MSSQL %>" target="_blank">Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MSSQL %>" target="_blank">Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">Oracle </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.ORACLE %>" target="_blank" >Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.ORACLE %>" target="_blank" >Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">H2 Database </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.H2 %>" target="_blank" >Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.H2 %>" target="_blank" >Create Indexes</a></td>
</tr>
<tr>
    <td><span class="item">SQLite </span></td>
		<td><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.SQLITE %>">Create Tables</a></td>
		<td><a href="createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.SQLITE %>">Create Indexes</a></td>
</tr>
</table>
</div>

<!-- 
<ul>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MYSQL %>" target="_blank" >MySQL</a> </p></li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.POSTGRE %>" target="_blank">Postgre SQL</a></p></li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.DB2 %>" target="_blank" >IBM DB2</a></p></li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MSSQL %>" target="_blank">MS SQL</a></p> </li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.ORACLE %>" target="_blank" >Oracle</a></p></li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.H2 %>" target="_blank" >H2 Database</a></p></li>
<li><p><a href="createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.SQLITE %>">SQLite</a></p></li>
</ul>
 -->

</table>


<!-- END -->
</td>
</tr>
</table> 

</body>
</html>

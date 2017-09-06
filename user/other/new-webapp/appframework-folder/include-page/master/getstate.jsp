<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%><%@ page import="java.util.*, java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %>
<jsp:useBean id="StBn" scope="page" class="com.db.$DATABASE.State_cityBean" /><%
String ParamAttribute = request.getParameter("Attribute");
String ParamSelect = request.getParameter("Select");
String All = request.getParameter("All") ;
String None = request.getParameter("None") ;
String OrderBy = null ;
OrderBy = request.getParameter("OrderBy") ;
if(OrderBy!=null && OrderBy.length()>0) OrderBy=" ORDER BY state_city."+OrderBy ;
else OrderBy=" ";
if(All!=null && "true".equalsIgnoreCase(All) ) out.println("<option value=\"\"> -- ALL -- </option>") ;
if(None!=null && "true".equalsIgnoreCase(None) ) out.println("<option value=\"\"> -- NONE -- </option>") ;
StBn.openTable(" GROUP BY `State` " , OrderBy );
while(StBn.nextRow()){%>
<option <% if(ParamSelect != null) if(ParamSelect.equalsIgnoreCase(StBn.State)) out.print("selected=\"selected\""); %> value ="<%=StBn.State %>" ><%=StBn.State %></option>
<% }// end while loop
StBn.closeTable();
%>



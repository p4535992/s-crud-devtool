<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %>
<jsp:useBean id="ItemBean" scope="page" class="com.db.$DATABASE.MasteritemlistBean" /><% 
//Table name : itemlist ; Fields: RecordID, Attribute, Options 
String ParamAttribute = request.getParameter("Attribute");
String ParamSelect = request.getParameter("Select");
String All = request.getParameter("All") ;
String None = request.getParameter("None") ;
String OrderBy = null ;
String GroupBy = null ;
OrderBy = request.getParameter("OrderBy") ;
GroupBy = request.getParameter("GroupBy") ;
if(OrderBy!=null && OrderBy.length()>0) OrderBy=" ORDER BY masteritemlist."+OrderBy ;
else OrderBy="ORDER BY masteritemlist.Options";
if(GroupBy!=null && GroupBy.length()>0) GroupBy=" GROUP BY masteritemlist."+GroupBy ;
else GroupBy="";
if(All!=null && "true".equalsIgnoreCase(All) ) out.println("<option value=\"\"> -- ALL -- </option>") ;
if(None!=null && "true".equalsIgnoreCase(None) ) out.println("<option value=\"\"> -- NONE -- </option>") ;
ItemBean.openTable(" WHERE masteritemlist.Attribute = '"+ParamAttribute+"' "+GroupBy+"" , OrderBy );
while(ItemBean.nextRow()){%>
<option <% if(ParamSelect != null) if(ParamSelect.equalsIgnoreCase(ItemBean.Options)) out.print("selected=\"selected\""); %> value ="<%=ItemBean.Options %>" ><%=ItemBean.Options %></option>
<% }// end while loop
ItemBean.closeTable();
%>
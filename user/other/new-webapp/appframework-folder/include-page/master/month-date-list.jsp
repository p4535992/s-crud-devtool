<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%><%@ page import="java.io.*, java.util.*, java.text.*, java.sql.*, com.webapp.utils.*"%><% 
String ElementName = request.getParameter("ElementName");
if (ElementName ==null) ElementName = "MonthAndDay" ;
String ElementID = request.getParameter("ElementID");
if(ElementID == null) ElementID = ElementName;

String ClassName = request.getParameter("ClassName");
String cls = (ClassName !=null)? " class=\""+ClassName+"\" " : " ";

String plugin = request.getParameter("Plugin");
String plgn = (plugin != null) ? " " + plugin + " " : " ";

String[] MonthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" } ;

DecimalFormat dft = new DecimalFormat("00");

java.sql.Date today = DateTimeHelper.today();

int tday = today.getDate();
int tmonth = today.getMonth() ;
%>
 
<div class="col-md-1 col-sm-2 col-xs-12">
<select name="<%=ElementName %>_Date" id="<%=ElementID %>_Date" <%=cls %> <%=plgn %>>
  <%  
  for(int dy=1; dy <= 31; dy++)
	{
	%><option value="<%=dy %>" <% if(dy==tday){ %> selected="selected" <% } %>  > <%=dft.format(dy) %>  </option>
	<% 
	}
	%>
</select>
</div>
<span class="visible-xs-*">&nbsp;&nbsp;</span>
<div class="col-md-2 col-sm-3 col-xs-12"> 
<select name="<%=ElementName %>_Month" id="<%=ElementID %>_Month" <%=cls %> <%=plgn %>>
 <%  
  for(int mn=0; mn < 12; mn++)
	{
	%><option value="<%=mn+1 %>" <% if(mn==tmonth){ %> selected="selected" <% } %> > <%=MonthNames[mn] %> </option>
	<% 
	}
	%>
</select>
</div>
<% 
String appPath=request.getContextPath(); 
String menuType = request.getParameter("menuType");
String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>

<%  
if(menuType.equals("topbar"))
{
%>
  <jsp:include page ="/$LoginFolderName/include-page/assets/topbar/menu-body-topbar.jsp">
		 <jsp:param  name="MenuTitle" value="<%=MenuTitle %>"/>
		 <jsp:param  name="MenuLink" value="<%=MenuLink %>"/>
	</jsp:include>	
<%  
}
else if(menuType.equals("center"))
{
%>
  <jsp:include page ="/$LoginFolderName/include-page/assets/center/menu-body-center.jsp">
		 <jsp:param  name="MenuTitle" value="<%=MenuTitle %>"/>
		 <jsp:param  name="MenuLink" value="<%=MenuLink %>"/>
	</jsp:include>	
<%  
}
else
{
%>
  <jsp:include page ="/$LoginFolderName/include-page/assets/base/menu-body-base.jsp">
		 <jsp:param  name="MenuTitle" value="<%=MenuTitle %>"/>
		 <jsp:param  name="MenuLink" value="<%=MenuLink %>"/>
	</jsp:include>	
<%  
}
%>

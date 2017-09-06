<%! 
String StrValue(Object ob )
{
	if(ob==null) return "";
	return StringEscapeUtils.escapeHtml4(ob.toString());
		
}
%>
<%
String menuType = $BeanName.MenuType ;

String menuTypeClass = "";
if(menuType.equalsIgnoreCase("TOPBAR"))
{
 menuTypeClass = "site-navbar-small" ;
}
else if(menuType.equalsIgnoreCase("CENTER"))
{
 menuTypeClass = "";
}
else
{
 menuTypeClass="site-menubar-unfold" ;
}
%>



<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.text.*"%>
<%@ page import="org.apache.commons.lang3.*" %>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<jsp:useBean id="AlofAdBn" scope="page" class="com.db.$DATABASE.AccesslogofsitemanagerBean" />
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<%
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath();
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
  
String Action = request.getParameter("Action") ;
if(Action==null) Action="Form" ; // Other action Update

if(("Update").equalsIgnoreCase(Action))
{
  String oldmenuStyle = request.getParameter("oldmenuStyle");
  String MenuStyle = request.getParameter("MenuStyle");
	SiMngrBn.MenuType = MenuStyle ;
	SiMngrBn.updateRecord(LogUsr.AdminID);
	
/*
String WebAppDir =  application.getRealPath("/admin");

File ReplFile_navINC = new File( WebAppDir+"/nav_menu.inc");
String StrBuf_navINC = FileUtils.readFileToString(ReplFile_navINC);
String RepStr_navINC = StringUtils.replace(StrBuf_navINC, oldmenuStyle,MenuStyle);
//RepStr_navINC = StringUtils.replace(RepStr_navINC, ?,?);
FileUtils.writeStringToFile(ReplFile_navINC ,RepStr_navINC);

*/	

response.sendRedirect(response.encodeRedirectURL(appPath+"/admin/index.jsp"));
}
%>
<%@include file="/admin/nav_menu.inc"%>
<!-- nav-tabs -->
<ul class="site-sidebar-nav nav nav-tabs nav-justified nav-tabs-line" data-plugin="nav-tabs" role="tablist">
  <li class="active" role="presentation">
    <a data-toggle="tab" href="#sidebar-accesslog" role="tab">
      <i class="icon fa fa-check-square-o fa-lg" aria-hidden="true"></i>
    </a>
  </li>
  <li role="presentation">
    <a data-toggle="tab" href="#sidebar-setting" role="tab">
      <i aria-hidden="true" class="icon wb-layout"></i>
    </a>
  </li>
</ul>

<div class="site-sidebar-tab-content tab-content">
  <div class="tab-pane fade active in" id="sidebar-accesslog">
    <div>
      <div>
        <h5 class="clearfix">LOGIN ACCESSLOG</h5>

        <div class="list-group">
				
<%  
AlofAdBn.openTable("WHERE `AdminID` = "+LogUsr.AdminID,"ORDER BY `LoginTime` DESC LIMIT 10" ); 
while(AlofAdBn.nextRow())
{
    Format formatter = new SimpleDateFormat("EEEE"); 
    String dayname = formatter.format(AlofAdBn.LoginTime);

String ipAdd = "" ;		
if(AlofAdBn.IPAddress.equalsIgnoreCase("[::1]")) ipAdd = "localhost";
else ipAdd = "IP : "+AlofAdBn.IPAddress ;
%>				
          <a class="list-group-item" href="javascript:void(0)">			
            <div class="media">
              <div class="media-left">
							   <i class="icon fa fa-smile-o fa-2x" aria-hidden="true" style="color: #62a8ea;"></i>
              </div>
              <div class="media-body">
                <h4 class="media-heading"><%=DateTimeHelper.showDateTimePicker(AlofAdBn.LoginTime) %></h4>
                <small><%=dayname %>  [ <%=ipAdd %> ]</small>
              </div>
            </div>
          </a>
<% 
} // end while( AlofAdBn.nextRow());
AlofAdBn.closeTable();
%>
					
					
        </div>
				
      </div>
    </div>
  </div>

  <div class="tab-pane fade" id="sidebar-setting">
    <div>
      <div>

<% 
if(("Form").equalsIgnoreCase(Action))
{
%>
    <form action="<%=thisFile %>" method="post">
		<input type="hidden" name="Action" value="Update" />
		<input type="hidden" name="oldmenuStyle" value="<%=menuType %>" />
        <h5>THEME SETTING [Menu]
          <div class="pull-right">
              <button type="submit" class="btn btn-primary btn-xs">Update</button>
          </div>	
				</h5>
        <ul class="list-group">
          <li class="list-group-item">
            <div class="pull-right margin-top-5">
                <div class="radio-custom radio-primary">
                  <input id="BASE" name="MenuStyle" type="radio" value="base" <% if(menuType.equalsIgnoreCase("base")){ %> checked <% } %>>
                  <label for="BASE">&nbsp;</label>
                </div>
            </div>
            <h5>BASE Style</h5>
            <p>Fixed Menu left Side</p>
          </li>
          <li class="list-group-item">
            <div class="pull-right margin-top-5">
                <div class="radio-custom radio-primary">
                  <input id="TOPBAR" name="MenuStyle" type="radio" value="topbar" <% if(menuType.equalsIgnoreCase("topbar")){ %> checked <% } %>>
									<label for="TOPBAR">&nbsp;</label>
                </div>
            </div>
            <h5>TOPBAR Style</h5>
            <p>Fixed Menu on top</p>
          </li>
          <li class="list-group-item">
            <div class="pull-right margin-top-5">
                <div class="radio-custom radio-primary">
                  <input id="CENTER" name="MenuStyle" type="radio" value="center" <% if(menuType.equalsIgnoreCase("center")){ %> checked <% } %>>
                  <label for="CENTER">&nbsp;</label>
                </div>
            </div>
            <h5>CENTER Style</h5>
            <p>Menu open at mouse hover</p>
          </li>
        </ul>
		</form>		
<%
}  
else // end if(("Form").equalsIgnoreCase(Action))
{
%>

<div class="well well-sm well-danger">
  Error: The page is invoked with invalid action parameter.
</div>

<% 
} 
%>
				
      </div>
    </div>
  </div>
</div>

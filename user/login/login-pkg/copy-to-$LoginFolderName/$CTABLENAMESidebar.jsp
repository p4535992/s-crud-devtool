<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@ page import="java.io.*, java.text.*"%>
<%@ page import="org.apache.commons.lang3.*" %>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<jsp:useBean id="Alof$BeanName" scope="page" class="$BeanPackage.Accesslogof$TABLENAMEBean" />
<%
String appPath = request.getContextPath();
String thisFile = appPath+request.getServletPath();
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);
  
String Action = request.getParameter("Action") ;
if(Action==null) Action="Form" ; // Other action Update

if(("Update").equalsIgnoreCase(Action))
{
  $BeanName.locateRecord($BeanName.$IDField);
  String oldmenuStyle = request.getParameter("oldmenuStyle");
  String MenuStyle = request.getParameter("MenuStyle");
	$BeanName.MenuType = MenuStyle ;
	$BeanName.updateRecord($BeanName.$IDField);

response.sendRedirect(response.encodeRedirectURL(appPath+"/$LoginFolderName/index.jsp"));
}
%>
<%@include file="/$LoginFolderName/nav_menu.inc"%>
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
Alof$BeanName.openTable("WHERE `$IDField` = "+$BeanName.$IDField,"ORDER BY `LoginTime` DESC LIMIT 10" ); 
while(Alof$BeanName.nextRow())
{
    Format formatter = new SimpleDateFormat("EEEE"); 
    String dayname = formatter.format(Alof$BeanName.LoginTime);

String ipAdd = "" ;		
if(Alof$BeanName.IPAddress.equalsIgnoreCase("[::1]")) ipAdd = "localhost";
else ipAdd = "IP : "+Alof$BeanName.IPAddress ;
%>				
          <a class="list-group-item" href="javascript:void(0)">			
            <div class="media">
              <div class="media-left">
							   <i class="icon fa fa-smile-o fa-2x" aria-hidden="true" style="color: #62a8ea;"></i>
              </div>
              <div class="media-body">
                <h4 class="media-heading"><%=DateTimeHelper.showDateTimePicker(Alof$BeanName.LoginTime) %></h4>
                <small><%=dayname %>  [ <%=ipAdd %> ]</small>
              </div>
            </div>
          </a>
<% 
} // end while( Alof$BeanName.nextRow());
Alof$BeanName.closeTable();
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

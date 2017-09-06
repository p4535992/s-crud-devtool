<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%> 
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath=request.getContextPath();
$WEBAPP.$LoginClass LogUsr = ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);

String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>
  <nav class="site-navbar navbar navbar-default navbar-fixed-top navbar-mega navbar-inverse"
  role="navigation">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle hamburger hamburger-close navbar-toggle-left hided"
      data-toggle="menubar">
        <span class="sr-only">Toggle navigation</span>
        <span class="hamburger-bar"></span>
      </button>
      <button type="button" class="navbar-toggle collapsed" data-target="#site-navbar-collapse"
      data-toggle="collapse">
        <i class="icon wb-more-horizontal" aria-hidden="true"></i>
      </button>
      <a class="navbar-brand navbar-brand-center" href="javascript:void(0)" target="_blank">
        <img class="navbar-brand-logo navbar-brand-logo-normal" src="<%=appPath %><%=ApplicationResource.ProductBannerLogo %>"
        title="<%=ApplicationResource.ProductName %>">
        <img class="navbar-brand-logo navbar-brand-logo-special" src="<%=appPath %><%=ApplicationResource.ProductLogo %>"
        title="<%=ApplicationResource.ProductName %>">
        <span class="navbar-brand-text hidden-xs"> <%=ApplicationResource.ProductName %></span>
      </a>
    </div>

    <div class="navbar-container container-fluid">
      <!-- Navbar Collapse -->
      <div class="collapse navbar-collapse navbar-collapse-toolbar" id="site-navbar-collapse">
        <!-- Navbar Toolbar -->
        <ul class="nav navbar-toolbar">
          <li class="hidden-float" id="toggleMenubar">
            <a data-toggle="menubar" href="#" role="button">
              <i class="icon hamburger hamburger-arrow-left">
                  <span class="sr-only">Toggle menubar</span>
                  <span class="hamburger-bar"></span>
                </i>
            </a>
          </li>
        </ul>
        <!-- End Navbar Toolbar -->

        <!-- Navbar Toolbar Right -->
        <ul class="nav navbar-toolbar navbar-right navbar-toolbar-right">
          <li<%if(MenuTitle.equalsIgnoreCase("NavUserDropdown")){ %> class="dropdown active"<% }else{ %> class="dropdown"<% } %> >
            <a role="button" data-animation="scale-up" aria-expanded="false" title="<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %>" href="javascript:void(0)" data-toggle="dropdown">
              <i class="icon fa fa-user-secret fa-lg" aria-hidden="true"></i>
            </a>
            <ul role="menu" class="dropdown-menu">
              <li role="presentation">
                <a role="menuitem" href="javascript:void(0)" class="vertical-align-middle text-center"><img width="120" height="120" class="img-circle img-bordered img-bordered-primary" alt="<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %>" src="<%=appPath %>/$TABLENAMEphoto/<%=$BeanName.$IDField %>"><br /><%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></a>
              </li>
              <li role="presentation"<%if(MenuLink.equalsIgnoreCase("Profile")){ %> class="active"<% }else{ %><% } %>>
                <a role="menuitem" href="<%=appPath %>/$LoginFolderName/$CTABLENAMEProfile.jsp"><i aria-hidden="true" class="icon wb-user"></i> Profile</a>
              </li>
              <li role="presentation"<%if(MenuLink.equalsIgnoreCase("ChangePassword")){ %> class="active"<% }else{ %><% } %>>
                <a role="menuitem" href="<%=appPath %>/$LoginFolderName/changepassword.jsp"><i aria-hidden="true" class="icon wb-edit"></i> Edit Password</a>
              </li>
              <li role="presentation" class="divider"></li>
              <li role="presentation">
                <a role="menuitem" href="javascript:void(0)" onclick="AppConfirm('question','Are you sure ?','<%=appPath %>/$LoginFolderName/$CTABLENAMELogOut.jsp','Log out from current browser session ?')" ><i aria-hidden="true" class="icon wb-power"></i> Logout</a>
              </li>
            </ul>
          </li>
          <li class="dropdown">
            <a data-toggle="dropdown" href="javascript:void(0)" title="Notifications" aria-expanded="false"
            data-animation="scale-up" role="button">
              <i class="icon wb-bell" aria-hidden="true"></i>
              <span class="badge badge-danger up">5</span>
            </a>
            <ul class="dropdown-menu dropdown-menu-right dropdown-menu-media" role="menu">
              <li class="dropdown-menu-header" role="presentation">
                <h5>NOTIFICATIONS</h5>
                <span class="label label-round label-danger">New 5</span>
              </li>

              <li class="list-group" role="presentation">
                <div data-role="container">
                  <div data-role="content">
                    <a class="list-group-item" href="javascript:void(0)" role="menuitem">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i class="icon wb-order bg-red-600 white icon-circle" aria-hidden="true"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">A new order has been placed</h6>
                          <time class="media-meta" datetime="2016-06-12T20:50:48+08:00">5 hours ago</time>
                        </div>
                      </div>
                    </a>
                    <a class="list-group-item" href="javascript:void(0)" role="menuitem">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i class="icon wb-user bg-green-600 white icon-circle" aria-hidden="true"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Completed the task</h6>
                          <time class="media-meta" datetime="2016-06-11T18:29:20+08:00">2 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a class="list-group-item" href="javascript:void(0)" role="menuitem">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i class="icon wb-settings bg-red-600 white icon-circle" aria-hidden="true"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Settings updated</h6>
                          <time class="media-meta" datetime="2016-06-11T14:05:00+08:00">2 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a class="list-group-item" href="javascript:void(0)" role="menuitem">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i class="icon wb-calendar bg-blue-600 white icon-circle" aria-hidden="true"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Event started</h6>
                          <time class="media-meta" datetime="2016-06-10T13:50:18+08:00">3 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a class="list-group-item" href="javascript:void(0)" role="menuitem">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i class="icon wb-chat bg-orange-600 white icon-circle" aria-hidden="true"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Message received</h6>
                          <time class="media-meta" datetime="2016-06-10T12:34:48+08:00">3 days ago</time>
                        </div>
                      </div>
                    </a>
                  </div>
                </div>
              </li>
              <li class="dropdown-menu-footer" role="presentation">
                <a class="dropdown-menu-footer-btn" href="javascript:void(0)" role="button">
                  <i class="icon wb-settings" aria-hidden="true"></i>
                </a>
                <a href="javascript:void(0)" role="menuitem">
                    All notifications
                  </a>
              </li>
            </ul>
          </li>
          <li id="toggleChat">
						<a data-url="<%=appPath %>/$LoginFolderName/$CTABLENAMESidebar.jsp" title="Login Log" href="javascript:void(0)" data-toggle="site-sidebar">
              <i class="icon wb-more-vertical" aria-hidden="true"></i>
            </a>
          </li>
        </ul>
        <!-- End Navbar Toolbar Right -->
      </div>
      <!-- End Navbar Collapse -->

    </div>
  </nav>
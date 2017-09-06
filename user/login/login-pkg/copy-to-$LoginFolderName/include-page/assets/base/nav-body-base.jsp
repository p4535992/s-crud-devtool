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
  <nav role="navigation" class="site-navbar navbar navbar-default navbar-fixed-top navbar-mega navbar-inverse">

    <div class="navbar-header">
      <button data-toggle="menubar" class="navbar-toggle hamburger hamburger-close navbar-toggle-left hided unfolded" type="button">
        <span class="sr-only">Toggle navigation</span>
        <span class="hamburger-bar"></span>
      </button>
      <button data-toggle="collapse" data-target="#site-navbar-collapse" class="navbar-toggle collapsed" type="button">
        <i aria-hidden="true" class="icon wb-more-horizontal"></i>
      </button>
			<div data-toggle="gridmenu" class="navbar-brand navbar-brand-center site-gridmenu-toggle" aria-expanded="false">
			  <!-- <a href="javascript:void(0)" target="_blank"></a> -->
        <img class="navbar-brand-logo navbar-brand-logo-normal" src="<%=appPath %><%=ApplicationResource.ProductBannerLogo %>" title="<%=ApplicationResource.ProductName %>">
        <span class="navbar-brand-text hidden-xs"> <%=ApplicationResource.ProductName %></span>
        
			</div>
<!-- 			
      <div data-toggle="gridmenu" class="navbar-brand navbar-brand-center site-gridmenu-toggle">
        <img title="<%=ApplicationResource.ProductName %>" src="<%=appPath %><%=ApplicationResource.ProductBannerLogo %>" class="navbar-brand-logo">
        <span class="navbar-brand-text hidden-xs"> <%=ApplicationResource.ProductName %></span>
      </div>
 -->			
    </div>

    <div class="navbar-container container-fluid">
      <!-- Navbar Collapse -->
      <div id="site-navbar-collapse" class="collapse navbar-collapse navbar-collapse-toolbar">
        <!-- Navbar Toolbar -->
        <ul class="nav navbar-toolbar">
          <li id="toggleMenubar" class="hidden-float">
            <a role="button" href="#" data-toggle="menubar">
              <i class="icon hamburger hamburger-arrow-left hided unfolded">
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
                <a role="menuitem" href="<%=appPath %>/$LoginFolderName/$CTABLENAMEProfile.jsp"><i aria-hidden="true" class="icon wb-user"></i>Profile</a>
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
            <a role="button" data-animation="scale-up" aria-expanded="false" title="Notifications" href="javascript:void(0)" data-toggle="dropdown">
              <i aria-hidden="true" class="icon wb-bell"></i>
              <span class="badge badge-danger up">5</span>
            </a>
            <ul role="menu" class="dropdown-menu dropdown-menu-right dropdown-menu-media">
              <li role="presentation" class="dropdown-menu-header">
                <h5>NOTIFICATIONS</h5>
                <span class="label label-round label-danger">New 5</span>
              </li>

              <li role="presentation" class="list-group">
                <div data-role="container">
                  <div data-role="content">
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i aria-hidden="true" class="icon wb-order bg-red-600 white icon-circle"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">A new order has been placed</h6>
                          <time datetime="2016-06-12T20:50:48+08:00" class="media-meta">5 hours ago</time>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i aria-hidden="true" class="icon wb-user bg-green-600 white icon-circle"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Completed the task</h6>
                          <time datetime="2016-06-11T18:29:20+08:00" class="media-meta">2 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i aria-hidden="true" class="icon wb-settings bg-red-600 white icon-circle"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Settings updated</h6>
                          <time datetime="2016-06-11T14:05:00+08:00" class="media-meta">2 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i aria-hidden="true" class="icon wb-calendar bg-blue-600 white icon-circle"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Event started</h6>
                          <time datetime="2016-06-10T13:50:18+08:00" class="media-meta">3 days ago</time>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <i aria-hidden="true" class="icon wb-chat bg-orange-600 white icon-circle"></i>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Message received</h6>
                          <time datetime="2016-06-10T12:34:48+08:00" class="media-meta">3 days ago</time>
                        </div>
                      </div>
                    </a>
                  </div>
                </div>
              </li>
              <li role="presentation" class="dropdown-menu-footer">
                <a role="button" href="javascript:void(0)" class="dropdown-menu-footer-btn">
                  <i aria-hidden="true" class="icon wb-settings"></i>
                </a>
                <a role="menuitem" href="javascript:void(0)">
                    All notifications
                  </a>
              </li>
            </ul>
          </li>
          <li class="dropdown">
            <a role="button" data-animation="scale-up" aria-expanded="false" title="Messages" href="javascript:void(0)" data-toggle="dropdown">
              <i aria-hidden="true" class="icon wb-envelope"></i>
              <span class="badge badge-info up">3</span>
            </a>
            <ul role="menu" class="dropdown-menu dropdown-menu-right dropdown-menu-media">
              <li role="presentation" class="dropdown-menu-header">
                <h5>MESSAGES</h5>
                <span class="label label-round label-info">New 3</span>
              </li>

              <li role="presentation" class="list-group">
                <div data-role="container">
                  <div data-role="content">
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <span class="avatar avatar-sm">
                            <img alt="..." src="<%=appPath %><%=ApplicationResource.ProductLogo %>">
                            <i></i>
                          </span>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Mary Adams</h6>
                          <div class="media-meta">
                            <time datetime="2016-06-17T20:22:05+08:00">30 minutes ago</time>
                          </div>
                          <div class="media-detail">Anyways, i would like just do it</div>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <span class="avatar avatar-sm">
                            <img alt="..." src="<%=appPath %><%=ApplicationResource.ProductLogo %>">
                            <i></i>
                          </span>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Caleb Richards</h6>
                          <div class="media-meta">
                            <time datetime="2016-06-17T12:30:30+08:00">12 hours ago</time>
                          </div>
                          <div class="media-detail">I checheck the document. But there seems</div>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <span class="avatar avatar-sm">
                            <img alt="..." src="<%=appPath %><%=ApplicationResource.ProductLogo %>">
                            <i></i>
                          </span>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">June Lane</h6>
                          <div class="media-meta">
                            <time datetime="2016-06-16T18:38:40+08:00">2 days ago</time>
                          </div>
                          <div class="media-detail">Lorem ipsum Id consectetur et minim</div>
                        </div>
                      </div>
                    </a>
                    <a role="menuitem" href="javascript:void(0)" class="list-group-item">
                      <div class="media">
                        <div class="media-left padding-right-10">
                          <span class="avatar avatar-sm">
                            <img alt="..." src="<%=appPath %><%=ApplicationResource.ProductLogo %>">
                            <i></i>
                          </span>
                        </div>
                        <div class="media-body">
                          <h6 class="media-heading">Edward Fletcher</h6>
                          <div class="media-meta">
                            <time datetime="2016-06-15T20:34:48+08:00">3 days ago</time>
                          </div>
                          <div class="media-detail">Dolor et irure cupidatat commodo nostrud nostrud.</div>
                        </div>
                      </div>
                    </a>
                  </div>
                </div>
              </li>
              <li role="presentation" class="dropdown-menu-footer">
                <a role="button" href="javascript:void(0)" class="dropdown-menu-footer-btn">
                  <i aria-hidden="true" class="icon wb-settings"></i>
                </a>
                <a role="menuitem" href="javascript:void(0)">
                    See all messages
                  </a>
              </li>
            </ul>
          </li>
          <li id="toggleChat">
            <a data-url="<%=appPath %>/$LoginFolderName/$CTABLENAMESidebar.jsp" title="Login Log" href="javascript:void(0)" data-toggle="site-sidebar">
              <i aria-hidden="true" class="icon wb-chat"></i>
            </a>
          </li>
        </ul>
        <!-- End Navbar Toolbar Right -->
      </div>
      <!-- End Navbar Collapse -->

    </div>
  </nav>
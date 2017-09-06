<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%> 
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<% 
String appPath=request.getContextPath(); 
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
int nAdminID = LogUsr.AdminID;
SiMngrBn.locateRecord(nAdminID);

String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>
  <nav role="navigation" class="site-navbar navbar navbar-inverse navbar-fixed-top navbar-mega">
    <div class="navbar-header">
      <button data-toggle="menubar" class="navbar-toggle hamburger hamburger-close navbar-toggle-left hided" type="button">
        <span class="sr-only">Toggle navigation</span>
        <span class="hamburger-bar"></span>
      </button>
      <button data-toggle="collapse" data-target="#site-navbar-collapse" class="navbar-toggle collapsed" type="button">
        <i aria-hidden="true" class="icon wb-more-horizontal"></i>
      </button>
      <div data-toggle="gridmenu" class="navbar-brand navbar-brand-center site-gridmenu-toggle">
        <img title="<%=ApplicationResource.ProductName %>" src="<%=appPath %><%=ApplicationResource.ProductBannerLogo %>" class="navbar-brand-logo">
      </div>
    </div>

    <div class="navbar-container container-fluid">
      <!-- Navbar Collapse -->
      <div id="site-navbar-collapse" class="collapse navbar-collapse navbar-collapse-toolbar">
        <!-- Navbar Toolbar -->
        <ul class="nav navbar-toolbar">
          <li id="toggleMenubar" class="hidden-float">
            <a role="button" href="#" data-toggle="menubar">
              <i class="icon hamburger hamburger-arrow-left">
                  <span class="sr-only">Toggle menubar</span>
                  <span class="hamburger-bar"></span>
                </i>
            </a>
          </li>
				<% 
				 if(SiMngrBn.SuperAdminRight > 0)
				 { 
				%>
          <li<%if(MenuTitle.equalsIgnoreCase("SuperAdmin")){ %> class="dropdown dropdown-fw dropdown-mega active"<% }else{ %> class="dropdown dropdown-fw dropdown-mega"<% } %>>
            <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false" title="Super Administrator Privilege"
            data-animation="fade" role="button"><i aria-hidden="true" class="icon fa fa-gears fa-lg"></i></a>
            <ul class="dropdown-menu" role="menu">
              <li role="presentation">
                <div class="mega-content">
                  <div class="row">
                    <div class="col-sm-5">
                      <h5><i aria-hidden="true" class="icon fa fa-cubes fa-lg iccolor"></i>&nbsp;Super Admin Privilege</h5>
        					      <ul class="list-group list-group-full" style="margin-bottom: 5px;margin-left: 25px;">
                          <li class="list-group-item"><i aria-hidden="true" class="icon fa fa-user iccolor"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/managesitemanager.jsp">Manage Sitemanager</a></li>
                          <li class="list-group-item"><i class="icon fa fa-cog iccolor" aria-hidden="true"></i>&nbsp;<a href="javascript:void(0)" onclick="AppConfirm('','Are you sure ?','<%=appPath %>/admin/superadmin/appSetting.jsp','Do not change any settings unless you are 100% sure !\nYou could inadvertently mess-up the entire application.')">Application Setting</a></li>
                        </ul>

                      <!-- Accordion -->
                      <div role="tablist" aria-multiselectable="true" id="UserAccessLogAccordion" class="panel-group panel-group-simple" style="margin-bottom: 0;">
                        <div class="panel">
                          <div role="tab" id="UserAccessLogAccordionHeadingOne" class="panel-heading">
                            <a aria-controls="UserAccessLogCollapseOne" aria-expanded="false" data-parent="#UserAccessLogAccordion" href="#UserAccessLogCollapseOne" data-toggle="collapse" class="panel-title">
                                <i aria-hidden="true" class="icon fa fa-sign-in fa-lg iccolor"></i>&nbsp;User Access Log
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="UserAccessLogAccordionHeadingOne" id="UserAccessLogCollapseOne" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/accesslog/accesslogofsitemanager.jsp">Accesslog of Admin</a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
											</div>	


                      <!-- Accordion -->
                      <div role="tablist" aria-multiselectable="true" id="RESETpwAccordion" class="panel-group panel-group-simple">
                        <div class="panel">
                          <div role="tab" id="RESETpwAccordionHeadingOne" class="panel-heading">
                            <a aria-controls="RESETpwCollapseOne" aria-expanded="false" data-parent="#RESETpwAccordion" href="#RESETpwCollapseOne" data-toggle="collapse" class="panel-title">
                                <i class="icon fa fa-check-square-o iccolor" aria-hidden="true"></i>&nbsp;Reset Password & Clear Session
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="RESETpwAccordionHeadingOne" id="RESETpwCollapseOne" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/resetpassword/resetpasswordofSitemanager.jsp">Admin Staff</a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
											</div>	
                    </div>
										<div class="col-sm-2">
										</div>
                    <div class="col-sm-5">
                      <h5 class="margin-bottom-0"><i aria-hidden="true" class="icon fa fa-envelope-o fa-lg iccolor"></i>&nbsp;SMS / Email</h5>

                      <!-- Accordion -->
                      <div role="tablist" aria-multiselectable="true" id="siteMegaAccordion" class="panel-group panel-group-simple">
                        <div class="panel">
                          <div role="tab" id="siteMegaAccordionHeadingOne" class="panel-heading">
                            <a aria-controls="siteMegaCollapseOne" aria-expanded="false" data-parent="#siteMegaAccordion" href="#siteMegaCollapseOne" data-toggle="collapse" class="panel-title">
                                <i aria-hidden="true" class="icon fa fa-crosshairs fa-lg iccolor"></i>&nbsp;Collapsible Group Item #1
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="siteMegaAccordionHeadingOne" id="siteMegaCollapseOne" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 1</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 2</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 3</a></li>
															</ul>
                            </div>
                          </div>
                        </div>
                        <div class="panel">
                          <div role="tab" id="siteMegaAccordionHeadingTwo" class="panel-heading">
                            <a aria-controls="siteMegaCollapseTwo" aria-expanded="false" data-parent="#siteMegaAccordion" href="#siteMegaCollapseTwo" data-toggle="collapse" class="panel-title collapsed">
                                <i aria-hidden="true" class="icon fa fa-crosshairs fa-lg iccolor"></i>&nbsp;Collapsible Group Item #2
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="siteMegaAccordionHeadingTwo" id="siteMegaCollapseTwo" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 1</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 2</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 3</a></li>
															</ul>
                            </div>
                          </div>
                        </div>

                        <div class="panel">
                          <div role="tab" id="siteMegaAccordionHeadingThree" class="panel-heading">
                            <a aria-controls="siteMegaCollapseThree" aria-expanded="false" data-parent="#siteMegaAccordion" href="#siteMegaCollapseThree" data-toggle="collapse" class="panel-title collapsed">
                                <i aria-hidden="true" class="icon fa fa-crosshairs fa-lg iccolor"></i>&nbsp;Collapsible Group Item #3
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="siteMegaAccordionHeadingThree" id="siteMegaCollapseThree" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 1</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 2</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/???">Sample Link 3</a></li>
															</ul>
                            </div>
                          </div>
                        </div>
                      </div>
                      <!-- End Accordion -->

                    </div>
                  </div>
                </div>
              </li>
            </ul>
          </li>
					<% 
					 } //END if(SiMngrBn.SuperAdminRight > 0) 
					%>
        </ul>
        <!-- End Navbar Toolbar -->

        <!-- Navbar Toolbar Right -->
        <ul class="nav navbar-toolbar navbar-right navbar-toolbar-right">
          <li<%if(MenuTitle.equalsIgnoreCase("NavUserDropdown")){ %> class="dropdown active"<% }else{ %> class="dropdown"<% } %> >
            <a role="button" data-animation="scale-up" aria-expanded="false" title="<%=ShowItem.showAdminName(nAdminID, 3) %>" href="javascript:void(0)" data-toggle="dropdown">
              <i class="icon fa fa-user-secret fa-lg" aria-hidden="true"></i>
            </a>
            <ul role="menu" class="dropdown-menu">
              <li role="presentation">
                <a role="menuitem" href="javascript:void(0)" class="vertical-align-middle text-center"><img width="120" height="120" class="img-circle img-bordered img-bordered-primary" alt="<%=ShowItem.showAdminName(nAdminID, 3) %>" src="<%=appPath %>/sitemanagerphoto/<%=nAdminID %>"><br /><%=ShowItem.showAdminName(nAdminID, 3) %></a>
              </li>
              <li role="presentation"<%if(MenuLink.equalsIgnoreCase("Profile")){ %> class="active"<% }else{ %><% } %>>
                <a role="menuitem" href="<%=appPath %>/admin/AdminProfile.jsp"><i aria-hidden="true" class="icon wb-user"></i> Profile</a>
              </li>
              <li role="presentation"<%if(MenuLink.equalsIgnoreCase("ChangePassword")){ %> class="active"<% }else{ %><% } %>>
                <a role="menuitem" href="<%=appPath %>/admin/changepassword.jsp"><i aria-hidden="true" class="icon wb-edit"></i> Edit Password</a>
              </li>
<!-- 
              <li role="presentation">
                <a role="menuitem" href="<%=appPath %>/admin/AdminSetting.jsp"><i aria-hidden="true" class="icon wb-settings"></i> Settings</a>
              </li>
 -->
              <li role="presentation" class="divider"></li>
              <li role="presentation">
                <a role="menuitem" href="javascript:void(0)" onclick="AppConfirm('question','Are you sure ?','<%=appPath %>/admin/AdminLogOut.jsp','Log out from current browser session ?')" ><i aria-hidden="true" class="icon wb-power"></i> Logout</a>
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
            <a data-url="<%=appPath %>/admin/AdminSidebar.jsp" title="Login Log" href="javascript:void(0)" data-toggle="site-sidebar">
              <i aria-hidden="true" class="icon wb-chat"></i>
            </a>
          </li>
        </ul>
        <!-- End Navbar Toolbar Right -->

        <div class="navbar-brand navbar-brand-center">
          <a href="javascript:void(0)" target="_blank">
            <img title="<%=ApplicationResource.ProductName %>" src="<%=appPath %><%=ApplicationResource.ProductBannerLogo %>" class="navbar-brand-logo">
          </a>
        </div>
      </div>
      <!-- End Navbar Collapse -->

    </div>
  </nav>
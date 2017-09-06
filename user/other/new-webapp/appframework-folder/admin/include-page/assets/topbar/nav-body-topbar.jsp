<%@ page import="com.$WEBAPP.*, com.db.$DATABASE.*"%> 
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<% 
String appPath=request.getContextPath(); 
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
int nAdminID = LogUsr.AdminID;
SiMngrBn.locateRecord(nAdminID);

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
													<li class="list-group-item"><i aria-hidden="true" class="icon fa fa-download iccolor"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/backup/managedaily_backup.jsp">Daily Backup</a></li>
                        </ul>	
                    </div>
										<div class="col-sm-2">
										</div>
                    <div class="col-sm-5">
                      <!-- Accordion -->
                      <div role="tablist" aria-multiselectable="true" id="RESETpwAccordion" class="panel-group panel-group-simple" style="margin-bottom: 0;">
                        <div class="panel">
                          <div role="tab" id="RESETpwAccordionHeadingOne" class="panel-heading">
                            <a aria-controls="RESETpwCollapseOne" aria-expanded="false" data-parent="#RESETpwAccordion" href="#RESETpwCollapseOne" data-toggle="collapse" class="panel-title">
                                <i class="icon fa fa-check-square-o fa-lg iccolor" aria-hidden="true"></i>&nbsp;Reset Password & Clear Session
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
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/accesslog/accesslogofsitemanager.jsp">Admin</a></li>
                              </ul>
                            </div>
                          </div>
                        </div>
											</div>	

                      <!-- <h5 class="margin-bottom-0"><i aria-hidden="true" class="icon fa fa-envelope-o fa-lg iccolor"></i>&nbsp;SMS / Email</h5> -->
                      <!-- Accordion -->
                      <div role="tablist" aria-multiselectable="true" id="siteMegaAccordion" class="panel-group panel-group-simple">
                        <div class="panel">
                          <div role="tab" id="siteMegaAccordionHeadingOne" class="panel-heading">
                            <a aria-controls="siteMegaCollapseOne" aria-expanded="false" data-parent="#siteMegaAccordion" href="#siteMegaCollapseOne" data-toggle="collapse" class="panel-title">
                                <i aria-hidden="true" class="icon fa fa-envelope-o fa-lg iccolor"></i>&nbsp;SMS Settings & Logs
                              </a>
                          </div>
                          <div role="tabpanel" aria-labelledby="siteMegaAccordionHeadingOne" id="siteMegaCollapseOne" class="panel-collapse collapse">
                            <div class="panel-body" style="padding-top: 0px;margin-left: 25px;">
              					      <ul class="list-group list-group-full">
                                <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/smsappSetting.jsp">SMS Setting</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/managesmsgatewayaccounts.jsp">Gateway Service Account</a></li>
																<!-- <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/proxysetup.jsp">Setup Proxy Server</a></li> -->
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/managesms_template.jsp">SMS Template</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/smslogs/singlesmslog.jsp">Single SMS Log</a></li>
																<li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/smslogs/smsjobs.jsp">Bulk SMS Log</a></li>
																<!-- <li class="list-group-item"><i class="icon fa fa-anchor iccolor" aria-hidden="true"></i>&nbsp;<a href="<%=appPath %>/admin/superadmin/sms/???">Sample Link</a></li> -->
															</ul>
                            </div>
                          </div>
                        </div>
                        <div class="panel" style="display:none;">
                          <div role="tab" id="siteMegaAccordionHeadingTwo" class="panel-heading">
                            <a aria-controls="siteMegaCollapseTwo" aria-expanded="false" data-parent="#siteMegaAccordion" href="#siteMegaCollapseTwo" data-toggle="collapse" class="panel-title collapsed">
                                <i aria-hidden="true" class="icon fa fa-crosshairs fa-lg iccolor"></i>&nbsp;Email Settings & Logs
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
          <li<%if(MenuTitle.equalsIgnoreCase("NavUserDropdowns")){ %> class="dropdown active"<% }else{ %> class="dropdown"<% } %>>
            <a role="button" data-animation="scale-up" aria-expanded="false" title="<%=ShowItem.showAdminName(nAdminID, 3) %>" href="javascript:void(0)" data-toggle="dropdown">
              <i class="icon fa fa-user-secret fa-lg" aria-hidden="true"></i>
            </a>
            <ul role="menu" class="dropdown-menu">
              <li role="presentation">
                <a role="menuitem" href="javascript:void(0)" class="vertical-align-middle text-center"><img width="120" height="120" class="img-circle img-bordered img-bordered-primary" alt="<%=ShowItem.showAdminName(nAdminID, 3) %>" src="<%=appPath %>/sitemanagerphoto/<%=nAdminID %>"><br /><%=ShowItem.showAdminName(nAdminID, 3) %></a>
              </li>
              <li role="presentation">
                <a role="menuitem" href="<%=appPath %>/admin/AdminProfile.jsp"<%if(MenuLink.equalsIgnoreCase("Profile")){ %> class="active"<% } %>><i aria-hidden="true" class="icon wb-user"></i> Profile</a>
              </li>
              <li role="presentation">
                <a role="menuitem" href="<%=appPath %>/admin/changepassword.jsp"<%if(MenuLink.equalsIgnoreCase("ChangePassword")){ %> class="active"<% } %>><i aria-hidden="true" class="icon wb-edit"></i> Edit Password</a>
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
          <li id="toggleChat"><!-- Admin-Login-log.jsp site-sidebar.tpl-->
						<a data-url="<%=appPath %>/admin/AdminSidebar.jsp" title="Login Log" href="javascript:void(0)" data-toggle="site-sidebar">
              <i class="icon wb-more-vertical" aria-hidden="true"></i>
            </a>
          </li>
        </ul>
        <!-- End Navbar Toolbar Right -->
      </div>
      <!-- End Navbar Collapse -->

    </div>
  </nav>
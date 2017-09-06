<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" /> 
<% 
String appPath=request.getContextPath(); 
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
 
String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>
  <div class="site-menubar">
    <div class="site-menubar-header">
      <div class="cover overlay">
        <img class="cover-image" src="<%=appPath %>/assets/center/examples/images/dashboard-header.jpg" alt="...">
        <div class="overlay-panel vertical-align overlay-background">
          <div class="vertical-align-middle" style="width: 100%;">
            <a class="avatar avatar-lg" href="javascript:void(0)">
              <img src="<%=appPath %>/global/portraits/1.jpg" alt="">
            </a>
            <div class="site-menubar-info">
              <h5 class="site-menubar-user"><%=ShowItem.showAdminName(LogUsr.AdminID, 3) %></h5>
              <p class="site-menubar-email"><%=SiMngrBn.Email %></p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="site-menubar-body">
      <div>
        <div>
          <ul class="site-menu">
            <li <% if(MenuTitle.equalsIgnoreCase("DashboardTitle")){ %>class="site-menu-item has-sub active open" <% }else{ %>class="site-menu-item has-sub" <% } %>>
              <a href="javascript:void(0)">
                <i class="site-menu-icon wb-dashboard" aria-hidden="true"></i>
                <span class="site-menu-title">Dashboard</span>
                <div class="site-menu-badge">
                  <span class="badge badge-success">3</span>
                </div>
              </a>
              <ul class="site-menu-sub">
                <li <% if(MenuLink.equalsIgnoreCase("DashboardLink1")){ %>class="site-menu-item active" <% }else{ %>class="site-menu-item" <% } %>>
                  <a class="animsition-link" href="../index-2.html">
                    <span class="site-menu-title">Dashboard v1</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../dashboard/v2.html">
                    <span class="site-menu-title">Dashboard v2</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../dashboard/ecommerce.html">
                    <span class="site-menu-title">Ecommerce</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../dashboard/analytics.html">
                    <span class="site-menu-title">Analytics</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../dashboard/team.html">
                    <span class="site-menu-title">Team</span>
                  </a>
                </li>
              </ul>
            </li>
            <li class="site-menu-item has-sub">
              <a href="javascript:void(0)">
                <i class="site-menu-icon wb-layout" aria-hidden="true"></i>
                <span class="site-menu-title">Layouts</span>
                <span class="site-menu-arrow"></span>
              </a>
              <ul class="site-menu-sub">
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/menubar-fold.html">
                    <span class="site-menu-title">Menubar Fold</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/menubar-disable-hover.html">
                    <span class="site-menu-title">Menubar Disable Hover</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/menubar-open.html">
                    <span class="site-menu-title">Menubar Open</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/menubar-push.html">
                    <span class="site-menu-title">Menubar Push</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/grids.html">
                    <span class="site-menu-title">Grid Scaffolding</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/layout-grid.html">
                    <span class="site-menu-title">Layout Grid</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/headers.html">
                    <span class="site-menu-title">Different Headers</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/panel-transition.html">
                    <span class="site-menu-title">Panel Transition</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/boxed.html">
                    <span class="site-menu-title">Boxed Layout</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/two-columns.html">
                    <span class="site-menu-title">Two Columns</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="../layouts/bordered-header.html">
                    <span class="site-menu-title">Bordered Header</span>
                  </a>
                </li>
              </ul>
            </li>
            <li class="site-menu-item has-sub">
              <a href="javascript:void(0)">
                <i class="site-menu-icon wb-file" aria-hidden="true"></i>
                <span class="site-menu-title">Pages</span>
                <span class="site-menu-arrow"></span>
              </a>
              <ul class="site-menu-sub">
                <li class="site-menu-item has-sub">
                  <a href="javascript:void(0)">
                    <span class="site-menu-title">Errors</span>
                    <span class="site-menu-arrow"></span>
                  </a>
                  <ul class="site-menu-sub">
                    <li class="site-menu-item">
                      <a class="animsition-link" href="error-400.html">
                        <span class="site-menu-title">400</span>
                      </a>
                    </li>
                    <li class="site-menu-item">
                      <a class="animsition-link" href="error-403.html">
                        <span class="site-menu-title">403</span>
                      </a>
                    </li>
                    <li class="site-menu-item">
                      <a class="animsition-link" href="error-404.html">
                        <span class="site-menu-title">404</span>
                      </a>
                    </li>
                    <li class="site-menu-item">
                      <a class="animsition-link" href="error-500.html">
                        <span class="site-menu-title">500</span>
                      </a>
                    </li>
                    <li class="site-menu-item">
                      <a class="animsition-link" href="error-503.html">
                        <span class="site-menu-title">503</span>
                      </a>
                    </li>
                  </ul>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="faq.html">
                    <span class="site-menu-title">FAQ</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="gallery.html">
                    <span class="site-menu-title">Gallery</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="gallery-grid.html">
                    <span class="site-menu-title">Gallery Grid</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="search-result.html">
                    <span class="site-menu-title">Search Result</span>
                  </a>
                </li>
                <li class="site-menu-item has-sub">
                  <a href="javascript:void(0)">
                    <span class="site-menu-title">Maps</span>
                    <span class="site-menu-arrow"></span>
                  </a>
                  <ul class="site-menu-sub">
                    <li class="site-menu-item">
                      <a class="animsition-link" href="map-google.html">
                        <span class="site-menu-title">Google Maps</span>
                      </a>
                    </li>
                    <li class="site-menu-item">
                      <a class="animsition-link" href="map-vector.html">
                        <span class="site-menu-title">Vector Maps</span>
                      </a>
                    </li>
                  </ul>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="maintenance.html">
                    <span class="site-menu-title">Maintenance</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="forgot-password.html">
                    <span class="site-menu-title">Forgot Password</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="lockscreen.html">
                    <span class="site-menu-title">Lockscreen</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="login.html">
                    <span class="site-menu-title">Login</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="register.html">
                    <span class="site-menu-title">Register</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="login-v2.html">
                    <span class="site-menu-title">Login V2</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="register-v2.html">
                    <span class="site-menu-title">Register V2</span>
                    <div class="site-menu-label">
                      <span class="label label-info label-round">new</span>
                    </div>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="login-v3.html">
                    <span class="site-menu-title">Login V3</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="register-v3.html">
                    <span class="site-menu-title">Register V3</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="user.html">
                    <span class="site-menu-title">User List</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="invoice.html">
                    <span class="site-menu-title">Invoice</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="blank.html">
                    <span class="site-menu-title">Blank Page</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="email.html">
                    <span class="site-menu-title">Email</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="code-editor.html">
                    <span class="site-menu-title">Code Editor</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="profile.html">
                    <span class="site-menu-title">Profile</span>
                  </a>
                </li>
                <li class="site-menu-item">
                  <a class="animsition-link" href="site-map.html">
                    <span class="site-menu-title">Sitemap</span>
                  </a>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
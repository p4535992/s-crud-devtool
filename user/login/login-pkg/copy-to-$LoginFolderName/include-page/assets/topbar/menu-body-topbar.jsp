<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%> 
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath=request.getContextPath();
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);

String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>
<!--

 <% if(MenuTitle.equalsIgnoreCase("DashboardTitle")){ %>class="" <% }else{ %>class="" <% } %>
 <% if(MenuLink.equalsIgnoreCase("DashboardLink1")){ %>class="" <% }else{ %>class="" <% } %>
 // for section
 <% if(MenuLink.equalsIgnoreCase("DashboardLink1") || MenuLink.equalsIgnoreCase("DashboardLink2")){ %>class="" <% }else{ %>class="" <% } %>
 
// ================for withot section [single]==================================

scenario 1 : dropdown : withot section [single] > link as dropdown > link

//top dropdown
dropdown site-menu-item has-sub : dropdown site-menu-item has-sub active
    //drop list item
   > site-menu-item has-sub : site-menu-item has-sub active open
	     //link
	    > site-menu-item : site-menu-item active

scenario 2 : dropdown : withot section [single] > link
//top dropdown
dropdown site-menu-item has-sub : dropdown site-menu-item has-sub active
	   //link
   > site-menu-item : site-menu-item active


		
// ================End withot section [single]==================================
  
// ================for section==================================================

scenario 1 : dropdown > section > link as dropdown > link
//top dropdown
dropdown site-menu-item has-section has-sub : dropdown site-menu-item has-section has-sub active
    //section
  > site-menu-section site-menu-item has-sub : site-menu-section site-menu-item has-sub active
      //drop list item	
    > site-menu-item has-sub : site-menu-item has-sub active open
		     //link
			 > site-menu-item : site-menu-item active
			
scenario 2 : dropdown > section > link	

//top dropdown
dropdown site-menu-item has-section has-sub : dropdown site-menu-item has-section has-sub active
    //section
  > site-menu-section site-menu-item has-sub : site-menu-section site-menu-item has-sub active
		   //link
		> site-menu-item : site-menu-item active

// ======================End section============================================

-->
  <div class="site-menubar site-menubar-light">
    <div class="site-menubar-body">
      <div>
        <div>
          <ul class="site-menu">
            <li class="site-menu-category">General</li>
            <li class="dropdown site-menu-item has-sub">
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
                <i class="site-menu-icon wb-layout" aria-hidden="true"></i>
                <span class="site-menu-title">Layouts</span>
                <span class="site-menu-arrow"></span>
              </a>
              <div class="dropdown-menu">
                <div class="site-menu-scroll-wrap is-list">
                  <div>
                    <div>
                      <ul class="site-menu-sub site-menu-normal-list">
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
                        <li class="site-menu-item">
                          <a class="animsition-link" href="../layouts/page-aside-fixed.html">
                            <span class="site-menu-title">Page Aside Fixed</span>
                          </a>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </li>
            <li class="dropdown site-menu-item has-sub">
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
                <i class="site-menu-icon wb-file" aria-hidden="true"></i>
                <span class="site-menu-title">Pages</span>
                <span class="site-menu-arrow"></span>
              </a>
              <div class="dropdown-menu">
                <div class="site-menu-scroll-wrap is-list">
                  <div>
                    <div>
                      <ul class="site-menu-sub site-menu-normal-list">
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
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </li>
            <li class="site-menu-category">Elements</li>
            <li class="dropdown site-menu-item has-section has-sub">
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
                <i class="site-menu-icon wb-bookmark" aria-hidden="true"></i>
                <span class="site-menu-title">UI</span>
                <span class="site-menu-arrow"></span>
              </a>
              <ul class="dropdown-menu site-menu-sub site-menu-section-wrap blocks-sm-3">
                <li class="site-menu-section site-menu-item has-sub">
                  <header>
                    <span class="site-menu-title">Basic UI</span>
                    <span class="site-menu-arrow"></span>
                  </header>
                  <div class="site-menu-scroll-wrap is-section">
                    <div>
                      <div>
                        <ul class="site-menu-sub site-menu-section-list">
                          <li class="site-menu-item has-sub">
                            <a href="javascript:void(0)">
                              <span class="site-menu-title">Panel</span>
                              <span class="site-menu-arrow"></span>
                            </a>
                            <ul class="site-menu-sub">
                              <li class="site-menu-item">
                                <a class="animsition-link" href="../uikit/panel-structure.html">
                                  <span class="site-menu-title">Panel Structure</span>
                                </a>
                              </li>
                              <li class="site-menu-item">
                                <a class="animsition-link" href="../uikit/panel-actions.html">
                                  <span class="site-menu-title">Panel Actions</span>
                                </a>
                              </li>
                              <li class="site-menu-item">
                                <a class="animsition-link" href="../uikit/panel-portlets.html">
                                  <span class="site-menu-title">Panel Portlets</span>
                                </a>
                              </li>
                            </ul>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/buttons.html">
                              <span class="site-menu-title">Buttons</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/dropdowns.html">
                              <span class="site-menu-title">Dropdowns</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/icons.html">
                              <span class="site-menu-title">Icons</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/list.html">
                              <span class="site-menu-title">List</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/tooltip-popover.html">
                              <span class="site-menu-title">Tooltip &amp; Popover</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/modals.html">
                              <span class="site-menu-title">Modals</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/tabs-accordions.html">
                              <span class="site-menu-title">Tabs &amp; Accordions</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/images.html">
                              <span class="site-menu-title">Images</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/badges-labels.html">
                              <span class="site-menu-title">Badges &amp; Labels</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/progress-bars.html">
                              <span class="site-menu-title">Progress Bars</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/carousel.html">
                              <span class="site-menu-title">Carousel</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/typography.html">
                              <span class="site-menu-title">Typography</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/colors.html">
                              <span class="site-menu-title">Colors</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../uikit/utilities.html">
                              <span class="site-menu-title">Utilties</span>
                            </a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </li>
                <li class="site-menu-section site-menu-item has-sub">
                  <header>
                    <span class="site-menu-title">Advanced UI</span>
                    <span class="site-menu-arrow"></span>
                  </header>
                  <div class="site-menu-scroll-wrap is-section">
                    <div>
                      <div>
                        <ul class="site-menu-sub site-menu-section-list">
                          <li class="site-menu-item hidden-xs site-tour-trigger">
                            <a href="javascript:void(0)">
                              <span class="site-menu-title">Tour</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/animation.html">
                              <span class="site-menu-title">Animation</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/highlight.html">
                              <span class="site-menu-title">Highlight</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/lightbox.html">
                              <span class="site-menu-title">Lightbox</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/scrollable.html">
                              <span class="site-menu-title">Scrollable</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/rating.html">
                              <span class="site-menu-title">Rating</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/context-menu.html">
                              <span class="site-menu-title">Context Menu</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/alertify.html">
                              <span class="site-menu-title">Alertify</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/masonry.html">
                              <span class="site-menu-title">Masonry</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/treeview.html">
                              <span class="site-menu-title">Treeview</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/toastr.html">
                              <span class="site-menu-title">Toastr</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/maps-vector.html">
                              <span class="site-menu-title">Vector Maps</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/maps-google.html">
                              <span class="site-menu-title">Google Maps</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/sortable-nestable.html">
                              <span class="site-menu-title">Sortable &amp; Nestable</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../advanced/bootbox-sweetalert.html">
                              <span class="site-menu-title">Bootbox &amp; Sweetalert</span>
                            </a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </li>
                <li class="site-menu-section site-menu-item has-sub">
                  <header>
                    <span class="site-menu-title">Structure</span>
                    <span class="site-menu-arrow"></span>
                  </header>
                  <div class="site-menu-scroll-wrap is-section">
                    <div>
                      <div>
                        <ul class="site-menu-sub site-menu-section-list">
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/alerts.html">
                              <span class="site-menu-title">Alerts</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/ribbon.html">
                              <span class="site-menu-title">Ribbon</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/pricing-tables.html">
                              <span class="site-menu-title">Pricing Tables</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/overlay.html">
                              <span class="site-menu-title">Overlay</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/cover.html">
                              <span class="site-menu-title">Cover</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/timeline-simple.html">
                              <span class="site-menu-title">Simple Timeline</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/timeline.html">
                              <span class="site-menu-title">Timeline</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/step.html">
                              <span class="site-menu-title">Step</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/comments.html">
                              <span class="site-menu-title">Comments</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/media.html">
                              <span class="site-menu-title">Media</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/chat.html">
                              <span class="site-menu-title">Chat</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/testimonials.html">
                              <span class="site-menu-title">Testimonials</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/nav.html">
                              <span class="site-menu-title">Nav</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/navbars.html">
                              <span class="site-menu-title">Navbars</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/blockquotes.html">
                              <span class="site-menu-title">Blockquotes</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/pagination.html">
                              <span class="site-menu-title">Pagination</span>
                            </a>
                          </li>
                          <li class="site-menu-item">
                            <a class="animsition-link" href="../structure/breadcrumbs.html">
                              <span class="site-menu-title">Breadcrumbs</span>
                            </a>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SiAuthBn" scope="page" class="com.db.$DATABASE.Sitemanager_authorizationBean" /> 
<%! 
final static int DATABASE = 1 ;
final static int SMS = 2 ;
%>
<% 
String appPath=request.getContextPath(); 
com.$WEBAPP.LoggedSitemanager LogUsr = (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiBn.locateRecord(LogUsr.AdminID);

boolean bAuthorization = false ;

int no=0;
StringBuilder sb = new StringBuilder();
ArrayList<String> Module = new ArrayList<String>();

boolean bAllowDataBase = false ;
boolean bSMS = false;

  if(SiAuthBn.locateOnField("AdminID", ""+SiBn.AdminID))
  {
	  bAuthorization = true ;
    SiAuthBn.openTable("WHERE `AdminID`="+LogUsr.AdminID+" ","");
    while(SiAuthBn.nextRow())
    {
      if(no>0) sb.append(",");
      sb.append(SiAuthBn.ModuleID);
      no ++;
    }
    SiAuthBn.closeTable();
    Module = CSVHelper.arrayListFromCsv(""+sb);
    
    if(Module.contains("1") ) bAllowDataBase = true ;
		if(Module.contains("2") ) bSMS = true ;
  }
  else
	{
	  bAuthorization = false ;
	  bAllowDataBase = false ; 
		bSMS = false ;
	}


String MenuTitle = request.getParameter("MenuTitle");
String MenuLink = request.getParameter("MenuLink");
%>
<style type="text/css">
<!-- 
.fa-lg1 {
    font-size: 1.15em;
    line-height: 1em;
    vertical-align: 0;
} 
-->
</style>
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
<!-- MenuLink : <%=MenuLink %> -->
  <div class="site-menubar site-menubar-light">
    <div class="site-menubar-body">
      <div>
        <div>
          <ul class="site-menu">
					
            <li class="site-menu-category">System</li>
						
						<li <% if(MenuTitle.equalsIgnoreCase("DashboardTitle")){ %>class="site-menu-item active" <% }else{ %>class="site-menu-item" <% } %>>
              <a href="<%=appPath %>/admin/index.jsp">
                <i aria-hidden="true" class="site-menu-icon fa fa-lg1 fa-dashboard"></i>
                <span class="site-menu-title">Dashboard</span>
              </a>
            </li>
					 <% 
					 if(SiBn.SuperAdminRight == 1 && bAllowDataBase == true)
           {
					 %>
						
						<li <% if(MenuTitle.equalsIgnoreCase("DatabaseTitle")){ %>class="dropdown site-menu-item has-sub active" <% }else{ %>class="dropdown site-menu-item has-sub" <% } %>>
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
								<i class="site-menu-icon fa fa-lg1 fa-database" aria-hidden="true" style="font-size: 1em;"></i>
                <span class="site-menu-title">Database</span>
                <span class="site-menu-arrow"></span>
              </a>
              <div class="dropdown-menu">
                <div class="site-menu-scroll-wrap is-list">
                  <div>
                    <div>
                      <ul class="site-menu-sub site-menu-normal-list">
                        
												<li <% if(MenuLink.equalsIgnoreCase("MasterLink")){ %>class="site-menu-item active" <% }else{ %>class="site-menu-item" <% } %>>
                          <a class="animsition-link" href="<%=appPath %>/admin/master/attriblist.jsp?M=<%=DATABASE %>">
														<i class="site-menu-icon wb-library" aria-hidden="true"></i>
                            <span class="site-menu-title">&nbsp;Master</span>
                          </a>
                        </li>
												
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </li>
						
							 <% 
							 } // END if(SiBn.SuperAdminRight == 1 || bAllowDataBase == true)
							 %>
							 
							<% 
							if(SiBn.SuperAdminRight == 1 && bSMS == true )
           		{
					 		%>
							
							<li class="site-menu-category">SMS & Email</li>

						<li <% if(MenuTitle.equalsIgnoreCase("SMSTitle")){ %>class="dropdown site-menu-item has-sub active" <% }else{ %>class="dropdown site-menu-item has-sub" <% } %>>
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
								<i class="site-menu-icon fa fa-envelope-o fa-lg1" aria-hidden="true"></i>
                <span class="site-menu-title">SMS</span>
                <span class="site-menu-arrow"></span>
              </a>
              <div class="dropdown-menu">
                <div class="site-menu-scroll-wrap is-list">
                  <div>
                    <div>
                      <ul class="site-menu-sub site-menu-normal-list">
                        
												<li <% if(MenuLink.equalsIgnoreCase("QuickSMSLink")){ %>class="site-menu-item active" <% }else{ %>class="site-menu-item" <% } %>>
                          <a class="animsition-link" href="<%=appPath %>/admin/sms/quicksms.jsp?M=<%=SMS %>">
														<i class="site-menu-icon fa fa-motorcycle fa-lg1" aria-hidden="true"></i>
                            <span class="site-menu-title">&nbsp;Quick</span>
                          </a>
                        </li>
												<li <% if(MenuLink.equalsIgnoreCase("ExcelSMSLink")){ %>class="site-menu-item active" <% }else{ %>class="site-menu-item" <% } %>>
                          <a class="animsition-link" href="<%=appPath %>/admin/sms/smsfromexcel.jsp?M=<%=SMS %>">
														<i class="site-menu-icon fa fa-file-excel-o fa-lg1" aria-hidden="true"></i>
                            <span class="site-menu-title">&nbsp;Excel</span>
                          </a>
                        </li>

                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </li>					 

							<% 
							} // if(SiBn.SuperAdminRight == 1 || bSMS == true )
							%>
						
            <!-- <li class="site-menu-category">Elements</li> -->
            <li class="dropdown site-menu-item has-section has-sub">
              <a class="dropdown-toggle" href="javascript:void(0)" data-dropdown-toggle="false">
							<!-- 
                <i class="site-menu-icon wb-bookmark" aria-hidden="true"></i>
                <span class="site-menu-title">UI</span>
                <span class="site-menu-arrow"></span>
								 -->
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
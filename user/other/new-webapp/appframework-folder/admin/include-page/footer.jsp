<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%> 
<%@ page import="com.webapp.utils.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

java.sql.Date today = DateTimeHelper.today();
int cYear = today.getYear()+1900;
%>
  <!-- Footer -->
  <footer class="site-footer">
    <div class="site-footer-legal">&copy; <%=cYear %> <a href="javascript:void(0)" target="_blank" ><span class="text-uppercase" ><%=ApplicationResource.ProductName %></span></a></div>
    <div class="site-footer-right">
      <small>Develop with <i class="red-600 wb wb-heart"></i> by <a href="javascript:void(0)" target="_blank" ><span class="text-uppercase" ><%=ApplicationResource.CompanyName %></span></a></small>
    </div>
  </footer>
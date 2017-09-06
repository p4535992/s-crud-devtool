<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%>
<%@ page import="com.webapp.utils.*"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

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
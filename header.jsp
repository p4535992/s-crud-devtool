<%@ page import="com.beanwiz.*, java.net.InetAddress "%>
<% 
String appPath = request.getContextPath() ;
InetAddress iAddress = InetAddress.getLocalHost();
  String currentIp = iAddress.getHostAddress();
	//InetAddress.getLocalHost().getHostAddress()
	String hostname = iAddress.getHostName();
/*
  InetAddress inet = InetAddress.getLocalHost();
  InetAddress[] ips = InetAddress.getAllByName(inet.getCanonicalHostName());
  if (ips  != null ) {
    for (int i = 0; i < ips.length; i++) {
      out.println(ips[i]+"</br>");
    }
  }
*/
%>

<nav class="navbar navbar-default navbar-fixed-top site-header">
  <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="<%=appPath %>/index.jsp"><i class="fa fa-motorcycle fa-lg text-primary"></i>&nbsp;&nbsp;Development Tool</a>
        </div>
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav">
        <li class="dropdown"> 
				  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-umbrella fa-lg text-primary"></i>&nbsp;&nbsp;User Host&nbsp;<span class="caret"></span></a>
          <ul class="dropdown-menu">
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;Automatic login permitted for Host [localhost]</samp></a></li>
            <li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;Host : <%=request.getRemoteHost() %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;get Hostname of the current Server name : <%=hostname %></samp></a></li>
            <li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;returns the clients IP : <%=request.getRemoteAddr() %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;Host Addr [get the local address] : <%=currentIp %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg text-primary"></i>&nbsp;returns the IP of the server the application is running on : <%=request.getLocalAddr() %></samp></a></li>
          </ul>
        </li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#contact" data-toggle="modal" data-target="#myModal"><i class="fa fa-ambulance fa-lg text-primary"></i>&nbsp;&nbsp;Contact</a></li>
      </ul>
    </div>
    <!--/.nav-collapse -->
  </div>
</nav>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"><!--  animated zoomInDown -->
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"><i aria-hidden="true" class="icon glyphicon glyphicon-phone-alt"></i>&nbsp;&nbsp;Contact</h4>
      </div>
      <div class="modal-body">
        Na male
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<%@ page import="com.beanwiz.*, java.net.InetAddress "%>
<% 
String appPath = request.getContextPath() ;
com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
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
					<a class="navbar-brand" href="#"><i class="fa fa-motorcycle fa-lg text-primary"></i>&nbsp;&nbsp;Development Tool</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
<!-- 					
        <li class="dropdown"> 
				  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-umbrella fa-lg text-primary"></i>&nbsp;&nbsp;User Host&nbsp;<span class="caret"></span></a>
          <ul class="dropdown-menu">
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Automatic login permitted for Host [localhost]</samp></a></li>
            <li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Host : <%=request.getRemoteHost() %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;get Hostname of the current Server name : <%=hostname %></samp></a></li>
            <li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;returns the clients IP : <%=request.getRemoteAddr() %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Host Addr [get the local address] : <%=currentIp %></samp></a></li>
						<li><a href="#"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;returns the IP of the server the application is running on : <%=request.getLocalAddr() %></samp></a></li>
          </ul>
        </li>
 -->				
          </ul>
          <ul class="nav navbar-nav navbar-right">	
					  <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg text-primary"></i>&nbsp;&nbsp;Home</a></li>		
            <li><a href="#" data-toggle="modal" data-target="#ContactModal"><i class="fa fa-ambulance fa-lg text-primary"></i>&nbsp;&nbsp;Contact</a></li>
            <li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" title="<%=LogUsr.getUserName() %>"><i class="fa fa-user fa-lg text-primary"></i>&nbsp;&nbsp;<span class="visible-xs-inline-block"><%=LogUsr.getUserName() %>&nbsp;<span class="caret"></span></span></a>
              <ul class="dropdown-menu">
                <li>
                  <div class="navbar-User row-fluid-text">
                    <div class="row">
                      <div class="col-md-3">
                        <p class="text-center"><i class="fa fa-user text-primary" style="font-size: 70px;"></i></p>
                      </div>
                      <div class="col-md-9">
                        <p class="text-left"><strong><%=LogUsr.getUserName() %></strong></p>
                        <p class="text-left small">crazytodevelop@@gmail.com</p>
												<h3 class="text-left"><span class="label label-primary"><i class="fa fa-universal-access fa-lg"></i>&nbsp;&nbsp;<%=LogUsr.getTitle() %></span></h3>
                        
                      </div>
                    </div>
                  </div>
                </li>
                
                <li>
                  <!-- List group -->
                  <div class="list-group navbar-User-list">
									  <button type="button" class="list-group-item" onclick=""><i class="fa fa-user-secret fa-lg text-primary"></i>&nbsp;&nbsp;Profile</button>
										<button type="button" class="list-group-item" onclick="LogoutConfirm('<%=appPath %>/user/userlogout.jsp')"><i class="fa fa-sign-out fa-lg text-primary"></i>&nbsp;&nbsp;Log Out</button>
                  </div>
                </li>
              </ul>
              </li>
				      <li><a href="#" data-toggle="modal" data-target="#wrenchModal" id="wrenchModaltrigger"  title="Other Developement Tool"><i class="fa fa-wrench fa-lg text-primary"></i>&nbsp;&nbsp;<span class="visible-xs-inline-block">Other Developement Tool</span></a></li>
					</ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>


<!-- Modal -->
<div class="modal animated zoomInDown" id="ContactModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-ambulance fa-lg text-primary"></i>&nbsp;&nbsp;Contact</h4>
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

<!-- Modal -->
<div class="modal right fade wrenchModal" id="wrenchModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header" >
        <button type="button" class="close visible-xs-inline" data-dismiss="modal" aria-label="Close"><span aria-hidden="true" class="fa fa-close"></span></button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-wrench fa-lg"></i>&nbsp;&nbsp;Other Developement Tool</h4>
      </div>
      <div class="modal-body" >
      <ul class="nav nav-pills nav-stacked accordian-stacked-menu" id="stacked-menu">
			  <li class="panel"><a class="nav-container" href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg text-primary"></i>&nbsp;&nbsp;Home</a></li>
        <li class="panel"><a class="nav-container" href="<%=appPath %>/user/other/statusflags/index.jsp"><i class="fa fa-flag text-primary"></i>&nbsp;&nbsp;Status Flag Entities</a></li>
        <li class="panel"><a class="nav-container" href="<%=appPath %>/user/other/generic/index.jsp"><i class="fa fa-file-text text-primary"></i>&nbsp;&nbsp;Generic JSP Page</a></li>
        <li class="panel"><a class="nav-container" href="<%=appPath %>/user/other/excel-to-mysql-code/index.jsp"><i class="fa fa-file-o text-primary"></i>&nbsp;&nbsp;Get JSP: Excel To MySQL</a></li>
        <li class="panel"><a class="nav-container" data-parent="#stacked-menu" href="#Migrate" data-toggle="collapse" aria-expanded="false" aria-controls="Migrate"><i class="fa fa-database text-primary"></i>&nbsp;&nbsp;Migrate: Excel To MySQL<div class="caret-container"><i class="fa fa-plus text-primary"></i></div></a>
          <ul class="nav nav-pills nav-stacked foriconanim collapse" id="Migrate">
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/selectfile-create.jsp"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Insert Data From Excel<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( Create Table )</a></li>
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/selectfile-insert.jsp"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Insert Data From Excel<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;( Existing Table )</a></li>
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/excel-upload-template.jsp"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Process Excel Upload File</a></li>
          </ul>
        </li>
        <li class="panel"><a class="nav-container" data-parent="#stacked-menu" href="#AppFramework" data-toggle="collapse" aria-expanded="false" aria-controls="AppFramework"><i class="fa fa-fire-extinguisher fa-lg text-primary"></i>&nbsp;&nbsp;Get App Framework<div class="caret-container"><i class="fa fa-plus text-primary"></i></div></a>          
          <ul class="nav nav-pills nav-stacked foriconanim collapse" id="AppFramework">
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/new-webapp/index.jsp"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Web App Framework</a></li>
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/excelexport.zip"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Excel Export From Query</a></li>
                <li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/labelprint.zip"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Label Printing Code</a></li>
								<li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/email-support.zip"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;Email Sending Code</a></li>
								<li><a class="nav-sub-container" href="<%=appPath %>/user/other/excel-mysql-data-migrate/sms-support.zip"><i class="fa fa-hand-o-right text-primary"></i>&nbsp;&nbsp;SMS Sending Code</a></li>
          </ul>
        </li>





      </ul>
			</div>
			
				
    </div>	
  </div>
</div>




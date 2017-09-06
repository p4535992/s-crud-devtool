<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*, org.json.simple.*, org.json.simple.parser.*,"%>
<%@ page import="com.webapp.utils.*, com.webapp.resin.* " %>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Generic JSP Page</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
<style type="text/css">
<!--
.table > tbody > tr > td {
  vertical-align: middle;
}
-->
</style>
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Typical JSP Page</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Generic JSP Page</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />
<form action="generic-jsp-page.jsp" method="post" class="form-horizontal">

<div class="row">
  <div class="col-md-12">
	<button type="submit" class="btn btn-primary btn-lg btn-block"><i class="fa fa-download"></i>&nbsp;&nbsp;Get It!</button>
  </div>			
</div>
<div class="row">
  <div class="col-md-12">
	&nbsp;
  </div>			
</div>
			
<div class="row">
  <div class="col-md-4">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Page Information</h3>
        </div>
        <div class="panel-body">
				
				
<div class="table-responsive">			
<table class="table table-condensed borderless">
    <tr>
        <td>App. Name</td>
        <td><input type="text" name="AppName" id="AppName" class="form-control" /></td>
    </tr>
    <tr>
        <td>WebApp Pkg.</td>
        <td><input type="text" name="WebAppPkg" id="WebAppPkg" class="form-control" /></td>
    </tr>
    <tr>
        <td>DB. Pkg</td>
        <td><input type="text" name="DbPkg" id="DbPkg" class="form-control" /></td>
    </tr>
    <tr>
        <td>User Dir</td>
        <td><input type="text" name="LoginFolderName" id="LoginFolderName" value="admin" class="form-control" /></td>
    </tr>
    <tr>
        <td>Page Title</td>
        <td><input type="text" name="Title" id="Title" value="Manage ???" class="form-control" /></td>
    </tr>
    <tr>
        <td>Page Actions</td>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="HasActions" id="HasActions" value="true" />
				<label for="HasActions"><input type="text" name="PageActions" id="PageActions" value="Form, List, Update" class="form-control" /></label>
				</span>
				</td>
    </tr>

</table>
</div>

         </div>
      </div>			
	</div>
  <div class="col-md-4">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Vcomp. WebApp-Jar Pkg.</h3>
        </div>

<div class="table-responsive">			
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibsth" id="WebAppLibsth"/>
				<label for="WebAppLibsth">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Check All</b></label>
				</span>

</th>
</tr>
</thead>
<tbody>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsJSP" value="JSP" checked="checked" />
				<label for="WebAppLibsJSP">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;JSP</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsUTILS" value="UTILS" checked="checked" />
				<label for="WebAppLibsUTILS">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Utils</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsDB" value="DB" checked="checked" />
				<label for="WebAppLibsDB">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DB (Database)</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsRESIN" value="RESIN"/>
				<label for="WebAppLibsRESIN">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resin File Upload</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsBARCODE" value="BARCODE" />
				<label for="WebAppLibsBARCODE">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Barcode</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsHTTP-TOOLS" value="HTTP-TOOLS" />
				<label for="WebAppLibsHTTP-TOOLS">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HTTP Tools</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsPDF" value="PDF" />
				<label for="WebAppLibsPDF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF Helper</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsPOI" value="POI" />
				<label for="WebAppLibsPOI">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;POI Helper</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsMAIL" value="MAIL" />
				<label for="WebAppLibsMAIL">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MAIL Support</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="WebAppLibs" id="WebAppLibsSMS" value="SMS" />
				<label for="WebAppLibsSMS">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SMS Support</label>
				</span>
				</td>
    </tr>
</tbody>		
</table>
</div>

        
      </div>			
	</div>
  <div class="col-md-4">
      <div class="panel panel-default">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Third Party Jars</h3>
        </div>

<div class="table-responsive">			
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibsth" id="ThirdPartyLibsth"/>
				<label for="ThirdPartyLibsth">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Check All</b></label>
				</span>

</th>
</tr>
</thead>
<tbody>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsAPACHE-HTTP" value="APACHE-HTTP" />
				<label for="ThirdPartyLibsAPACHE-HTTP">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Apache HTTP Client</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsJODA-TIME" value="JODA-TIME" />
				<label for="ThirdPartyLibsJODA-TIME">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Joda Time</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsSIMPLE-JSON" value="SIMPLE-JSON" />
				<label for="ThirdPartyLibsSIMPLE-JSON">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Simple Json</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsXOM" value="XOM" />
				<label for="ThirdPartyLibsXOM">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;XOM Xml Parser</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsJSOUP" value="JSOUP" />
				<label for="ThirdPartyLibsJSOUP">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Jsoup HTML Parser</label>
				</span>
				</td>
    </tr>

    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsPOI-EXCEL" value="POI-EXCEL" />
				<label for="ThirdPartyLibsPOI-EXCEL">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Apache POI For Excel</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsPOI-WORD-OLD" value="POI-WORD-OLD" />
				<label for="ThirdPartyLibsPOI-WORD-OLD">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Apache POI For Word XP</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsPOI-WORD-NEW" value="POI-WORD-NEW" />
				<label for="ThirdPartyLibsPOI-WORD-NEW">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Apache POI For Word 2007</label>
				</span>
				</td>
    </tr>

    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsPDF-JET" value="PDF-JET" />
				<label for="ThirdPartyLibsPDF-JET">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF Jet</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsPDF-JPOD" value="PDF-JPOD" />
				<label for="ThirdPartyLibsPDF-JPOD">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PDF JPOD</label>
				</span>
				</td>
    </tr>
    <tr>
        <td>
				<span class="checkbox checkbox-inline checkbox-primary">
				<input type="checkbox" name="ThirdPartyLibs" id="ThirdPartyLibsZXING" value="ZXING" />
				<label for="ThirdPartyLibsZXING">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Zxing BarCode</label>
				</span>
				</td>
    </tr>
</tbody>			
</table>
</div>

      </div>			
	</div>
</div>				
</form>
    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--
$("#WebAppLibsth").click(function () {
        if ($("#WebAppLibsth").is(':checked')) {
            $("input[name=WebAppLibs]").each(function () {
                $(this).prop("checked", true);
            });

        } else {
            $("input[name=WebAppLibs]").each(function () {
                $(this).prop("checked", false);
            });
        }
    });
		
$("#ThirdPartyLibsth").click(function () {
        if ($("#ThirdPartyLibsth").is(':checked')) {
            $("input[name=ThirdPartyLibs]").each(function () {
                $(this).prop("checked", true);
            });

        } else {
            $("input[name=ThirdPartyLibs]").each(function () {
                $(this).prop("checked", false);
            });
        }
    });
		

$(document).ready(function(){
 // {{ Begin Init jQuery 
   $("#AppName").bind("keyup input paste", function() {
     var txt = $("#AppName").val();
		 $("#WebAppPkg").val("com."+txt);
		 $("#DbPkg").val("com.db."+txt);
   });
});
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

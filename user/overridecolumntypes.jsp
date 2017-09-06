<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" />
<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String ColName= request.getParameter("ColName");
String ColKey = request.getParameter("ColKey");
String ColSQLType = request.getParameter("colType");
int nCount = OverrideMap.size();

String Action = request.getParameter("Action");
if("Remove".equalsIgnoreCase(Action))
{
   OverrideMap.remove(ColKey);
	java.lang.StringBuffer rd = request.getRequestURL();
  rd.append(thisFile+"?Action=New&ColName="+ColName+"&ColKey="+ColKey+"&colType="+ColSQLType);
  response.sendRedirect(response.encodeRedirectURL(rd.toString()));
}
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Set Column Overrides</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body style="margin-bottom: 0px;padding-top: 10px;">   
<div class="container-fluid">

<% 
if("New".equalsIgnoreCase(Action))
{ 
%>

<div class="panel panel-primary">
  <div class="panel-heading">
    <h3 class="panel-title">Current Column Type: <%=ColSQLType %></h3>
  </div>
  <div class="panel-body">

<form action="<%=thisFile %>" method="post" onsubmit="return ChkValue()" id="OverrideMap_form">
<input type="hidden" name="Action" value="Add" />
<input type="hidden" name="ColName" value="<%=ColName %>" />
<input type="hidden" name="ColKey" value="<%=ColKey %>" />
<input type="hidden" name="colType" value="<%=ColSQLType %>" />	
  <div class="form-group">
    <label for="exampleInputEmail1"><%=ColName %></label>
    <%=com.beanwiz.ColTypeOverride.dropList() %>
  </div>

  <div class="form-group">
      <button type="submit" class="btn btn-primary">Go</button>
    </div>
  </div>	

</form>	
  </div>
</div>

<% 
} 
%>
<% 
if("Add".equalsIgnoreCase(Action))
{
   OverrideMap.put(ColKey, request.getParameter("JDBCType"));
%>
<div class="table-responsive">

<table class="table table-striped table-bordered">
<thead>
<tr>
<th>#</th>
<th>Field</th>
<th>JDBC Type</th>
<th>Remove</th>
</tr>
</thead>
<tbody>	
<% 
Iterator i =  OverrideMap.entrySet().iterator();
int n=0;
while (i.hasNext()) 
{
 Map.Entry entry = (Map.Entry) i.next();
 n++;
 String ky = (String)entry.getKey() ;
 int ty = Integer.parseInt(  (String)entry.getValue());
%>

<tr>
    <td><%=n %></td>
		<td><%=ky %></td>
		<td><%= ColTypeOverride.typeLabel(ty) %></td>
		<!-- <td><a href="<%=thisFile %>?Action=Remove&ColKey=<%=entry.getKey() %>&colType=<%=ColSQLType %>&ColName=<%=ColName %>" onclick="{ return confirm('Remove:<%=entry.getKey() %>' ) ; }">remove</a></td> -->
		<td><a href="#" onclick='removeConfirm("<%=thisFile %>?Action=Remove&ColKey=<%=entry.getKey() %>&colType=<%=ColSQLType %>&ColName=<%=ColName %>","<%=entry.getKey() %>")'>Remove</a></td>
</tr>
<% 
}
%>
</tbody>
</table>

</div>		
<%
}
%>
</div> <!-- /container -->

<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/nakupanda-modal-js.jsp" flush="true" />

<script type="text/javascript">
<!--
function ChkValue()
{
  var newval = $('#JDBCType').val() ;
	//alert(newval); 
	var lbl = $('#JDBCType :selected').text() ;
	if(newval=="0")
	{
	   //alert("Please select JDBC Type.");
		 //swal({title: "Please select JDBC Type !"});
		 BootstrapDialog.alert({
            title: '<i class="fa fa-bell-o fa-lg faa-shake animated"></i>&nbsp;&nbsp;Alert',
            message: 'Please select JDBC Type !',
						draggable: true,
						size: BootstrapDialog.SIZE_SMALL,
						type: BootstrapDialog.TYPE_WARNING
						
		 }); 
		 
	   return false ;
	}
return confirm("Please confirm !\nOverride column type to: "+lbl);
}
function removeConfirm(url,msg)
{
        BootstrapDialog.confirm({
            title: 'Are You Sure ?',
            message: 'Remove :'+msg,
            type: BootstrapDialog.TYPE_DANGER, // <-- Default value is BootstrapDialog.TYPE_PRIMARY
            callback: function(result) {
                // result will be true if button was click, while it will be false if users close the dialog directly.
                if(result) {
                    NavigateTo(url);		
                }else {
                    toastr.info('Remove Cancel !');
                }
            }
        });
}
// -->
</script>

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

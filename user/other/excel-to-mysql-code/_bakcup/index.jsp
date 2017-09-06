<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*, nu.xom.*" %><%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %>
<% 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();


 %>
<!DOCTYPE HTML >
<html>
<head>
<title>The Bean Wizard</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" /> 
<script type="text/javascript">
<!--
$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
  
	$("#excel_upload_form").validate({
	    rules: 
      {
          ExcelFile:"required",
					JNDIDSN:"required",
					TableName:"required"
      } 
	});

	
	$("#JNDIDSN_DROP_LIST").change(function(){
	  var val = $(this).val();
		$("#TBL-LIST").load("<%=appPath %>/user/droplist/tables-for-jndi.jsp?JNDIDSN="+val);
		 
	}) ;
	
	
 // End init
});

// -->
</script>
</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<div style="padding:1em;">
<ul>
<li><a href="javascript:void(0)"  onclick="{ $('#upload_form_div').show();  }" >Generate excel to mysql jsp page.</a>
     <div id="upload_form_div" style="display:none; padding:1em;">
		 <form action="setfields.jsp" id="excel_upload_form" method="post" enctype="multipart/form-data" >
         <table border="1" cellpadding="6" cellspacing="0" summary="">
            <tr>
                <td><span class="label">Select Excel File</span></td>
								<td><input type="file" enctype="multipart/form-data" name="ExcelFile" /></td>
            </tr>
						<tr>
                <td><span class="label">Web. App. Package</span></td>
								<td><input type="text" name="WebAppPkg" value="com.?"/></td>
            </tr>
						<tr>
                <td><span class="label">JNDI-DSN</span></td>
								<td>
								<jsp:include page="/user/droplist/get-jndi-dsn-list.jsp" flush="true">
                    <jsp:param name="ElementName" value="JNDIDSN" />
                </jsp:include>
								
								</td>
            </tr>
						<tr>
                <td><span class="label">Database Table</span></td>
								<td>
								 <span id="TBL-LIST">Select JNDI DSN First</span>
								
								</td>
            </tr>
						<tr>
                 <td><span class="label">Submit</span></td>
                 <td><button type="submit">Ok Upload Excel File</button>&nbsp;&nbsp;&nbsp;&nbsp;<button type="button" value="" onclick="{ $('#upload_form_div').hide(); }">Cancel</button></td>
            </tr>
        </table>
		 </form>
		 </div>

</li>
</ul>

</div>
</body>
</html>

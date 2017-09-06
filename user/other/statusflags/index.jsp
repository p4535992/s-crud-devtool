<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*, org.json.simple.*, org.json.simple.parser.*,"%>
<%@ page import="com.webapp.utils.*, com.webapp.resin.* " %>
<jsp:useBean id="ItemList" scope="session" class="TreeMap<Integer, JSONObject>" />

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Action=request.getParameter("Action") ;
String Message =null;

String PackageName ="";
String ClassName = "" ;

if(session.getAttribute("CLASS-NAME") !=null) ClassName = (String)session.getAttribute("CLASS-NAME");
if(session.getAttribute("PACKAGE-NAME") !=null) PackageName = (String)session.getAttribute("PACKAGE-NAME");



if("Add".equalsIgnoreCase(Action))
{
  Message = "One item added." ;
	String Field = request.getParameter("Field") ;
	String Value = request.getParameter("Value") ;
	String Label = request.getParameter("Label") ;
	int nVal = Integer.parseInt(Value);
	
	JSONObject jobj = new JSONObject();
	jobj.put("Field", Field) ;
	jobj.put("Value", Value) ;
	jobj.put("Label", Label) ;	
	ItemList.put(new Integer(nVal),jobj);
}
if("Delete".equalsIgnoreCase(Action))
{
    Integer delKey = Integer.valueOf(request.getParameter("Key")) ;
		ItemList.remove(delKey);
    Message = "One item removed." ;
}
if("Clear".equalsIgnoreCase(Action))
{
     
		ItemList.clear(); 
		session.removeAttribute("CLASS-NAME");
    session.removeAttribute("PACKAGE-NAME");
    Message = "All entities are cleared from list." ;
}
 
if("LoadJson".equalsIgnoreCase(Action))
{
 
   com.webapp.resin.ResinFileUpload RsFileUp = new com.webapp.resin.ResinFileUpload();
	 RsFileUp.load(application, request, "JSONFile");
	 String JsonInput = new String(RsFileUp.getFileBytes()).trim();
	 
   JSONParser parser=new JSONParser();
	 JSONObject JsonOb = (JSONObject)parser.parse(JsonInput);
	 PackageName = (String)JsonOb.get("PackageName");
   ClassName =  (String)JsonOb.get("ClassName");
	 JSONArray FieldItems = (JSONArray)JsonOb.get("FieldItems");
	 Message=FieldItems.toJSONString();
	 ItemList.clear(); 
	 
	 
	 for ( Object ob :  FieldItems) 
	 {
	    Object obv = ((JSONObject)ob).get("Value");
	    ItemList.put( Integer.valueOf((String)obv), (JSONObject)ob );
			Message = " ( "+ItemList.size()+" ) Object loaded from file: "+RsFileUp.getFileName();
	 }
	 
	 session.setAttribute("CLASS-NAME", ClassName );
	 session.setAttribute("PACKAGE-NAME", PackageName );
	 
}
int count = ItemList.size();
%>

<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Status Flag POJO</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
<style type="text/css">
<!-- 
.error1 {
color: #a94442;
font-weight: 500;
font-size: 85%;
}
-->
</style>
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Status Flag POJO</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Status Flag POJO</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />

<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Entity : </span><span class="text-muted"><%=count %></span></big>
    </div>
    <div class="col-md-6">
    </div>
  </div>

</div>	

<button type="button" class="btn btn-circle fixed-add-btn-circle" onclick="{ $('#LoadJSONBlock').toggle(); }"><i class="fa fa-upload fa-lg"></i></button>

<div class="row">

  <div class="col-md-5">

<div class="panel panel-default" id="LoadJSONBlock" style="display:none">
  <!-- Default panel contents -->
  <div class="panel-heading">
	   <h3 class="panel-title"><i class="fa fa-upload text-primary"></i>&nbsp;&nbsp;Upload File</h3>
	</div>
	<div class="panel-body">
<form action="<%=thisFile %>" method="post" id="LoadJSONForm" enctype="multipart/form-data">
<input type="hidden" name="Action" value="LoadJson" />

<div class="row" align="center">
  
	<div class="form-group">
	<div class="col-md-12">
    <div class="input-group">
		  <input type="file" enctype="multipart/form-data" name="JSONFile" class="form-control" placeholder="Select File" />
      <span class="input-group-btn">
        <button class="btn btn-default" type="submit"><i class="fa fa-upload fa-lg text-primary"></i></button>
      </span>	
    </div><!-- /input-group -->
  </div><!-- /.col-md-12 -->
	</div>
	
</div><!-- /.row -->

</form>
	</div>
</div>	
	

<% 
if(count > 0 ){ 
%>

<div class="panel panel-default">
  <!-- Default panel contents -->
  <div class="panel-heading">
	   <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Entity List</h3>
	</div>

  <!-- Table -->
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th width="5%">#</th>
<th>Field</th>
<th width="7%">Value</th>
<th>Label</th>
<th width="7%"><span><button type="button" class="btn btn-primary btn-sm" onclick="clearList('<%=thisFile %>?Action=Clear')">Clear List</button></span></th>
</tr>
</thead>
<tbody>
<%
int index=0;
  
for( Map.Entry<Integer, JSONObject> entry : ItemList.entrySet() )
{
		   index++;
       Integer Key = (Integer)entry.getKey();
			 JSONObject item = (JSONObject)entry.getValue();
		   String Fld = (String)item.get("Field");
		   String Val = (String)item.get("Value");
		   String Lbl = (String)item.get("Label");
%>
    <tr>
		<td><%=index %></td>
		<td><%=Fld %></td>
		<td><%=Val %></td>
		<td><%=Lbl %></td>
		<td align="center"><a href="#" onclick="deleteEntityItem('<%=thisFile %>?Action=Delete&Key=<%=Key %>','Delete Item [ <%=Key %>: <%=Fld  %>  ]')"><i class="fa fa-trash-o fa-lg text-primary"></i></a></td>
		</tr>
<%   
} 
%>
</tbody>
</table>
</div>

</div>
<% 
} 
%>	

	</div>
	
  <div class="col-md-3">
	
<div class="panel panel-default" id="NewItemBlock" ><!-- <% if(count == 0 ){ %>style="display:none"<% } %>  -->
  <!-- Default panel contents -->
  <div class="panel-heading">
	   <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Add New Entity</h3>
	</div>
	<div class="panel-body">	
<form action="<%=thisFile %>" method="post" id="NewItemForm" class="form-horizontal">
<input type="hidden" name="Action" value="Add" />

  <div class="form-group">
    <label for="Field" class="col-sm-3 control-label">Field</label>
    <div class="col-sm-9">
      <input type="text" name="Field" class="form-control" id="Field" placeholder="Class Entity" style="text-transform: uppercase">
    </div>
  </div>
  <div class="form-group">
    <label for="Value" class="col-sm-3 control-label">Value</label>
    <div class="col-sm-9">
      <input type="text" name="Value" class="form-control" id="Value" placeholder="Assign value">
    </div>
  </div>
  <div class="form-group">
    <label for="Label" class="col-sm-3 control-label">Label</label>
    <div class="col-sm-9">
      <input type="text" name="Label" class="form-control" id="Label" placeholder="Display Name">
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button type="submit" class="btn btn-primary"><i class="fa fa-plus"></i>&nbsp;&nbsp;Add</button>
			<button type="button" class="btn btn-primary fRESET">Reset</button>
    </div>
  </div>

</form>
	</div>
</div>	

	</div>

<% 
if(count > 0 ){ 
%>
  <div class="col-md-4">

<div class="panel panel-default" id="JavaCodeBlock" ><!-- style="display:none" -->
  <!-- Default panel contents -->
  <div class="panel-heading">
	   <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Get JAVA &amp; JSON Page</h3>
	</div>
	<div class="panel-body">	
	
<form action="getjavaclass.jsp" method="post" id="JavaClassForm" class="form-horizontal" target="_blank" >

  <div class="form-group">
    <label for="ClassName" class="col-sm-4 control-label">Class Name</label>
    <div class="col-sm-8">
		  <div class="input-group">
       <span class="input-group-addon" id="basic-addon1">@</span>
      <input type="text" name="ClassName" value="<%=ClassName %>" class="form-control" id="ClassName">
			</div>
    </div>
  </div>
  <div class="form-group">
    <label for="PackageName" class="col-sm-4 control-label">Java Package</label>
    <div class="col-sm-8">
      <input type="text" name="PackageName" value="<%=PackageName %>" class="form-control" id="PackageName">
    </div>
  </div>


  <div class="form-group">
	  <div class="row">
    <div class="col-md-6"><!-- onclick="getJavaClassForm()" button -->
      <button type="submit" id="getJavaClassForm" class="btn btn-primary pull-right" onclick="{ $('#JavaClassForm').attr('action', 'getjavaclass.jsp'); }"><i class="fa fa-download"></i>&nbsp;&nbsp;Java Class</button>
    </div>
    <div class="col-md-6"><!-- onclick="getJSONClassForm()" -->
      <button type="submit" id="getJSONClassForm" class="btn btn-primary" onclick="{ $('#JavaClassForm').attr('action', 'getjsonobject.jsp'); }"><i class="fa fa-download"></i>&nbsp;&nbsp;JSON Object</button>
		</div>
		</div>
  </div>

</form>
	</div>
</div>
	
	</div>	
<% 
} 
%>	
	
</div>


</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/formValidation-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/jvalidate-js.jsp" flush="true" />
<script type="text/javascript">
<% 
if(Message!=null)
{ 
%>
toastr.info("<%=Message %>");
<% 
} 
%>

function clearList(url) {
  swal({
    title: "Are you sure?",
    text: "Remove All Entity from the List!",
    type: "warning",
    showCancelButton: true,
    closeOnConfirm: false	
  }).then(function(isConfirm) {
    if (isConfirm === true) {
      NavigateTo(url);
    }
    else if (isConfirm === false) {
      toastr.info('Cancel !');
    }
    else {
      //swal('Any fool can use a computer');
    }
  });
}


function deleteEntityItem(url,msg) {
  swal({
    title: "Please confirm !",
    text: msg,
    type: "warning",
    showCancelButton: true,
    closeOnConfirm: false	
  }).then(function(isConfirm) {
    if (isConfirm === true) {
      NavigateTo(url);
    }
    else if (isConfirm === false) {
      toastr.info('Delete Cancel !');
    }
    else {
      //swal('Any fool can use a computer');
    }
  });
}
		
$(document).ready(function() {

	  $("#JavaClassForm").validate({ 
	      rules: 
        {
				 ClassName:"required",
				 PackageName:"required"
				 
				}
	   });
		  		
	  $("#LoadJSONForm").validate({ 
	      rules: 
        {
				 JSONFile:"required"
				}
	   }); 

/*
    $('#LoadJSONForm').formValidation({
        framework: 'bootstrap',
        fields: {
            JSONFile: {
						    row: '.col-md-12',
                validators: {
                    notEmpty: {
                        message: 'The Field is required'
                    }
                }
            }
        }
    });		
*/		
    $('#NewItemForm').formValidation({
        framework: 'bootstrap',
        fields: {
            Field: {
                validators: {
                    notEmpty: {
                        message: 'The Field is required'
                    }
                }
            },
            Value: {
                validators: {
                    notEmpty: {
                        message: 'The Value is required'
                    },
                    numeric: {
                        message: 'The value is not a number',
                    }
										
                }
            },
            Label: {
                validators: {
                    notEmpty: {
                        message: 'The Label is required'
                    }
                }
            }
        }
    });
	

	
		
});
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

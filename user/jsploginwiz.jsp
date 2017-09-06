<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<%!
String FirstUpper(String str)
{
 char ch ;
 String ret = str.toLowerCase();
		 if(str.length()>0)
		 {
		   ch=(char)(ret.charAt(0)-32);
			 ret=ch+ret.substring(1);
		 }
 return ret;
}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String JNDIDSN= request.getParameter("JNDIDSN");
String WebAppName = request.getParameter("WebAppName");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");

char First  = TableName.charAt(0);
if(First > 96) First-=32 ;
String BeanName = First+TableName.substring(1,2)+"Bn" ;
String BeanClass = First+TableName.substring(1)+"Bean" ;
String BeanPackage  = "com.db."+JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );

String CTableName = First+TableName.substring(1) ;

String Database = null;
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
Database=conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}
/* 
Some stubborn vendors like Oralce act like stick in mud, 
and do not comply with the standards
*/

String PK="?";
try 
{
  java.sql.Statement stmt = conn.createStatement();
  java.sql.ResultSet rslt = null ;
  rslt = stmt.executeQuery(BeanwizHelper.openTableSQL(conn, TableName)); 
  java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
  int count  = rsmd.getColumnCount();
 	for(int n = 1 ; n <= count ; n++ )
  {	
	   if( rsmd.isAutoIncrement(n))PK=rsmd.getColumnName(n) ;; 

  }// end for(int n = 1 ; n <= count ; n++ ) 
  // clean up the lists

String tmp = PK.replace("ID", "");
String PKL = tmp.toLowerCase().trim();
String PKU = tmp.toUpperCase().trim();


%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Generate Login Pages</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">

<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Generate Login Pages</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">Table List : <strong><%=Database %></strong></a></li>
      <li class="active">Login Page</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />

<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Table : </span><span class="text-muted"><%=Database %>.<%=TableName %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>

</div>		

<form class="form-horizontal" action="faltu.jsp" method="post" id="loginform" name="loginform" target="_self">
<input type="hidden" name="DriverName" value="<%=DriverName %>" />
<input type="hidden" name="BeanClass"  value="<%=BeanClass %>" />
<input type="hidden" name="BeanPackage"  value="<%=BeanPackage %>" />
<input type="hidden" name="JNDIDSN"  value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName"  value="<%=TableName %>"/>
<input type="hidden" name="Database"  value="<%=Database %>"/>
<div class="row">

  <div class="col-md-5">

  <div class="form-group">
    <label class="col-sm-4 control-label">Bean ID</label>
    <div class="col-sm-8">
		  <input class="form-control" name="BeanName" id="BeanName" value="<%=BeanName %>">
    </div>
  </div>
  <div class="form-group">
    <label for="WebApp" class="col-sm-4 control-label">WebApp Pkg</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="WebApp" id="WebApp" value="com.<%=WebAppName%>">
    </div>
  </div>
  <div class="form-group">
    <label for="Title" class="col-sm-4 control-label">Title</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="Title"  id="Title" value="<%=FirstUpper(TableName) %>">
    </div>
  </div>
  <div class="form-group">
    <label for="IDField" class="col-sm-4 control-label">PK - ID Field</label>
	    <div class="col-sm-8">
       <input type="text" name="IDField" class="form-control" value="<%=PK %>" id="IDField">
    </div>
  </div>
  <div class="form-group">
    <label for="IDFieldType" class="col-sm-4 control-label">PK Field Type</label>
    <div class="col-sm-8">
     
			<select name="IDFieldType" id="IDFieldType" class="form-control selectpicker">
    		<option value="INT" selected="selected">Integer</option>
    		<option value="STRING" >Character Data</option> 
  		</select>
    </div>
  </div>
  <div class="form-group">
    <label for="LoginClass" class="col-sm-4 control-label">Login Class</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginClass"  id="LoginClass" value="Logged<%=FirstUpper(TableName) %>">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginObjectID" class="col-sm-4 control-label">Object Session ID</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginObjectID"  id="LoginObjectID" value="the<%=FirstUpper(TableName) %>">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginIDField" class="col-sm-4 control-label">LoginID Field</label>
	    <div class="col-sm-8">
        <jsp:include page="/tablefields/" flush="true">
        <jsp:param name="Element" value="LoginIDField" />
        </jsp:include>
    </div>
  </div>
  <div class="form-group">
    <label for="LoginIDFieldType" class="col-sm-4 control-label">LoginID Field Type</label>
    <div class="col-sm-8">
  		<select name="LoginIDFieldType" id="LoginIDFieldType" class="form-control selectpicker">
    		<option value="INT" selected="selected">Integer</option>
    		<option value="STRING" >Character Data</option> 
  		</select>
    </div>
  </div>
  <div class="form-group">
    <label for="PasswordField" class="col-sm-4 control-label">Password Field</label>
    <div class="col-sm-8">
       <jsp:include page="/tablefields/" flush="true">
        <jsp:param name="Element" value="PasswordField"  />
      	<jsp:param name="Select" value="Password"  />
       </jsp:include>
    </div>
  </div>
  <div class="form-group">
    <label for="DisplayFields" class="col-sm-4 control-label">Display Fields</label>
    <div class="col-sm-8">
		  <input type="text" name="DisplayFields" id="DisplayFields" value="2,3,4" class="form-control"/>
    </div>
  </div>

	</div>
  <div class="col-md-5">
  <div class="form-group">
    <label class="col-sm-4 control-label">Class</label>
    <div class="col-sm-8">
		  <input class="form-control" value="<%=BeanPackage %>.<%=BeanClass %>" disabled>
    </div>
  </div>
	
  <div class="form-group">
    <label for="LoginForm" class="col-sm-4 control-label">Login Form Page</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginForm" id="LoginForm" value="/<%=FirstUpper(TableName) %>LoginForm.jsp">
    </div>
  </div>
  <div class="form-group">
    <label for="LogoutPage" class="col-sm-4 control-label">Logout Page</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LogoutPage" id="LogoutPage"  value="/<%=FirstUpper(TableName) %>LogOut.jsp">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginServlet" class="col-sm-4 control-label">Login Servlet Name</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginServlet" id="LoginServlet" value="<%=FirstUpper(TableName) %>LoginServlet">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginServletPath" class="col-sm-4 control-label">Servlet Path Map</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginServletPath" id="LoginServletPath" value="/<%=TableName %>_login_check/">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginFilter" class="col-sm-4 control-label">Login Filter Name</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginFilter" id="LoginFilter" value="<%=FirstUpper(TableName) %>LoginFilter">
    </div>
  </div>
  <div class="form-group">
    <label for="AccessPath" class="col-sm-4 control-label">Filter Check Path</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="AccessPath" id="AccessPath" value="*/<%=TableName %>/*">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginSuccesPath" class="col-sm-4 control-label">Login Success Page</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginSuccesPath" id="LoginSuccesPath" value="/<%=TableName %>/index.jsp">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginFailurePath" class="col-sm-4 control-label">Login Failure Page</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginFailurePath" id="LoginFailurePath" value="/<%=FirstUpper(TableName) %>LoginForm.jsp">
    </div>
  </div>
  <div class="form-group">
    <label for="LoginRole" class="col-sm-4 control-label">Login Role</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="LoginRole"  id="LoginRole" value="<%=FirstUpper(TableName) %>">
    </div>
  </div>
  <div class="form-group">
    <label for="ScriptFolder" class="col-sm-4 control-label">JavaScript folder</label>
    <div class="col-sm-8">
      <input class="form-control" type="text" name="ScriptFolder"  id="ScriptFolder" value="/scripts">
    </div>
  </div>
	
</div>



<div class="col-md-2">

<div class="table-responsive">
<table class="table table-condensed borderless" >
<tr>
<td>
<label for="LoginFolderName" class="control-label">Login Folder Name</label>
<input type="text" class="form-control" name="LoginFolderName" id="LoginFolderName" value="<%=FirstUpper(TableName) %>"> 
</td>
</tr>
<tr>
<td>
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="IPAccessControl" id="IPAccessControl" />
      <label for="IPAccessControl">IP Access Control</label>
      </span>
</td>
</tr>
<tr>
<td><button type="button" name="jsp" onclick='getLoginClass()' class="btn btn-primary btn-block">Login Class</button></td>
</tr>

<tr>
<td><button type="button" name="jsp" onclick='getLoginWebXml()' class="btn btn-primary btn-block">WEB.XML Config.</button></td>
</tr>

<tr>
<td><button type="button" name="jsp" onclick='getLoginForm()' class="btn btn-primary btn-block">Login Form</button></td>
</tr>
<!-- 
<tr>
<td><button type="button" name="jsp" onclick='getIndexPage()' class="btn btn-primary btn-block">Index Page</button></td>
</tr>
<tr>
<td><button type="button" name="jsp" onclick='getBannerPage()' class="btn btn-primary btn-block">Banner Page</button></td>
</tr>
<tr>
<td><button type="button" name="jsp" onclick='getChangePasswordPage()' class="btn btn-primary btn-block">Change Password Page</button></td>
</tr>
<tr>
<td><button type="button" name="jsp" onclick='getLogoutPage()' class="btn btn-primary btn-block">Logout Page</button></td>
</tr>
<tr>
<td><button type="button" name="jsp" onclick='getTemplatePage()' class="btn btn-primary btn-block">Template Page</button></td>
</tr>
 -->
<tr>
<td><button type="button" name="jsp" onclick='getloginpkg()' class="btn btn-primary btn-block">Login Package</button></td>
</tr>
</table> 
</div>

</div>
	
</div>

</form>	

<form  action="faltu.jsp" method="post">

<div class="row">

<div class="col-md-6">
  <div class="form-group">
    <label for="AppsettingSql" class="control-label">Appsetting Table Sql</label>
		<textarea rows="6" name="AppsettingSql" id="AppsettingSql" class="form-control" >
insert  into `appsetting`(`Type`,`Name`,`Description`,`Value`,`URL`,`UpdateDateTime`) values 
(2,'<%=PKU %>-LOGIN-TYPE','1 = <%=PK %>, 2 = EmpCode, 3 = Mobile, 4 = EmailID, 5 = Username','1','','<%=new java.sql.Timestamp(System.currentTimeMillis()) %>'),
(1,'<%=PKU %>-LOGIN-ENABLE','Flag which controls whether login by <%=tmp %> is allowed or not.','YES','','<%=new java.sql.Timestamp(System.currentTimeMillis()) %>');
		</textarea>
  </div>
</div>	

<div class="col-md-6">
  <div class="form-group">
    <label for="ShowItem" class="control-label">ShowItem.java</label>
		<textarea rows="6" name="ShowItem" id="ShowItem" class="form-control" >
		
ShowItem.show<%=CTableName %>Name(int id, int nameType)		
ShowItem.show<%=CTableName %>NameWithGender(int id, int nameType)
		
private static <%=BeanPackage %>.<%=BeanClass %> <%=BeanName %> = new <%=BeanPackage %>.<%=BeanClass %>();
	
//***********************************************************// 

// ShowItem.show<%=CTableName %>Name(int id, int nameType) 

  public static String show<%=CTableName %>Name(int ID, int nameType) {
      String ret = "";
      try {
        if (<%=BeanName %>.locateRecord(ID)) {
          if (nameType == 1) {
            ret = <%=BeanName %>.FirstName + " " + <%=BeanName %>.MiddleName + " " + <%=BeanName %>.LastName;
          }
          if (nameType == 2) {
            ret = <%=BeanName %>.FirstName + " " + ((<%=BeanName %>.MiddleName != null && <%=BeanName %>.MiddleName.length() > 0) ? <%=BeanName %>.MiddleName.substring(0, 1) + "." : " ") + " " + <%=BeanName %>.LastName;
          }
          if (nameType == 3) {
            ret = <%=BeanName %>.FirstName + " " + <%=BeanName %>.LastName;
          }
        }
      } catch (java.sql.SQLException ex) {
        ret = ex.toString();
      }
      return ret;
    } //end ShowItem.show<%=CTableName %>Name(int id, int nameType)
 
//***********************************************************//

// ShowItem.show<%=CTableName %>NameWithGender(int id, int nameType) 

  public static String show<%=CTableName %>NameWithGender(int ID, int nameType) {
      String ret = "";
	  String gendericon = "";
      try {
        if (<%=BeanName %>.locateRecord(ID)) {
			
		if(<%=BeanName %>.Gender.equalsIgnoreCase("Male")) gendericon = "<i class='icon fa fa-male fa-lg iccolor' aria-hidden='true'></i>&nbsp;" ;
		else if(<%=BeanName %>.Gender.equalsIgnoreCase("FeMale")) gendericon = "<i class='icon fa fa-female fa-lg iccolor' aria-hidden='true'></i>&nbsp;" ;
		else gendericon = "";
			
          if (nameType == 1) {
            ret = gendericon+" "+<%=BeanName %>.FirstName + " " + <%=BeanName %>.MiddleName + " " + <%=BeanName %>.LastName;
          }
          if (nameType == 2) {
            ret = gendericon+" "+<%=BeanName %>.FirstName + " " + ((<%=BeanName %>.MiddleName != null && <%=BeanName %>.MiddleName.length() > 0) ? <%=BeanName %>.MiddleName.substring(0, 1) + "." : " ") + " " + <%=BeanName %>.LastName;
          }
          if (nameType == 3) {
            ret = gendericon+" "+<%=BeanName %>.FirstName + " " + <%=BeanName %>.LastName;
          }
        }
      } catch (java.sql.SQLException ex) {
        ret = ex.toString();
      }
      return ret;
    } //end ShowItem.show<%=CTableName %>NameWithGender(int id, int nameType)	  
  
//***********************************************************//  
		</textarea>
  </div>
</div>

		


</div>
<div class="row">

<div class="col-md-6">
  <div class="form-group">
    <label for="MustbeField" class="control-label">Must be Field</label>
		<textarea rows="29" name="MustbeField" id="MustbeField" class="form-control" >

DROP TABLE IF EXISTS `<%=TableName %>`;

CREATE TABLE `<%=TableName %>` (
  `<%=PK %>` INT(11) NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(255) DEFAULT NULL,
  `MiddleName` VARCHAR(255) DEFAULT NULL,
  `LastName` VARCHAR(255) DEFAULT NULL,
  `Gender` VARCHAR(250) DEFAULT NULL,
  `BirthDate` DATE DEFAULT NULL,
  `MaritalStatus` VARCHAR(255) DEFAULT NULL,
  `EmpCode` VARCHAR(250) DEFAULT NULL,
  `JoiningDate` DATE DEFAULT NULL,
  `LeavingDate` DATE DEFAULT NULL,
  `Address` MEDIUMTEXT,
  `City` VARCHAR(250) DEFAULT NULL,
  `State` VARCHAR(250) DEFAULT NULL,
  `PIN` VARCHAR(6) DEFAULT NULL,
  `Landline` VARCHAR(255) DEFAULT NULL,
  `Mobile` VARCHAR(20) DEFAULT NULL,
  `Email` VARCHAR(250) DEFAULT NULL,
  `Username` CHAR(255) DEFAULT NULL,
  `Password` CHAR(20) DEFAULT NULL,
  `PasswordType` SMALLINT(6) DEFAULT '0',
  `AccessModule` VARCHAR(255) DEFAULT NULL,
  `LoginRole` CHAR(255) DEFAULT NULL,
  `CurrentStatus` SMALLINT(6) DEFAULT NULL,
  `LoginStatus` SMALLINT(6) DEFAULT NULL,
  `MultiLogin` SMALLINT(6) DEFAULT NULL,
  `MenuType` VARCHAR(255) DEFAULT NULL,
  `UpdateDateTime` DATETIME DEFAULT NULL,
  PRIMARY KEY (`<%=PK %>`),
  KEY `AdminID` (`<%=PK %>`),
  KEY `EmpCode` (`EmpCode`),
  KEY `Mobile` (`Mobile`),
  KEY `EmailID` (`Email`),
  KEY `Username` (`Username`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

		</textarea>
    
  </div>
</div>	


</div>

</form>	

</div> <!-- /container -->
<%  
}	 
finally
{
conn.close();
}
%>
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--


function getLoginClass()
{
  document.forms['loginform'].action='login/getloginclass.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}
function getLoginForm()
{
  document.forms['loginform'].action='login/getloginform.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}

function getLoginWebXml()
{
  document.forms['loginform'].action='login/getloginwebxml.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}
function getIndexPage()
{
document.forms['loginform'].action='login/getindexpage.jsp' ;
  // document.forms['loginform'].target='_blank' ;
document.forms['loginform'].submit();

}

function getBannerPage()
{
   document.forms['loginform'].action='login/getbannerpage.jsp' ;
  // document.forms['loginform'].target='_blank' ;
   document.forms['loginform'].submit();

}

function getChangePasswordPage()
{
   document.forms['loginform'].action='login/getchangepwpage.jsp' ;
  // document.forms['loginform'].target='_blank' ;
   document.forms['loginform'].submit();

}



function getLogoutPage()
{
  document.forms['loginform'].action='login/getlogoutpage.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}

function getTemplatePage()
{
  document.forms['loginform'].action='login/gettemplatepage.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}

function getloginpkg()
{
  document.forms['loginform'].action='login/getloginpkg.jsp' ;
  // document.forms['loginform'].target='_blank' ;
  document.forms['loginform'].submit();
}


// -->
</script>

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

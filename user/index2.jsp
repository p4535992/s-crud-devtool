<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %>
<%@ page import="com.caucho.naming.*, oracle.sql.*, oracle.jdbc.* oracle.jdbc.driver.*, oracle.jdbc.pool.*" %>
<%@ page import="com.microsoft.sqlserver.jdbc.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ taglib uri="validation" prefix="chk" %>

<%!
void SaveDataSource(String uid, JndiDataSrc dsrc, ServletContext cntx)
throws Exception
{
     String xmlfilepath = cntx.getRealPath("/WEB-INF/saved-jndi-ds.xml");
     File xmlfile = new File(xmlfilepath);
	   Document doc =null;
	   
	   if( xmlfile.createNewFile() )
	   {
	       Element dslist  = new Element("dslist");
	       doc  = new Document(dslist);
	   }
	   else
	   {
	       Builder builder = new Builder();
	       doc = builder.build(xmlfile);
     }
	
	   Element ds = new Element("datasource");
		 Attribute wizuser = new Attribute("wizuser", uid) ;
	   ds.addAttribute(wizuser);
		 
		 Attribute sqlengine = new Attribute("sqlengine", ""+dsrc.sqlengine);
		 ds.addAttribute(sqlengine);
		 
		 Attribute database = new Attribute("database", dsrc.database);
		 ds.addAttribute(database);

		 Attribute jndi = new Attribute("jndi", dsrc.jndi);
		 ds.addAttribute(jndi);

		 Attribute url = new Attribute("url", dsrc.url);
		 ds.addAttribute(url);

		 Attribute user = new Attribute("user", dsrc.user);
		 ds.addAttribute(user);

		 Attribute password = new Attribute("password", dsrc.password);
		 ds.addAttribute(password);


		 Attribute driver = new Attribute("driver", dsrc.driver);
		 ds.addAttribute(driver);

		 Attribute dbhost = new Attribute("dbhost", dsrc.dbhost);
		 ds.addAttribute(dbhost);

		 Attribute dbport = new Attribute("dbport", dsrc.dbport);
		 ds.addAttribute(dbport);
		 
		 Attribute title = new Attribute("title", dsrc.title);
		 ds.addAttribute(title);

		 
		 doc.getRootElement().appendChild(ds);
 
     FileOutputStream os = new  FileOutputStream(xmlfile);
     nu.xom.Serializer serializer = new nu.xom.Serializer( os , "UTF-8");
     serializer.setIndent(4);
     serializer.write(doc); 
     os.close();
}
%>

<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Action = request.getParameter("Action");

String MessageText = null ;
MessageText = request.getParameter("Message");


String SQLDatabase = null;
com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource vds = null;
// ? org.postgresql.ds.PGConnectionPoolDataSource  pgds = null ;
org.postgresql.ds.PGSimpleDataSource pgds = null ;
com.microsoft.sqlserver.jdbc.SQLServerDataSource mssqlds = null ;

OracleDataSource ords = null ;
String debug=null ;

String ToSave = null;
String SaveDataSource = RequestHelper.paramValue(request, "SaveDataSource", "NO");

if("addlist".equalsIgnoreCase( Action))
{
   SQLDatabase = request.getParameter("SQLDatabase");
   String LocalJNDI = request.getParameter("DSN");
	 String Title = request.getParameter("Title");
	 
	 vds = new com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource() ;
   vds.setServerName("localhost");
	 vds.setPort(3306)  ;
   vds.setDatabaseName(SQLDatabase);
   vds.setUser("root") ;
	 vds.setPassword("") ;
	 Jndi.bindDeep("java:comp/env/"+LocalJNDI,  vds);
	
	JndiDataSrc objLc =  new JndiDataSrc() ;
	
	objLc.sqlengine= com.webapp.utils.PortableSQL.MYSQL ;
  objLc.database = SQLDatabase;
	objLc.jndi =  LocalJNDI ; 
  objLc.url = "jdbc:mysql://localhost:3306/"+SQLDatabase+"?characterEncoding=UTF-8";
  objLc.user = "root" ;
  objLc.password = "";
  objLc.driver = "com.mysql.jdbc.Driver" ;
	objLc.dbhost = "localhost";
	objLc.dbport = "3306" ;
	objLc.title = Title ;
	application.setAttribute("JNDI:"+LocalJNDI, objLc );
	
}

if("remoteadd".equalsIgnoreCase( Action ))
{
	String SQLHost = request.getParameter("SQLHost");
	int SQLPort=0;
	String SQLUser = request.getParameter("SQLUser");
	String SQLPassword = request.getParameter("SQLPassword") ;
  SQLDatabase = request.getParameter("SQLDatabase");
	String JNDIDSN = request.getParameter("JNDIDSN"); 
	String Title = request.getParameter("Title");
	
	try
	 {
	  SQLPort=Integer.parseInt(request.getParameter("SQLPort"));
   }
	 catch(NumberFormatException ex)
	 { 
	   SQLPort=3306;
	 }
	short nSQLEngine = 0 ; 
	try
	{ 
	   nSQLEngine = Short.parseShort( request.getParameter("SQLEngine") );
	}catch( NumberFormatException ex){ nSQLEngine = 0 ; }
	
  	String NewContext="java:comp/env/jdbc/"+JNDIDSN;
		
		JndiDataSrc objRm =  new JndiDataSrc() ;
    
		objRm.sqlengine= nSQLEngine ;
    objRm.database = SQLDatabase;
		objRm.jndi = "jdbc/"+JNDIDSN ; 
    objRm.user = SQLUser ;
    objRm.password = SQLPassword ;
		objRm.dbhost =  SQLHost;
		objRm.dbport = ""+SQLPort;
		objRm.title = Title ;

	   if(nSQLEngine==com.webapp.utils.PortableSQL.MYSQL)
	   {
       	 vds = new com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource() ;
         vds.setServerName(SQLHost);
	       vds.setPort(SQLPort)  ;
				 vds.setDatabaseName(SQLDatabase);
         vds.setUser(SQLUser) ;
	       vds.setPassword(SQLPassword) ;
				 Jndi.bindDeep(NewContext,  vds);
				 objRm.url="jdbc:mysql://"+SQLHost+":"+SQLPort+"/"+SQLDatabase+"?characterEncoding=UTF-8";
				 objRm.driver = "com.mysql.jdbc.Driver" ;
		
		 }
		 else if (nSQLEngine==com.webapp.utils.PortableSQL.POSTGRE )
		 {
		     // ?  pgds = new org.postgresql.ds.PGConnectionPoolDataSource();
       	 
				 pgds = new org.postgresql.ds.PGSimpleDataSource(); 
				 pgds.setServerName(SQLHost);
				 pgds.setPortNumber(SQLPort)  ;
         pgds.setDatabaseName(SQLDatabase);
         pgds.setUser(SQLUser) ;
	       pgds.setPassword(SQLPassword) ;
				 Jndi.bindDeep(NewContext,  pgds);
				 objRm.url="jdbc:postgresql://"+SQLHost+":"+SQLPort+"/"+SQLDatabase ;
				 objRm.driver = "org.postgresql.Driver" ;
		 }	
		 else if (nSQLEngine==com.webapp.utils.PortableSQL.MSSQL)
		 {
		     mssqlds = new com.microsoft.sqlserver.jdbc.SQLServerDataSource();
			 	 mssqlds.setServerName(SQLHost) ;
				 mssqlds.setPortNumber(SQLPort) ;
				 mssqlds.setDatabaseName(SQLDatabase) ;
				 mssqlds.setUser(SQLUser);
				 mssqlds.setPassword(SQLPassword);
			   Jndi.bindDeep(NewContext,  mssqlds);
         objRm.url="jdbc:sqlserver://"+SQLHost+":"+SQLPort+";database="+SQLDatabase+";integratedSecurity=true;" ;
				 objRm.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
		 }
		 else if (nSQLEngine==com.webapp.utils.PortableSQL.ORACLE)
		 {	  
       String ourl = "jdbc:oracle:thin:@$H:$P:$D" ; // template of url
	
			 ourl=ourl.replace("$H", SQLHost );
			 ourl=ourl.replace("$P", ""+SQLPort);
			 ourl=ourl.replace("$D", SQLDatabase);
			 ords = new OracleDataSource();
			 ords.setURL(ourl);
		   ords.setUser(SQLUser);
       ords.setPassword(SQLPassword);
		   Jndi.bindDeep(NewContext,  ords);
			 objRm.url="jdbc:oracle:thin:@"+SQLHost+":"+SQLPort+":"+SQLDatabase ;
			 objRm.driver = "oracle.jdbc.driver.OracleDriver" ;
		 }
		 application.setAttribute("JNDI:jdbc/"+JNDIDSN, objRm );
     ToSave = "JNDI:jdbc/"+JNDIDSN ;
	 
     if("YES".equalsIgnoreCase(SaveDataSource))
     { 
          SaveDataSource(LogUsr.UserID,  objRm, application);
     }  
}

if("Delete".equalsIgnoreCase(Action) )
{
  String DelItem= request.getParameter("Item");
	
  javax.naming.Context cntxdel = new javax.naming.InitialContext();
  cntxdel.unbind("java:comp/env/jdbc/"+DelItem); // 
	application.removeAttribute("JNDI:jdbc/"+DelItem);
	    
			      
	MessageText = "One record deleted.<br />Deleted JNDI = "+DelItem ;
  // Page redirection code begin {{
  java.lang.StringBuffer rd = request.getRequestURL();
  rd.append("?Message="+MessageText);
  response.sendRedirect(response.encodeRedirectURL(rd.toString()));
  // }} Page redirection code end
	
}
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Repid Development Tool</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />
<div class="container-fluid">

    <div class="row page-header11">
    	<div class="col-md-12 col-xs-12">
        <h4 class="page-title11"><i class="fa fa-send-o"></i>&nbsp;&nbsp;JNDI Datasource</h4>	
	    </div>
    </div>
<hr class="pageheaderHR" />

<div class="row">
<div class="col-md-4">
<% 
if( "localhost".equalsIgnoreCase(request.getServerName()))
{
%>	

<!-- Button trigger modal -->
<button type="button" class="btn btn-circle fixed-add-btn-circle" data-toggle="modal" data-target="#RemoteHost" ><i class="fa fa-plus fa-lg"></i></button>


<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;MySQL Database <small>( Local Host )</small></h3>
  </div>
  <div class="panel-body">

<form action="<%=thisFile %>"  method="post" id="local_mysql_server"  class="form-horizontal">
<input type="hidden" name="Action" value="addlist" />

<div class="form-group">
<label for="SQLDatabase" class="col-sm-3 control-label">Database</label>
<div class="col-sm-9"><!-- multiple="multiple"--> 
<select class="form-control selectpicker" name="SQLDatabase" id="SQLDatabase" onchange="OnDatabaseSelect()" title="Select database...">
<option value="">&nbsp;None&nbsp;</option>
<%  
 Class.forName ("com.mysql.jdbc.Driver").newInstance ();
 java.sql.Connection conn = DriverManager.getConnection ("jdbc:mysql://localhost/test", "root", "");
 DatabaseMetaData md = conn.getMetaData();
 java.sql.ResultSet rslt = md.getCatalogs();  
 int num=0;          
 while(rslt.next())
 {
 num++;
 String db = rslt.getString(1);
%>

<option value="<%=db %>">[ <%=num %> ] <%=db %></option>
<% 
} 
conn.close();
%>
</select>  
</div>
</div>

  <div class="form-group">
    <label for="LocalTitle" class="col-sm-3 control-label">Title</label>
		<div class="col-sm-9">
		<input type="text" class="form-control" name="Title"  id="LocalTitle"/>
		</div>
  </div>
  <div class="form-group">
    <label for="LOCALDSN" class="col-sm-3 control-label">JNDI DSN</label>
		<div class="col-sm-9">
		<div class="input-group">
      <input type="text" class="form-control" name="DSN" id="LOCALDSN" >
      <span class="input-group-btn">
        <button type="submit" class="btn btn-primary" type="button"><i class="fa fa-plus"></i>&nbsp;&nbsp;ADD</button>
      </span>
    </div><!-- /input-group -->
		</div>
  </div>
</form>

	
	
  </div>
</div>

<% 
} // end if ( "127.0.0.1".equals(request.getRemoteHost() )
else
{
 %> 


<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Saved JNDI Datasources<br /><small>( User : <%=LogUsr.getUserName() %> )</small></h3>
  </div>
  <div class="panel-body">
		
<% 
  
  String xmlfilepath = application.getRealPath("/WEB-INF/saved-jndi-ds.xml");
  File xmlfile = new File(xmlfilepath);
  if(xmlfile.exists())
	{
	  
	     Builder builder = new Builder();
	     Document doc =  builder.build(xmlfile);
	      
			 Nodes list = doc.query("/dslist/datasource[@wizuser='"+LogUsr.UserID+"']");
			 if(list!=null && list.size()>0)
			 {
			      %>


<form action="addfromsaveddatasource.jsp" id="ADD_SAVED_DS_FORM" method="post">
  <div class="form-group">
    <label for="datasource">JNDI Datasource</label>
<div class="input-group">
      <span class="input-group-btn">
        <button type="submit" class="btn btn-primary" type="button" onclick="RemoveSavedItem()" ><i class="fa fa-trash"></i></button>
      </span>

  
						 <select name="datasource" class="form-control" id="datasource">
						  <option value=""> -- None selected --</option>  
						<% 
						  for(int i=0; i < list.size(); i++)
							{
						    Element elm = (Element)list.get(i);
								String opval = elm.getAttributeValue("wizuser")+":"+elm.getAttributeValue("jndi")  ;
								String title =  elm.getAttributeValue("title") ;
								String showitem = ""; 
								
								if(title !=null && title.length() > 0)
								{
								     showitem = title+" [ "+elm.getAttributeValue("dbhost")+":"+elm.getAttributeValue("dbport")+" ]" ;
								}
								else
								{
									  showitem = elm.getAttributeValue("jndi") + " [ "+elm.getAttributeValue("dbhost")+":"+elm.getAttributeValue("dbport")+" ]" ;
								}
						 %>
						   <option value="<%=opval %>"><%=showitem %></option>
						 <% 
						  } 
							%>
						 </select>							
							
      <span class="input-group-btn">
        <button type="submit" class="btn btn-primary" type="button"><i class="fa fa-plus"></i></button>
      </span>
							

</div>
</div>
</form>


						<%
			 } 
	}
%>
  </div>
</div>

	

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;From Remote Host</h3>
  </div>
  <div class="panel-body">



<form action="<%=thisFile %>" method="post" id="remote_mysql_serv" class="form-horizontal">
<input type="hidden" name="Action" value="remoteadd" />
  <div class="form-group">
	
<div class="row">
  <div class="col-md-12">

    <label class="col-sm-4 control-label">SQL Engine</label>
    <div class="col-sm-8">
		
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.MYSQL %>" id="MySQLradio"  onclick="SetDefaultPort(<%=PortableSQL.MYSQL %>)" />
<label for="MySQLradio"> MySQL </label>
</div>	
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.POSTGRE %>" id="POSTGREradio"  onclick="SetDefaultPort(<%=PortableSQL.POSTGRE %>)" />
<label for="POSTGREradio"> Postgre SQL </label>
</div>
	
	</div>
	</div>
  <div class="col-md-12">

    <div class="col-sm-4 control-label"></div>
    <div class="col-sm-8">

<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.MSSQL %>" id="MSSQLradio" onclick="SetDefaultPort(<%=PortableSQL.MSSQL %>)" />
<label for="MSSQLradio"> MS SQL </label>
</div>	
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.ORACLE %>" id="Oracleradio" onclick="SetDefaultPort(<%=PortableSQL.ORACLE %>)" />
<label for="Oracleradio"> Oracle </label>
</div>

    </div>
	
	</div>
</div>	

  </div>
  <div class="form-group">
    <label for="SQLHost" class="col-sm-4 control-label">SQL Server</label>
    <div class="col-sm-8">
		  <input type="text" name="SQLHost" id="SQLHost" class="form-control" value="<%=request.getRemoteAddr() %>" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLPort" class="col-sm-4 control-label">SQL Port</label>
    <div class="col-sm-8">
      <input type="text" name="SQLPort" id="SQLPort" class="form-control" disabled/>
    </div>
  </div>
  <div class="form-group">
    <label for="SQLUser" class="col-sm-4 control-label">SQL User</label>
    <div class="col-sm-8">
      <input type="text" name="SQLUser" id="SQLUser" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLPassword" class="col-sm-4 control-label">SQL Password</label>
    <div class="col-sm-8">
      <input type="password" name="SQLPassword" id="SQLPassword" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLDatabaseRH" class="col-sm-4 control-label">SQL Database</label>
    <div class="col-sm-8">
      <input type="text" name="SQLDatabase"  id="SQLDatabaseRH" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="JNDIDSN" class="col-sm-4 control-label">Context (JNDI)</label>
    <div class="col-sm-8">
      <input type="text" name="JNDIDSN"  id="JNDIDSN" class="form-control" placeholder='"jdbc/" will be prefixed' />
			<p class="help-block"></p>
    </div>
  </div>
  <div class="form-group">
    <label for="RemoteTitle" class="col-sm-4 control-label">Resource Title</label>
    <div class="col-sm-8">
      <input type="text" name="Title" id="RemoteTitle" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="inputPassword3" class="col-sm-4 control-label">Save ?</label>
    <div class="col-sm-8">
				<div class="checkbox checkbox-primary">
            <input type="checkbox" name="SaveDataSource" id="SaveDataSource" value="YES">
            <label for="SaveDataSource">Save JNDI details for future use</label>
        </div>      
    </div>
  </div>
              <div class="form-group">
                <div class="row">
                  <div class="col-xs-6"> <button type="submit" class="btn btn-primary pull-right">Submit</button> </div>
                  <div class="col-xs-6"> <button type="button" class="btn btn-primary fRESET">Reset</button> </div>
                </div>
              </div>

</form>







  </div>
</div>


<% 
} 
%> 


	
	
	</div>


  <div class="col-md-8">
	
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;List of JNDI Datasource</h3>
  </div>
  <div class="panel-body">

<div class="table-responsive">	
<table class="table table-striped table-bordered">
<thead>
<tr>
<th width="5%" align="left" valign="top" >#</th>
<th width="45%" align="left" valign="top" >JNDI Datasources</th>
<th width="25%" align="left" valign="top" >JNDI - DSN </th>
<th width="15%" align="left" valign="top" >Host:Port</th>
<th width="10%" align="left" valign="top" >Delete</th>
</tr>
</thead>
<tbody>
<% 

Context env = (Context) new InitialContext().lookup("java:comp/env");
NamingEnumeration  en = env.list("jdbc");
int no=0 ;
 while(en.hasMore())
 {
 
 NameClassPair pr = (NameClassPair)en.next();
 String ItemName =  pr.getName();
    if(!ItemName.equals("$"))
    {
          no++;
          String JNDIDSN =   "jdbc/"+ItemName;
          String HostPort = "N/A" ;
          String Title = ItemName;
 
          JndiDataSrc obDtSrc = (JndiDataSrc)application.getAttribute("JNDI:"+JNDIDSN);
          if(obDtSrc != null)
          {
              HostPort = obDtSrc.dbhost+":"+obDtSrc.dbport ;
		          Title = obDtSrc.title;
		         if(Title==null || Title.length()==0) Title = ItemName;
          }
 
%>
<tr>
<td><%=no %></td>
<td><a href="tablelist.jsp?JNDIDSN=<%=JNDIDSN %>"><%=Title %></a></td>
<td><%=JNDIDSN %></td>
<td><%=HostPort %></td>
<td align="center"><a href="#" onclick='DeleteConfirm("<%=thisFile %>?Action=Delete&Item=<%=ItemName %>","<%=ItemName %>")'><i class="fa fa-trash-o fa-lg text-primary"></i></a></td>


</tr>
<%
     } // end  if(!ItemName.equals("$"))
 
 }
 %>


</tbody>
</table>	
</div>	
	
	
	
  </div>
</div>

	

	
	</div>
</div>		



<!-- Modal -->
<div class="modal fade" id="RemoteHost" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" >
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"><i class="fa fa-database fa-lg text-primary"></i>&nbsp;&nbsp;From Remote Host</h4>
      </div>
      <div class="modal-body">
			
			
<div class="row">
  <div class="col-md-7">
	
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;From Remote Host</h3>
  </div>
  <div class="panel-body">



<form action="<%=thisFile %>" method="post" id="remote_mysql_serv" class="form-horizontal">
<input type="hidden" name="Action" value="remoteadd" />
  <div class="form-group">
	
<div class="row">
  <div class="col-md-12">

    <label class="col-sm-4 control-label">SQL Engine</label>
    <div class="col-sm-8">
		
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.MYSQL %>" id="MySQLradio"  onclick="SetDefaultPort(<%=PortableSQL.MYSQL %>)" />
<label for="MySQLradio"> MySQL </label>
</div>	
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.POSTGRE %>" id="POSTGREradio"  onclick="SetDefaultPort(<%=PortableSQL.POSTGRE %>)" />
<label for="POSTGREradio"> Postgre SQL </label>
</div>
	
	</div>
	</div>
  <div class="col-md-12">

    <div class="col-sm-4 control-label"></div>
    <div class="col-sm-8">

<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.MSSQL %>" id="MSSQLradio" onclick="SetDefaultPort(<%=PortableSQL.MSSQL %>)" />
<label for="MSSQLradio"> MS SQL </label>
</div>	
<div class="radio radio-primary radio-inline">
<input type="radio" name="SQLEngine" value="<%=PortableSQL.ORACLE %>" id="Oracleradio" onclick="SetDefaultPort(<%=PortableSQL.ORACLE %>)" />
<label for="Oracleradio"> Oracle </label>
</div>

    </div>
	
	</div>
</div>	

  </div>
  <div class="form-group">
    <label for="SQLHost" class="col-sm-4 control-label">SQL Server</label>
    <div class="col-sm-8">
		  <input type="text" name="SQLHost" id="SQLHost" class="form-control" value="<%=request.getRemoteAddr() %>" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLPort" class="col-sm-4 control-label">SQL Port</label>
    <div class="col-sm-8">
      <input type="text" name="SQLPort" id="SQLPort" class="form-control" disabled/>
    </div>
  </div>
  <div class="form-group">
    <label for="SQLUser" class="col-sm-4 control-label">SQL User</label>
    <div class="col-sm-8">
      <input type="text" name="SQLUser" id="SQLUser" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLPassword" class="col-sm-4 control-label">SQL Password</label>
    <div class="col-sm-8">
      <input type="password" name="SQLPassword" id="SQLPassword" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="SQLDatabaseRH" class="col-sm-4 control-label">SQL Database</label>
    <div class="col-sm-8">
      <input type="text" name="SQLDatabase"  id="SQLDatabaseRH" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="JNDIDSN" class="col-sm-4 control-label">Context (JNDI)</label>
    <div class="col-sm-8">
      <input type="text" name="JNDIDSN"  id="JNDIDSN" class="form-control" placeholder='"jdbc/" will be prefixed' />
			<p class="help-block"></p>
    </div>
  </div>
  <div class="form-group">
    <label for="RemoteTitle" class="col-sm-4 control-label">Resource Title</label>
    <div class="col-sm-8">
      <input type="text" name="Title" id="RemoteTitle" class="form-control" />
    </div>
  </div>
  <div class="form-group">
    <label for="inputPassword3" class="col-sm-4 control-label">Save ?</label>
    <div class="col-sm-8">
				<div class="checkbox checkbox-primary">
            <input type="checkbox" name="SaveDataSource" id="SaveDataSource" value="YES">
            <label for="SaveDataSource">Save JNDI details for future use</label>
        </div>      
    </div>
  </div>
              <div class="form-group">
                <div class="row">
                  <div class="col-xs-6"> <button type="submit" class="btn btn-primary pull-right">Submit</button> </div>
                  <div class="col-xs-6"> <button type="button" class="btn btn-primary fRESET">Reset</button> </div>
                </div>
              </div>

</form>







  </div>
</div>	
	
	</div>
  <div class="col-md-5">

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Saved JNDI Datasources</h3>
  </div>
  <div class="panel-body">
	<h5>User : <%=LogUsr.getUserName() %></h5>	
<% 
  
  String xmlfilepathmodal = application.getRealPath("/WEB-INF/saved-jndi-ds.xml");
  File xmlfilemodal = new File(xmlfilepathmodal);
  if(xmlfilemodal.exists())
	{
	  
	     Builder builder = new Builder();
	     Document doc =  builder.build(xmlfilemodal);
	      
			 Nodes list = doc.query("/dslist/datasource[@wizuser='"+LogUsr.UserID+"']");
			 if(list!=null && list.size()>0)
			 {
			      %>


<form action="addfromsaveddatasource.jsp" id="ADD_SAVED_DS_FORM" method="post">
  <div class="form-group">
    <label for="datasource">JNDI Datasource</label>
<div class="input-group">
      <span class="input-group-btn">
        <button type="submit" class="btn btn-primary" type="button" onclick="RemoveSavedItem()" ><i class="fa fa-trash"></i></button>
      </span>

  
						 <select name="datasource" class="form-control" id="datasource">
						  <option value=""> -- None selected --</option>  
						<% 
						  for(int i=0; i < list.size(); i++)
							{
						    Element elm = (Element)list.get(i);
								String opval = elm.getAttributeValue("wizuser")+":"+elm.getAttributeValue("jndi")  ;
								String title =  elm.getAttributeValue("title") ;
								String showitem = ""; 
								
								if(title !=null && title.length() > 0)
								{
								     showitem = title+" [ "+elm.getAttributeValue("dbhost")+":"+elm.getAttributeValue("dbport")+" ]" ;
								}
								else
								{
									  showitem = elm.getAttributeValue("jndi") + " [ "+elm.getAttributeValue("dbhost")+":"+elm.getAttributeValue("dbport")+" ]" ;
								}
						 %>
						   <option value="<%=opval %>"><%=showitem %></option>
						 <% 
						  } 
							%>
						 </select>							
							
      <span class="input-group-btn">
        <button type="submit" class="btn btn-primary" type="button"><i class="fa fa-plus"></i></button>
      </span>
							

</div>
</div>
</form>


						<%
			 } 
	}
%>
  </div>
</div>	
	
	</div>
</div>			



			
			
			
      </div>
    </div>
  </div>
</div>
		 
</div> <!-- container-fluid -->


<jsp:include page="/user/assets-user/include-page/footer-user.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />	
<jsp:include page="/assets/include-page/js/formValidation-js.jsp" flush="true" />
	
<script type="text/javascript">
<!--
function DeleteConfirm (url,ITEM)
{
  swal({
    title: "Are you sure?",
    text: "Really want to delete the JNDI Item : "+ITEM,
    type: "question",
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

function OnDatabaseSelect()
{
  $("#LOCALDSN").val("jdbc/"+$("select[name='SQLDatabase']").val());
	$("#LocalTitle").val($("select[name='SQLDatabase']").val());
	
	
}

function SetDefaultPort( iVal)
{
   var port = "0" ;
   switch(iVal)
	 {
	    case <%=PortableSQL.MYSQL %> :
			   port="3306" ;
			break ;

	    case <%=PortableSQL.POSTGRE %> :
			   port="5432" ;
			break ;
			
			case <%=PortableSQL.MSSQL %> :
			   port="1433" ;
			break ;
			
			case <%=PortableSQL.ORACLE %> :
			   port="1521" ;
			break ;
	 }
	 $('#SQLPort').val(port);
	 
}

function RemoveSavedItem()
{
  var b = confirm("Removed selected datasource from saved list ?") ;
  if(b)
	{
     $("#ADD_SAVED_DS_FORM").prop("action", "removesaveddatasource.jsp");
	   $("#ADD_SAVED_DS_FORM").submit();
	}
}

$(document).ready(function(){

     // JSP Block start 
	  <% 
		if(MessageText!=null &&  MessageText.length()>0)
    { 
		%>
			toastr.success('<%=MessageText %>');//
		<%
		} 
		%> 
		// JSP Block end


    $('#local_mysql_server').formValidation({
        framework: 'bootstrap',
				excluded: ':disabled',
        fields: {
            SQLDatabase: {
                validators: {
                    notEmpty: {
                        message: 'The SQLDatabase is required'
                    }
                }
            },						
            DSN: {
                validators: {
                    notEmpty: {
                        message: 'The DSN is required'
                    }
                }
            },
            Title: {
                validators: {
                    notEmpty: {
                        message: 'The Title is required'
                    }
                }
            }
        }
    });
		
    $('#ADD_SAVED_DS_FORM').formValidation({
        framework: 'bootstrap',
        fields: {
            datasource: {
                validators: {
                    notEmpty: {
                        message: 'The Datasource is required'
                    }
                }
            }
        }
    });
		
    $('#remote_mysql_serv').formValidation({
        framework: 'bootstrap',
        fields: {
            SQLEngine: {
                validators: {
                    notEmpty: {
                        message: 'The SQL Engine is required'
                    }
                }
            },
            SQLHost: {
                validators: {
                    notEmpty: {
                        message: 'The SQL Host is required'
                    }
                }
            },
            SQLDatabase: {
                validators: {
                    notEmpty: {
                        message: 'The SQL Database is required'
                    }
                }
            },
            JNDIDSN: {
                validators: {
                    notEmpty: {
                        message: 'The JNDI-DSN is required'
                    }
                }
            },
            Title: {
                validators: {
                    notEmpty: {
                        message: 'The Title is required'
                    }
                }
            }
        }
    });

   // End init
});


// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

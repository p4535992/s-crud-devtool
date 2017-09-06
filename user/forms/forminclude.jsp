<%@ page import="com.beanwiz.*, java.io.*, java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.webapp.utils.*" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" />
<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");
String FormName = request.getParameter("FormName");
String ForeignKey =  request.getParameter("ForeignKey");
String LoginFolderName =  request.getParameter("LoginFolderName");

String[] FKeys  =  null ;
if(ForeignKey!= null && ForeignKey.length()>0) FKeys =ForeignKey.split(":");
java.util.HashSet KeySet = new java.util.HashSet();
if(FKeys!=null)
{
for (int i=0; i<FKeys.length ; i++)
{
 KeySet.add(FKeys[i]);
}
}

boolean bUpdate=false;
if("Update".equalsIgnoreCase(request.getParameter("Mode"))) bUpdate=true;

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
String query = BeanwizHelper.openTableSQL(conn, TableName);


try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	
%>

<div class="row"><%
int n = 0;
int k = 1 ;
for(n = 1 ; n <= count ; n++ )
{	
   int ColType = rsmd.getColumnType(n);
	 String ColName = rsmd.getColumnName(n) ;
	 String ColVarName="";
 	 int ColSize = rsmd.getColumnDisplaySize(n) ;
 	 int Precision = rsmd.getPrecision(n);
	 int Scale = rsmd.getScale(n);

	 
   if( rsmd.isAutoIncrement(n))continue ;	
	 
	 if(bUpdate)
	 {
	 ColVarName=BeanName+"."+ColName.replace((char)32, '_' ) ;
	 }
	 
 if(FKeys!=null && KeySet.contains(ColName))
{ %>
<!-- FOREIGN KEY FIELD NOT SHOWN
<tr>
 <td><%=ColName %>:</td>
 <td> <input type="text" name="<%=ColName %>" value="<%=ColVarName %>"   /></td>
</tr> 
-->
<% 
}
else
{ 

 if( FieldMap!=null && FieldMap.size() >0  ) // If input field preferences are present in session
 { 
 %>
  <div class="form-group col-sm-6">
	  <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
	  <jsp:include page="inputfield.jsp" flush="true"><jsp:param name="ColName" value="<%= ColName %>" /><jsp:param name="ColVarName" value="<%=ColVarName %>" /><jsp:param name="UpdateForm" value="<%=bUpdate %>" /></jsp:include>
	</div>
 <%
 
 }
 else
 { 
   //   If input field preferences are NOT present in session
 
  if( ColType ==java.sql.Types.DATE)
  {
	%>
	  <div class="form-group col-sm-6">
	  <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control readonlybg" <%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showDatePicker("+ColVarName+") %"+">\" ");%>data-plugin="datepicker">
				  <span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span>
			</div>	
	 </div>
<%
  
 	}
  else if ( ColType ==java.sql.Types.TIMESTAMP)
  {
 %> 
    <div class="form-group col-sm-6">
	    <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
		  <input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control"<%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showDateTimePicker("+ColVarName+") %"+">\" ");%> />
		</div>
<!--  
    <div class="form-group col-sm-6">
    <label for="FirstName" class="control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
      <div class="input-group input-group-icon" >
        <input type='text' name="<%=ColName %>" id="<%=ColName %>" class="form-control datetimepicker readonlybg"<%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showDateTimePicker("+ColVarName+") %"+">\" ");%> />
          <span class="input-group-addon"><span class="icon fa fa-clock-o" aria-hidden="true"></span></span>
      </div>
    </div>
-->
<%
 }
  else if ( ColType ==java.sql.Types.TIME)
  {
 %> 
    <div class="form-group col-sm-6">
	    <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
      <div class="input-group input-group-icon">	
        <input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control readonlybg"<%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showTimeClockPicker("+ColVarName+", \"Read\") %"+">\" ");%>  data-plugin="clockpicker" data-placement="bottom">
        <span class="input-group-addon"><span class="icon fa fa-clock-o" aria-hidden="true"></span></span>
      </div>
    </div>	
<%
 }
  else if (ColType ==java.sql.Types.VARBINARY ||ColType ==java.sql.Types.LONGVARBINARY || ColType ==java.sql.Types.BINARY || ColType ==java.sql.Types.BLOB )
  {
 %>
     <div class="form-group col-sm-6">
	     <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
       <input type="file" name="<%=ColName %>" id="<%=ColName %>"  enctype="multipart/form-data" class="form-control filestyle" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" title="Please select the <%=ColName %>." /><!-- accept=".xls,.xlsx" --> />
		 </div>
<%
  }
  else if(ColType ==java.sql.Types.LONGVARCHAR || ColType ==java.sql.Types.CLOB )
  {
 %>
    <div class="form-group col-sm-6">
	     <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
			 <textarea rows="2" name="<%=ColName %>" id="<%=ColName %>" class="form-control" ><%  if(bUpdate){ %><\%=<%=ColVarName %> %><% } %></textarea>
	  </div>
<%
  }
  else
  {
 %>
    <div class="form-group col-sm-6">
	     <label for="<%=ColName %>" class="control-label blue-grey-600" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></label>
       <input type="text" name="<%= ColName %>" id="<%= ColName %>" class="form-control" <%if(bUpdate){ %>value="<\%=StrValue(<%=ColVarName %>) %>" <% } %> />
	  </div>
<%
  }
 } //end if (FieldMap!=null && FieldMap.size() >0 )   input field preferences are NOT present in session Values are present in session 	
	
} // end if of if(FKeys!=null && KeySet.contains(ColName))
if(n%2==0)out.println("</div>\r\n");
if(n%2==0 && k!=count)out.println("<div class=\"row\" >");

//k++; 
}// end for(int n = 1 ; n <= count ; n++ ) 
//if(k%2==0)out.print("<div class=\"form-group col-sm-6\">&nbsp;</div><div class=\"form-group col-sm-6\">&nbsp;</div>"); 
%></div> <!-- End div class=row -->

<%
  stmt.close();
}
finally
{
 	 conn.close();
}
%>



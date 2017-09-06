<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="com.beanwiz.*"%><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%
boolean bUpdate=false;
if( "true".equalsIgnoreCase( request.getParameter("UpdateForm") ) ) bUpdate=true ;
String ColName =  request.getParameter("ColName")   ;
String ColVarName = request.getParameter("ColVarName") ;
Short oFldType = (Short)FieldMap.get(ColName) ;
short iFldType = 0;
if( oFldType != null ) iFldType = oFldType.shortValue() ;
else iFldType = FieldInputs.TEXT  ;

 switch(iFldType)
 {
  case FieldInputs.TEXT :
  %><input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control"<%if(bUpdate){ %> value="<\%=StrValue(<%=ColVarName %>) %>" <% } %> /><% 
	break ;
  case FieldInputs.SELECT :
  %><select name="<%=ColName %>" id="<%=ColName %>" class="form-control show-tick" data-plugin="selectpicker"><option value="">?</option></select><% 
	break ;
  case FieldInputs.TEXTAREA :
  %><textarea rows="2" name="<%=ColName %>" id="<%=ColName %>" class="form-control" ><%  if(bUpdate){ %><\%=<%=ColVarName %> %><% } %></textarea><% 
	break ;
  case FieldInputs.FILE :
  %><input type="file" name="<%=ColName %>" id="<%=ColName %>" enctype="multipart/form-data" class="form-control filestyle" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" title="Please select the <%=ColName %>." /><!-- accept=".xls,.xlsx" --><% 
	break ;
  case FieldInputs.DATEPICKER :
  %>
		  <div class="input-group input-group-icon">	
			  <input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control readonlybg" <%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showDatePicker("+ColVarName+") %"+">\" ");%>data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	<% 
	break ;
  case FieldInputs.DATETIMEPICKER :
  %>
			 <div class="input-group input-group-icon" >
			   <input type='text' name="<%=ColName %>" id="<%=ColName %>" class="form-control datetimepicker" <%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showDateTimePicker("+ColVarName+") %"+">\" ");%> >
				   <span class="input-group-addon">
					   <span class="icon fa fa-clock-o" aria-hidden="true"></span>
					 </span>
				</div>
	<% 
	break ;
  case FieldInputs.TIMEPICKER :
  %>
			 <div class="input-group input-group-icon">	
			   <input type="text" name="<%=ColName %>" id="<%=ColName %>" class="form-control readonlybg" <%if(bUpdate)out.print(" value=\"<"+"%=DateTimeHelper.showTimeClockPicker("+ColVarName+", \"Read\") %"+">\" ");%>data-plugin="clockpicker" data-placement="bottom">
				   <span class="input-group-addon">
					   <span class="icon fa fa-clock-o" aria-hidden="true"></span>
					 </span>
			 </div>
	<% 
	break ;
  case FieldInputs.JAVACLASSENTITY :
  %><% if(bUpdate){%><\%=<%=ColName %>.getDropList("<%=ColName %>", "<%=ColName %>", <%=ColVarName %>, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %><% }else{ %><\%=<%=ColName %>.getDropList("<%=ColName %>", "<%=ColName %>", <%=ColName %>.value, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %><% } %><% 
	break ;
  case FieldInputs.GETITEMLIST :
  %>
			 <select name="<%=ColName %>" id="<%=ColName %>" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <% out.print("<jsp:include page =\"/include-page/master/getlistitems.jsp\" >"); %>
			     <% out.print("<jsp:param name=\"Attribute\" value=\""+ColName+"\" />"); %>
					 <% if(bUpdate) out.print("<jsp:param name=\"Select\" value=\"<"+"%="+ColVarName+" %"+">\" />"); %>
					 <% if(!bUpdate) out.print("<jsp:param name=\"All\" value=\"false\" />"); %>
					 <% out.print("<jsp:param name=\"None\" value=\"true\" />"); %>
					 <% out.print("<jsp:param name=\"OrderBy\" value=\"\" />"); %>
					 <% out.print("<jsp:param name=\"GroupBy\" value=\"\" />"); %>
				<% out.print("</jsp:include>\r\n"); %>
			 </select>
	<% 
	break ;
  case FieldInputs.DBDROPLIST :
  %>
			  <% out.print("<jsp:include page =\"/???list/\" >"); %>
			     <% out.print("<jsp:param name=\"ElementName\" value=\""+ColName+"\" />"); %>
					 <% out.print("<jsp:param name=\"ElementID\" value=\""+ColName+"\" />"); %>
					 <% if(bUpdate) out.print("<jsp:param name=\"Select\" value=\"<"+"%="+ColVarName+" %"+">\" />"); %>
					 <% if(!bUpdate) out.print("<jsp:param name=\"All\" value=\"false\" />"); %>
					 <% out.print("<jsp:param name=\"None\" value=\"true\" />"); %>
					 <% out.print("<jsp:param name=\"WhereClause\" value=\"\" />"); %>
					 <% out.print("<jsp:param name=\"OrderBy\" value=\"\" />"); %>
					 <% out.print("<jsp:param name=\"GroupBy\" value=\"\" />"); %>
					 <% out.print("<jsp:param name=\"ClassName\" value=\"form-control show-tick\" />"); %>
					 <% out.print("<jsp:param name=\"Plugin\" value=\"data-plugin='selectpicker' data-container='body' data-live-search='false'\" />"); %>
					 <% out.print("<jsp:param name=\"Multiple\" value=\"false\" />"); %>
				<% out.print("</jsp:include>\r\n"); %>
	<% 
	break ;
  case FieldInputs.YESNOSELECT :
  %>
			 <select name="<%=ColName %>" id="<%=ColName %>" class="form-control show-tick" data-plugin="selectpicker">
			   <option value="">--None--</option>
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0" <% if(bUpdate)out.print("<"+"%if( "+ColVarName+" == 0 ){%"+">  selected=\"selected\" <"+"% } %"+">" ) ; %> >&nbsp;No&nbsp;</option>
      	 <option value="1" <% if(bUpdate)out.print("<"+"%if( "+ColVarName+" == 1 ){%"+">  selected=\"selected\" <"+"% } %"+">" ) ; %> >&nbsp;Yes&nbsp;</option>
			 </select>
	<% 
	break ;
	
	
  case FieldInputs.RADIO :
  %><input type="radio" name="<%=ColName %>" id="<%=ColName %>"  value="1" class="form-control" />option 1 &nbsp;&nbsp;<input type="radio" name="<%=ColName %>" value="2" />option 2<% 
	break ;
  case FieldInputs.CHECK :
  %><input type="checkbox" name="<%=ColName %>" id="<%=ColName %>"  class="form-control" /><% 
	break ;
  case FieldInputs.MFTAG :
  %><dtag:MaleFemale ElementName="<%=ColName %>" ElementID="<%=ColName %>" ClassName="form-control" <%  if(bUpdate){ %>Value="<\%=<%=ColVarName %> %>"<%  } %> /><% 
	break ;
  case FieldInputs.YNTAG :
  %><dtag:YesNo ElementName="<%=ColName %>" ElementID="<%=ColName %>" ClassName="form-control" <%  if(bUpdate){ %>Value="<\%=""+<%=ColVarName %> %>"<%  } %> /><% 
	break ;
  case FieldInputs.DATEPICK :
  out.print("<dtag:DatePicker ElementName=\""+ColName+"\" ");  out.print(" ElementID=\""+ColName+"\" "); 	 out.print(" CalendarImage=\"<"+"%=CalendarImage %"+">\" ");	   if(bUpdate)out.print(" DateString=\"<"+"%=com.webapp.utils.DateHelper.showDate("+ColVarName+") %"+">\" "); out.print("/>");
	break ;
	case FieldInputs.DATETIMEPICK :
  out.print("<dtag:DateTimePicker ElementName=\""+ColName+"\" ");  out.print(" ElementID=\""+ColName+"\" "); 	 out.print(" CalendarImage=\"<"+"%=CalendarImage %"+">\" ");	 if(bUpdate)  out.print(" DateTimeString=\"<"+"%=StrValue("+ColVarName+") %"+">\" ");  out.print("/>");
	break ;
  case FieldInputs.DATEINPUT :
  %><dtag:DateInput  ElementName="<%=ColName %>" ElementID="<%=ColName %>" ClassName="form-control" <% if(bUpdate){ %> DateString="<\%=<%=ColVarName %>.toString() %>"  <%  } %>   /><% 
	break ;
  case FieldInputs.TIMEINPUT :
	String TimeExpr = ColVarName+".getHours()"+"+\":\"+"+ColVarName+".getMinutes()+\":\" + "+ColVarName+".getSeconds()" ;
  out.print("<dtag:TimeInput ElementName=\""+ColName+"\" "); 
  if(bUpdate)out.print(" TimeString=\""+"<"+"%="+" "+TimeExpr+"%"+">\""); out.print("/>"); 
  break ;
	case FieldInputs.STATELIST:
	%><dtag:StateList  ElementName="<%=ColName %>" ElementID="<%=ColName %>" ClassName="form-control" <%  if(bUpdate){ %> Select="<\%=<%=ColVarName %> %>"  <%  } else { %> None="true"  <%  }  %>/>  <%
	break;
	case FieldInputs.COUNTRYLIST:
	%><dtag:CountryList ElementName="<%=ColName %>" ElementID="<%=ColName %>" ClassName="form-control" <%  if(bUpdate){ %> Select="<\%=<%=ColVarName %> %>"  <%  } %>  /><%
	break;		
 }

%>
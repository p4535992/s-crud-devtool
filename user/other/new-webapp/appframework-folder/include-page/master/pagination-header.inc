<% 
if(QryObj.count>QryObj.pagesize)
{ 
LastBlock= (QryObj.count/QryObj.pagesize)*QryObj.pagesize ;
if(LastBlock == QryObj.count) LastBlock-=QryObj.pagesize ;
%>
<div ><!-- class="table-responsive table-responsive-overflow"  -->
<table class="table table-curved table-condensed Rslt-Act-nav-tbl" >
<tr>
<td width="15%" align="center" >
<% 
if(QryObj.offset >=QryObj.pagesize )
{ 
%>
<a href="<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET=0"><i class='icon fa fa-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;First</span></a></td>
<% }
else
{ %>
<i class='icon fa fa-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;First</span>
<% 
} 
%>

<td width="20%" align="center" > 
<% 
if(QryObj.offset >=QryObj.pagesize )
{ 
%>
<a href="<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET=<%=QryObj.offset-QryObj.pagesize  %>"><i class='icon fa fa-step-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;Previous</span></a><span class="hidden-xs">&nbsp;&nbsp;[ <%=QryObj.offset-QryObj.pagesize+1 %> to <%=QryObj.offset %> ]</span>
<% }
else
{ %>
<i class='icon fa fa-step-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;Previous</span> 
<% 
} 
%>
</td>
<td  width="30%" align="center" >
<div class="input-group col-sm-6">
<select name="block" id="block" class="form-control show-tick" data-plugin="selectpicker" onchange="GoToBlock()">
<% 
int i=0;
int j = LastBlock/QryObj.pagesize ;
int of = 0 ; 
for(i=0 ;i < j ; i++)
{ 
of = i*QryObj.pagesize ;
%>
<option value="<%=of %>" <% if(QryObj.offset==of) out.print("selected=\"selected\""); %> >[ <%=of+1 %> to <%=(i+1)*QryObj.pagesize %> ]</option>
<% 
} 
if( ( j*QryObj.pagesize) < QryObj.count)
{
of = i*QryObj.pagesize ;
%>
<option value="<%=of %>" <% if(QryObj.offset==of) out.print("selected=\"selected\""); %> >[ <%=of+1 %> to <%=QryObj.count %> ]</option>
<%
} 
%>
</select>
  <span class="input-group-btn">
	  <button class="btn btn-primary" type="button" onclick="{ $('#repag_div').slideToggle(); }"><i class='icon fa fa-list'></i></button>
	</span>
</div>
</td>
<td width="20%" align="center" >
<% 
if(QryObj.offset < (QryObj.count - QryObj.pagesize) )
{ 
%>
<span class="hidden-xs">[ <%=QryObj.offset+QryObj.pagesize+1 %> to <%= ( (QryObj.offset+QryObj.pagesize+QryObj.pagesize)<=QryObj.count? QryObj.offset+QryObj.pagesize+QryObj.pagesize : QryObj.count ) %> ]&nbsp;&nbsp;</span><a href="<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET=<%=QryObj.offset+QryObj.pagesize  %>"><span class='hidden-xs' style='font-size: 16px;'>Next&nbsp;</span><i class='icon fa fa-step-forward' aria-hidden='true'></i></a>
<% }
else
{ %>
<span class='hidden-xs' style='font-size: 16px;'>Next&nbsp;</span><i class='icon fa fa-step-forward' aria-hidden='true'></i>
<% 
} 
%>
</td>
<td width="15%" align="center" >
<% 
if(QryObj.offset < (QryObj.count - QryObj.pagesize) )
{ 
%>
<a href="<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET=<%=LastBlock %>"><span class='hidden-xs' style='font-size: 16px;'>Last&nbsp;</span><i class='icon fa fa-forward' aria-hidden='true'></i></a>
<% }
else
{ %>
<span class='hidden-xs' style='font-size: 16px;'>Last&nbsp;</span><i class='icon fa fa-forward' aria-hidden='true'></i>
<% 
} 
%>

</td>
</tr>
</table>
</div>

<div id="repag_div" style="display:none;margin-bottom: 10px;">
<div class="input-group col-sm-2 col-sm-offset-5">
  <input type="text" name="RowCount" id="RowCount" class="form-control" value="<%=QryObj.pagesize %>" >
  <span class="input-group-btn"><button type="button" class="btn btn-primary" onclick="RePaginate()">Re-Paginate</button></span>
</div>
</div>
<% 
}
else
{ 
if(QryObj.count >= 10) 
{
%>

<div style="margin-bottom: 10px;">
<div class="input-group col-sm-2 col-sm-offset-5">
  <input type="text" name="RowCount" id="RowCount" class="form-control" value="<%=QryObj.pagesize %>" >
  <span class="input-group-btn"><button type="button" class="btn btn-primary" onclick="RePaginate()">Re-Paginate</button></span>
</div>
</div>
<%  
} // END if(QryObj.count >= 10 )
} 
%>

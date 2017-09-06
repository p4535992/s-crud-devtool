<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
 
<%! 
String StrValue(Object ob )
{
return (ob==null)? "":ob.toString() ;
}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();

SMSSetting st = new SMSSetting( application );
ProxySetting proxy = new ProxySetting() ;


String Message = null ;

if("POST".equalsIgnoreCase( request.getMethod()))
{
          // updateSettingItemAndURL updateSettingItem
     String HostURL ="";
     String AuthURL ="";
     String AuthType="";
     boolean bAuthRequired=false;

     if("YES".equalsIgnoreCase(request.getParameter("UseProxy")))
     {
           HostURL = request.getParameter("ProxyHost")+":"+request.getParameter("ProxyPort");
	         if("NONE".equalsIgnoreCase(request.getParameter("ProxyType")))
	         {
	               AuthType="NONE";
		             AuthURL="";
	         }
	         else if("NTLM".equalsIgnoreCase(request.getParameter("ProxyType")))
	         {
	             //  URL := ProxyDomain:ProxyHost:UserDomain:UserName:Password
	               AuthURL= request.getParameter("ProxyDomain")+":"+request.getParameter("ProxyHost")+":"+request.getParameter("UserDomain")+":"+request.getParameter("ProxyUser")+":"+request.getParameter("UserPassword") ;
	               AuthType="NTLM";
	         }
	         else
	         {
	             // URL := realm:user:password
	               AuthURL= request.getParameter("ProxyRealm")+":"+request.getParameter("ProxyUser")+":"+request.getParameter("UserPassword") ;
	               if(request.getParameter("Digest")!=null)AuthType="DIGEST";
		             else AuthType="BASIC";
	         }
	         st.updateSettingItemAndURL("PROXY-SERVER", "YES", HostURL );
	         st.updateSettingItemAndURL("PROXY-AUTH", AuthType, AuthURL );
     }
     else
     {
           st.updateSettingItemAndURL("PROXY-SERVER", "NO", "" );
	         st.updateSettingItemAndURL("PROXY-AUTH", "", "" );
     }
			proxy.init(SMSHelper.getDSN(application));
			
			
      Message="Proxy Settings Updated" ;
      java.lang.StringBuffer rd = request.getRequestURL();
      rd.append("?Message="+Message);
      response.sendRedirect(response.encodeRedirectURL(rd.toString()));

} // end POST METHOD
else
{
   proxy.detectProxy( SMSHelper.getDSN(application));
}
// END IF - if("POST".equalsIgnoreCase( request.getMethod()))

   String PrxAuth="";
  if("NONE".equalsIgnoreCase(proxy.ProxyType) )
  {
      PrxAuth  = "NONE" ;
  }
  else if("NTLM".equalsIgnoreCase(proxy.ProxyType))
  {
      PrxAuth  = "NTLM" ;
  }
  else if("BASIC".equalsIgnoreCase(proxy.ProxyType) || "DIGEST".equalsIgnoreCase(proxy.ProxyType))
  {
      PrxAuth  = "OTHER" ;
  }
  else
  {
      PrxAuth  = "NONE" ;
  }

%>
<html>
<head>

<title>Setup Proxy Server</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %><%=ApplicationResource.stylesheet %>" />
<script type="text/javascript">
<!--
<% 
if(proxy.UseProxy)
{  
%>
var UseProxy = true;
<% 
} 
else
{
%>
UseProxy=false;
<% 
} 
if("NONE".equalsIgnoreCase(proxy.ProxyType) )
{
%>
var ProxyAuth  = "NONE" ;
<% 
}
else if("NTLM".equalsIgnoreCase(proxy.ProxyType))
{
%>
var ProxyAuth  = "NTLM" ;
<% 
}
else if("BASIC".equalsIgnoreCase(proxy.ProxyType) || "DIGEST".equalsIgnoreCase(proxy.ProxyType))
{
%>
var ProxyAuth = "OTHER" ;
<% 
} 
else
{
%>
var ProxyAuth  = "NONE" ;
<%  
}
%>
 
function NavigateTo(page)
{
document.location.href=page;
}
function getProxyType()
{
 var rad="0";
 for (var i=0; i < document.Proxy.ProxyType.length; i++)
   {
   if (document.Proxy.ProxyType[i].checked)
      {
        rad  = document.Proxy.ProxyType[i].value;
      }
   }
return rad  ;
}

function getProxy()
{
 var prval="?";
 for (var i=0; i < document.Proxy.UseProxy.length; i++)
   {
   if (document.Proxy.UseProxy[i].checked)
      {
        prval  = document.Proxy.UseProxy[i].value;
      }
   }
  return prval  ;
}

function chkbtn()
{
 
 var  Pr  = getProxy();
 var PrType = getProxyType();
 if(Pr.toUpperCase()=="YES")UseProxy=true ;
 else UseProxy=false;
 if(PrType.toUpperCase()=="NONE" ) ProxyAuth="NONE";
 else if (PrType.toUpperCase()=="NTLM" ) ProxyAuth="NTLM";
 else ProxyAuth = "OTHER";
 UpdateDisp()

}


function UpdateDisp()
{
   var divProxyBlock = document.getElementById("ProxyBlock");
   var divNTLMBlock = document.getElementById("NTLMBlock");
   var divOtherBlock = document.getElementById("OtherBlock");
	 var divPasswordBlock = document.getElementById("PasswordBlock");
	 

   divNTLMBlock.style.display="none";
	 divOtherBlock.style.display="none" ;
	 divPasswordBlock.style.display="none" ;
	 
   if(ProxyAuth=="NTLM")
    {
      divNTLMBlock.style.display="block" ;
			divPasswordBlock.style.display="block" ;
    }
   else if(ProxyAuth=="OTHER")
    {
      divOtherBlock.style.display="block" ;
			divPasswordBlock.style.display="block" ;
    }
		
		if(UseProxy==true) divProxyBlock.style.display="block" ;
    else divProxyBlock.style.display="none" ;
}
 
// -->
</script>
<style type="text/css">
<!-- 
#ProxyBlock 
{
display: block ;
}
#NTLMBlock
{
display: block ;
}
#OtherBlock
{
display: block ;
}

#PasswordBlock
{
display: block ;
}  
-->
</style>


</head>
<body topmargin="0"  class="admin"  onload="UpdateDisp()" >
<hr size="1">
<% if(Message !=null){ %> <p align="center"><big><%=Message %></big></p> <hr size="1" />    <% } %>

<table summary="" width="100%">
<tr>
<td width="70%" align="left" ><span class="title">HTTP Proxy Server Setup:</span></td>
<td width="30%"  align="right"  ><a href="<%=appPath %>/admin/index.jsp"><b>&laquo; Done Go Back</b></a></td></tr>
</table>
<form name="Proxy" action="<%=thisFile %>" method="post" >
<table summary="" width="100%" border="1" cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Use Proxy Server:</span></td>
<td valign="top" width="75%" >
 
<input type="radio" name="UseProxy" value="YES" <% if(proxy.UseProxy){ %> checked="checked"<%   }  %> onclick="chkbtn()" />Yes  &nbsp;&nbsp;&nbsp;&nbsp;
<input type="radio" name="UseProxy" value="NO"  <% if(!proxy.UseProxy){ %> checked="checked"<%  }  %>  onclick="chkbtn()" />No 
 
</td></tr>
</table> 
<div id="ProxyBlock">
<table summary="" width="100%" border="1" cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Proxy Host / Port:</span></td>
<td valign="top" width="75%" >
Host: <input type="text"  name="ProxyHost" value="<%=StrValue(proxy.ProxyHost) %>"/> 
Port: <input type="text"  name="ProxyPort" size="6" value="<%=StrValue(""+proxy.ProxyPort) %>"/>
</td>
</tr>
</table>
<table summary="" width="100%" border="1" cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Authentication Type:</span></td>
<td valign="top" width="75%" >
<input type="radio"  name="ProxyType" value="NONE" onclick="chkbtn()"  <% if("NONE".equalsIgnoreCase(PrxAuth)){ %>checked="checked"  <% } %>   /> No Proxy Authentication Required<br/>
<input type="radio"  name="ProxyType" value="NTLM" onclick="chkbtn()"  <% if("NTLM".equalsIgnoreCase(PrxAuth)){ %>checked="checked"  <% } %>   /> Microsoft Proxy using NTML Authentication Scheme.<br/>
<input type="radio"  name="ProxyType" value="OTHER" onclick="chkbtn()" <% if("OTHER".equalsIgnoreCase(PrxAuth)){ %>checked="checked"  <% } %>  /> Other Proxy using Basic or Digest Authentication Scheme.
 
</td>
</tr>
</table>
<div id="NTLMBlock">
<table summary="" width="100%" border="1"  cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Authenticaion<br/>Details for MS Proxy:</span></td>
<td valign="top" width="75%" >
Proxy Domain <input type="text"  name="ProxyDomain"  value="<%=StrValue(proxy.ProxyDomain) %>" /> <br/>
User Domain <input type="text"  name="UserDomain"  value="<%=StrValue(proxy.UserDomain) %>"  />
</td>
</tr>
</table>
</div>

<div id="OtherBlock">
<table summary="" width="100%" border="1"  cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Authenticaion<br/>Details for Other Proxy</span></td>
<td valign="top" width="75%" >
Proxy Realm <input type="text"  name="ProxyRealm" value="<%=StrValue(proxy.ProxyRealm) %>"  /> <br/>
<input type="checkbox" name="Digest"   <%  if("DIGEST".equalsIgnoreCase(proxy.ProxyType)){ %>checked="checked"  <%} %>  /> Use  Digest Authentication Scheme 
</td>
</tr>
</table>

</div>

<div id="PasswordBlock">
<table summary="" width="100%" border="1" cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Proxy User:</span></td>
<td valign="top" width="75%" >
Username: <input type="text"  name="ProxyUser" size="16" value="<%=StrValue(proxy.ProxyUser )%>" /> 
Password: <input type="text"  name="UserPassword" size="16" value="<%=StrValue(proxy.UserPassword )%>" />
</td>
</tr>
</table>
</div>
</div>
<table summary="" width="100%" border="1" cellpadding="4" cellspacing="2" >
<tr><td valign="top" width="25%"><span class="label">Submit / Cancel</span></td>
<td valign="top" width="75%" >
 <button type="submit">Update Proxy Settings</button>&nbsp;&nbsp;&nbsp;
 <button type="button" onclick="NavigateTo('index.jsp')">Candel Update </button>
 
</td>
</tr>
</table>

</form>




</body>
</html>

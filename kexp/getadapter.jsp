
<%@ page import="java.net.NetworkInterface, java.net.SocketException, java.util.Enumeration, java.util.Vector"%>
<%! 
Vector getAdaptorNames() throws SocketException
  {
    Vector localVector = new Vector();
    Enumeration localEnumeration = NetworkInterface.getNetworkInterfaces();
    while (localEnumeration.hasMoreElements())
    {
      NetworkInterface localNetworkInterface = (NetworkInterface)localEnumeration.nextElement();
      localVector.add(localNetworkInterface.getName());
    }
    return localVector;
  }
	
String getAdaptorAddress(String paramString) throws SocketException
  {
    NetworkInterface localNetworkInterface = NetworkInterface.getByName(paramString);
    if (localNetworkInterface == null) return null;
    int i = 0;
    byte[] arrayOfByte = localNetworkInterface.getHardwareAddress();
    if (arrayOfByte != null) i = arrayOfByte.length;
    StringBuffer localStringBuffer = new StringBuffer();
    if (i > 0)
    {
      for (int j = 0; j < i; j++)
      {
        int k = 0;
        k |= arrayOfByte[j] & 0xFF;
        String str = Integer.toHexString(k).toUpperCase();
        if (str.length() < 2) localStringBuffer.append("0" + str); else
          localStringBuffer.append(str);
        if (j < i - 1) localStringBuffer.append("-");
      }

    }
    else
    {
      return null;
    }

    return localStringBuffer.toString();
  }
	
String getKey(String paramString)
  {
    Object localObject = null;
    if (paramString == null)
      return "";
    String[] arrayOfString = paramString.split("-");
    StringBuffer localStringBuffer = new StringBuffer();
    int i = 0;
    for (int j = 0; j < arrayOfString.length; j++)
    {
      int k = 0;
      try
      {
        k = Integer.decode("0X" + arrayOfString[j]).intValue();
        i += k;
        char c = (char)(65 + k % 26);
        localStringBuffer.append(c);
      }
      catch (NumberFormatException localNumberFormatException)
      {
        return null;
      }
    }
    localStringBuffer.append("-" + i);
    return localStringBuffer.toString();
  }		
%>
<% 
String appPath = request.getContextPath();
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
<jsp:include page="/header.jsp" flush="true" />	

<div class="container-fluid">			

<div class="row">
  <div class="col-md-12">
      <div class="panel panel-danger">
        <div class="panel-heading">
          <h3 class="panel-title">Key</h3>
        </div>
        <div class="panel-body">
          <ul class="list-group">
					  <% for(int i =0; i< getAdaptorNames().size() ; i++) {%>
							 <% if(getAdaptorAddress(getAdaptorNames().get(i).toString()) != null) {%>
            	 <li class="list-group-item"><%=getAdaptorNames().get(i) %> - <%=getAdaptorAddress(getAdaptorNames().get(i).toString()) %> - <%=getKey(getAdaptorAddress(getAdaptorNames().get(i).toString())) %></li>
						   <% } %>
						<% } %>
          </ul>
        </div>
      </div>			
	</div>
</div>				

    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
</body>
</html>	
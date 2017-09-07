<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*"%>
<%@ page  import="org.json.simple.*" %>
<%@ page import="java.util.* "%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%!  
String rpHash(String value) { 
    int hash = 5381; 
    value = value.toUpperCase(); 
    for(int i = 0; i < value.length(); i++) { 
        hash = ((hash << 5) + hash) + value.charAt(i); 
    } 
    return String.valueOf(hash); 
} 
%>

<% 

response.setHeader("Cache-control", "no-cache"); 
response.setDateHeader("Expires", 0); 
response.setHeader("Pragma", "No-cache");

boolean flag = false ;

String realPersoncaptchacaptchaval =  request.getParameter("realPersoncaptcha") ;
String realPersoncaptchacaptchaHashval =  request.getParameter("realPersoncaptchaHash") ;


if (rpHash(request.getParameter("realPersoncaptcha")).equals(request.getParameter("realPersoncaptchaHash")))
    {  
       flag = true ;
		}
		else
		{
       flag = false ;		
		}

  JSONObject jobj = new JSONObject();

	jobj.put("valid",flag);	
	jobj.put("realPersoncaptcha",rpHash(request.getParameter("realPersoncaptcha")));
	jobj.put("realPersoncaptchaHash",request.getParameter("realPersoncaptchaHash"));
		
  out.print(jobj);
%>

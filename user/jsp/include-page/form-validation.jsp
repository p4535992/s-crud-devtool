<%@ page import="com.beanwiz.*" %><%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.lang.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="com.beanwiz.TableColumn" %><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><jsp:useBean id="ManFieldMap" scope="session" class="java.util.TreeMap" /><%
int nManCount = ManField.size();
String TableName = request.getParameter("TableName");
String LoginFolderName =  request.getParameter("LoginFolderName");
String PageType =  request.getParameter("PageType");
String NewFormID = TableName+"_Add" ;
String UpdateFormID = TableName+"_Update" ;
String SearchFormID = TableName+"_Search" ;
String s = ""; 
String s1 = "";
%>/* Form validation code Start : for validation plugin */<% if(PageType.equalsIgnoreCase("R-D") || PageType.equalsIgnoreCase("R-D-P") || PageType.equalsIgnoreCase("R-D-POPUP")) {%>
<% }else{ %><% if(PageType.equalsIgnoreCase("ALL-IN-ONE") || PageType.equalsIgnoreCase("Listpage") || PageType.equalsIgnoreCase("Listpage-P")) {%><\% 
if(nAction==NEW_FORM ) 
{
%>
// New Entry Form
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>//fetch_Course(1,<\%=nModuleID %>,'NewAct')<% } %> 
<% 
if(nManCount > 0) // mandatory fields are there
{ 
%>    $('#<%=NewFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {<% for( int i=0; i < nManCount; i++){s = (String)ManField.get(i) ;if(ManFieldMap.containsKey(s)){s1 = ManFieldMap.get(s).toString() ;%>
            <%=(String)ManField.get(i) %>: {
                validators: {<%int i1 = 0; String[] parts = s1.split(","); int partslength =  parts.length;for(String str:parts){i1++;short svalidType = Short.parseShort(str);%>
								    <%if(svalidType == ValidationType.MOBILE_IN){%>regexp<% }else{ %><%=ValidationType.getLabel(svalidType) %><% } %>: {<% if(svalidType == ValidationType.NOT_EMPTY) {%>
                        message: 'The <%=(String)ManField.get(i) %> is required'<% }if(svalidType == ValidationType.NUMERIC){ %>
												message: 'not number'<% }if(svalidType == ValidationType.STRING_LENGTH){ %>
												max: 50,
												//min: 3,
											  message: 'The value must be less than 50 characters'<% }if(svalidType == ValidationType.FILE){ %>
												extension: 'pdf',
												type: 'application/pdf',
                        message: 'Please choose a PDF file'<% }if(svalidType == ValidationType.EMAIL){ %>
												message: 'not valid email address'<% }if(svalidType == ValidationType.PHONE){ %>
												country: 'IN',
												message: 'not valid phone number'<% }if(svalidType == ValidationType.REGEXP){ %>
												regexp: /^$/,
										    message: 'not valid'<% }if(svalidType == ValidationType.MOBILE_IN){ %>
										    regexp: /^[789]\d{9}$/,//^[7-9][0-9]{9}$
										    message: 'not valid Mobile number'<% } %>					
                    }<% if(i1>0 && i1 != partslength) {%>,<% } %><% } %>
								}
						}<% if(i <nManCount-1) out.print(","); %><% } } %>
        }
    });<%
}
else
{ 
%>
<% out.println("/*"); %>    $('#<%=NewFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {
            $$fieldname$$: {
                validators: {
                    notEmpty: {
                        message: 'The $$fieldname$$ is required'
                    }
                }
            }
        }
    });
<% out.println("*/"); %><% 
}
%>
<\%
}  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>//fetch_Course(1,<\%=nModuleID %>,'ChngAct')<% } %>  
<% 
if(nManCount > 0) // mandatory fields are there
{ 
%>    $('#<%=UpdateFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {<% for( int i=0; i < nManCount; i++){s = (String)ManField.get(i) ;if(ManFieldMap.containsKey(s)){s1 = ManFieldMap.get(s).toString() ;%>
            <%=(String)ManField.get(i) %>: {
                validators: {<%int i1 = 0; String[] parts = s1.split(","); int partslength =  parts.length;for(String str:parts){i1++;short svalidType = Short.parseShort(str);%>
								    <%if(svalidType == ValidationType.MOBILE_IN){%>regexp<% }else{ %><%=ValidationType.getLabel(svalidType) %><% } %>: {<% if(svalidType == ValidationType.NOT_EMPTY) {%>
                        message: 'The <%=(String)ManField.get(i) %> is required'<% }if(svalidType == ValidationType.NUMERIC){ %>
												message: 'The value is not number'<% }if(svalidType == ValidationType.STRING_LENGTH){ %>
												max: 50,
												//min: 3,
											  message: 'The FirstName must be less than 50 characters'<% }if(svalidType == ValidationType.FILE){ %>
												extension: 'pdf',
												type: 'application/pdf',
                        message: 'Please choose a PDF file'<% }if(svalidType == ValidationType.EMAIL){ %>
												message: 'The value is not valid email address'<% }if(svalidType == ValidationType.PHONE){ %>
												country: 'IN',
												message: 'The value is not valid phone number'<% }if(svalidType == ValidationType.REGEXP){ %>
												regexp: /^$/,
										    message: 'The value is not valid'<% }if(svalidType == ValidationType.MOBILE_IN){ %>
										    regexp: /^[789]\d{9}$/,//^[7-9][0-9]{9}$
										    message: 'not valid Mobile number'<% } %>					
                    }<% if(i1>0 && i1 != partslength) {%>,<% } %><% } %>
								}
						}<% if(i <nManCount-1) out.print(","); %><% } } %>
        }
    });<% 
}
else
{ 
%><% out.println("/*"); %>    $('#<%=UpdateFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {
            $$fieldname$$: {
                validators: {
                    notEmpty: {
                        message: 'The $$fieldname$$ is required'
                    }
                }
            }
        }
    });
<% out.println("*/"); %><% 
}
%>
<\%
}<% if(PageType.equalsIgnoreCase("ALL-IN-ONE")) {%>
else if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>//fetch_Course(1,<\%=nModuleID %>,'SrchAct')<% } %>
<% out.println("/*"); %>    $('#<%=SearchFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {
            $$fieldname$$: {
                validators: {
                    notEmpty: {
                        message: 'The $$fieldname$$ is required'
                    }
                }
            }
        }
    });
<% out.println("*/"); %><\%
}<% } %>
%>
<% 
}
else if(PageType.equalsIgnoreCase("S-R-D-P") || PageType.equalsIgnoreCase("S-R-D") || PageType.equalsIgnoreCase("S-R-D-QryObj")) 
{
%>
<\%
if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>//fetch_Course(1,<\%=nModuleID %>,'SrchAct')<% } %>
<% out.println("/*"); %>    $('#<%=SearchFormID %>').formValidation({
        framework: 'bootstrap',
        fields: {
            $$fieldname$$: {
                validators: {
                    notEmpty: {
                        message: 'The $$fieldname$$ is required'
                    }
                }
            }
        }
    });
<% out.println("*/"); %><\%
} 
%>
<% } %> 
<% } %>
/* Form validation code End */
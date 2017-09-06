<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="com.beanwiz.TableColumn" %><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%
int nManCount = ManField.size();
String TableName = request.getParameter("TableName");
String LoginFolderName =  request.getParameter("LoginFolderName");
String PageType =  request.getParameter("PageType");
String NewFormID = TableName+"_Add" ;
String UpdateFormID = TableName+"_Update" ;
String SearchFormID = TableName+"_Search" ;
%>/* Form validation code Start : for validation plugin */<% if(PageType.equalsIgnoreCase("R-D") || PageType.equalsIgnoreCase("R-D-P") || PageType.equalsIgnoreCase("R-D-POPUP")) {%>
<% }else{ %><% if(PageType.equalsIgnoreCase("Listpage") || PageType.equalsIgnoreCase("Listpage-P")) {%><\% 
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
        fields: {<% for( int i=0; i < nManCount; i++){%>
            <%=(String)ManField.get(i) %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=(String)ManField.get(i) %> is required'
                    }
                }
            }<% if(i <nManCount-1) out.print(","); %><% } %>
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
        fields: {<% for( int i=0; i < nManCount; i++){%>
            <%=(String)ManField.get(i) %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=(String)ManField.get(i) %> is required'
                    }
                }
            }<% if(i <nManCount-1) out.print(","); %><% } %>
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
}
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
<% }else{ %> 
<\% 
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
        fields: {<% for( int i=0; i < nManCount; i++){%>
            <%=(String)ManField.get(i) %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=(String)ManField.get(i) %> is required'
                    }
                }
            }<% if(i <nManCount-1) out.print(","); %><% } %>
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
        fields: {<% for( int i=0; i < nManCount; i++){%>
            <%=(String)ManField.get(i) %>: {
                validators: {
                    notEmpty: {
                        message: 'The <%=(String)ManField.get(i) %> is required'
                    }
                }
            }<% if(i <nManCount-1) out.print(","); %><% } %>
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
}
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
} 
%><% } %><% } %>
/* Form validation code End */
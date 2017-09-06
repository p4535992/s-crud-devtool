<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, nu.xom.*, com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %><%@ page import="javax.naming.*" %><% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String ElementID = request.getParameter("ElementID");
if(ElementID == null) ElementID = "JNDIDSN_DROP_LIST" ;
String ElementName = request.getParameter("ElementName");
if(ElementName == null) ElementName = "JNDIDSN" ;
String ElementClass = request.getParameter("ElementClass");
String Cls = ( ElementClass!=null )? " class=\""+ElementClass+"\" " : " ";


 %>
<select name="<%=ElementName %>" id="<%=ElementID %>" <%=Cls %> >
    <option value="">-- None Selected --</option>
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
 

 %><option value="<%=JNDIDSN %>"> <%=Title %> [ <%=JNDIDSN %> ]</option>

<% 
      } // end if (!ItemName.equals("$"))
 
 } // end while
 
 %>
</select>
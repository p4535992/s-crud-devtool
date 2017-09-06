<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String TableName = request.getParameter("TableName")  ;
String IDField  = request.getParameter("IDField")  ;
String BeanName = request.getParameter("BeanName")  ;
String SQLEngine = request.getParameter("SQLEngine") ;
String WebApp =  request.getParameter("WebApp");
%>


 if(nAction == PROCESS_CHECKED)
 {
    qStr  = new <%=WebApp %>.apputil.appMakeQueryString( request, application );
		//  qStr  = new <%=WebApp %>.apputil.MakeQueryString( request, "<%=SQLEngine %>" );
	  qStr.addMultiSelectParam(<%=BeanName  %>._tablename, "<%=IDField %>", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("<%=IDField %>");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `<%=TableName %>` "+ WhrCls + " ORDER BY `<%=TableName %>`.`<%=IDField %>` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   <%=BeanName %>.openTable(WhrCls, " ORDER BY `<%=IDField %>` ");
           while(<%=BeanName %>.nextRow())
           {
					   
           }
					 <%=BeanName %>.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = <%=BeanName %>.executeUpdate( qStr.SQL( "DELETE FROM `<%=TableName %>` "+WhrCls+" ") );
				 MessageText = " ( "+del_cnt+" ) records are deleted." ;
				}
				else
				{
				  MessageText = "Record deletion not permitted." ;
				}
		}
		
		if("Activity".equalsIgnoreCase(CheckedAction) && chk_count > 0 )
		{
		      String WhereParam  = RequestHelper.encodeBase64( WhrCls.getBytes()) ;
          String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
          String redirect  = "<%=TableName %>-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
          response.sendRedirect(response.encodeRedirectURL(redirect)); 
		}

		/* 
		  // Forwared Base64 encoded sql to other page if relevent
		   String SQLPARAM = new String( com.webapp.base64.UrlBase64.encode(ChkQuery.getBytes() ) );
       String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile ).getBytes() ) );
       String redirect  = appPath+"/$PATH.jsp?Count="+chk_count+"&SQL="+SQLPARAM+"&ReturnPath="+ReturnPath; //  &Target=Target&MobileField=Mobile&EmailField=Email  
       response.sendRedirect(response.encodeRedirectURL(redirect)); 
		
		*/
     nAction=default_cmd ;
 }


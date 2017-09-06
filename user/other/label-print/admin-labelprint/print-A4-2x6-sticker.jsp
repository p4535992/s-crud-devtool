<%@ page import="java.io.*, java.util.*, java.sql.*, java.text.*, javax.imageio.*   "%><% 
  %><%@ page import="com.pdfjet.*,com.pdfjet.* "%><% 
	%><%@ page import="com.google.zxing.*, com.google.zxing.common.*, com.google.zxing.client.j2se.*, com.google.zxing.qrcode.*, com.google.zxing.oned.*" %><% 
  %><%@ page import="com.webapp.utils.* com.webapp.db.*,  com.webapp.jsp.* com.webapp.pdf.* "%><% 
	%><%@ page import="com.$WEBAPP.* " %><%
	%><%!
	
	 
	
	  final int ROWS = 6;
	  final int COLS = 2;
		final int CELLS = ROWS*COLS ;
	  
		double LEFT =    PDFUnits.HALF_INCH/3 ; 
		double RIGHT  =  PDFUnits.A4WIDTH-(PDFUnits.HALF_INCH/3) ;
	  double TOP  =    PDFUnits.HALF_INCH * 0.6; 
	  double BOTTOM =  PDFUnits.A4HEIGHT-( PDFUnits.HALF_INCH * 0.6)  ;
		
	  double HEIGHT = BOTTOM-TOP;
		double WIDTH  = RIGHT-LEFT ;

		double CELLWD = WIDTH/COLS;
		double CELLHT = HEIGHT/ROWS;
		
		double BOX_HEIGHT =  ( PDFUnits.HALF_INCH * 2.25 );
		double BOX_WIDTH =  CELLWD - PDFUnits.HALF_INCH;
		
		 double[] xpos_title = new double[CELLS];
		 double[] ypos_title = new double[CELLS];
		 
		 double[] xpos_addr = new double[CELLS];
		 double[] ypos_addr = new double[CELLS];

		 double[] xpos_mobile = new double[CELLS];
		 double[] ypos_mobile = new double[CELLS];

	
	    void DrawPage(com.pdfjet.Page pg)
	    throws Exception
	    { 
	         Box mainbox = new Box();
    		   mainbox.setPosition(LEFT ,TOP);
           mainbox.setSize(WIDTH,  HEIGHT);
    	     mainbox.setLineWidth(1) ;
           mainbox.drawOn(pg);
					 
					 Line line = new Line();
		       line.setWidth(1); 
						
						for( int i=0; i<COLS ; i++)
						{
						  if(i>0)
							{
						   line.setStartPoint( LEFT+ ( CELLWD*i ), TOP);
			         line.setEndPoint  ( LEFT+ ( CELLWD*i ), BOTTOM );
			         line.drawOn(pg);
							}
						}
						
						for( int i=0; i<ROWS ; i++)
						{
						   if(i>0)
							 {
							   line.setStartPoint( LEFT, TOP+(CELLHT*i));
			           line.setEndPoint  ( RIGHT,TOP+(CELLHT*i));
			           line.drawOn(pg);
							 }
						  
						} // for( int i=0; i<ROWS ; i++)
	    }
	
	
	   void DrawLabel(com.pdfjet.Page pg, int idx, String title, String address, String mobile)
		 throws Exception
		 {
		 
		          txLnTitle.setText(title);
							txLnTitle.setPosition (xpos_title[idx], ypos_title[idx]);
							txLnTitle.drawOn(pg); 
							
		          txBxAddr.setText(address);
							txBxAddr.setPosition (xpos_addr[idx], ypos_addr[idx]);
							txBxAddr.drawOn(pg); 

		          txLnMobile.setText("Mobile: "+mobile);
							txLnMobile.setPosition (xpos_mobile[idx], ypos_mobile[idx]);
							txLnMobile.drawOn(pg); 
		 }
	   // Private Servlet Variables
		 
		 com.pdfjet.PDF pdf = null;
		 
		 com.pdfjet.Font fntTitle =null;
		 com.pdfjet.TextLine txLnTitle = null;

		 com.pdfjet.Font fntAddr =null;
		 com.pdfjet.TextBox txBxAddr = null;
		 
		 
		 com.pdfjet.Font fntMobile =null;
		 com.pdfjet.TextLine txLnMobile = null;
	   
		 // Servlet init on load
		 public void jspInit() 
     {
		      ServletContext  cntx = getServletConfig().getServletContext() ;
			 	  int idx=0;
		      for(int y=0; y< ROWS; y++)
		      {
						    double y_val= TOP+(CELLHT *y)+(PDFUnits.HALF_INCH*0.50);
						    for(int x=0; x< COLS; x++)
                {
    							   ypos_title[idx] =  y_val;
    								 ypos_addr[idx] =   y_val+(PDFUnits.HALF_INCH*0.25);
    								 ypos_mobile[idx] = y_val+(PDFUnits.HALF_INCH*2.80);
    								 
    								 xpos_title[idx] = LEFT+ (CELLWD* x)+(PDFUnits.HALF_INCH*0.5);
    								 xpos_addr[idx] =  LEFT+ (CELLWD* x)+(PDFUnits.HALF_INCH*0.5);
    								 xpos_mobile[idx] = LEFT+ (CELLWD* x)+(PDFUnits.HALF_INCH*0.5);
    								 
    								 idx++;
							  } // end inner for
		      } // end outer for

		 }
		 
	%><% 
	  
	String appPath = request.getContextPath() ;
  String thisFile =appPath+request.getServletPath() ;	
		
   try
	 {
	  response.setDateHeader("Expires", 0 );
    response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
    response.setHeader("Pragma", "no-cache"); 
    response.setContentType("application/pdf");
		
		/*
		          Code for barcode image
							
							com.google.zxing.Writer writer = new Code128Writer(); 
				      BitMatrix matrix = null;
				      int h = 20;
				      int w = 40;
				      matrix = writer.encode(text , com.google.zxing.BarcodeFormat.CODE_128, w, h);
				    
				      ByteArrayOutputStream baos = new ByteArrayOutputStream();
				      MatrixToImageWriter.writeToStream(matrix, "png", baos);
				      byte[] ImgBytes = baos.toByteArray() ;                    
				
							
							
		          ByteArrayInputStream is_code128 = new ByteArrayInputStream(ImgBytes);
				      Image code128img  = new Image(pdf, new  BufferedInputStream(is_code128), ImageType.PNG);

				      code128img.setPosition(xpos_bar[idx], ypos_bar[idx] );
				      code128img.drawOn(pg); 
		
		
		*/
    
		// Initialize those private class variables every time on page invokation which are thread dependent
		// These variable need output stream as constructor parameter 
		
	  ServletOutputStream jspos = response.getOutputStream();
		// Create PDF object from out stream
		 pdf = new PDF(jspos );

		 fntTitle = new com.pdfjet.Font(pdf, CoreFont.HELVETICA);
	   txLnTitle = new TextLine(fntTitle, ""); 
	   fntTitle.setSize(16);
		 
		 fntAddr = new com.pdfjet.Font(pdf, CoreFont.HELVETICA);
		 fntAddr.setSize(14);
	   txBxAddr = new TextBox(fntAddr , "", BOX_WIDTH, BOX_HEIGHT );
		 txBxAddr.setNoBorders();
		 txBxAddr.setSpacing(0.5);
		
   	 fntMobile = new com.pdfjet.Font(pdf, CoreFont.HELVETICA);
		 fntMobile.setSize(9);
	   txLnMobile = new TextLine(fntMobile, ""); 
		 
   
	    String SQL = RequestHelper.getBase64param(request, "SQL");
		  int nCount = RequestHelper.getInteger(request, "Count");
			GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
		       
			String[] TitleFields = RequestHelper.getCsvStringArray(request, "Title");	
			String[] AddressFields = RequestHelper.getCsvStringArray(request, "Address");		 
			String  MobileField = request.getParameter("Mobile");
					 
						
						 ResultSet rslt = genqry.openQuery(SQL);
						 int n=0,index=0;
						 com.pdfjet.Page pdpage = null;
	           while(rslt.next())
	           {  
	                 n++;
							     if( index==0 ) // at 0 index start new page
									 { 
									    pdpage = new com.pdfjet.Page(pdf, A4.PORTRAIT);
										  DrawPage(pdpage);
									 }
									 String Title = "Unknown Title" ;
									 
									 if(TitleFields!=null)
									 {  
									    StringBuilder sbTitle = new StringBuilder();
									    for(String st:TitleFields)
											{
											   sbTitle.append(rslt.getString(st));
												 sbTitle.append(" ");
											}
									    Title = sbTitle.toString();
									 }
									 String Address = " ";
									 
									 if(AddressFields!=null)
									 {
									    StringBuilder sbAdr = new StringBuilder();
									    for(String st:AddressFields)
											{
											   sbAdr.append(rslt.getString(st));
												 sbAdr.append(" ");
											}
									    Address = sbAdr.toString();
									 
									 }
									 
									 String Mobile = "" ;
									 if(MobileField!=null) Mobile=rslt.getString(MobileField);
									 
									 
									 DrawLabel(pdpage, index, Title, Address, Mobile);
									 
								   index++;
							     if( index==CELLS )index=0;
						 }
						 genqry.closeQuery();
						 
		  /* close and flush stream */
	     pdf.flush();
       jspos.close(); 
	}
	catch(Exception ex)
	{
	  response.setContentType("text/html");
	 %>
	 <!DOCTYPE HTML >
   <html>
   <head>
       <title>PDF Creation Error</title>
        <link rel="stylesheet" href="<%=appPath %><%=ApplicationResource.stylesheet %>" type ="text/css" />
   </head>
   <body>
   <jsp:include page="/banner.jsp" flush="true" />
   <div id="div1" style="padding:1em">
      <h1 style="color:red">PDF Creation Error:</h1>
		  <%=ExceptionHelper.showException(ex, "exception_div") %>
   </div>
   </body>
   </html>

	 
	 
	 <%
	}	
	 %>
<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page  import="java.io.*, java.text.*, java.math.* java.sql.*, javax.sql.*, javax.naming.*, com.webapp.utils.*, com.webapp.resin.* " %>
<%@ page  import=" com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %> 
<jsp:useBean id="theColumnList" scope="session" class="java.util.ArrayList<TableColumn>" />
<%! 
public class TableColumn
{
         public int ColNo =0;
         public String ColName ;
         public int  ColSQLType ;
         public String ColTypeName;
         public int ColSize ;
         public int Precision ;
         public int Scale ;
         public String VarName ;
         public String VarType ;
         public String GetMethod ;
         public String SetMethod ;
         public boolean Auto = false ;
         public boolean TypeOverride=false ;	 
}

SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");

String CellValue(Cell c)
		{
		    String ret=null;
				try
				{
			    POIHelper.getStringFromCell(c);
				}		
				catch(Exception e ){ ret="" ;}
				
			 return ret;	
		}

String ColForMySQL(TableColumn colinfo, short count, short no  ) 
    {
        String ret="" ;
	      if(colinfo.Auto ) 
	      {
	        return " `"+colinfo.ColName+"` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ;
	      }
	      switch(colinfo.ColSQLType)
		    { 
            case java.sql.Types.ARRAY :
            case java.sql.Types.DATALINK :
            case java.sql.Types.DISTINCT :
            case java.sql.Types.JAVA_OBJECT :
            case java.sql.Types.NULL :
            case java.sql.Types.OTHER :
            case java.sql.Types.REF :
            case java.sql.Types.ROWID :
            case java.sql.Types.STRUCT :
            break ;
		
	          case java.sql.Types.BOOLEAN :
            case java.sql.Types.BIT :
               ret=" `"+colinfo.ColName+"` BIT(1)   DEFAULT NULL"+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.TINYINT :
               ret=" `"+colinfo.ColName+"` TINYINT(4)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.SMALLINT :
               ret=" `"+colinfo.ColName+"` SMALLINT(6)   DEFAULT  NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.INTEGER :
               ret=" `"+colinfo.ColName+"` INT(11)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.BIGINT :
               ret=" `"+colinfo.ColName+"` BIGINT(20)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.FLOAT :
                ret=" `"+colinfo.ColName+"` FLOAT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
    
	          case java.sql.Types.REAL :		
            case java.sql.Types.DOUBLE :
                ret=" `"+colinfo.ColName+"` DOUBLE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.NUMERIC :		
            case java.sql.Types.DECIMAL :
						
                ret=" `"+colinfo.ColName+"` DECIMAL("+colinfo.Precision+","+colinfo.Scale+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
						case java.sql.Types.NCHAR :
            case java.sql.Types.CHAR :
                ret=" `"+colinfo.ColName+"` CHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.NVARCHAR :
            case java.sql.Types.VARCHAR :
                ret=" `"+colinfo.ColName+"` VARCHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
						/*
            case java.sql.Types.DATE :
						    
                ret=" `"+df.parse(colinfo.ColName)+"` DATE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
						*/
	          case java.sql.Types.TIME :
                ret=" `"+colinfo.ColName+"` TIME  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
            case java.sql.Types.TIMESTAMP :
                ret=" `"+colinfo.ColName+"` DATETIME  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.CLOB :
            case java.sql.Types.SQLXML :
            case java.sql.Types.NCLOB :
            case java.sql.Types.LONGNVARCHAR :
            case java.sql.Types.LONGVARCHAR :
            ret=" `"+colinfo.ColName+"` LONGTEXT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	          case java.sql.Types.BINARY :
            case java.sql.Types.BLOB :
            case java.sql.Types.LONGVARBINARY :
            case java.sql.Types.VARBINARY :
            ret=" `"+colinfo.ColName+"` LONGBLOB  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
		   }  // End switch(colinfo.ColSQLType)
	  
      return ret ;	
    } // end mehod colForMySQL

String PreCreateForMySQL(String table)
	{
      String ret=" CREATE TABLE IF NOT EXISTS `"+table+"` (\r\n" ;
      return ret ;	
	} // end mehod preCreateForMySQL
  
String PostCreateForMySQL(String table)
	{
      String ret=" ) ENGINE=MyISAM DEFAULT CHARSET=utf8 ;\r\n" ;
      return ret ;	
	} // end mehod postCreateForMySQL
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName") ;

int nHeaderCount = 0;
try
{
  nHeaderCount = Integer.parseInt(request.getParameter("HeaderCount") ) ;
}catch(NumberFormatException ex)
{
  nHeaderCount = 0;
}

 
int nDuplicateField = 0;
try
{
    nDuplicateField = Integer.parseInt(request.getParameter("DuplicateField") ) ;
		if(nDuplicateField > nHeaderCount ) nDuplicateField = 0;
		 
}catch(NumberFormatException ex)
{
    nDuplicateField = 0;
}
int nDuplicateIndex =  nDuplicateField-1 ;
 

String ExcelFilePath = request.getParameter("ExcelFilePath");
String DropTable = request.getParameter("DropTable");



File ExcelFileObj = new File(ExcelFilePath);
boolean  bAuto = ( request.getParameter("AutoInc") != null)? true : false ;
String   AutoColName = request.getParameter("AutoColName") ;
int nPriKey = 0;
try
{
	 nPriKey = Integer.parseInt(request.getParameter("PriKey"));
}
catch(NumberFormatException ex)
{
   nPriKey = 0;
	 
}

String[] ColumnName = request.getParameterValues("ColumnName") ;
String[] SQLType =  request.getParameterValues("SQLType") ;
String[] Precision = request.getParameterValues("Precision") ;
String[] Scale = request.getParameterValues("Scale") ;
boolean[] MandatoryCols = new boolean [nHeaderCount];

int nCol =0;
theColumnList.clear();
StringBuilder error= new StringBuilder() ;
StringBuilder crt_tbl = new StringBuilder();
StringBuilder InsStmt = new StringBuilder(" INSERT INTO `"+TableName+"` ( ") ;
StringBuilder InsVar  = new StringBuilder(" ) VALUES ( " );

if( bAuto )
{
  nCol++;
  TableColumn tc_auto = new TableColumn() ;
	tc_auto.ColNo = nCol ;
	tc_auto.Auto = true ;
	tc_auto.ColName = AutoColName ;
	theColumnList.add(tc_auto) ;
}
for(int i = 0 ; i < nHeaderCount ; i++ )
{
    nCol++;
		MandatoryCols[i] = ( request.getParameter("CHK"+i)!=null )? true:false;
		TableColumn tc = new TableColumn() ;
		tc.ColNo = nCol;
		tc.Auto =false;
    tc.ColName = ColumnName[i];
		try
		{
		 tc.Precision = Integer.parseInt( Precision[i] );
		}catch(NumberFormatException e)
		{
		  error.append("Index: "+i);
		  error.append(e.toString());
		}
		try
		{
		 tc.Scale = Integer.parseInt( Scale[i] );
		}catch(NumberFormatException e)
		{
		  error.append("Index: "+i);
		  error.append(e.toString());
		}
		
		try
		{
		 tc.ColSQLType = Integer.parseInt( SQLType[i] );
		}catch(NumberFormatException e)
		{
		  error.append("Index: "+i);
		  error.append(e.toString());
		}
		theColumnList.add(tc) ;
		InsStmt.append("`"+ColumnName[i]+"` ");
		InsVar.append(" ? ");
		if(i< ( nHeaderCount-1) ) 
		{ 
		   InsStmt.append(", ");
			 InsVar.append(", ");
	  }	
}

    InsStmt.append(InsVar.toString());
		InsStmt.append(" ) ;") ;
		
   

    crt_tbl.append( PreCreateForMySQL(TableName) )  ;
    int no=0;
    int tot=theColumnList.size();
    for(TableColumn c :theColumnList)
    { 
        no++;
	      crt_tbl.append(ColForMySQL(c, (short)tot, (short)no )) ;
    } 
    crt_tbl.append( PostCreateForMySQL(TableName) ) ;
		
 
    Context env = (Context) new InitialContext().lookup("java:comp/env");
    DataSource source = (DataSource) env.lookup(JNDIDSN);
    Connection conn = source.getConnection();
    com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);

     
		
		java.sql.Statement stmtCr = conn.createStatement();
		if("YES".equalsIgnoreCase(DropTable))
		{
		   stmtCr.executeUpdate(" DROP TABLE IF EXISTS `"+TableName+"` "); 
		   
		}
		stmtCr.executeUpdate(crt_tbl.toString());
		stmtCr.close();
		
		java.sql.PreparedStatement stmtIns = conn.prepareStatement(InsStmt.toString());
		java.sql.Statement stmtDup = conn.createStatement();
		
		
		      Workbook wb = WorkbookFactory.create( new FileInputStream(ExcelFilePath));
          Sheet sheet = wb.getSheetAt(0);
			    int nLastIndx = sheet.getLastRowNum();
			    int nImported = 0;
					int nInvalid = 0;
					int nDuplicate =0;
		
		
		
		String[]  chkdupval= new String[nHeaderCount] ;
		
		for(int n=1; n <= nLastIndx; n++)
    {
         Row cur_row   = sheet.getRow(n);  
				 if(cur_row ==null) continue ;
				 
				 boolean bValid = true ;
	
		     for(int ind=0; ind < nHeaderCount ; ind++)
	       { 
				     
							
				      String str = "" ;  
							chkdupval[ind] = "";
							
							Cell cell = cur_row.getCell(ind);
							if(cell !=null ) str=POIHelper.getStringFromCell( cell );
							
							if(MandatoryCols[ind] )
							{
							    if(str==null || str.length()==0)
									{
									   bValid = false ;
										 nInvalid++;
										 break;
									}
							}
							
							if(bValid)
							{
							              int nSqlType = Integer.parseInt( SQLType[ind]);
              							
              							switch(nSqlType )
              							{
              							     case java.sql.Types.BOOLEAN :
                                 case java.sql.Types.BIT :
                                 if("true".equalsIgnoreCase(str) || "yes".equalsIgnoreCase(str) || "1".equalsIgnoreCase(str) )
              									 {
              									    stmtIns.setBoolean(ind+1, true);   
																		chkdupval[ind]=str;
              									 }
              									 else if ( "false".equalsIgnoreCase(str) || "no".equalsIgnoreCase(str) || "0".equalsIgnoreCase(str) )
              									 {
              									    stmtIns.setBoolean(ind+1, false);  
																		chkdupval[ind]=str; 
              									 } 
              									 else
              									 {
              									     stmtIns.setNull(ind+1, java.sql.Types.BOOLEAN) ;
              									 }
                                 break;
                                  //------------
              	                 case java.sql.Types.TINYINT :
              									 try
              									 {
																    
              									    stmtIns.setByte(ind+1, Byte.parseByte(str));
																		chkdupval[ind]=str;
              									  
              									 }catch(NumberFormatException e)
              									 {
              									    stmtIns.setNull(ind+1, java.sql.Types.TINYINT) ;
              									 }
              									 break;
              									 //------------
                                 case java.sql.Types.SMALLINT :
              									 try
              									 {
              									     stmtIns.setShort(ind+1, Short.parseShort(str));
																		 chkdupval[ind]=str;
              									 }catch(NumberFormatException e)
              									 {
              									     stmtIns.setNull(ind+1, java.sql.Types.SMALLINT) ;
              									 }
              									 break; 
              									  //------------
              									 
              									 
                             	   case java.sql.Types.INTEGER :
              									 try
              									 {
              									     stmtIns.setInt(ind+1, Integer.parseInt(str) );
																		 chkdupval[ind]=str;
              											 
              									 }catch(NumberFormatException e)
              									 {
              									     stmtIns.setNull(ind+1, java.sql.Types.INTEGER) ;
																		 
              									 }
              									 break;
              									  //------------
                                 case java.sql.Types.BIGINT :
              									 try
              									 {
              									     stmtIns.setLong(ind+1, Long.parseLong(str));
																		 chkdupval[ind]=str;
																		 
              									 }catch(NumberFormatException e)
              									 {
              									     stmtIns.setNull(ind+1, java.sql.Types.BIGINT) ;
              									 }
                                 
              									  break;
              									  //------------
              									
              									 
              									 case java.sql.Types.REAL :		
                                 case java.sql.Types.DOUBLE :
              	                 case java.sql.Types.NUMERIC :		
                                 case java.sql.Types.DECIMAL :
              									 try
              									 {
																     BigDecimal bd = new BigDecimal(str);
              									     stmtIns. setBigDecimal(ind+1,bd  );
																		 chkdupval[ind] = bd.toString();
																		 
              									 }catch(NumberFormatException e)
              									 {
              									     stmtIns.setNull(ind+1, java.sql.Types.DECIMAL) ;
              									 }
              
              									 break;
              									 
              									  //------------
              									 
              									 case java.sql.Types.DATE:
              									 
              									 java.sql.Date dt = null ;
              									 if(cell !=null) dt = POIHelper.getDateFromCell(cell );
              									 if(dt!=null)
																 { 
																    stmtIns.setDate(ind+1, dt ) ;
																	  chkdupval[ind]=dt.toString();	
																 }
              									 else 
																 {
																   stmtIns.setNull(ind+1, java.sql.Types.DATE) ;
              									 }
              									 break;
              									  //------------
              
              									 case java.sql.Types.TIME :
              									  try
              										{
              									     java.util.Date dt1 = null;
              											  if(cell !=null) dt1 = cell.getDateCellValue();
                                      if(dt1!=null )
																			{
																			   stmtIns.setTime(ind+1, new java.sql.Time(dt1.getTime()) ) ;
                                         chkdupval[ind] = dt1.toString();	
																			}
              											  else 
																		  {
																			   stmtIns.setNull(ind+1, java.sql.Types.TIME) ;
																			}
																			
              										}catch(Exception e){ stmtIns.setNull(ind+1, java.sql.Types.TIME) ;    }
              									 break ;
                           
                                  //------------
                                 case java.sql.Types.TIMESTAMP :
              									  try
              										{
              									     java.util.Date dt2 = null;
              											 if(cell !=null) dt2 =  cell.getDateCellValue();
              											 if(dt2 !=null)
																		 {
																		    stmtIns.setTimestamp(ind+1, new java.sql.Timestamp(dt2.getTime()) ) ;
																				chkdupval[ind] =dt2.toString();	
																		 }
              											 else  
																		 {
																		    stmtIns.setNull(ind+1, java.sql.Types.TIMESTAMP) ;
																		 }
              										}catch(Exception e){ stmtIns.setNull(ind+1, java.sql.Types.TIMESTAMP) ;    }
              									 break ;
                           
                                  //------------
              									 
              									 default:
              									    stmtIns.setString(ind+1, str) ; 
																		chkdupval[ind]=str;
              									 break;
              							} // end switch(nSQLType)
							    } 
				 } // End - Inner for loop 		
				 
				  // Create record from query
					
				  if(bValid)
					{
					    int nExisting = 0;
					    
						   
						 
						  if(nDuplicateField > 0)
							{ 
						      String DupQuery = " SELECT COUNT(*) FROM `"+TableName+"` WHERE `"+ColumnName[ nDuplicateIndex ]+"`='"+chkdupval[ nDuplicateIndex ]+"' " ;
            
					        ResultSet rsltDup = stmtDup.executeQuery(DupQuery);
									if(rsltDup!=null && rsltDup.next()) nExisting = rsltDup.getInt(1);
							}
					    if ( nExisting == 0)
							{
							    stmtIns.executeUpdate();
									nImported++;
							}
							else
							{
							   nDuplicate++;
							}
					    
					}	
				  else
					{
					     stmtIns.clearParameters();
					}
				 
				 
		}	 // End - outer for loop
		
		stmtIns.close();
		stmtDup.close();
    conn.close();
		ExcelFileObj.delete();

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Create Table</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Create Table & Insert Data</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="selectfile-create.jsp">Select File</strong></a></li>
      <li class="active">Create Table</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />

<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Table : </span><span class="text-muted"><%=TableName %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>

</div>		

<div class="well well-sm"><b><%=nImported %></b> records inserted</div>
<% 
if(nInvalid > 0)
{ 
%>
<div class="well well-sm"><b><%=nInvalid %></b> spreadsheet rows where either blank or had invalid data.</div>
<% 
} 
%>
<% 
if(nDuplicate > 0)
{ 
%>
<div class="well well-sm"><b><%=nDuplicate %></b> spreadsheet rows had duplicate values for field: <%=ColumnName[ nDuplicateIndex ] %>. ( records not inserted )</div>
<% 
} 
%>
<% 
if(error.toString().length() > 0)
{ 
%>
<div class="well well-sm"><b>Error</b> : <br /><%=error.toString() %></div>
<% 
} 
%>

</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

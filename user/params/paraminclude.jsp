<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");
String Database = null ;
           
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
Database = conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}


com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
String query = BeanwizHelper.openTableSQL(conn, TableName);
StringBuffer dump = new StringBuffer();	

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	



for(int n = 1 ; n <= count ; n++ )
{	
	 int nJdbcType = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
	 String ColTypeName = rsmd.getColumnTypeName(n);
	 String ColVarName = com.beanwiz.ColumnName.colVarName(ColName);
	 boolean bOverride=false ;
	 
	 int ColSize = rsmd.getColumnDisplaySize(n) ;
	 int Precision = rsmd.getPrecision(n);
	 int Scale = rsmd.getScale(n);

	 	 // Check for column type overrride 
	 String col_key = Database+"."+TableName+"."+ColName ;
	 
	 if( OverrideMap !=null && OverrideMap.containsKey(col_key) )
	 {
	    bOverride=true;
			try
			{
			    nJdbcType = Integer.parseInt( (String)OverrideMap.get(col_key) );
			}catch(NumberFormatException ex)
			{
			  // revert back to original type
			   nJdbcType = rsmd.getColumnType(n);
			}
			ColTypeName = ColTypeOverride.typeLabel(nJdbcType) ;
	 }  // end if
	 
	 if( bOverride )
	 {
	  dump.append( "\r\n// Warning: The  column '"+ColName+"' no. [ " + n + " ] is manually overriden, it is  not wizard detected.\r\n" ) ;
   }

	 
	 
	 
	  if( rsmd.isAutoIncrement(n))   dump.append("/* Auto increment column: \r\n");//continue ;
         switch(nJdbcType)
	       {
	          case java.sql.Types.BINARY:
		        //		VarType =  "byte[]" ;
			        dump.append("// $CODE Binary Data 	//");
				      dump.append("     if(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				      dump.append("     FileInputStream "+ColVarName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			      dump.append("     if("+ColVarName+"_Stream.available()>0)\r\n     {\r\n ");
				      dump.append("     "+BeanName+"."+ColVarName+" = new byte["+ColVarName+"_Stream.available()] ;\r\n ");
	 			      dump.append("     "+ColVarName+"_Stream.read( "+BeanName+"."+ColVarName+", 0, "+ColVarName+"_Stream.available()); \r\n     }\r\n     }\r\n ");
					 
					  break ;
			 
            case java.sql.Types.BIGINT:
	          //		VarType =  "long" ;
	            dump.append("     try\r\n ");
							dump.append("     { \r\n ");
	            dump.append("          "+BeanName+"."+ColVarName+" = Long.parseLong(request.getParameter(\""+ColName+"\")) ;\r\n ");
	            dump.append("     }catch( NumberFormatException ex)\r\n    { \r\n\t"+BeanName+"."+ColVarName+" = 0 ;\r\n    }\r\n");
			      break ;
                          
	          case java.sql.Types.BIT:
	          // 	VarType =  "boolean" ;
	            dump.append("      try \r\n ");
							dump.append("      { \r\n ");
	            dump.append("           "+BeanName+"."+ColVarName+" = ( Byte.parseByte(request.getParameter(\""+ColName+"\")))>0? true:false ;\r\n ");
	            dump.append("      } catch( NumberFormatException ex)\r\n     { \r\n          "+BeanName+"."+ColVarName+" = false ;\r\n     }\r\n");
  	        break ;
						              
	          case java.sql.Types.BLOB:
	          //			VarType =  "byte[]" ;
	  	        dump.append("      if(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
		          dump.append("      FileInputStream "+ColVarName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 	          dump.append("      if("+ColVarName+"_Stream.available()>0)\r\n    {\r\n ");
	 	          dump.append("      "+BeanName+"."+ColVarName+" = new byte["+ColVarName+"_Stream.available()] ;\r\n ");
	 	          dump.append("      "+ColVarName+"_Stream.read( "+BeanName+"."+ColVarName+", 0, "+ColVarName+"_Stream.available()); \r\n    }\r\n    }\r\n ");

						break ;
                          
 	          case java.sql.Types.CHAR:
	          //		VarType =  "String" ;
		          dump.append("      "+BeanName+"."+ColVarName+" = request.getParameter(\""+ColName+"\");\r\n");
            break;
						
	          case java.sql.Types.CLOB:
			      //		VarType =  "String" ;
		          dump.append("      "+BeanName+"."+ColVarName+" = request.getParameter(\""+ColName+"\");\r\n");
            break ;
                  
	          case java.sql.Types.DATE:
	 	        //		VarType =  "java.sql.Date" ;
              dump.append("     "+BeanName+"."+ColVarName+" = DateTimeHelper.requestDatePicker( request, \""+ColName+"\" );\r\n");
            break ;
	                
	          case java.sql.Types.DECIMAL:
	 	        //	VarType =  "java.math.BigDecimal" ;
		          dump.append("      try\r\n      {\r\n     "+BeanName+"."+ColVarName+"  =  new BigDecimal( request.getParameter(\""+ColName+"\"));\r\n     }\r\n");
		          dump.append("      catch( NumberFormatException ex )\r\n     {\r\n     ");
		          dump.append("      "+BeanName+"."+ColVarName+"  =  new BigDecimal((double)0) ; \r\n");
		          dump.append("      }\r\n");	
		        break ;
						
	          case java.sql.Types.DOUBLE:
 			      // VarType =  "double" ;
	 		        dump.append("     try\r\n ");
							dump.append("     { \r\n ");
	 		        dump.append("          "+BeanName+"."+ColVarName+" = Double.parseDouble(request.getParameter(\""+ColName+"\")) ;\r\n ");
	 		        dump.append("     } catch( NumberFormatException ex)\r\n     {\r\n          "+BeanName+"."+ColVarName+" = 0 ;\r\n     }\r\n");
		        break ;
                   
	          case java.sql.Types.FLOAT:
	 		      //	VarType =  "float" ;
	 		        dump.append("     try \r\n ");
			        dump.append("     { \r\n ");
	 		        dump.append("          "+BeanName+"."+ColVarName+" = Float.parseFloat(request.getParameter(\""+ColName+"\")) ;\r\n ");
	 		        dump.append("     }catch( NumberFormatException ex)\r\n     { \r\n          "+BeanName+"."+ColVarName+" = 0 ;\r\n     }\r\n");
	          break ;
	
	          case java.sql.Types.INTEGER:
	 		      //	VarType =  "int" ;
	            dump.append("     try  \r\n ");
	            dump.append("     {\r\n ");							
	            dump.append("          "+BeanName+"."+ColVarName+" = Integer.parseInt(request.getParameter(\""+ColName+"\")) ;\r\n ");
	            dump.append("     } catch( NumberFormatException ex)\r\n     { \r\n         "+BeanName+"."+ColVarName+" = 0 ;\r\n     }\r\n");
            break ;
						
	          case java.sql.Types.JAVA_OBJECT:
	   	      //	VarType =  "Object" ;
            break ;
	          
						case java.sql.Types.LONGVARBINARY:
            //	VarType =  "byte[]" ;
				      dump.append("    if(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n     {\r\n ");
				      dump.append("    FileInputStream "+ColVarName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			      dump.append("    if("+ColVarName+"_Stream.available()>0)\r\n     {\r\n ");
	 			      dump.append("     "+BeanName+"."+ColVarName+" = new byte["+ColVarName+"_Stream.available()] ;\r\n ");
	 			      dump.append("     "+ColVarName+"_Stream.read( "+BeanName+"."+ColVarName+", 0, "+ColVarName+"_Stream.available());\r\n     }\r\n     }\r\n ");
							 
						break ;
                        
        	  case java.sql.Types.LONGVARCHAR:
						case java.sql.Types.LONGNVARCHAR:
	 	 	      // 	VarType =  "String" ;
  			      dump.append("     "+BeanName+"."+ColVarName+" = request.getParameter(\""+ColName+"\");\r\n");
              /* You may need this if you want text files coming as file upload !
				      dump.append("    if(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n    {\r\n ");
				      dump.append("    FileInputStream "+ColVarName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			      dump.append("    "+BeanName+"."+ColVarName+" = new byte["+ColVarName+"_Stream .available()] ;\r\n");
	 			      dump.append("    "+ColVarName+"_Stream.read( "+BeanName+"."+ColVarName+", 0, "+ColVarName+"_Stream.available());\r\n     }\r\n");
 		          */
		        break ;			
						case java.sql.Types.NCHAR:
						case java.sql.Types.NVARCHAR:
						case java.sql.Types.NCLOB :
	          //		VarType =  "String" ;
			         dump.append("     "+BeanName+"."+ColVarName+" = request.getParameter(\""+ColName+"\");\r\n");
									 
									 
						
	                 
	          case java.sql.Types.NULL :
            //			VarType =  "Object" ;
            break ;
	 
	          case java.sql.Types.NUMERIC:
	          //			VarType =  "int" or "BigDecimal" ;
						// Oracle is funny ! converts all INTEGER to NUMBER 
			      // Do wild guesswork to find data types int / bigdecimal 
			      // 0 scale numeric values are integers in oracle
	            if(Scale == 0  && psql.getEngine()== PortableSQL.ORACLE )
			        {  
	               dump.append("     try\r\n ");
								 dump.append("     {\r\n ");
	               dump.append("         "+BeanName+"."+ColVarName+" = Integer.parseInt(request.getParameter(\""+ColName+"\")) ;\r\n ");
	               dump.append("     } catch( NumberFormatException ex)\r\n     { \r\n\t"+BeanName+"."+ColVarName+" = 0 ;\r\n     }\r\n");
			        }
			        else
			        {
 		             dump.append("     try\r\n     {\r\n\t"+BeanName+"."+ColVarName+"  =  new BigDecimal( request.getParameter(\""+ColName+"\"));\r\n     }\r\n");
		             dump.append("     catch( NumberFormatException ex )\r\n     {\r\n");
		             dump.append("     "+BeanName+"."+ColVarName+"  =  new BigDecimal((double)0) ; ");
		             dump.append("     }\r\n");	
              }
			      break ;
	
	          case java.sql.Types.OTHER:
	 		      //	VarType =  "String" ;
	          break ;
					
	          case java.sql.Types.REF:
	 		      //	VarType =  "Object";
			      break ;
			
	          case java.sql.Types.SMALLINT:
	  	      //	VarType =  "short" ;
	            dump.append("    try \r\n ");
	            dump.append("    { \r\n ");
	            dump.append("         "+BeanName+"."+ColVarName+" = Short.parseShort(request.getParameter(\""+ColName+"\")) ;\r\n");
	            dump.append("    } catch( NumberFormatException ex)\r\n     {     \r\n         "+BeanName+"."+ColVarName+" = 0 ;\r\n    }\r\n");
            break ;
	                  
						case java.sql.Types.STRUCT:
	 		      //	VarType =  "Object" ;
			      break ;
						      
	          case java.sql.Types.TIME:
	   	      //			VarType =  "java.sql.Time" ;
		          dump.append("    "+BeanName+"."+ColVarName+" = DateTimeHelper.requestTimePicker( request, \""+ColName+"\" );\r\n");
			      break ;
	                 
	          case java.sql.Types.TIMESTAMP:
	 		      //				VarType =  "java.sql.Timestamp" ;
		          dump.append("     "+BeanName+"."+ColVarName+" = new java.sql.Timestamp(System.currentTimeMillis()); // DateTimeHelper.requestDateTimePicker( request, \""+ColName+"\" ) ; \r\n ") ;
            break ;		
                     
	          case java.sql.Types.TINYINT:
	          //		VarType =  "byte" ;
       	      dump.append("     try  \r\n ");
							dump.append("     { \r\n ");
	            dump.append("          "+BeanName+"."+ColVarName+" = Byte.parseByte(request.getParameter(\""+ColName+"\")) ;\r\n ");
	            dump.append("     } catch( NumberFormatException ex)\r\n     { \r\n\t"+BeanName+"."+ColVarName+" = 0 ;\r\n     }\r\n");
            break ;
	             
						case java.sql.Types.VARBINARY:
	          //			VarType =  "byte[]" ;
				      dump.append("    if(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				      dump.append("    FileInputStream "+ColVarName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			      dump.append("    if("+ColVarName+"_Stream.available()>0)\r\n {\r\n ");
	 			      dump.append("    "+BeanName+"."+ColVarName+" = new byte["+ColVarName+"_Stream.available()] ;\r\n ");
	 			      dump.append("    "+ColVarName+"_Stream.read( "+BeanName+"."+ColVarName+", 0, "+ColVarName+"_Stream.available()); \r\n }\r\n}\r\n ");
			      
						 
						
						break ;
	                   
	          case java.sql.Types.VARCHAR:
	 	        //				VarType =  "String" ;
	 	          dump.append("     "+BeanName+"."+ColVarName+" = request.getParameter(\""+ColName+"\");\r\n");
		          break ;
		 
	       }		// END switch 
		 if( rsmd.isAutoIncrement(n))   dump.append("*/\r\n");
	    
	}// end for(int n = 1 ; n <= count ; n++ ) 
  rslt.close(); 
  stmt.close();
}
finally
{
 	 conn.close();
}

out.print(dump.toString());	 

%>
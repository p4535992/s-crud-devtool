<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.webapp.utils.*" %><%@ page contentType="text/plain" %>
<%
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
String query = psql.SQL(" SELECT * FROM `"+TableName+"` LIMIT 10 " ) ;

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	
StringBuffer dump = new StringBuffer();	
for(int n = 1 ; n <= count ; n++ )
{	
	 int sqltype = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
	 String ColTypeName = rsmd.getColumnTypeName(n);
	 int ColSize = rsmd.getColumnDisplaySize(n) ;
 	 int Precision = rsmd.getPrecision(n);
	 int Scale = rsmd.getScale(n);

	 dump.append("\r\n//---- Col :"+n+" - Type: "+ColTypeName);
	 switch(sqltype)
	 {
	 case java.sql.Types.BINARY:
		 //		VarType =  "byte[]" ;
			dump.append("// $CODE Binary Data 	//");
				 dump.append("\r\nif(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				 dump.append("FileInputStream "+ColName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			 dump.append("if("+ColName+"_Stream.available()>0)\r\n {\r\n ");
				 dump.append("$BEAN."+ColName+" = new byte["+ColName+"_Stream .available()] ;\r\n ");
	 			 dump.append( ColName+"_Stream.read( $BEAN."+ColName+", 0, "+ColName+"_Stream.available()); \r\n }\r\n}\r\n");
			
			break ;
			 
   case java.sql.Types.BIGINT:
	   //		VarType =  "long" ;
	     dump.append("\r\ntry{ \r\n ");
	     dump.append("\t$BEAN."+ColName+" = Long.parseLong(request.getParameter(\""+ColName+"\")) ;\r\n ");
	     dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");
			break ;


	 case java.sql.Types.BIT:
	   // 	VarType =  "boolean" ;
	      dump.append("\r\ntry{ \r\n ");
	      dump.append("\t$BEAN."+ColName+" = ( Byte.parseByte(request.getParameter(\""+ColName+"\")))>0? true:false ;\r\n ");
	      dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = false ;\r\n }\r\n");
	 		 
	 case java.sql.Types.BLOB:
      //	VarType =  "byte[]" ;
				 dump.append("\r\nif(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				 dump.append("FileInputStream "+ColName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			 dump.append("if("+ColName+"_Stream.available()>0)\r\n {\r\n ");
				 dump.append("$BEAN."+ColName+" = new byte["+ColName+"_Stream .available()] ;\r\n ");
	 			 dump.append( ColName+"_Stream.read( $BEAN."+ColName+", 0, "+ColName+"_Stream.available()); \r\n }\r\n}\r\n");
			break ;
		 
		
	 case java.sql.Types.CHAR:
	   //		VarType =  "String" ;
		 dump.append("\r\n$BEAN."+ColName+" = request.getParameter(\""+ColName+"\");\r\n");

			break;
	 case java.sql.Types.CLOB:
	     //		VarType =  "String" ;
			 dump.append("\r\n$BEAN."+ColName+" = request.getParameter(\""+ColName+"\");\r\n");

			break ;

	 case java.sql.Types.DATE:
	 	 //			VarType =  "java.sql.Date" ;
     dump.append(BeanName+"."+ColName+" = com.webapp.utils.DateHelper.requestDate( request, \""+ColName+"\" );\r\n");

			break ;
	 case java.sql.Types.DECIMAL:
	 	 //	VarType =  "java.math.BigDecimal" ;
		 dump.append("\r\ntry{\r\n\t$BEAN."+ColName+"  =  new BigDecimal( request.getParameter(\""+ColName+"\"));\r\n}\r\n");
		 dump.append("catch( NumberFormatException ex )\r\n{\r\n\t");
		 dump.append("$BEAN."+ColName+"  =  new BigDecimal((double)0) ; ");
		 dump.append("\r\n}\r\n");	
	 
		 
		  break ;
	 case java.sql.Types.DOUBLE:
 			// VarType =  "double" ;
	 		dump.append("\r\ntry{ \r\n ");
	 		dump.append("\t$BEAN."+ColName+" = Double.parseDouble(request.getParameter(\""+ColName+"\")) ;\r\n ");
	 		dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");
		 
		 
		 
		 break ;
	 case java.sql.Types.FLOAT:
	 		//	VarType =  "float" ;
	 		dump.append("\r\ntry{ \r\n ");
	 		dump.append("\t$BEAN."+ColName+" = Float.parseFloat(request.getParameter(\""+ColName+"\")) ;\r\n ");
	 		dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");
			
			
			
	    break ;
	 case java.sql.Types.INTEGER:
	 		//	VarType =  "int" ;
      dump.append("\r\ntry{ \r\n ");
	    dump.append("\t$BEAN."+ColName+" = Integer.parseInt(request.getParameter(\""+ColName+"\")) ;\r\n ");
	    dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");
			
      break ;
	 case java.sql.Types.JAVA_OBJECT:
	   	//	VarType =  "Object" ;
      break ;
	 case java.sql.Types.LONGVARBINARY:
      //	VarType =  "byte[]" ;
				 dump.append("\r\nif(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				 dump.append("FileInputStream "+ColName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			 dump.append("if("+ColName+"_Stream.available()>0)\r\n {\r\n ");
				 dump.append("$BEAN."+ColName+" = new byte["+ColName+"_Stream .available()] ;\r\n ");
	 			 dump.append( ColName+"_Stream.read( $BEAN."+ColName+", 0, "+ColName+"_Stream.available()); \r\n }\r\n}\r\n");
			break ;
			
			
			
	 case java.sql.Types.LONGVARCHAR:
	 	 	  // 	VarType =  "String" ;
	  		 dump.append("\r\n$BEAN."+ColName+" = request.getParameter(\""+ColName+"\");\r\n");
        /*  Your may need this if text files comming as file upload
				
				 dump.append("\r\nif(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				 dump.append("FileInputStream "+ColName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			 dump.append("$BEAN."+ColName+" = new byte["+ColName+"_Stream .available()] ;\r\n");
	 			 dump.append( ColName+"_Stream.read( $BEAN."+ColName+", 0, "+ColName+"_Stream.available()); \r\n}\r\n");
 		    */
		
		
			break ;			
	 case java.sql.Types.NULL :
      //			VarType =  "Object" ;

		  break ;
	 case java.sql.Types.NUMERIC:
      // Oracle is funny ! converts all INTEGER to NUMBER 
			// Do wild guesswork to find data types int / bigdecimal 
			// 0 scale numeric values are integers in oracle
	    if(Scale == 0  && psql.getEngine()== PortableSQL.ORACLE )
			{  
	         dump.append("\r\ntry{ \r\n ");
	         dump.append("\t"+BeanName+"."+ColName+" = Integer.parseInt(request.getParameter(\""+ColName+"\")) ;\r\n ");
	         dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t"+BeanName+"."+ColName+" = 0 ;\r\n }\r\n");
			}
			else
			{
 		    dump.append("\r\ntry{\r\n\t"+BeanName+"."+ColName+"  =  new BigDecimal( request.getParameter(\""+ColName+"\"));\r\n}\r\n");
		    dump.append("catch( NumberFormatException ex )\r\n{\r\n\t");
		    dump.append(BeanName+"."+ColName+"  =  new BigDecimal((double)0) ; ");
		    dump.append("}\r\n");	
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
	     dump.append("\r\ntry{ \r\n ");
	     dump.append("\t$BEAN."+ColName+" = Short.parseShort(request.getParameter(\""+ColName+"\")) ;\r\n ");
	     dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");

      break ;
	 case java.sql.Types.STRUCT:
	 		//	VarType =  "Object" ;
			break ;
	 case java.sql.Types.TIME:
	   	//			VarType =  "java.sql.Time" ;
		  dump.append(BeanName+"."+ColName+" = com.webapp.utils.DateHelper.requestTime( request, \""+ColName+"\" );\r\n");
			
			break ;
	 case java.sql.Types.TIMESTAMP:
	 		//				VarType =  "java.sql.Timestamp" ;
 	     dump.append(BeanName+"."+ColName+" = com.webapp.utils.DateHelper.requestDateTime( request, \""+ColName+"\" );\r\n ") ;
			
			break ;		
	 case java.sql.Types.TINYINT:
	    //		VarType =  "byte" ;
	     dump.append("\r\ntry{ \r\n ");
	     dump.append("\t$BEAN."+ColName+" = Byte.parseByte(request.getParameter(\""+ColName+"\")) ;\r\n ");
	     dump.append("} catch( NumberFormatException ex)\r\n { \r\n\t$BEAN."+ColName+" = 0 ;\r\n }\r\n");
	
		 
		 break ;
	 case java.sql.Types.VARBINARY:
	    //			VarType =  "byte[]" ;
				dump.append("\r\nif(request.getParameter(\""+ColName+"\")!= null && request.getParameter(\""+ColName+"\").length()> 0) \r\n{\r\n ");
				dump.append("FileInputStream "+ColName+"_Stream = new FileInputStream(request.getParameter(\""+ColName+"\"));\r\n ");
	 			dump.append("if("+ColName+"_Stream.available()>0)\r\n {\r\n ");
				dump.append("$BEAN."+ColName+" = new byte["+ColName+"_Stream .available()] ;\r\n ");
	 			dump.append( ColName+"_Stream.read( $BEAN."+ColName+", 0, "+ColName+"_Stream.available()); \r\n }\r\n}\r\n");
		 break ;
	 case java.sql.Types.VARCHAR:
	 	 //				VarType =  "String" ;
	 	 dump.append("\r\n$BEAN."+ColName+" = request.getParameter(\""+ColName+"\");\r\n");
		
	 } 
	 
	}// end for(int n = 1 ; n <= count ; n++ ) 

	 
out.print(dump.toString());	 
	

  stmt.close();
	
}
finally
{
 	 conn.close();
}

%>


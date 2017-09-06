<% 
switch(col.ColSQLType)
	{
	    case  java.sql.Types.ARRAY:
	        col.GetMethod = "getArray(\""+col.ColName+"\")" ;
	        col.SetMethod = "getArray( "+n+" , "+col.VarName+" ) ";
	        col.VarType =  "java.sql.Array" ;
					col.NullInit = " = null ;" ;
	    break ;
	 
      case java.sql.Types.BIGINT:
	  	    col.GetMethod = "getLong(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setLong( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "long" ;
					col.NullInit = " = (long)0 ;" ;
	    break ;

	    case java.sql.Types.BINARY:
	        col.GetMethod = "getBytes(\""+col.ColName+"\")";
	        col.SetMethod = "setBytes( "+n+" , "+col.VarName+" ) ";
          col.VarType =  "byte[]" ;
					col.NullInit = " = null ;" ;
      break ; 
 
      case java.sql.Types.BIT:
	        col.GetMethod = "getBoolean(\""+col.ColName+"\")";
	        col.SetMethod = "setBoolean( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "boolean" ;
					col.NullInit = " = false ;" ; 
	    break ;
			
      case java.sql.Types.BLOB:
	  	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes(  "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
					col.NullInit = " = null ;" ;
      break ; 
		
      case java.sql.Types.BOOLEAN: 		
		      col.GetMethod = "getBoolean(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBoolean( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "boolean" ;
					col.NullInit = " = false ;" ; 
	    break ; 		
	
	    case java.sql.Types.CHAR:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
	    break;

      case java.sql.Types.CLOB:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
		  break ;

	    case java.sql.Types.DATALINK :
	        // Unsupported equivallent java type
	   	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
					col.NullInit = " = null ;" ;
 	    break ;
			
		  case java.sql.Types.DATE:
	 		    col.GetMethod = "getDate(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setDate( "+n+" , "+col.VarName+" ) " ;
			    col.VarType =  "java.sql.Date" ;
					col.NullInit = " = null ;" ;
		  break ;
	    
		  case java.sql.Types.DECIMAL:
	        col.GetMethod = "getBigDecimal(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setBigDecimal( "+n+" , "+col.VarName+" ) " ;
			    col.VarType =  "java.math.BigDecimal" ;
					col.NullInit = " = null ;" ;
	    break ;
	 
	    case java.sql.Types.DOUBLE:
	        col.GetMethod = "getDouble(\""+col.ColName+"\")";
	  	    col.SetMethod = "setDouble( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "double" ;
					col.NullInit = " = (double)0 ;" ;
		  break ;
	 
	    case java.sql.Types.FLOAT:
	   	    col.GetMethod = "getFloat(\""+col.ColName+"\")";
	  	    col.SetMethod = "setFloat( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "float" ;
					col.NullInit = " = (float)0 ;" ;
	    break ;

		  case java.sql.Types.INTEGER:
          col.GetMethod = "getInt(\""+col.ColName+"\")";
	  	    col.SetMethod = "setInt( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "int" ;
					col.NullInit = " = 0 ;" ;
      break ;

      case java.sql.Types.JAVA_OBJECT:
	   	    col.GetMethod = "getObject(\""+col.ColName+"\")";
	  	    col.SetMethod = "setObject( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "Object" ;
					col.NullInit = " = null ;" ;
      break ;
	    
		  case java.sql.Types.LONGVARBINARY:
	   	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
					col.NullInit = " = null ;" ;
		  break ;
		
	    case java.sql.Types.LONGVARCHAR:
			case java.sql.Types.LONGNVARCHAR:

		      col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
 		  break ;	

	    case java.sql.Types.NCHAR :
		      col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
		  break ;
		
	    case java.sql.Types.NCLOB :
		      col.GetMethod = "getNull(\""+col.ColName+"\")";
	  	    col.SetMethod = "setNull( "+n+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
		  break ;
               		
	    case java.sql.Types.NULL :
		      col.GetMethod = "getNull(\""+col.ColName+"\")";
	  	    col.SetMethod = "setNull( "+n+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "Object" ;
					col.NullInit = " = null ;" ;
					 
		  break ;

    	case java.sql.Types.NUMERIC:
	  	    col.GetMethod = "getBigDecimal(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBigDecimal( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "java.math.BigDecimal" ;
					col.NullInit = " = null ;" ;
      break ;
	 
      case java.sql.Types.NVARCHAR :
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
      break ;		
	 
	    case java.sql.Types.OTHER:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
	    break ;
					                   
	    case java.sql.Types.REAL:
	   	    col.GetMethod = "getDouble(\""+col.ColName+"\")";
	  	    col.SetMethod = "setDouble( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "double";
					col.NullInit = " = (double)0 ;" ;
		  break ;
		                             
	    case java.sql.Types.REF:
	   	   col.GetMethod = "getString(\""+col.ColName+"\")";
	  	   col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		     col.VarType =  "String";
				 col.NullInit = " = \"\" ;" ;
				 
		  break ;
		                                            
	    case java.sql.Types.ROWID:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "String";
					col.NullInit = " = \"\" ;" ;
					
		  break ;
		                      
	    case java.sql.Types.SMALLINT:
	   	    col.GetMethod = "getShort(\""+col.ColName+"\")";
	  	    col.SetMethod = "setShort( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "short" ;
					col.NullInit = " = (short)0 ;" ;
      break ;
	                                    
		  case java.sql.Types.STRUCT:
	   	    col.GetMethod = "getObject(\""+col.ColName+"\")";
	  	    col.SetMethod = "setObject( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "Object" ;
					col.NullInit = " = null ;" ;
		  break ;
		                  
		  case java.sql.Types.SQLXML:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
		      col.VarType =  "String";
					col.NullInit = " = \"\" ;" ;
					
		  break ;
			                   
	    case java.sql.Types.TIME:
           col.GetMethod = "getTime(\""+col.ColName+"\")";
	  	     col.SetMethod = "setTime( "+n+" , "+col.VarName+" ) ";
			     col.VarType =  "java.sql.Time" ;
					 col.NullInit = " = null ;" ;
					 
		  break ;
		
		
      case java.sql.Types.TIMESTAMP :
	   	    col.GetMethod = "getTimestamp(\""+col.ColName+"\")";
	  	    col.SetMethod = "setTimestamp( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "java.sql.Timestamp" ;
					col.NullInit = " = null ;" ;
		  break ;		
		
	    case java.sql.Types.TINYINT:
	   	    col.GetMethod = "getByte(\""+col.ColName+"\")";
	  	    col.SetMethod = "setByte( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "byte" ;
					col.NullInit = " = (byte)0 ;" ;
      break ;
	 
	    case java.sql.Types.VARBINARY:
	        col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "byte[]" ;
					col.NullInit = " = null ;" ;
	    break ;
	                  
	    case java.sql.Types.VARCHAR:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+n+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
					col.NullInit = " = \"\" ;" ;
	 } 
%>
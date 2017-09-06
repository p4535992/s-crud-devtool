// check column data type

switch(col.ColSQLType)
	{
	    case  java.sql.Types.ARRAY:
	        col.GetMethod = "getArray(\""+col.ColName+"\")" ;
	        col.SetMethod = "getArray( "+(n-nAuto)+" , "+col.VarName+" ) ";
	        col.VarType =  "java.sql.Array" ;
	    break ;
	 
      case java.sql.Types.BIGINT:
	  	    col.GetMethod = "getLong(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setLong( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "long" ;
	    break ;

	    case java.sql.Types.BINARY:
	        col.GetMethod = "getBytes(\""+col.ColName+"\")";
	        col.SetMethod = "setBytes( "+(n-nAuto)+" , "+col.VarName+" ) ";
          col.VarType =  "byte[]" ;
      break ; 
 
      case java.sql.Types.BIT:
	        col.GetMethod = "getBoolean(\""+col.ColName+"\")";
	        col.SetMethod = "setBoolean( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "boolean" ;
	    break ;
			
      case java.sql.Types.BLOB:
	  	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes(  "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
      break ; 
		
      case java.sql.Types.BOOLEAN: 		
		      col.GetMethod = "getBoolean(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBoolean( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "boolean" ;
	    break ; 		
	
	    case java.sql.Types.CHAR:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
		    col.VarType =  "String" ;
	    break;

      case java.sql.Types.CLOB:
	   	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
		  break ;

	    case java.sql.Types.DATALINK :
	        // Unsupported equivallent java type
	   	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
 	    break ;
			
		  case java.sql.Types.DATE:
	 		    col.GetMethod = "getDate(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setDate( "+(n-nAuto)+" , "+col.VarName+" ) " ;
			    col.VarType =  "java.sql.Date" ;
		  break ;
	    
		  case java.sql.Types.DECIMAL:
	        col.GetMethod = "getBigDecimal(\""+col.ColName+"\")" ;
	  	    col.SetMethod = "setBigDecimal( "+(n-nAuto)+" , "+col.VarName+" ) " ;
			    col.VarType =  "java.math.BigDecimal" ;
	    break ;
	 
	    case java.sql.Types.DOUBLE:
	        col.GetMethod = "getDouble(\""+col.ColName+"\")";
	  	    col.SetMethod = "setDouble( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "double" ;
		  break ;
	 
	    case java.sql.Types.FLOAT:
	   	    col.GetMethod = "getFloat(\""+col.ColName+"\")";
	  	    col.SetMethod = "setFloat( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "float" ;
	    break ;

		  case java.sql.Types.INTEGER:
          col.GetMethod = "getInt(\""+col.ColName+"\")";
	  	    col.SetMethod = "setInt( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "int" ;
      break ;

      case java.sql.Types.JAVA_OBJECT:
	   	    col.GetMethod = "getObject(\""+col.ColName+"\")";
	  	    col.SetMethod = "setObject( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "Object" ;
      break ;
	    
		  case java.sql.Types.LONGVARBINARY:
	   	    col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "byte[]" ;
		  break ;
		
	    case java.sql.Types.LONGVARCHAR:
		      col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "String" ;
 		  break ;	

	    case java.sql.Types.NCHAR :
		      col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "String" ;
		  break ;
		
	    case java.sql.Types.NCLOB :
		      col.GetMethod = "getNull(\""+col.ColName+"\")";
	  	    col.SetMethod = "setNull( "+(n-nAuto)+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "String" ;
		  break ;
               		
	    case java.sql.Types.NULL :
		      col.GetMethod = "getNull(\""+col.ColName+"\")";
	  	    col.SetMethod = "setNull( "+(n-nAuto)+" , "+col.ColSQLType+" ) ";
		      col.VarType =  "Object" ;
		  break ;

    	case java.sql.Types.NUMERIC:
	  	    col.GetMethod = "getBigDecimal(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBigDecimal( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "java.math.BigDecimal" ;
      break ;
	 
      case java.sql.Types.NVARCHAR :
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
      break ;		
	 
	    case java.sql.Types.OTHER:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
	    break ;
					                   
	    case java.sql.Types.REAL:
	   	    col.GetMethod = "getDouble(\""+col.ColName+"\")";
	  	    col.SetMethod = "setDouble( "+(n-nAuto)+" , "+col.VarName+" ) ";
		    col.VarType =  "double";
		  break ;
		                             
	    case java.sql.Types.REF:
	   	   col.GetMethod = "getString(\""+col.ColName+"\")";
	  	   col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
		     col.VarType =  "String";
		  break ;
		                                            
	    case java.sql.Types.ROWID:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "String";
		  break ;
		                      
	    case java.sql.Types.SMALLINT:
	   	    col.GetMethod = "getShort(\""+col.ColName+"\")";
	  	    col.SetMethod = "setShort( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "short" ;
      break ;
	                                    
		  case java.sql.Types.STRUCT:
	   	    col.GetMethod = "getObject(\""+col.ColName+"\")";
	  	    col.SetMethod = "setObject( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "Object" ;
		  break ;
		                  
		  case java.sql.Types.SQLXML:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
		      col.VarType =  "String";
		  break ;
			                   
	    case java.sql.Types.TIME:
           col.GetMethod = "getTime(\""+col.ColName+"\")";
	  	     col.SetMethod = "setTime( "+(n-nAuto)+" , "+col.VarName+" ) ";
			     col.VarType =  "java.sql.Time" ;
		  break ;
		
		
      case java.sql.Types.TIMESTAMP :
	   	    col.GetMethod = "getTimestamp(\""+col.ColName+"\")";
	  	    col.SetMethod = "setTimestamp( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "java.sql.Timestamp" ;
		  break ;		
		
	    case java.sql.Types.TINYINT:
	   	    col.GetMethod = "getByte(\""+col.ColName+"\")";
	  	    col.SetMethod = "setByte( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "byte" ;
      break ;
	 
	    case java.sql.Types.VARBINARY:
	        col.GetMethod = "getBytes(\""+col.ColName+"\")";
	  	    col.SetMethod = "setBytes( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "byte[]" ;
	    break ;
	                  
	    case java.sql.Types.VARCHAR:
	   	    col.GetMethod = "getString(\""+col.ColName+"\")";
	  	    col.SetMethod = "setString( "+(n-nAuto)+" , "+col.VarName+" ) ";
			    col.VarType =  "String" ;
	 } 
          
// Add column to list
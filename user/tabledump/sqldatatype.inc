<% 
			  switch(rsmd.getColumnType(n))
      	{
      	    case  java.sql.Types.ARRAY:
      					delims.put(new Integer(n) , "'");
      	    break ;
      	 
            case java.sql.Types.BIGINT:
      	       delims.put(new Integer(n) , "");
				    break ;
      
      	    case java.sql.Types.BINARY:
      	         delims.put(new Integer(n) , "#");
            break ; 
       
            case java.sql.Types.BIT:
      	        delims.put(new Integer(n) , "");
      	    break ;
      			
            case java.sql.Types.BLOB:
      	  	    delims.put(new Integer(n) , "#");
            break ; 
      		
            case java.sql.Types.BOOLEAN: 		
      		      delims.put(new Integer(n) , "");
      	    break ; 		
      	
      	    case java.sql.Types.CHAR:
      	   	    delims.put(new Integer(n) , "'");
      	    break;
      
            case java.sql.Types.CLOB:
      	   	    delims.put(new Integer(n) , "'");
      		  break ;
      
      	    case java.sql.Types.DATALINK :
      	   	    delims.put(new Integer(n) , "'");
       	    break ;
      			
      		  case java.sql.Types.DATE:
      	 		   delims.put(new Integer(n) , "'");
      		  break ;
      	    
      		  case java.sql.Types.DECIMAL:
      	        delims.put(new Integer(n) , "");
      	    break ;
      	 
      	    case java.sql.Types.DOUBLE:
      	        
								delims.put(new Integer(n) , "");
      		  break ;
      	 
      	    case java.sql.Types.FLOAT:
      	   	    delims.put(new Integer(n) , "");
      	    break ;
      
      		  case java.sql.Types.INTEGER:
                delims.put(new Integer(n) , "");
            break ;
      
            case java.sql.Types.JAVA_OBJECT:
      	   	   delims.put(new Integer(n) , "'");
            break ;
      	    
      		  case java.sql.Types.LONGVARBINARY:
      	   	    delims.put(new Integer(n) , "#");
      		  break ;
      		
      	    case java.sql.Types.LONGVARCHAR:
      		      delims.put(new Integer(n) , "'");
       		  break ;	
      
      	    case java.sql.Types.NCHAR :
      		      delims.put(new Integer(n) , "'");
      		  break ;
      		
      	    case java.sql.Types.NCLOB :
      		      delims.put(new Integer(n) , "'");
      		  break ;
                     		
      	    case java.sql.Types.NULL :
      		     delims.put(new Integer(n) , "'");
      		  break ;
      
          	case java.sql.Types.NUMERIC:
      	  	    delims.put(new Integer(n) , "");
            break ;
      	 
            case java.sql.Types.NVARCHAR :
      	   	    delims.put(new Integer(n) , "'");
            break ;		
      	 
      	    case java.sql.Types.OTHER:
      	   	    delims.put(new Integer(n) , "'");
      	    break ;
      					                   
      	    case java.sql.Types.REAL:
      	   	   delims.put(new Integer(n) , "");
      		  break ;
      		                             
      	    case java.sql.Types.REF:
      	   	   delims.put(new Integer(n) , "'");
      		  break ;
      		                                            
      	    case java.sql.Types.ROWID:
      	   	    delims.put(new Integer(n) , "'");
      		  break ;
      		                      
      	    case java.sql.Types.SMALLINT:
      	   	   delims.put(new Integer(n) , "");
            break ;
      	                                    
      		  case java.sql.Types.STRUCT:
      	   	    delims.put(new Integer(n) , "'");
      		  break ;
      		                  
      		  case java.sql.Types.SQLXML:
      	   	   delims.put(new Integer(n) , "'");
      		  break ;
      			                   
      	    case java.sql.Types.TIME:
                 delims.put(new Integer(n) , "'");
      		  break ;
      		
      		
            case java.sql.Types.TIMESTAMP :
      	   	    delims.put(new Integer(n) , "'");
      		  break ;		
      		
      	    case java.sql.Types.TINYINT:
      	   	    delims.put(new Integer(n) , "");
            break ;
      	 
      	    case java.sql.Types.VARBINARY:
      	        delims.put(new Integer(n) , "#");
      	    break ;
      	                  
      	    case java.sql.Types.VARCHAR:
      	   	   delims.put(new Integer(n) , "'");
								
      	 } // end switch(col.ColSQLType)
%>
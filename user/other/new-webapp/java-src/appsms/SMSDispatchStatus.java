package com.$WEBAPP.appsms;
import java.util.* ;
 
public class SMSDispatchStatus
{
     public static final short FAILED = -1 ;
     public static final short UNKNOWN = 0 ;
     public static final short PENDING = 1 ;
     public static final short INPROCESS = 2 ;
     public static final short SUCCESS = 3 ;
     public static final short SCHEDULED = 4 ;
     public static final short MISSED = 5 ;

     
     public static String getLabel(short item)
     {
          String ret="";
          switch(item)
          {
            case  FAILED:
                ret = "Dispatch Failed" ;
            break;
            case  UNKNOWN:
                ret = "Unknown Status" ;
            break;
            case  PENDING:
                ret = "Dispatch Pending" ;
            break;
            case  INPROCESS:
                ret = "Dispatch In Process" ;
            break;
            case  SUCCESS:
                ret = "Dispatch Successful" ;
            break;
            case  SCHEDULED:
                ret = "Dispatch Scheduled" ;
            break;
            case  MISSED:
                ret = "Dispatch Missed" ;
            break;
				 
          } // end switch case
          return ret ;
     } // End  getLabel(short item)
		 
		 
		 
		 
     public static String getDropList(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\""+Elm+"\"  >\r\n");
          sb.append("    <option value=\"\"> [ None Selected ] </option>\r\n");				
          sb.append("<option value=\""+FAILED+"\""+( (item ==  FAILED ) ? sel :" " )+" >Dispatch Failed</option>\r\n") ;     
          sb.append("<option value=\""+UNKNOWN+"\""+( (item ==  UNKNOWN ) ? sel :" " )+" >Unknown Status</option>\r\n") ;     
          sb.append("<option value=\""+PENDING+"\""+( (item ==  PENDING ) ? sel :" " )+" >Dispatch Pending</option>\r\n") ;     
          sb.append("<option value=\""+INPROCESS+"\""+( (item ==  INPROCESS ) ? sel :" " )+" >Dispatch In Process</option>\r\n") ;     
          sb.append("<option value=\""+SUCCESS+"\""+( (item ==  SUCCESS ) ? sel :" " )+" >Dispatch Successful</option>\r\n") ;     
          sb.append("<option value=\""+SCHEDULED+"\""+( (item ==  SCHEDULED ) ? sel :" " )+" >Dispatch Scheduled</option>\r\n") ;     
          sb.append("<option value=\""+MISSED+"\""+( (item ==  MISSED ) ? sel :" " )+" >Dispatch Missed</option>\r\n") ;     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item)		 

     public static String getDropList(String Elm, short item, String none_label )		 
     {
		      String nonelbl = (none_label!=null)? none_label: "None Selected" ;
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\""+Elm+"\"  >\r\n");
          sb.append("    <option value=\"\"> [ "+nonelbl+" ] </option>\r\n");				
          sb.append("<option value=\""+FAILED+"\""+( (item ==  FAILED ) ? sel :" " )+" >Dispatch Failed</option>\r\n") ;     
          sb.append("<option value=\""+UNKNOWN+"\""+( (item ==  UNKNOWN ) ? sel :" " )+" >Unknown Status</option>\r\n") ;     
          sb.append("<option value=\""+PENDING+"\""+( (item ==  PENDING ) ? sel :" " )+" >Dispatch Pending</option>\r\n") ;     
          sb.append("<option value=\""+INPROCESS+"\""+( (item ==  INPROCESS ) ? sel :" " )+" >Dispatch In Process</option>\r\n") ;     
          sb.append("<option value=\""+SUCCESS+"\""+( (item ==  SUCCESS ) ? sel :" " )+" >Dispatch Successful</option>\r\n") ;     
          sb.append("<option value=\""+SCHEDULED+"\""+( (item ==  SCHEDULED ) ? sel :" " )+" >Dispatch Scheduled</option>\r\n") ;     
          sb.append("<option value=\""+MISSED+"\""+( (item ==  MISSED ) ? sel :" " )+" >Dispatch Missed</option>\r\n") ;     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
		 
		 
		 
     public static String getRadioButtons(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+FAILED+"\""+( (item ==  FAILED ) ? chk :" " )+"  />&nbsp;Dispatch Failed\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+UNKNOWN+"\""+( (item ==  UNKNOWN ) ? chk :" " )+"  />&nbsp;Unknown Status\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+PENDING+"\""+( (item ==  PENDING ) ? chk :" " )+"  />&nbsp;Dispatch Pending\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+INPROCESS+"\""+( (item ==  INPROCESS ) ? chk :" " )+"  />&nbsp;Dispatch In Process\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+SUCCESS+"\""+( (item ==  SUCCESS ) ? chk :" " )+"  />&nbsp;Dispatch Successful\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+SCHEDULED+"\""+( (item ==  SCHEDULED ) ? chk :" " )+"  />&nbsp;Dispatch Scheduled\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+MISSED+"\""+( (item ==  MISSED ) ? chk :" " )+"  />&nbsp;Dispatch Missed\r\n");   
          return sb.toString();				
     }	// End method: getRadioButtons(String Elm, short item)		 

     public static String getCheckBoxes(String Elm, String selCsv)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          HashSet<Short> hs = new HashSet();
          if(selCsv!=null && selCsv.length()>0)
          {
              String[] parts = selCsv.split(",");
              if(parts !=null && parts.length > 0)
              {
                   for(String it : parts)
                   {
                       try{  hs.add(Short.valueOf(it)); }catch( NumberFormatException ex ){ }  											
                   }	// End for loop								 									 							
              }	 // End   if(parts !=null && parts.length > 0)													
              			
          } // End   if(selCsv!=null && selCsv.length()>0)
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+FAILED+"\""+(  (hs.contains(new Short(FAILED))) ? chk :" " )+"  />&nbsp;Dispatch Failed<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+UNKNOWN+"\""+(  (hs.contains(new Short(UNKNOWN))) ? chk :" " )+"  />&nbsp;Unknown Status<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+PENDING+"\""+(  (hs.contains(new Short(PENDING))) ? chk :" " )+"  />&nbsp;Dispatch Pending<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+INPROCESS+"\""+(  (hs.contains(new Short(INPROCESS))) ? chk :" " )+"  />&nbsp;Dispatch In Process<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+SUCCESS+"\""+(  (hs.contains(new Short(SUCCESS))) ? chk :" " )+"  />&nbsp;Dispatch Successful<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+SCHEDULED+"\""+(  (hs.contains(new Short(SCHEDULED))) ? chk :" " )+"  />&nbsp;Dispatch Scheduled<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+MISSED+"\""+(  (hs.contains(new Short(MISSED))) ? chk :" " )+"  />&nbsp;Dispatch Missed<br />\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

} // End Class Definition
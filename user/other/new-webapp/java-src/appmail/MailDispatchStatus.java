package com.$WEBAPP.appmail;
import java.util.* ;
 
public class MailDispatchStatus
{
     public static final short NONE = 0 ;
     public static final short PENDING = 1 ;
     public static final short INPROCESS = 2 ;
     public static final short SUCCESS = 3 ;

     
     public static String getLabel(short item)
     {
          String ret="";
          switch(item)
          {
            case  NONE:
                ret = "None ( Unknonw )" ;
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
				 
          } // end switch case
          return ret ;
     } // End  getLabel(short item)
		 
     public static String getDropList(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\""+Elm+"\"  >\r\n");
          sb.append("    <option value=\"\"> [ None Selected ] </option>\r\n");				
          sb.append("    <option value=\""+NONE+"\""+( (item ==  NONE ) ? sel :" " )+" >None ( Unknonw )</option>\r\n") ;     
          sb.append("    <option value=\""+PENDING+"\""+( (item ==  PENDING ) ? sel :" " )+" >Dispatch Pending</option>\r\n") ;     
          sb.append("    <option value=\""+INPROCESS+"\""+( (item ==  INPROCESS ) ? sel :" " )+" >Dispatch In Process</option>\r\n") ;     
          sb.append("    <option value=\""+SUCCESS+"\""+( (item ==  SUCCESS ) ? sel :" " )+" >Dispatch Successful</option>\r\n") ;     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item)		 

     public static String getRadioButtons(String Elm, short item)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+NONE+"\""+( (item ==  NONE ) ? chk :" " )+"  />&nbsp;None ( Unknonw )\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+PENDING+"\""+( (item ==  PENDING ) ? chk :" " )+"  />&nbsp;Dispatch Pending\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+INPROCESS+"\""+( (item ==  INPROCESS ) ? chk :" " )+"  />&nbsp;Dispatch In Process\r\n");   
          sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
          sb.append("<input type=\"radio\" name=\""+Elm+"\" value=\""+SUCCESS+"\""+( (item ==  SUCCESS ) ? chk :" " )+"  />&nbsp;Dispatch Successful\r\n");   
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
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+NONE+"\""+(  (hs.contains(new Short(NONE))) ? chk :" " )+"  />&nbsp;None ( Unknonw )<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+PENDING+"\""+(  (hs.contains(new Short(PENDING))) ? chk :" " )+"  />&nbsp;Dispatch Pending<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+INPROCESS+"\""+(  (hs.contains(new Short(INPROCESS))) ? chk :" " )+"  />&nbsp;Dispatch In Process<br />\r\n");   
          sb.append("<input type=\"checkbox\" name=\""+Elm+"\" value=\""+SUCCESS+"\""+(  (hs.contains(new Short(SUCCESS))) ? chk :" " )+"  />&nbsp;Dispatch Successful<br />\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

} // End Class Definition
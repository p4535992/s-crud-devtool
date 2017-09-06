package com.$WEBAPP.appsms ;
import java.util.* ;
 
public class MobileNumberStatus
{
     public static final short OK = 1 ;
     public static final short INVALID = 2 ;
     public static final short BLANK = 3 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  OK:
               ret = "Ok" ;
            break;
          case  INVALID:
               ret = "Invalid" ;
            break;
          case  BLANK:
               ret = "Blank" ;
            break;
        } // end switch case
         return ret ;
     } // End  getLabel(short item)

    public static String getDropList(String ElmName, String ElmID, short item, boolean all_label, boolean none_label, String cls, String plugin)		 
     {
          String nonelbl = (none_label == true)? "-- None --" : " " ;
					String alllbl = (all_label == true)? "-- All --" : " " ;
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
					String plgn = (plugin !=null)? " "+plugin+" " : " " ;
          StringBuilder sb = new StringBuilder();
          String sel= " selected=\"selected\" ";
          sb.append("<select name=\"" + ElmName + "\" id=\"" + ElmID + "\" "+cls_name+" "+plgn+"  >\r\n");
					if(all_label == true) sb.append("<option value=\"\"> [ " + alllbl + " ] </option>\r\n");
          if(none_label == true) sb.append("<option value=\"\"> [ " + nonelbl + " ] </option>\r\n");		  

          			
          sb.append("<option value=\"" + OK + "\"" + ((item == OK) ? sel : " ") + " > Ok </option>\r\n");     
          sb.append("<option value=\"" + INVALID + "\"" + ((item == INVALID) ? sel : " ") + " > Invalid </option>\r\n");     
          sb.append("<option value=\"" + BLANK + "\"" + ((item == BLANK) ? sel : " ") + " > Blank </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + OK + "\"" + ((item == OK) ? chk : " ") + " " + cls_name + "  /> Ok\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + INVALID + "\"" + ((item == INVALID) ? chk : " ") + " " + cls_name + "  /> Invalid\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + BLANK + "\"" + ((item == BLANK) ? chk : " ") + " " + cls_name + "  /> Blank\r\n");
          return sb.toString();				
     }	// End method: getRadioButtons(String Elm, short item)		 

     public static String getCheckBoxes(String Elm, String selCsv, String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          HashSet hs = new HashSet();
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + OK + "\"" + ((hs.contains(new Short(OK))) ? chk : " ") + " " + cls_name + "  /> Ok\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + INVALID + "\"" + ((hs.contains(new Short(INVALID))) ? chk : " ") + " " + cls_name + "  /> Invalid\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + BLANK + "\"" + ((hs.contains(new Short(BLANK))) ? chk : " ") + " " + cls_name + "  /> Blank\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"1\":\"Ok\",\"2\":\"Invalid\",\"3\":\"Blank\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ OK, INVALID, BLANK } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(OK), "Ok");
         mp.put( new Short(INVALID), "Invalid");
         mp.put( new Short(BLANK), "Blank");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

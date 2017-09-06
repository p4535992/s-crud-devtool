package com.beanwiz ;
import java.util.* ;
 
public class ValidationType
{
     public static final short NOT_EMPTY = 1 ;
     public static final short NUMERIC = 2 ;
     public static final short STRING_LENGTH = 3 ;
     public static final short FILE = 4 ;
     public static final short EMAIL = 5 ;
     public static final short PHONE = 6 ;
     public static final short REGEXP = 7 ;
     public static final short MOBILE_IN = 8 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  NOT_EMPTY:
               ret = "notEmpty" ;
            break;
          case  NUMERIC:
               ret = "numeric" ;
            break;
          case  STRING_LENGTH:
               ret = "stringLength" ;
            break;
          case  FILE:
               ret = "file" ;
            break;
          case  EMAIL:
               ret = "emailAddress" ;
            break;
          case  PHONE:
               ret = "phone" ;
            break;
          case  REGEXP:
               ret = "regexp" ;
            break;
          case  MOBILE_IN:
               ret = "Mobile (IN)" ;
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

          			
          sb.append("<option value=\"" + NOT_EMPTY + "\"" + ((item == NOT_EMPTY) ? sel : " ") + " > notEmpty </option>\r\n");     
          sb.append("<option value=\"" + NUMERIC + "\"" + ((item == NUMERIC) ? sel : " ") + " > numeric </option>\r\n");     
          sb.append("<option value=\"" + STRING_LENGTH + "\"" + ((item == STRING_LENGTH) ? sel : " ") + " > stringLength </option>\r\n");     
          sb.append("<option value=\"" + FILE + "\"" + ((item == FILE) ? sel : " ") + " > file </option>\r\n");     
          sb.append("<option value=\"" + EMAIL + "\"" + ((item == EMAIL) ? sel : " ") + " > emailAddress </option>\r\n");     
          sb.append("<option value=\"" + PHONE + "\"" + ((item == PHONE) ? sel : " ") + " > phone </option>\r\n");     
          sb.append("<option value=\"" + REGEXP + "\"" + ((item == REGEXP) ? sel : " ") + " > regexp </option>\r\n");     
          sb.append("<option value=\"" + MOBILE_IN + "\"" + ((item == MOBILE_IN) ? sel : " ") + " > Mobile (IN) </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + NOT_EMPTY + "\"" + ((item == NOT_EMPTY) ? chk : " ") + " " + cls_name + "  /> notEmpty\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + NUMERIC + "\"" + ((item == NUMERIC) ? chk : " ") + " " + cls_name + "  /> numeric\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + STRING_LENGTH + "\"" + ((item == STRING_LENGTH) ? chk : " ") + " " + cls_name + "  /> stringLength\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + FILE + "\"" + ((item == FILE) ? chk : " ") + " " + cls_name + "  /> file\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + EMAIL + "\"" + ((item == EMAIL) ? chk : " ") + " " + cls_name + "  /> emailAddress\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + PHONE + "\"" + ((item == PHONE) ? chk : " ") + " " + cls_name + "  /> phone\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + REGEXP + "\"" + ((item == REGEXP) ? chk : " ") + " " + cls_name + "  /> regexp\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + MOBILE_IN + "\"" + ((item == MOBILE_IN) ? chk : " ") + " " + cls_name + "  /> Mobile (IN)\r\n");
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + NOT_EMPTY + "\"" + ((hs.contains(new Short(NOT_EMPTY))) ? chk : " ") + " " + cls_name + "  /> notEmpty\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + NUMERIC + "\"" + ((hs.contains(new Short(NUMERIC))) ? chk : " ") + " " + cls_name + "  /> numeric\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + STRING_LENGTH + "\"" + ((hs.contains(new Short(STRING_LENGTH))) ? chk : " ") + " " + cls_name + "  /> stringLength\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + FILE + "\"" + ((hs.contains(new Short(FILE))) ? chk : " ") + " " + cls_name + "  /> file\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + EMAIL + "\"" + ((hs.contains(new Short(EMAIL))) ? chk : " ") + " " + cls_name + "  /> emailAddress\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + PHONE + "\"" + ((hs.contains(new Short(PHONE))) ? chk : " ") + " " + cls_name + "  /> phone\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + REGEXP + "\"" + ((hs.contains(new Short(REGEXP))) ? chk : " ") + " " + cls_name + "  /> regexp\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + MOBILE_IN + "\"" + ((hs.contains(new Short(MOBILE_IN))) ? chk : " ") + " " + cls_name + "  /> Mobile (IN)\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"1\":\"notEmpty\",\"2\":\"numeric\",\"3\":\"stringLength\",\"4\":\"file\",\"5\":\"emailAddress\",\"6\":\"phone\",\"7\":\"regexp\",\"8\":\"Mobile (IN)\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ NOT_EMPTY, NUMERIC, STRING_LENGTH, FILE, EMAIL, PHONE, REGEXP, MOBILE_IN } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(NOT_EMPTY), "notEmpty");
         mp.put( new Short(NUMERIC), "numeric");
         mp.put( new Short(STRING_LENGTH), "stringLength");
         mp.put( new Short(FILE), "file");
         mp.put( new Short(EMAIL), "emailAddress");
         mp.put( new Short(PHONE), "phone");
         mp.put( new Short(REGEXP), "regexp");
         mp.put( new Short(MOBILE_IN), "Mobile (IN)");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

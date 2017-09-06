package com.$WEBAPP ;
import java.util.* ;
 
public class CurrentStatusFlag
{
     public static final short BARRED = -1 ;
     public static final short UNKNOWN = 0 ;
     public static final short OK = 1 ;
     public static final short LEFT = 2 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  BARRED:
               ret = "Login Barred" ;
            break;
          case  UNKNOWN:
               ret = "Unknown" ;
            break;
          case  OK:
               ret = "Login OK" ;
            break;
          case  LEFT:
               ret = "Left" ;
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
          sb.append("<select name=\"" + ElmName + "\" id=\"" + ElmID + "\" "+ cls_name +" " +plgn+"   >\r\n");
		  if(all_label == true) sb.append("<option value=\"\"> [ " + alllbl + " ] </option>\r\n");
          if(none_label == true) sb.append("<option value=\"\"> [ " + nonelbl + " ] </option>\r\n");		  
          sb.append("<option value=\"" + BARRED + "\"" + ((item == BARRED) ? sel : " ") + " > Login Barred </option>\r\n");     
          sb.append("<option value=\"" + UNKNOWN + "\"" + ((item == UNKNOWN) ? sel : " ") + " > Unknown </option>\r\n");     
          sb.append("<option value=\"" + OK + "\"" + ((item == OK) ? sel : " ") + " > Login OK </option>\r\n");     
          sb.append("<option value=\"" + LEFT + "\"" + ((item == LEFT) ? sel : " ") + " > Left </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + BARRED + "\"" + ((item == BARRED) ? chk : " ") + " " + cls_name + "  /> Login Barred\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + UNKNOWN + "\"" + ((item == UNKNOWN) ? chk : " ") + " " + cls_name + "  /> Unknown\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + OK + "\"" + ((item == OK) ? chk : " ") + " " + cls_name + "  /> Login OK\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + LEFT + "\"" + ((item == LEFT) ? chk : " ") + " " + cls_name + "  /> Left\r\n");
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + BARRED + "\"" + ((hs.contains(new Short(BARRED))) ? chk : " ") + " " + cls_name + "  /> Login Barred\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + UNKNOWN + "\"" + ((hs.contains(new Short(UNKNOWN))) ? chk : " ") + " " + cls_name + "  /> Unknown\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + OK + "\"" + ((hs.contains(new Short(OK))) ? chk : " ") + " " + cls_name + "  /> Login OK\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + LEFT + "\"" + ((hs.contains(new Short(LEFT))) ? chk : " ") + " " + cls_name + "  /> Left\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"0\":\"Unknown\",\"1\":\"Login OK\",\"2\":\"Left\",\"-1\":\"Login Barred\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ BARRED, UNKNOWN, OK, LEFT } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(BARRED), "Login Barred");
         mp.put( new Short(UNKNOWN), "Unknown");
         mp.put( new Short(OK), "Login OK");
         mp.put( new Short(LEFT), "Left");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

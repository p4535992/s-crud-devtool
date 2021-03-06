package com.$WEBAPP.appsms ;
import java.util.* ;
 
public class SMSAccountType
{
     public static final short UNKNOWN = 0 ;
     public static final short PROMOTIONAL = 1 ;
     public static final short TRANSACTIONAL = 2 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  UNKNOWN:
               ret = "Unknown" ;
            break;
          case  PROMOTIONAL:
               ret = "Promotional" ;
            break;
          case  TRANSACTIONAL:
               ret = "Transactional" ;
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

          			
          sb.append("<option value=\"" + UNKNOWN + "\"" + ((item == UNKNOWN) ? sel : " ") + " > Unknown </option>\r\n");     
          sb.append("<option value=\"" + PROMOTIONAL + "\"" + ((item == PROMOTIONAL) ? sel : " ") + " > Promotional </option>\r\n");     
          sb.append("<option value=\"" + TRANSACTIONAL + "\"" + ((item == TRANSACTIONAL) ? sel : " ") + " > Transactional </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + UNKNOWN + "\"" + ((item == UNKNOWN) ? chk : " ") + " " + cls_name + "  /> Unknown\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + PROMOTIONAL + "\"" + ((item == PROMOTIONAL) ? chk : " ") + " " + cls_name + "  /> Promotional\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + TRANSACTIONAL + "\"" + ((item == TRANSACTIONAL) ? chk : " ") + " " + cls_name + "  /> Transactional\r\n");
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + UNKNOWN + "\"" + ((hs.contains(new Short(UNKNOWN))) ? chk : " ") + " " + cls_name + "  /> Unknown\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + PROMOTIONAL + "\"" + ((hs.contains(new Short(PROMOTIONAL))) ? chk : " ") + " " + cls_name + "  /> Promotional\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + TRANSACTIONAL + "\"" + ((hs.contains(new Short(TRANSACTIONAL))) ? chk : " ") + " " + cls_name + "  /> Transactional\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"0\":\"Unknown\",\"1\":\"Promotional\",\"2\":\"Transactional\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ UNKNOWN, PROMOTIONAL, TRANSACTIONAL } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(UNKNOWN), "Unknown");
         mp.put( new Short(PROMOTIONAL), "Promotional");
         mp.put( new Short(TRANSACTIONAL), "Transactional");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

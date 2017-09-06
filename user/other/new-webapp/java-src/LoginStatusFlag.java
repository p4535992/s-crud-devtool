package com.$WEBAPP ;
import java.util.* ;
 
public class LoginStatusFlag
{
     public static final short NOT_LOGGED = 0 ;
     public static final short LOGGED = 1 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  NOT_LOGGED:
               ret = "Not Logged" ;
            break;
          case  LOGGED:
               ret = "Logged" ;
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

          			
          sb.append("<option value=\"" + NOT_LOGGED + "\"" + ((item == NOT_LOGGED) ? sel : " ") + " > Not Logged </option>\r\n");     
          sb.append("<option value=\"" + LOGGED + "\"" + ((item == LOGGED) ? sel : " ") + " > Logged </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + NOT_LOGGED + "\"" + ((item == NOT_LOGGED) ? chk : " ") + " " + cls_name + "  /> Not Logged\r\n");
          sb.append("   | ");
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + LOGGED + "\"" + ((item == LOGGED) ? chk : " ") + " " + cls_name + "  /> Logged\r\n");
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + NOT_LOGGED + "\"" + ((hs.contains(new Short(NOT_LOGGED))) ? chk : " ") + " " + cls_name + "  /> Not Logged\r\n");   
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + LOGGED + "\"" + ((hs.contains(new Short(LOGGED))) ? chk : " ") + " " + cls_name + "  /> Logged\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"0\":\"Not Logged\",\"1\":\"Logged\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ NOT_LOGGED, LOGGED } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(NOT_LOGGED), "Not Logged");
         mp.put( new Short(LOGGED), "Logged");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

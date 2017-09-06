package com.$WEBAPP ;
import java.util.* ;
 
public class LoginRole
{
     public static final short Administrator = 1 ;

     public static String getLabel(short item)
     {
        String ret="";
        switch(item)
        {
          case  Administrator:
               ret = "Administrator" ;
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

          			
          sb.append("<option value=\"" + Administrator + "\"" + ((item == Administrator) ? sel : " ") + " > Administrator </option>\r\n");     
          sb.append("</select>\r\n");
          return sb.toString();										 
     }		// End method: getDropList(String Elm, short item, String none_label )		 
		 
     public static String getRadioButtons(String Elm, short item,  String cls)		 
     {
          StringBuilder sb = new StringBuilder();
          String chk = " checked=\"checked\" " ; 
          String cls_name = (cls !=null)? " class=\""+cls+"\" " : " " ;
          sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + Administrator + "\"" + ((item == Administrator) ? chk : " ") + " " + cls_name + "  /> Administrator\r\n");
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
          sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + Administrator + "\"" + ((hs.contains(new Short(Administrator))) ? chk : " ") + " " + cls_name + "  /> Administrator\r\n");   
          return sb.toString();				
     }	// End method:  getCheckBoxes(String Elm, String selCsv)				 

     public static String getJSONString()
     {
         return "{\"1\":\"Administrator\"}" ;
     } // End method getJSONString()
		 
		 
     public static short[] items()
     {
         return new short[]{ Administrator } ;
     } // End method items()
		 
     public static TreeMap itemMap()
     {
         TreeMap mp = new TreeMap();
         mp.put( new Short(Administrator), "Administrator");
       	 return mp ;    
     } // End method itemMap()
		 	 
} // End Class Definition

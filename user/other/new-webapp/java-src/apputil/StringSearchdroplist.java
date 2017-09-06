package com.$WEBAPP.apputil;
import java.util.*;

public class StringSearchdroplist
{
  public static final short EXACT = 0;
  public static final short START = 1;
  public static final short CONTAIN = 2;
  public static final short END = 3;
  public static final short NULL_CHECK = 4;


  public static String getLabel(short item)
    {
      String ret = "";
      switch (item)
      {
        case EXACT:
          ret = "Exact match";
          break;
        case START:
          ret = "Starting with";
          break;
        case CONTAIN:
          ret = "Containing";
          break;
        case END:
          ret = "Ending with";
          break;

        case NULL_CHECK:
          ret = "Check null";
          break;


      } // end switch case
      return ret;
    } // End  getLabel(short item)




  public static String getDropList(String Elm, short item)
    {
      StringBuilder sb = new StringBuilder();
      String sel = " selected=\"selected\" ";
      sb.append("<select name=\"" + Elm + "\"  >\r\n");
      sb.append("<option value=\"" + EXACT + "\"" + ((item == EXACT) ? sel : " ") + " >Exact match</option>\r\n");
      sb.append("<option value=\"" + START + "\"" + ((item == START) ? sel : " ") + " >Starting with</option>\r\n");
      sb.append("<option value=\"" + CONTAIN + "\"" + ((item == CONTAIN) ? sel : " ") + " >Containing</option>\r\n");
      sb.append("<option value=\"" + END + "\"" + ((item == END) ? sel : " ") + " >Ending with</option>\r\n");
      sb.append("<option value=\"" + NULL_CHECK + "\"" + ((item == NULL_CHECK) ? sel : " ") + " >Check null</option>\r\n");
      sb.append("</select>\r\n");
      return sb.toString();
    } // End method: getDropList(String Elm, short item)		 

  public static String getDropList(String Elm, short item, String none_label)
    {
      String nonelbl = (none_label != null) ? none_label : "None Selected";
      StringBuilder sb = new StringBuilder();
      String sel = " selected=\"selected\" ";
      sb.append("<select name=\"" + Elm + "\"  >\r\n");
      sb.append("    <option value=\"\"> [ " + nonelbl + " ] </option>\r\n");
      sb.append("    <option value=\"" + EXACT + "\"" + ((item == EXACT) ? sel : " ") + " >Exact match</option>\r\n");
      sb.append("    <option value=\"" + START + "\"" + ((item == START) ? sel : " ") + " >Starting with</option>\r\n");
      sb.append("    <option value=\"" + CONTAIN + "\"" + ((item == CONTAIN) ? sel : " ") + " >Containing</option>\r\n");
      sb.append("    <option value=\"" + END + "\"" + ((item == END) ? sel : " ") + " >Ending with</option>\r\n");
      sb.append("    <option value=\"" + NULL_CHECK + "\"" + ((item == NULL_CHECK) ? sel : " ") + " >Check null</option>\r\n");
      sb.append("</select>\r\n");
      return sb.toString();
    } // End method: getDropList(String Elm, short item, String none_label )		 


  public static String getDropList(String Elm, short item, String none_label, String cls_name, String plugin)
    {
      String nonelbl = (none_label != null) ? none_label : "None Selected";
      String cls = (cls_name != null) ? " class=\"" + cls_name + "\" " : " ";
      String plgn = (plugin != null) ? " " + plugin + " " : " ";

      StringBuilder sb = new StringBuilder();
      String sel = " selected=\"selected\" ";
      sb.append("<select name=\"" + Elm + "\" " + cls + " " + plgn + " >\r\n");
      //sb.append("    <option value=\"\"> [ "+nonelbl+" ] </option>\r\n");				
      sb.append("    <option value=\"" + EXACT + "\"" + ((item == EXACT) ? sel : " ") + " >Exact</option>\r\n");
      sb.append("    <option value=\"" + START + "\"" + ((item == START) ? sel : " ") + " >Start</option>\r\n");
      sb.append("    <option value=\"" + CONTAIN + "\"" + ((item == CONTAIN) ? sel : " ") + " >Contain</option>\r\n");
      sb.append("    <option value=\"" + END + "\"" + ((item == END) ? sel : " ") + " >End</option>\r\n");
      sb.append("    <option value=\"" + NULL_CHECK + "\"" + ((item == NULL_CHECK) ? sel : " ") + " >null</option>\r\n");
      sb.append("</select>\r\n");
      return sb.toString();
    } // End method: getDropList(String Elm, short item, String none_label )		 



  public static String getRadioButtons(String Elm, short item)
    {
      StringBuilder sb = new StringBuilder();
      String chk = " checked=\"checked\" ";
      sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + EXACT + "\"" + ((item == EXACT) ? chk : " ") + "  />&nbsp;Exact match\r\n");
      sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
      sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + START + "\"" + ((item == START) ? chk : " ") + "  />&nbsp;Starting with\r\n");
      sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
      sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + CONTAIN + "\"" + ((item == CONTAIN) ? chk : " ") + "  />&nbsp;Containing\r\n");
      sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
      sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + END + "\"" + ((item == END) ? chk : " ") + "  />&nbsp;Ending with\r\n");
      sb.append("&nbsp;&nbsp;&nbsp;|&nbsp;");
      sb.append("<input type=\"radio\" name=\"" + Elm + "\" value=\"" + NULL_CHECK + "\"" + ((item == END) ? chk : " ") + "  />&nbsp;Check null\r\n");
      return sb.toString();
    } // End method: getRadioButtons(String Elm, short item)		 

  public static String getCheckBoxes(String Elm, String selCsv)
    {
      StringBuilder sb = new StringBuilder();
      String chk = " checked=\"checked\" ";
      HashSet < Short > hs = new HashSet();
      if (selCsv != null && selCsv.length() > 0)
      {
        String[] parts = selCsv.split(",");
        if (parts != null && parts.length > 0)
        {
          for (String it: parts)
          {
            try
            {
              hs.add(Short.valueOf(it));
            }
            catch (NumberFormatException ex)
            {}
          } // End for loop								 									 							
        } // End   if(parts !=null && parts.length > 0)													

      } // End   if(selCsv!=null && selCsv.length()>0)
      sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + EXACT + "\"" + ((hs.contains(new Short(EXACT))) ? chk : " ") + "  />&nbsp;Exact match<br />\r\n");
      sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + START + "\"" + ((hs.contains(new Short(START))) ? chk : " ") + "  />&nbsp;Starting with<br />\r\n");
      sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + CONTAIN + "\"" + ((hs.contains(new Short(CONTAIN))) ? chk : " ") + "  />&nbsp;Containing<br />\r\n");
      sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + END + "\"" + ((hs.contains(new Short(END))) ? chk : " ") + "  />&nbsp;Ending with<br />\r\n");
      sb.append("<input type=\"checkbox\" name=\"" + Elm + "\" value=\"" + NULL_CHECK + "\"" + ((hs.contains(new Short(END))) ? chk : " ") + "  />&nbsp;Check null<br />\r\n");
      return sb.toString();
    } // End method:  getCheckBoxes(String Elm, String selCsv)				 

} // End Class Definition
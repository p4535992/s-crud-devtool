package com.$WEBAPP.apputil ;
import java.util.*;

public class NumberSearchdroplist
{

   public static String getOperatorList(String  name, String id, String classname, String plugin )
   {
      String ClsName = (classname!=null && classname.length()>0 )? " class=\""+classname+"\" " : " " ;
	  String plgn = (plugin!=null)? " "+plugin+" " : " " ;
		  String ElmName = (name!=null && name.length()>0)? " name=\""+name+"\"  " : " " ;
		  String EldID =   (id!=null && id.length()>0)? " id=\""+id+"\"  " : " " ;
		  StringBuilder sb = new StringBuilder();
		  sb.append("<select "+ElmName+" "+EldID+" "+ClsName+" "+plgn+" >\r\n");
		  sb.append("     <option value=\"=\" >&nbsp;=&nbsp;</option>\r\n");
		  sb.append("     <option value=\">\" >&nbsp;&gt;&nbsp;</option>\r\n");
		  sb.append("     <option value=\">=\" >&nbsp;&ge;&nbsp;</option>\r\n");
		  sb.append("     <option value=\"<\" >&nbsp;&lt;&nbsp;</option>\r\n");
		  sb.append("     <option value=\"<=\" >&nbsp;&le;&nbsp;</option>\r\n");	
			sb.append("     <option value=\"!=\" >&nbsp;&ne;&nbsp;</option>\r\n");
			sb.append("     <option value=\"null\" >&nbsp;&empty;&nbsp;</option>\r\n");				
      sb.append("</select>\r\n");
			return sb.toString();
  }

}


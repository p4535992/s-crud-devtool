package com.$WEBAPP ;
import com.db.$DATABASE.* ;
import javax.servlet.*;
import java.util.* ;
import com.webapp.utils.*;

/*
ShowItem.showActivityFullName(String activity)

ShowItem.showAdminName(int id, int nameType)
ShowItem.showAdminNameWithGender(int id, int nameType)

ShowItem.showExecutor(int UserID, String LoginRole)
ShowItem.showExecutorWithBR(int UserID, String LoginRole) 
*/

public class ShowItem {
	
  private static com.webapp.utils.PortableSQL psql = null;
  private static com.webapp.db.GenericQuery genqry = new com.webapp.db.GenericQuery(ApplicationResource.database);
  private static com.db.$DATABASE.SitemanagerBean SiBn = new com.db.$DATABASE.SitemanagerBean();
  private static com.db.$DATABASE.Module_activityBean SiActBn = new com.db.$DATABASE.Module_activityBean();

  public static void init(javax.servlet.ServletContext cntx) {
    psql = new com.webapp.utils.PortableSQL(cntx);
  }
  
//***********************************************************//  

// ShowItem.showActivityFullName(String activity)   

  public static String showActivityFullName(String activity) {
    String[] abc = CSVHelper.stringArrayFromCsv(activity);
    int i = 0;
    String ret = "";
    for (String xyz: abc) {
      i++;
      try {
        if (SiActBn.locateOnField("ModuleActivityID", xyz)) {
          ret = ret + "" + SiActBn.ModuleActivityName;
          if (abc.length > i) {
            ret = ret + ",";
          }
        }
      } catch (java.sql.SQLException ex) {
        ret = ex.toString();
      }
    }
    return ret;
  } //end ShowItem.showActivityFullName(String activity)
  
//***********************************************************// 

// ShowItem.showAdminName(int id, int nameType) 

  public static String showAdminName(int ID, int nameType) {
      String ret = "";
      try {
        if (SiBn.locateRecord(ID)) {
          if (nameType == 1) {
            ret = SiBn.FirstName + " " + SiBn.MiddleName + " " + SiBn.LastName;
          }
          if (nameType == 2) {
            ret = SiBn.FirstName + " " + ((SiBn.MiddleName != null && SiBn.MiddleName.length() > 0) ? SiBn.MiddleName.substring(0, 1) + "." : " ") + " " + SiBn.LastName;
          }
          if (nameType == 3) {
            ret = SiBn.FirstName + " " + SiBn.LastName;
          }
        }
      } catch (java.sql.SQLException ex) {
        ret = ex.toString();
      }
      return ret;
    } //end ShowItem.showAdminName(int id, int nameType)
 
//***********************************************************//

// ShowItem.showAdminNameWithGender(int id, int nameType) 

  public static String showAdminNameWithGender(int ID, int nameType) {
      String ret = "";
	  String gendericon = "";
      try {
        if (SiBn.locateRecord(ID)) {
			
		if(SiBn.Gender.equalsIgnoreCase("Male")) gendericon = "<i class='icon fa fa-male fa-lg iccolor' aria-hidden='true'></i>&nbsp;" ;
		else if(SiBn.Gender.equalsIgnoreCase("FeMale")) gendericon = "<i class='icon fa fa-female fa-lg iccolor' aria-hidden='true'></i>&nbsp;" ;
		else gendericon = "";
			
          if (nameType == 1) {
            ret = gendericon+" "+SiBn.FirstName + " " + SiBn.MiddleName + " " + SiBn.LastName;
          }
          if (nameType == 2) {
            ret = gendericon+" "+SiBn.FirstName + " " + ((SiBn.MiddleName != null && SiBn.MiddleName.length() > 0) ? SiBn.MiddleName.substring(0, 1) + "." : " ") + " " + SiBn.LastName;
          }
          if (nameType == 3) {
            ret = gendericon+" "+SiBn.FirstName + " " + SiBn.LastName;
          }
        }
      } catch (java.sql.SQLException ex) {
        ret = ex.toString();
      }
      return ret;
    } //end ShowItem.showAdminNameWithGender(int id, int nameType)	  
  
//***********************************************************//  
   	
// ShowItem.showExecutor(int UserID, String LoginRole)

  public static String showExecutor(int UserID, String LoginRole) 
  {	  
    String ret = "";
	switch(LoginRole)
	  {
		case "Administrator" :
			ret = "[ Administrator ]&nbsp;&nbsp;"+showAdminNameWithGender(UserID, 1)+"";
		break;
	  }
    return ret;
  } //end ShowItem.showExecutor(int UserID, String LoginRole)  
	
//***********************************************************//  
   	
// ShowItem.showExecutorWithBR(int UserID, String LoginRole)

  public static String showExecutorWithBR(int UserID, String LoginRole) 
  {	  
    String ret = "";
	switch(LoginRole)
	  {
		case "Administrator" :
			ret = "[ Administrator ]<br />"+showAdminNameWithGender(UserID, 1)+"";
		break;
	  }
    return ret;
  } //end ShowItem.showExecutorWithBR(int UserID, String LoginRole)  

}
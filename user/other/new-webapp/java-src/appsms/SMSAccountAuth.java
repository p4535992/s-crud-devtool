package com.$WEBAPP.appsms;
import com.db.$DATABASE.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class SMSAccountAuth
{
  private Sms_gatewayaccountsBean ActBn = new Sms_gatewayaccountsBean();
  private java.util.Vector < Integer > ActList = new java.util.Vector();
  private static final String SID = "MY-SMS-ACCOUNTS-";
  private String dsn = "jdbc/$WEBAPP"; // default dsn
  private ServletContext context = null;


  public SMSAccountAuth(ServletContext cntx)
  {
    this.context = cntx;
    // load data source from context
    this.dsn = this.context.getInitParameter("WEBSMS-DATASOURCE");
    if (this.dsn == null) this.dsn = "jdbc/$WEBAPP"; // Assume defualt value if not set
    ActBn.setDatasource(this.dsn);

  }

  public String getDSN()
  {
    return this.dsn;
  }



  public static SMSAccountAuth createAuthInSession(ServletContext cntx, HttpSession session)
  {
    String ses_id = SID + session.getId();
    SMSAccountAuth ret = new SMSAccountAuth(cntx);
    session.setAttribute(ses_id, ret);
    return ret;
  }



  public static SMSAccountAuth getAccountAuth(HttpSession session)
  {
    String ses_id = SID + session.getId();
    return (SMSAccountAuth) session.getAttribute(ses_id);
  }

  public static SMSAccountAuth GetOrCreateAccountAuth(ServletContext cntx, HttpSession session)
  {

    String ses_id = SID + session.getId();
    SMSAccountAuth auth = SMSAccountAuth.getAccountAuth(session);
    if (auth == null) auth = SMSAccountAuth.createAuthInSession(cntx, session);
    return auth;
  }



  public boolean addAccount(int ActID)
  {
    Integer it = new Integer(ActID);
    if (this.ActList.contains(it)) return false;
    this.ActList.add(it);
    return true;
  }

  public boolean setFromCSVString(String st, boolean bForceReload)
  {
    if (bForceReload == true || this.ActList.size() == 0)
    {
      return setFromCSVString(st);
    }
    return false;

  }

  public boolean setFromCSVString(String st)
  {
    if (st == null || st.length() == 0)
    {
      this.ActList.clear();
      return true;
    }
    String[] parts = st.split(",");
    if (parts == null || parts.length == 0) return false;
    this.ActList.clear();
    for (String itm: parts)
    {
      try
      {
        int i = Integer.parseInt(itm.trim());
        Integer it = new Integer(i);
        if (i > 0 && !this.ActList.contains(it)) this.ActList.add(it);
      }
      catch (NumberFormatException e)
      {

      }
    } // end for(String itm:parts)
    return true;
  }


  public void removeAccount(int ActID)
  {
    Integer it = new Integer(ActID);
    this.ActList.remove(it);
  }

  public String getAuthAccountList(String elm, int nSel)
    {
      StringBuilder sb = new StringBuilder();

      int nActCnt = ActList.size();
      if (nActCnt == 0)
      {
        sb.append("Not authorized to send SMS");
      }
      else if (nActCnt == 1)
      {
        try
        {
          ActBn.locateRecord(((Integer) ActList.get(0)).intValue());
		  sb.append("<select name=\"" + ((elm != null) ? elm : "AccountID") + "\" class=\"form-control show-tick\" data-plugin=\"selectpicker\" >\r\n");
		  sb.append("	<option value=\"" + ActBn.AccountID + "\" > " + ActBn.Title + " ( " + SMSAccountType.getLabel(ActBn.AccountType) + " ) </option>\r\n");
          sb.append("</select>\r\n");
        }
        catch (Exception e)
        {
          sb.append("Database Error ( Please report ) !");
        }
      }
      else if (nActCnt > 0)
      {
		sb.append("<select name=\"" + ((elm != null) ? elm : "AccountID") + "\" class=\"form-control show-tick\" data-plugin=\"selectpicker\" >\r\n");
        sb.append("     <option value=\"\"> -- NONE -- </option>\r\n");
        for (Integer itr: ActList)
        {
          String sl = (nSel == itr.intValue()) ? " selected=\"selected\" " : " ";
          try
          {
            if (ActBn.locateRecord(itr.intValue()))
            {
              sb.append("	<option value=\"" + itr + "\"  " + sl + " > " + ActBn.Title + " ( " + SMSAccountType.getLabel(ActBn.AccountType) + " ) </option>\r\n");
            }
            else
            {
              sb.append("	<option value=\"\">Error- Account ID: " + itr + " Not Found</option>");
            }
          }
          catch (java.sql.SQLException ex)
          {
            sb.append("<option value=\"\">Database Error: " + ex.getMessage() + "</option>");
          }
        }
        sb.append("</select>\r\n");
      } // end if (nActCnt > 0 )
      return sb.toString();
    } // end method : getAuthAccountList(String elm, int nSel )


  public static String showActListCSVString(String data_src, String csv)
  {
    if (csv == null || csv.length() == 0) return "";
    String[] parts = csv.split(",");
    if (parts == null || parts.length == 0) return "[ None ]";
    Sms_gatewayaccountsBean HtBn = new Sms_gatewayaccountsBean();
    HtBn.setDatasource(data_src);
    int n = 0;
    StringBuffer sb = new StringBuffer();
    for (String itm: parts)
    {
      try
      {
        int i = Integer.parseInt(itm.trim());
        if (HtBn.locateRecord(i))
        {
          if (n > 0) sb.append(", ");
          sb.append(HtBn.Title + " ( " + SMSAccountType.getLabel(HtBn.AccountType) + " ) ");
          n++;
        }
      }
      catch (Exception e)
      {

      }

    }
    return sb.toString();
  }


  public static String getActListCSVString(String data_src, String elm, String csv, int nSel)
    {
      if (csv == null || csv.length() == 0) return "[ Not Authorized To Send SMS ]";
      String[] parts = csv.split(",");
      if (parts == null || parts.length == 0) return "[ Not Authorized To Send SMS ]";

      StringBuffer sb = new StringBuffer();
      Sms_gatewayaccountsBean HtBn = new Sms_gatewayaccountsBean();
      HtBn.setDatasource(data_src);

      int i = 0;
      try
      {
        if (parts.length == 1)
        {

          HtBn.locateRecord(Integer.parseInt(parts[0]));
          sb.append("<!-- AccountID as hidden field -->\r\n");
          sb.append("<input type=\"hidden\" name=\"" + ((elm != null) ? elm : "AccountID") + "\"  value=\"" + HtBn.AccountID + "\" />\r\n");
          sb.append(HtBn.Title + " ( " + SMSAccountType.getLabel(HtBn.AccountType) + " )");
        }
        else if (parts.length > 1)
        {
          sb.append("<select name=\"" + ((elm != null) ? elm : "AccountID") + "\"   >\r\n");
          sb.append("     <option value=\"\">--- NOT SELECTED ---</option>\r\n");
          for (String itm: parts)
          {
            try
            {
              i = Integer.parseInt(itm);
            }
            catch (NumberFormatException e)
            {
              i = 0;
            }
            if (HtBn.locateRecord(i))
            {
              String sel = (nSel == i) ? " selected=\"selected\" " : " ";
              sb.append("     <option value=\"" + itm + "\"  " + sel + " > " + HtBn.Title + " ( " + SMSAccountType.getLabel(HtBn.AccountType) + " ) </option>\r\n");
            }
          } // End for loop 
          sb.append("</select>\r\n");
        } // End - else if (parts.length > 1)

      }
      catch (Exception e)
      {
        return "Data access error! (Please report this)";
      }
      return sb.toString();

    } // End method - getActListCSVString( )

  public static String getAccountsList(String dsn, String elm)
    {
      StringBuilder sb = new StringBuilder();
      sb.append("<select name=\"" + ((elm != null) ? elm : "AccountID") + "\"   >\r\n");
      sb.append("     <option value=\"\">--- NOT SELECTED ---</option>\r\n");
      Sms_gatewayaccountsBean HtBn = new Sms_gatewayaccountsBean();
      HtBn.setDatasource(dsn);
      try
      {
        HtBn.openTable(" ", " ");
        while (HtBn.nextRow())
        {
          sb.append("     <option value=\"" + HtBn.AccountID + "\"   > " + HtBn.Title + " ( " + SMSAccountType.getLabel(HtBn.AccountType) + " ) </option>\r\n");
        }
        HtBn.closeTable();
      }
      catch (java.sql.SQLException ex)
      {}

      sb.append("</select>\r\n");
      return sb.toString();
    } // end - getAccountsList(String elm)



  public static String getCSVStringFromReq(HttpServletRequest request, String elm)
  {
    String ElementName = elm != null ? elm : "AccountID";
    String[] vals = request.getParameterValues(ElementName);
    if (vals == null || vals.length == 0) return null;
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < vals.length; i++)
    {
      if (i > 0) sb.append(",");
      sb.append(vals[i]);
    }
    return sb.toString();
  }




  public static String getAccountsCheckList(String dsn, String elm, String csvstr)
    {
	  String ElementName = elm != null ? elm : "AccountID";
      java.util.HashSet < Integer > hs = new java.util.HashSet();
      if (csvstr != null && csvstr.length() > 0)
      {
        String[] parts = csvstr.split(",");
        if (parts != null && parts.length > 0)
        {
          for (String itm: parts)
          {
            try
            {
              hs.add(Integer.valueOf(itm));
            }
            catch (NumberFormatException e)
            {}
          } // end for
        } // end if(parts != null && parts.length > 0 ) 
      } // end if(csvstr !=null && csvstr.length()>0)

      StringBuilder sb = new StringBuilder();
      sb.append("<select name=\"" + ElementName + "\" class=\"form-control show-tick\" data-plugin=\"selectpicker\" multiple data-selected-text-format=\"count > 1\" data-actions-box=\"true\">\r\n");
      Sms_gatewayaccountsBean HtBn = new Sms_gatewayaccountsBean();
      HtBn.setDatasource(dsn);
      try
      {
        HtBn.openTable(" ", " ");
        while (HtBn.nextRow())
        {
          String sel = hs.contains(new Integer(HtBn.AccountID)) ? "selected=\"selected\"" : "";
		  sb.append("    <option value=\"" + HtBn.AccountID + "\" " + sel + "  >" + HtBn.Title + " ( " + SMSAccountType.getLabel(HtBn.AccountType) + " )</option>\r\n");
        }
        HtBn.closeTable();
      }
      catch (java.sql.SQLException ex)
      {}
      sb.append("</select>");
      return sb.toString();
    } // end method - getAccountsList(String elm)

} // End class definition
package com.$WEBAPP.apputil;
import java.lang.*;
import java.util.*;
import java.text.*;
import java.lang.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class appMakeQueryString
{
  public appMakeQueryString(HttpServletRequest rq)
  {
    psql = new com.webapp.utils.PortableSQL();
    this.rqst = rq;
  }

  public appMakeQueryString(HttpServletRequest rq, short eng)
  {
    psql = new com.webapp.utils.PortableSQL(eng);
    this.rqst = rq;
  }
  public appMakeQueryString(HttpServletRequest rq, String seng)
  {
    psql = new com.webapp.utils.PortableSQL(seng);
    this.rqst = rq;
  }

  public appMakeQueryString(HttpServletRequest rq, javax.servlet.ServletContext context)
  {
    this.rqst = rq;
    psql = new com.webapp.utils.PortableSQL(context);
  }

  // end constructors

  // Wrapper  facade for methods moved to class PortableSQL
  // This is done for backward compatibility

  public String colName(String name)
  {
    return psql.colName(name);
  }

  public String SQL(String str_sql)
  {
    return psql.SQL(str_sql);
  }

  public String getEngineName()
    {
      return psql.getEngineName();
    }
    // METHODS RELATED TO SQL GENERATION 		

  public void addCriterion(String crt)
  {
    if (crt != null) vt.add(" " + crt + " ");
  }

  public boolean addMultiSelectParam(String TableName, String param, boolean IsStr)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValues[] = rqst.getParameterValues(param);
      if (fldValues == null) return false;

      String sep = (IsStr) ? "'" : "";
      StringBuffer additem = new StringBuffer();
      additem.append(" `" + TableName + "`.`" + param + "` IN ( ");
      for (int i = 0; i < fldValues.length; i++)
      {
        String fld_val = com.webapp.utils.SQLHelper.escapeQuote(fldValues[i]);
        additem.append(" " + sep + fld_val + sep);
        if (i < (fldValues.length - 1)) additem.append(",");
      }
      additem.append(" ) ");
      vt.add(additem.toString());
      return true;
    } // End method addMultiSelectParam(String TableName, String param, boolean IsStr  )

  public boolean addStringParam(String TableName, String param, boolean exact)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param).trim();
      if (fldValue == null || fldValue.length() == 0) return false;
      fldValue = com.webapp.utils.SQLHelper.escapeQuote(fldValue);

      if (exact == true) // = query
      {
        vt.add(" `" + TableName + "`.`" + param + "` = '" + fldValue + "' ");
      }
      else // like query
      {
        vt.add(" `" + TableName + "`.`" + param + "` LIKE '" + fldValue + "%' ");
      }
      return true;
    } // End method addStringParam(String TableName, String param, boolean exact )

  public boolean addStringParam(String TableName, String param, short stype)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param);

      if (fldValue == null || fldValue.length()==0 ) 
	  {
		if(stype != StringSearchdroplist.NULL_CHECK) return false;
	  }
      if(fldValue!=null) fldValue = fldValue.trim();
	  
	  if(fldValue !=null && fldValue.length() > 0 ) fldValue = com.webapp.utils.SQLHelper.escapeQuote(fldValue);
	  
      switch (stype)
      {
        case StringSearchdroplist.EXACT:
          vt.add(" `" + TableName + "`.`" + param + "` = '" + fldValue + "' ");
          break;
        case StringSearchdroplist.START:
          vt.add(" `" + TableName + "`.`" + param + "` LIKE '" + fldValue + "%' ");
          break;
        case StringSearchdroplist.CONTAIN:
          vt.add(" `" + TableName + "`.`" + param + "` LIKE '%" + fldValue + "%' ");
          break;
        case StringSearchdroplist.END:
          vt.add(" `" + TableName + "`.`" + param + "` LIKE '%" + fldValue + "' ");
          break;
        case StringSearchdroplist.NULL_CHECK:
          vt.add(" `" + TableName + "`.`" + param + "` IS NULL OR `" + param + "` = '' ");
          break;
      }

      return true;
    } // End method - addStringParam(String TableName, String param, short stype )


  public boolean addStringParam(String TableName, String param, String opr)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param).trim();
      if (fldValue == null) return false;
      if (fldValue.length() == 0) return false;
      fldValue = com.webapp.utils.SQLHelper.escapeQuote(fldValue);
      vt.add(" `" + TableName + "`.`" + param + "` " + opr + "  '" + fldValue + "' ");
      return true;
    } // End method -  addStringParam(String TableName, String param, String opr )

  public boolean addCSVStringParam(String TableName, String param, boolean isCaseSen)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param).trim();
      if (fldValue == null) return false;
      if (fldValue.length() == 0) return false;
      fldValue = com.webapp.utils.SQLHelper.escapeQuote(fldValue);
      String CaseSen = (isCaseSen) ? "BINARY" : "";
      vt.add(" FIND_IN_SET (" + CaseSen + " '" + fldValue + "', `" + TableName + "`.`" + param + "`) ");
      return true;
    } // End method - addCSVStringParam(String TableName, String param, boolean isCaseSen)


  public boolean addStringInRangeParam(String TableName, String field, String from, String to)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;

      if (field == null || field.length() == 0) return false;
      if (from == null || from.length() == 0) return false;
      if (to == null || to.length() == 0) return false;

      String from_val = rqst.getParameter(from).trim();
      if (from_val == null || from_val.length() == 0) return false;
      from_val = com.webapp.utils.SQLHelper.escapeQuote(from_val);

      String to_val = rqst.getParameter(to).trim();
      if (to_val == null || to_val.length() == 0) return false;
      to_val = com.webapp.utils.SQLHelper.escapeQuote(to_val);

      vt.add(" `" + TableName + "`.`" + field + "` BETWEEN '" + from_val + "' AND '" + to_val + "' ");
      return true;
    } // End method - addStringInRangeParam(String TableName, String field, String from, String to )



  public boolean addNumberParam(String TableName, String param)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param).trim();
      if (fldValue == null) return false;
      if (fldValue.length() == 0) return false;

      vt.add(" `" + TableName + "`.`" + param + "`  = " + fldValue + " ");
      return true;
    } // End method - addNumberParam(String TableName, String param )


  public boolean addNumberParam(String TableName, String param, String opr)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = rqst.getParameter(param);
      if (fldValue == null || fldValue.length() == 0)
      {
        if (!"null".equalsIgnoreCase(opr)) return false;
      }
      if (fldValue != null) fldValue = fldValue.trim();
      if ("null".equalsIgnoreCase(opr))
      {
        vt.add(" `" + TableName + "`.`" + param + "` IS NULL  ");
      }
      else
      {
        vt.add(" `" + TableName + "`.`" + param + "`  " + opr + " " + fldValue + " ");
      }
      return true;
    } // End method -  addNumberParam(String TableName, String param, String opr )

  public boolean addNumberInRangeParam(String TableName, String field, String from, String to)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;

      if (field == null || field.length() == 0) return false;
      if (from == null || from.length() == 0) return false;
      if (to == null || to.length() == 0) return false;

      String from_val = rqst.getParameter(from).trim();
      if (from_val == null || from_val.length() == 0) return false;
      from_val = com.webapp.utils.SQLHelper.escapeQuote(from_val);

      String to_val = rqst.getParameter(to).trim();
      if (to_val == null || to_val.length() == 0) return false;
      to_val = com.webapp.utils.SQLHelper.escapeQuote(to_val);

      vt.add(" `" + TableName + "`.`" + field + "` BETWEEN  " + from_val + "  AND  " + to_val + "  ");
      return true;
    } // End method - addNumberInRangeParam(String TableName, String field, String from, String to )



  public boolean addDateParam(String TableName, String param, String cmpr)
    {
      String DateStr = null;
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      if (rqst.getParameter(param) == null) return false;
      DateStr = rqst.getParameter(param + "Year") + "-" + rqst.getParameter(param + "Month") + "-" + rqst.getParameter(param + "Day");
      vt.add(" `" + TableName + "`.`" + param + "` " + cmpr + " '" + DateStr + "'");
      return true;
    } // End method - addDateParam(String TableName, String param , String cmpr )

  /* addCalDateParam is for reading Calender style date input*/
  public boolean addCalDateParam(String TableName, String param, String sepr, String cmpr)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String FieldValue = rqst.getParameter(param);

	  if (FieldValue == null || FieldValue.length()==0 ) 
	  {
		if( ! "null".equalsIgnoreCase(cmpr) ) return false;
	  }
	  if( "null".equalsIgnoreCase(cmpr) ) 
	  {
		vt.add(" `" + TableName + "`.`"+param+"` IS NULL  "); 
		return true;  
	  }

      String[] StrParts = FieldValue.split(sepr);
      if (StrParts.length != 3) return false;
      String DateStr = StrParts[2] + "-" + StrParts[1] + "-" + StrParts[0];
      vt.add(" `" + TableName + "`.`" + param + "` " + cmpr + " '" + DateStr + "'");
      return true;
    } // End method - addCalDateParam(String TableName, String param ,String sepr, String cmpr )

  public boolean addDateInRange(String TableName, String datefield, String DateFromCtrl, String DateToCtrl)
    {

      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;

      String CriteriaFrom = null;
      String CriteriaTo = null;

      java.sql.Date dtFrom = DateTimeHelper.requestDatePicker(this.rqst, DateFromCtrl);
      java.sql.Date dtTo = DateTimeHelper.requestDatePicker(this.rqst, DateToCtrl);

      String sFrom = (dtFrom != null) ? dtFrom.toString() : " ";
      String sTo = (dtTo != null) ? dtTo.toString() : " ";

      CriteriaFrom = SQL(" `" + TableName + "`.`" + datefield + "` >= '" + sFrom + "' ");
      CriteriaTo = SQL(" `" + TableName + "`.`" + datefield + "` <= '" + sTo + "' ");

      if (dtFrom != null) this.addCriterion(CriteriaFrom);
      if (dtTo != null) this.addCriterion(CriteriaTo);

      return true;
    } // End method - addDateInRange(String TableName, String datefield, String DateFromCtrl, String DateToCtrl)
	
  /* addCalDateTimeParam is for reading Calender style date input*/
  public boolean addCalDateTimeParam(String TableName, String param, String cmpr)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String FieldValue = rqst.getParameter(param);

	  if (FieldValue == null || FieldValue.length()==0 ) 
	  {
		if( ! "null".equalsIgnoreCase(cmpr) ) return false;
	  }
	  if( "null".equalsIgnoreCase(cmpr) ) 
	  {
		vt.add(" `" + TableName + "`.`"+param+"` IS NULL  "); 
		return true;  
	  }
	  
	  java.sql.Timestamp tm = DateTimeHelper.requestDateTimePicker(this.rqst, param);
	  String tmStr = (tm != null) ? tm.toString() : " ";
      vt.add(" `" + TableName + "`.`" + param + "` " + cmpr + " '" + tmStr + "'");
      return true;
    } // End method - addCalDateTimeParam(String TableName, String param, String cmpr )

  public boolean addDateTimeInRange(String TableName, String datetimefield, String TmFromCtrl, String TmToCtrl)
    {

      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;

      String CriteriaFrom = null;
      String CriteriaTo = null;

      java.sql.Timestamp tmFrom = DateTimeHelper.requestDateTimePicker(this.rqst, TmFromCtrl);
      java.sql.Timestamp tmTo = DateTimeHelper.requestDateTimePicker(this.rqst, TmToCtrl);

      String sFrom = (tmFrom != null) ? tmFrom.toString() : " ";
      String sTo = (tmTo != null) ? tmTo.toString() : " ";

      CriteriaFrom = SQL(" `" + TableName + "`.`" + datetimefield + "`  >= '" + sFrom + "' ");
      CriteriaTo = SQL(" `" + TableName + "`.`" + datetimefield + "`  <= '" + sTo + "' ");

      if (tmFrom != null) addCriterion(CriteriaFrom);
      if (tmTo != null) addCriterion(CriteriaTo);

      return true;
    } // End method - addDateTimeInRange(String TableName, String datetimefield, String TmFromCtrl, String TmToCtrl)

  public boolean addDateTimeInRange2Field(String TableName, String datetimefieldFrom, String datetimefieldTo)
    {

      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;

      String CriteriaFrom = null;
      String CriteriaTo = null;

      java.sql.Timestamp tmFrom = DateTimeHelper.requestDateTimePicker(this.rqst, datetimefieldFrom);
      java.sql.Timestamp tmTo = DateTimeHelper.requestDateTimePicker(this.rqst, datetimefieldTo);

      String sFrom = (tmFrom != null) ? tmFrom.toString() : " ";
      String sTo = (tmTo != null) ? tmTo.toString() : " ";

      CriteriaFrom = SQL(" `" + TableName + "`.`" + datetimefieldFrom + "`  >= '" + sFrom + "' ");
      CriteriaTo = SQL(" `" + TableName + "`.`" + datetimefieldTo + "`  <= '" + sTo + "' ");

      if (tmFrom != null) addCriterion(CriteriaFrom);
      if (tmTo != null) addCriterion(CriteriaTo);

      return true;
    } // End method - addDateTimeInRange2Field(String TableName, String datetimefieldFrom, String datetimefieldTo)

  public boolean addGroupBy(String TableName, String param)
    {
      if (rqst == null) return false;
      if (TableName == null || TableName.length() == 0) return false;
      String fldValue = param;
      if (fldValue == null) return false;
      if (fldValue.length() == 0) return false;
      groupby = " GROUP BY `" + TableName + "`.`" + fldValue + "` ";
      return true;
    } // End method - addGroupBy(String TableName, String param )

  public void setTablename(String tbl)
  {
    tablename = tbl;
  }
  
  public String setOrderByClause(String TableName, String fldname, boolean repl)
  {
    if (TableName == null || TableName.length() == 0) return "";
	if (fldname == null || fldname.length() == 0) return "";
    orderbyclause = " ORDER BY `" + TableName + "`.`" + fldname + "` ";
    if (repl == true) orderbyclause = psql.SQL(orderbyclause);
    return orderbyclause;
  }// End method - setOrderByClause(String TableName, String fldname, boolean repl)
  
  public String getSQL(boolean repl)
    {
      if (tablename == null) return "ERROR:TABLENAME NOT SET";
      sql.append("SELECT * FROM `" + tablename + "`");
      int n = vt.size();
      if (n > 0)
      {
        sql.append(" WHERE ");
        for (int i = 0; i < n; i++)
        {
          sql.append((String) vt.get(i));
          if (i < (n - 1)) sql.append(" AND ");
        }
      }
      if (orderbyclause != null) sql.append(orderbyclause);

      if (repl == true) return psql.SQL(sql.toString());
      else return sql.toString();

    } // End method getSQL()

  // Default wrapper for getSQL()
  public String getSQL()
  {
    return getSQL(true);
  }

  public String getWhereClause(boolean repl)
    {
      StringBuffer whr = new StringBuffer();
      //	sql.append("SELECT * FROM "+tablename);
      int n = vt.size();
      if (n > 0)
      {
        whr.append(" WHERE ");
        for (int i = 0; i < n; i++)
        {
          whr.append((String) vt.get(i));
          if (i < (n - 1)) whr.append(" AND ");
        }
        if (groupby != null && groupby.length() > 0) whr.append(groupby);
      }

      if (repl == true) return psql.SQL(whr.toString());
      else return whr.toString();
    }
    // Default wrapper for getWhereClause()
  public String getWhereClause()
    {
      return getWhereClause(true);
    } // End method getWhereClause()

  public String getOrderByClause(String TableName, String param, boolean repl)
  {
    if (rqst == null) return "";
    if (TableName == null || TableName.length() == 0) return "";

    String fldValue = rqst.getParameter(param).trim();
    if (fldValue == null || fldValue.length() == 0) return "";
    orderbyclause = " ORDER BY `" + TableName + "`.`" + fldValue + "` ";
    if (repl == true) orderbyclause = psql.SQL(orderbyclause);
    return orderbyclause;
  }

  // Default wrapper for getOrderByClause(String param)

  public String getOrderByClause(String TableName, String param)
  {
    return getOrderByClause(TableName, param, true);
  }


  public String getInClauseFromList(String TableName, String field, ArrayList < String > arylist, boolean bString)
    {
      if (TableName == null || TableName.length() == 0) return "";
      if (field == null || field.length() == 0) return "";
      if (arylist == null || arylist.size() == 0) return "";
      StringBuilder sb = new StringBuilder();
      sb.append(" `" + TableName + "`.`" + field + "` IN ( ");
      int i = 0;
      Iterator < String > it = arylist.iterator();
      while (it.hasNext())
      {
        String item = it.next().trim();
        if (item == null || item.length() == 0) continue;
        if (i > 0) sb.append(", ");
        if (bString == true)
        {
          sb.append("'" + item + "'");
        }
        else
        {
          sb.append(item);
        }
        i++;
      } // end while
      sb.append(" ) ");
      if (i > 0) return psql.SQL(sb.toString());
      else return "";
    } // End method - getInClauseFromList(String TableName, String field, ArrayList<String> arylist, boolean bString)

  public Vector vt = new Vector();;
  public String tablename;
  public StringBuffer sql = new StringBuffer();
  public String groupby = "";
  public String orderbyclause;
  private HttpServletRequest rqst = null;
  private com.webapp.utils.PortableSQL psql = null;

} // END Class definition appMakeQueryString
<%
int nModuleID = 0;
try
{
   nModuleID = Integer.parseInt(request.getParameter("M"));
}
catch(NumberFormatException ex)
{ 
   nModuleID = 0;
}

ForeignKeyParam.append("&M="+nModuleID+"") ;

com.db.$DATABASE.Sitemanager_authorizationBean SiAthBn = new com.db.$DATABASE.Sitemanager_authorizationBean();

// Action authorization || Enable : true & Disable : false

ArrayList<String> AuthItems = new ArrayList<String>();
SiAthBn.openTable("WHERE `AdminID`="+LogUsr.AdminID+" AND `ModuleID`="+nModuleID+" ","");
while(SiAthBn.nextRow())
{
	if(StringUtils.isBlank(SiAthBn.ModuleActivityID) == true)
	{
	 bAllowAdd = false ;
	 bAllowUpdate = false ;
	 bAllowDelete = false ;
	}
	else
	{
	AuthItems = CSVHelper.arrayListFromCsv(SiAthBn.ModuleActivityID);

	if(AuthItems.contains("1") ) bAllowAdd = true ;
	if(AuthItems.contains("2") ) bAllowUpdate = true ;
	if(AuthItems.contains("3") ) bAllowDelete = true ;
	}
}
SiAthBn.closeTable();

int Mno=0;
StringBuilder ModuleSB = new StringBuilder();
ArrayList<String> ModuleAL = new ArrayList<String>();

boolean mbAllowDataBase = false ;
boolean mbSMS = false;

  if(SiAthBn.locateOnField("AdminID", ""+SiMngrBn.AdminID))
  {
    SiAthBn.openTable("WHERE `AdminID`="+LogUsr.AdminID+" ","");
    while(SiAthBn.nextRow())
    {
      if(Mno>0) ModuleSB.append(",");
      ModuleSB.append(SiAthBn.ModuleID);
      Mno++;
    }
    SiAthBn.closeTable();
    ModuleAL = CSVHelper.arrayListFromCsv(""+ModuleSB);
    
    if(ModuleAL.contains("1") ) mbAllowDataBase = true ;
	if(ModuleAL.contains("2") ) mbSMS = true ;
  }

%>
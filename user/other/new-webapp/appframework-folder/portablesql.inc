<%! 
String _SQL_ENGINE = null ;
com.webapp.utils.PortableSQL _psql=null ;
public void jspInit() 
{
    ServletContext _cntx = getServletConfig().getServletContext() ;
   _SQL_ENGINE = _cntx.getInitParameter("SQL-ENGINE");
   _psql = new com.webapp.utils.PortableSQL(_SQL_ENGINE);
   _gdb  = new com.webapp.db.GenericQuery( ApplicationResource.database, _SQL_ENGINE ) ;
}
String _PSQL(String in )
{
     return _psql.SQL(in);
}

com.webapp.db.GenericQuery _gdb = null ;
%>
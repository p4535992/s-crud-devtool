<% 
out.print("\r\n");
for (n=0 ; n<count ; n++)
{ 
  if( ((com.beanwiz.TableColumn)columns.get(n)).TypeOverride ) out.print("\r\n\t//Warning: JDBC data type of column: "+((com.beanwiz.TableColumn)columns.get(n)).ColName+" is overridden.\r\n\t//It is not wizard detected. ( not as per jdbc driver reported ) \r\n\r\n"); 
	out.print("    public "+((com.beanwiz.TableColumn)columns.get(n)).VarType+" "+((com.beanwiz.TableColumn)columns.get(n)).VarName+((com.beanwiz.TableColumn)columns.get(n)).NullInit+"  \r\n");
}
out.print("\r\n");
%>
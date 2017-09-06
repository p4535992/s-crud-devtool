<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, org.apache.commons.io.FileUtils, org.apache.commons.io.IOUtils, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="DbBkpBn" scope="page" class="com.db.$DATABASE.Daily_backupBean" />
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ; 

String dbPathDate ="";
java.sql.Date Today = DateTimeHelper.today();
SimpleDateFormat fmt = new SimpleDateFormat("dd-MMM-yyyy");
dbPathDate = fmt.format(Today);


//ALTERNATE CODE
/*
List cmdAndArgs = Arrays.asList({"cmd", "/c", "QUIZBACKUP.BAT"});
File dir = new File("C:\\Backup");

ProcessBuilder pb = new ProcessBuilder(cmdAndArgs);
pb.directory(new File(dir));
Process p = pb.start();
*/

try 
{
	Process p = Runtime.getRuntime().exec("cmd /c BACKUP.BAT", null, new File("D:\\Backup"));
	p.waitFor();
	InputStream is = p.getInputStream();
	
BufferedInputStream in = new BufferedInputStream(is);
byte[] contents = new byte[1024];

int bytesRead = 0;
String strFileContents = ""; 
while((bytesRead = in.read(contents)) != -1) { 
    strFileContents += new String(contents, 0, bytesRead);              
}

//out.print(strFileContents);	
	/*
	  int i = 0;
    while( (i = is.read() ) != -1) {
        out.print((char)i);
    }
	*/
	
    DbBkpBn.BackupID= 0;
    DbBkpBn.Path = "D:/Backup/Daily-Backup/"+dbPathDate.toUpperCase()+"/"+strFileContents+" ";
		DbBkpBn.FileName = " "+strFileContents+" ";
		DbBkpBn.PathDate = dbPathDate ;
		DbBkpBn.BackupDate = Today ;
    DbBkpBn.DateTime = new java.sql.Timestamp(System.currentTimeMillis());	
		DbBkpBn.Flag = BackupFlag.CREATE ; // 1 : Add And 2 : Delete
		DbBkpBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());	
    DbBkpBn.addRecord();
				
} catch (Exception e) {
    e.printStackTrace();
}
%>
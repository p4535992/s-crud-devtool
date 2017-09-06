package $WEBAPP ;
import com.db.$DATABASE.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	
import javax.servlet.*;
import javax.servlet.http.*;


public class Update$CTABLENAMEPhoto extends $CTABLENAME_photographBean
{
	private com.db.$DATABASE.$CTABLENAME_photographBean $BeanName = new com.db.$DATABASE.$CTABLENAME_photographBean() ;
	
	private HttpServletRequest request = null ;
	 
	public Update$CTABLENAMEPhoto(HttpServletRequest req )
	{
		this.request = req; 
	}
 
	public boolean update$CTABLENAMEPhotograph(int $IDFIELD, String UploadField )
	throws Exception
	{
		if(request ==null) return false ; 
			
		FileInputStream Photograph_Stream = new FileInputStream(request.getParameter(UploadField));
		int nsize = Photograph_Stream.available();
		if(nsize > 0)
		{	
			boolean rec_found = false ;
			
			if($BeanName.locateOnField("$IDFIELD",""+$IDFIELD)) rec_found = true ;
			
			$BeanName.$IDFIELD = $IDFIELD ;
			$BeanName.Photograph = new byte[Photograph_Stream.available()] ;
			Photograph_Stream.read( $BeanName.Photograph, 0, Photograph_Stream.available());
			$BeanName.FileSize = nsize;
			$BeanName.FileName = request.getParameter( UploadField+".filename" );
			$BeanName.MIMEType = request.getParameter( UploadField+".content-type" );
			$BeanName.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()) ;		

			// Add or update 
			if(rec_found) 
			{
			  $BeanName.updateRecord($BeanName.RecordID);	
			}	
			else 
			{
			  $BeanName.RecordID = 0 ;
			  $BeanName.addRecord();
			}
			return true ;
		}
		
		return false ;
	} // end updatePhotograph

	public boolean update$CTABLENAMEPhotographFromByteArray(int $IDFIELD, byte[] phbytes, String mimetype )
	throws Exception
	{
		if(request ==null) return false ; 
		if(phbytes ==null) return false;
		int nsize = phbytes.length;
		if(nsize > 0)
		{	
			boolean rec_found = false ;
			
			if($BeanName.locateOnField("$IDFIELD",""+$IDFIELD)) rec_found = true ;
			
			$BeanName.$IDFIELD = $IDFIELD ;
			$BeanName.Photograph = phbytes ;
			$BeanName.FileSize = nsize;
			$BeanName.FileName = "[Webcam Capture]";
			$BeanName.MIMEType = mimetype;
			$BeanName.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()) ;
			
			// Add or update 
			if(rec_found) 
			{
			  $BeanName.updateRecord($BeanName.RecordID);	
			}	
			else 
			{
			  $BeanName.RecordID = 0 ;
			  $BeanName.addRecord();
			}
			return true ;
		}
		
		return false ;
   } // end updateFromByteArray
}
package com.$WEBAPP.appmail;

public class MailErrorCodes
{
    public static final short NONE= 0;
    public static final short ABORTED = -1 ;
    public static final short BLANK =  -2;
    public static final short BADFORMAT= -3 ;
    public static final short MESSAGING_ERROR= -4 ;
    public static final short DATABASE_ERROR = -5 ;
		
    public static String getErrorCode(short code)
		{
         String ret ="Unknown Error" ;         
				 switch(code)
         {
				      case ABORTED:
							    ret = "Dispatch Aborted" ;
							    break;

				      case BLANK:
							    ret = "Blank Address" ;
							    break;

				      case BADFORMAT:
							    ret = "Invalid Email Address" ;
							    break;

				      case MESSAGING_ERROR:
							    ret = "Messaging Error" ;
							    break;
				      case DATABASE_ERROR:
							    ret = "Database Error" ;
							    break;

									

         }// end switch				 		
         return ret;		
		}    // end method 

}  // end class definition


package com.$WEBAPP.appsms;

public class SMSErrorCodes
{
    public static final short UNKNOWN = 0;
    public static final short ABORTED = -1 ;
    public static final short BLANK =  -2;
    public static final short BADFORMAT= -3 ;
    public static final short SMS_TOO_LONG=-4;
    public static final short NETWORKERROR= -10 ;
    public static final short SMSCERROR = -20 ;


		public static String getLabel(short code)
		{
		    String ret="";
				switch( code )
				{
            case UNKNOWN :	
						     ret = "Unknown" ;		
						break ;
								 	
            case ABORTED :	
						     ret = "Aborted" ;		
						break ;
								 	
            case BLANK :	
						     ret = "Blank number" ;		
						break ;
								 	
            case BADFORMAT :	
						     ret = "Invalid number" ;		
						break ;
								 	
            case SMS_TOO_LONG :	
						     ret = "SMS too long" ;		
						break ;

            case NETWORKERROR :	
						     ret = "Network connection error" ;		
						break ;
						
            case SMSCERROR :	
						     ret = "SMS center error" ;		
						break ;
								 	
            default:
						     ret = "Unknown" ;				
				
				}
        return ret ;		
     } // End method getLabel(short item)
} // End class definition

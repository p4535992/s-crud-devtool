package com.$WEBAPP.appsms;

public class SMSServerResponse
{
  public static final short UNKNOWN =0 ;
	public static final short HTTP = 1;
	public static final short SMPP = 2;
	public static final short COMPORT = 3;
	
	
  public short protocol=0;
  public short ReturnVal =0;
	public int StatusCode=0;
	public String Response = null;
	public int MsgCount = 0 ;
	public String[] SendStatus = null ;
	

}
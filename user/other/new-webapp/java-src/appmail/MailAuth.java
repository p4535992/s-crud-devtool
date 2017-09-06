package com.$WEBAPP.appmail;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.*; 
import java.security.*;
import javax.activation.*;

public class MailAuth extends javax.mail.Authenticator
{
	    private String username ;
	    private String password ;
	    MailAuth( String uname, String pwd )
	    {
	        this.username = uname ;
			    this.password = pwd ;
	    }
	    protected PasswordAuthentication getPasswordAuthentication()
	    {
	        return new PasswordAuthentication(username,password);
	    }
	 
} // Class definition ends here


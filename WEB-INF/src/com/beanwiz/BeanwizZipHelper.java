package com.beanwiz ;

import java.io.*;
import java.util.*;
import java.util.zip.*;
import org.apache.commons.io.IOUtils ;

public class BeanwizZipHelper
{
    
    public static int extractToFolder(String zipfile, String foldername)
		throws java.io.IOException
    {
		    if(foldername==null||foldername.length()==0 ||  zipfile==null || zipfile.length()==0) return 0;
				
        int cnt=0;
		    // Create necessary foler if it does not exis
				new File(foldername).mkdirs();
        ZipFile zip = new ZipFile(zipfile);
        Enumeration entrs = zip.entries();		 
				// Process each entry
        while (entrs.hasMoreElements())
        {
				     ZipEntry entry = (ZipEntry) entrs.nextElement();
             String cur_entry  = entry.getName();
						 File dest_file = new File(foldername, cur_entry);
						 // Create additional directory path in case cur_entry has multiple sub folders
						 File dest_folder = dest_file.getParentFile();
             dest_folder.mkdirs(); 
						 
						 // For regular files which are not directories
						 if (!entry.isDirectory())
             {
						    InputStream is = zip.getInputStream(entry);
								OutputStream os = new FileOutputStream(dest_file);
						    IOUtils.copy(is,os) ;
                os.flush();
                os.close();
                is.close();
								cnt++;
						 }
				
        } // end extract loop
				  
        return cnt;
    }	

		 public static int zipFolder(String folder, String zipfile)
		 throws java.io.IOException 
		 {
		       File delOld = new File(zipfile);
				   if(delOld.exists()) delOld.delete();
				   int count=0; 
				 
				   File mainfolder = new File(folder);
				   String parent = folder;
				   if(mainfolder.getParentFile()!=null)
				   {
				         parent = mainfolder.getParentFile().getCanonicalPath() ;
				   }
				   else
				   {
				         parent=folder ;
				   }
  				 ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipfile));
	   			 count = folderToZipStream(parent, folder,zos);
			  	 zos.flush();
				   zos.close();
				   return count ;
		 }
		
		 public static int folderToZipStream(String root , String folder, ZipOutputStream zos)
		 throws java.io.IOException 
		 {
		     if(folder==null || folder.length()==0 || zos==null ) return -1;
		     int cnt =0;
 			 // target is file object representing folder to zip   
         File   target = new File(folder); 
				 if(!target.exists())return -1;
				 String[] dirlist = target.list(); 
				 for(int i=0; dirlist!=null&& i<dirlist.length; i++) 
         { 
				      File fl = new File(target, dirlist[i]); 
							File rootFile = new File(root);
							 // Call this method recursively for all sub-folders
							ZipEntry entr =null;
	 
						  if(fl.isDirectory()) 
              {
								  String filePath = fl.getPath(); 
                  cnt += folderToZipStream(root, filePath, zos); 
              }
							else
							{
							    String zipentry_path = fl.getCanonicalPath().substring( rootFile.getCanonicalPath().length() + 1, fl.getCanonicalPath().length());
							    entr = new ZipEntry(zipentry_path); 
							    zos.putNextEntry(entr); 
							    FileInputStream fis = new FileInputStream(fl); 
									IOUtils.copy(fis,zos) ;
									fis.close();
									cnt++;
							}
				 
				 }// end for
		     return cnt;
		 }
		
		


} // End class definition
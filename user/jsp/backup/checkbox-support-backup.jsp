<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
String TableName = request.getParameter("TableName")  ;
String IDField  = request.getParameter("IDField")  ;

%>
// Support for check boxes in data list.


function CheckAllItems() 
{
     $('#<%=TableName %>_list' ).checkCheckboxes("input[name='<%=IDField  %>']"); 
     return false;
}

function UnCheckAllItems()
{
     $('#<%=TableName %>_list' ).unCheckCheckboxes("input[name='<%=IDField  %>']");
     return false;
}
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='<%=IDField  %>']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Please confirm\nDelete ( "+sel_count+" ) checked items ?" ;
		 
		 if(sel_count==0)
		 {
		   alert("You must check at least some items for batch deletion.");
			 return false ;
		  
		 }
		 
		 if(confirm(msg))
		 {
    		 $("#CheckedAction").val("Delete");
				 $('#<%=TableName %>_list' ).submit();
		 }	
		 return false;	 
} 

function CheckedActivity()
{
     var sel_items_actv = $("input[name='<%=IDField  %>']").fieldArray();
	   var sel_count_actv = ( sel_items_actv !=null ) ?  sel_items_actv.length: 0 ;
		 var msg = "Please confirm\nActivity for ( "+sel_count_actv+" ) checked items ?" ;
		 
		 if(sel_count_actv==0)
		 {
		   alert("You must check at least some items for checked activity");
			 return false ;
		 }
		 if(confirm(msg))
		 {
    		 $("#CheckedAction").val("Activity");
				 $('#<%=TableName %>_list' ).submit();
		 }	
		 return false;	
		 
}


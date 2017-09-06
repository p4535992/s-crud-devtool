<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
String TableName = request.getParameter("TableName")  ;
String IDField  = request.getParameter("IDField")  ;
String bDatatablesJSCSS = request.getParameter("DatatablesJSCSS") ;
%>
// Support for check boxes in data list.

$("#<%=TableName%>_Result_checkall").click(function () {
   if ($("#<%=TableName%>_Result_checkall").is(':checked')) {
        $("#<%=TableName%>_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);<% if(bDatatablesJSCSS.equalsIgnoreCase("true")){%>
					$('table.wdatatable').DataTable().rows().select();//for TR select<% } %>
      });
   } else {
        $("#<%=TableName%>_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);<% if(bDatatablesJSCSS.equalsIgnoreCase("true")){%>
					$('table.wdatatable').DataTable().rows().deselect();//for TR Deselect<% } %>
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='<%=IDField  %>']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Really want to Delete ( "+sel_count+" ) checked items ?" ;
		
		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item for Deletion !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Are you sure?',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Delete");
            $('#<%=TableName %>_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 

function CheckedActivity()
{
     var sel_items_actv = $("input[name='<%=IDField  %>']").fieldArray();
	   var sel_count_actv = ( sel_items_actv !=null ) ?  sel_items_actv.length: 0 ;
		 var msg = "Activity for ( "+sel_count_actv+" ) checked items ?" ;
		 
		 if(sel_count_actv==0)
		 {
		   swal({title: '',text: 'You must check at least one item for checked activity !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Please confirm !',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Activity");
            $('#<%=TableName %>_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 

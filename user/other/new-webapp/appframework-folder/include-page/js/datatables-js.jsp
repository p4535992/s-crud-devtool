<% String appPath=request.getContextPath(); %>
<!-- Datatables -->
<script src="<%=appPath %>/global/vendor/datatables/datatables.min.js"></script>
<script>
$(document).ready( function () {


  var dtCbsAndEvents = {
    /**
     * Whenever the table is re-drawn, update the export button labels, and disable any buttons dependent on row selection
     * 
     * @events  draw.dt#orders-table, page.dt#orders-table, order.dt#orders-table, draw.dt#orders-table, 
     *          column-visibility.dt#orders-table, search#orders-table, init.dt#orders-table, deselect.dt#orders-table, 
     *          select.dt#orders-table 
     * @param   {object}                e           jQuery event object
     * @param   {DataTables.Settings}   settings    DataTables settings object
     */
    updateOperationButtons: function ( e, settings ){ //page, order, draw, column-visibility search init.dt deselect.dt select.dt
        // I find that setting this to run after a 1 millisecond timeout to work for the dt.init event, otherwise, it doesnt seem to work...
        setTimeout(function(){
                // Create an API object of the associated table
            var dtApi               = new $.fn.dataTable.Api( settings ),
                // Get the count of ALL rows on the page
                rowCountAll         = dtApi.rows().count(),
                // Get the count of the rows on the CURRENT page
                rowCountPage        = dtApi.rows( { page: 'current', search: 'applied' } ).count(),
                // Get the count of the selected rows
                rowCountSelected    = dtApi.rows( { selected: true, search: 'applied' } ).count(),
                // DataTable button collections (labels get updated to specific values based on the class name)
                dtBtns              = {
                    // Buttons that require selected rows to be enabled
                    requireSelected  : dtApi.buttons( '.require-selected' ),
                    // Buttons that need to show the count of ALL rows
                    addCountAll      : dtApi.buttons( '.show-count-all' ),
                    // Buttons that need to show the count of SELECTED rows
                    addCountSelected : dtApi.buttons( '.show-count-selected' ),
                    // Buttons that need to show the count of rows on CURRENT PAGE
                    addCountPage     : dtApi.buttons( '.show-count-page' ),
                    // Buttons that need to show the count of SELECTED rows, or ALL if none are selected
                    allOrSelected    : dtApi.buttons( '.show-all-or-selected' )
                },            
                /**
                 * If the number provided is in the thousands, this will just add a comma where its needed
                 *
                 * @param   {number|string}     num     Number (eg: 1234567)
                 * @returns {string}  Proper thousands result (eg: 12,34,567)
                 */
                toThousands         = function( num ){
                    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
                },
                /**
                 * Update the label (or text) of a button, by appending a specified count of 
                 * rows to the buttons 'title' attribute
                 *
                 * @param   {number}    rowCount    Count to show in button
                 * @param   {boolean}   hideZero    If this is true, and the row count is 0, then (0) wont be appended
                 * @note    The DT button MUST have the titleAttr property defined, as that is the $().prop('title') value
                 */
                setBtnLabelCount    = function ( rowCount, hideIfZero ){
                    rowCount = parseInt( rowCount )
                    hideIfZero = !!hideIfZero

                    var btnPostTxt

                    if( hideIfZero === true && ! rowCount )
                      btnPostTxt = ''
                    
                    else 
                      btnPostTxt = ' ' + ( rowCount > 0 ? '(' + toThousands( rowCount ) + ')' : '(0)')

                    return function( btn, index ){
                        dtApi
                            .button( btn.node )
                            .text( $( btn.node ).prop( 'title' ) +  btnPostTxt )
                    }
                }

            // Buttons that need to show the selected rows, or all rows, if none are selected
            dtBtns.allOrSelected.each( setBtnLabelCount( rowCountSelected || rowCountAll ) )

            // Buttons that need to show the count of all rows
            dtBtns.addCountAll.each( setBtnLabelCount( rowCountAll ) )

            // Buttons that need to show the count of only selected rows
            dtBtns.addCountSelected.each( setBtnLabelCount( rowCountSelected, true ) )

            // Buttons that need to show the number of rows on the current page
            dtBtns.addCountPage.each( setBtnLabelCount( rowCountPage ) )

            // Buttons that should be disabled if no rows are selected
            dtBtns.requireSelected.enable( rowCountSelected > 0 )   
						
						if(rowCountSelected > 0) {
								$( '.dt-selected-rows' ).show();
								$( '.dt-all-rows' ).hide();
						}		
						else {
								$( '.dt-selected-rows' ).hide();
								$( '.dt-all-rows' ).show();
						}     
        }, 1)
    }
  }
  
  var dtInstance = $('table.wdatatable')
  // Update the operation button values and disabled status based on what rows are visible/selected/filtered
  .on( 'draw.dt page.dt order.dt draw.dt column-visibility.dt search init.dt deselect.dt select.dt', dtCbsAndEvents.updateOperationButtons )  
  .DataTable({
    select: { 
       style: 'multi+shift',
			 selector: 'td:first-child :checkbox'
    },
        //"stateSave": true, /*State saving*/
				"processing": true,
        "paging": false,
        "ordering": false,
        "info": false,
				"language": {  /* Comma decimal place */
            "decimal": ".",
            "thousands": ","
        },
			//"scrollX": true, /* Scroll - horizontal */
			//"bAutoWidth": false,// width="100%"
				"lengthChange": false,

   // ,buttons: []
  //});


  // DataTables Buttons (Export, select, column visibility, etc)
  //  new $.fn.dataTable.Buttons( dtInstance, {

buttons: [					
					{
             extend:    'colvis',
             text:      '<span class="fa fa-eye fa-lg"></span>&nbsp;&nbsp;Visibility',
						 className: 'btn-outline btn-dark',// btn-primary
             titleAttr: 'Column visibility',
						 postfixButtons: [ 'colvisRestore' ]
						 //,collectionLayout: 'fixed two-column'
          },
						{
             extend: 'collection',
             text: '<i class="fa fa-magic fa-lg"></i>&nbsp;&nbsp;Export',
						 className: 'btn-outline btn-dark dt-all-rows',// btn-primary
						 titleAttr: 'Export (Page)',
						 autoClose: true,
             buttons: [
      						       {  
      						       extend: 'copy',
      									 text: '<i class="fa fa-files-o"></i> Copy',
                         exportOptions: { columns: ':visible'}
      									 }, 
      						       {  
      						       extend: 'excel',
      									 text: '<i class="fa fa-file-excel-o"></i> Excel',
                         exportOptions: { columns: ':visible'}
      									 },
												 /*
      						       {  
      						       extend: 'csv',
      									 text: '<i class="fa fa-file-text-o"></i> CSV',
                         exportOptions: { columns: ':visible'}
      									 },
												 */ 
      						       {  
      						       extend: 'pdf',
      									 text: '<i class="fa fa-file-pdf-o"></i> PDF',
                         exportOptions: { columns: ':visible'},
												 download: 'open'
												 //,orientation: 'landscape'
                         //,pageSize: 'LEGAL'
												 },
												 {  
      						       extend: 'print',
      									 text: '<i class="fa fa-print"></i> Print',
                         exportOptions: { columns: ':visible'},
												 autoPrint: false,
												 customize: function ( win ) {
                                $(win.document.body)
                                    .css( 'font-size', '10pt' )
																		.css( 'padding-top', '0')
																		.css( 'margin', '10px')
																		//.prepend('<img src="http://datatables.net/media/images/logo-fade.png" style="position:absolute;display: block;margin: 0 auto;" />');
                                    //.prepend('<img src="http://localhost/$WEBAPP/admin/teachers/1.png" style="position:absolute; top:0; left:0;" />');
             												//.prepend( $( '<img />' ).attr('src','https://sasset.io/wp-content/uploads/2015/08/sasset_logo-300x87.png').addClass('asset-print-img') )
                                $(win.document.body).find( 'table' )
                                    .addClass( 'compact' )
																		.css( {
																		    'font-size': 'inherit'
                                        /* Etc CSS Styles..*/
                                    } );
                            }
      									 },
												 {
                            text: '<span class="fa fa-file-code-o"></span> JSON',
                            action: function ( e, dt, button, config ) {
                                var data = dt.buttons.exportData();
             
                                $.fn.dataTable.fileSave(
                                    new Blob( [ JSON.stringify( data ) ] ),
                                    'Export.json'
                                );
                            }								 
												 } 
                       ]
              },
							
							
						{
             extend: 'collection',
             text: '<i class="fa fa-magic fa-lg"></i>&nbsp;&nbsp;Export',
						 className: 'btn-outline btn-dark show-count-selected dt-selected-rows',// btn-primary
						 titleAttr: '<i class="fa fa-magic fa-lg"></i>&nbsp;&nbsp;Export',
						 autoClose: true,
             buttons: [
      						       {  
      						       extend: 'copy',
      									 text: '<i class="fa fa-files-o"></i> Copy',
                         exportOptions: { columns: ':visible', modifier: {selected: true, search: 'applied', order: 'applied'}}
      									 }, 
      						       {  
      						       extend: 'excel',
      									 text: '<i class="fa fa-file-excel-o"></i> Excel',
                         exportOptions: { columns: ':visible', modifier: {selected: true, search: 'applied', order: 'applied'}}
      									 },
												 /*
      						       {  
      						       extend: 'csv',
      									 text: '<i class="fa fa-file-text-o"></i> CSV',
                         exportOptions: { columns: ':visible', modifier: {selected: true, search: 'applied', order: 'applied'}}}
      									 },
												 */ 
      						       {  
      						       extend: 'pdf',
      									 text: '<i class="fa fa-file-pdf-o"></i> PDF',
                         exportOptions: { columns: ':visible', modifier: {selected: true, search: 'applied', order: 'applied'}},
												 download: 'open'
												 //,orientation: 'landscape'
                         //,pageSize: 'LEGAL'
												 },
												 {  
      						       extend: 'print',
      									 text: '<i class="fa fa-print"></i> Print',
                         exportOptions: { columns: ':visible', modifier: {selected: true, search: 'applied', order: 'applied'}},
												 autoPrint: false,
												 customize: function ( win ) {
                                $(win.document.body)
                                    .css( 'font-size', '10pt' )
																		.css( 'padding-top', '0')
																		.css( 'margin', '10px')
																		//.prepend('<img src="http://datatables.net/media/images/logo-fade.png" style="position:absolute;display: block;margin: 0 auto;" />');
                                    //.prepend('<img src="http://localhost/$WEBAPP/admin/teachers/1.png" style="position:absolute; top:0; left:0;" />');
             												//.prepend( $( '<img />' ).attr('src','https://sasset.io/wp-content/uploads/2015/08/sasset_logo-300x87.png').addClass('asset-print-img') )
                                $(win.document.body).find( 'table' )
                                    .addClass( 'compact' )
																		.css( {
																		    'font-size': 'inherit'
                                        /* Etc CSS Styles..*/
                                    } );
                            }
      									 } 
                       ]
              }
        ]				
    } );
  
		 $('table.wdatatable').addClass('nowrap');
		 $(".dataTables_filter").hide(); 
		 $('<div class="panel panel-transparent margin-bottom-0"><div class="panel-body padding-0" id="panel_Dtable_header"><div class="row"><div class="col-sm-6 col-md-4 panel_Dtable_First" ></div><div class="col-sm-2 col-md-5 panel_Dtable_Second"></div><div class="col-sm-4 col-md-3 panel_Dtable_Third text-right"></div></div></div></div>').insertBefore(".wd-table-responsive");
		 $('<div class="input-group input-group-icon"><input type="search" class="form-control" id="searchbox" placeholder="Search..." /><span class="blue-grey-600 input-group-addon"><span aria-hidden="true" class="fa fa-filter fa-lg"></span></span></div>').appendTo('#panel_Dtable_header .panel_Dtable_Third');				
     $("#searchbox").keyup(function() { dtInstance.search($(this).val()).draw() });
		 $('table.wdatatable').DataTable().buttons().container().appendTo( '#panel_Dtable_header .panel_Dtable_First' );
 

} );
</script>
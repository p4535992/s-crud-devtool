<% 
String appPath=request.getContextPath(); 
String exportType = request.getParameter("exportType");
%>
<!-- bootstrap-table -->
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/bootstrap-table.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/tableExport/FileSaver.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/tableExport/jspdf.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/tableExport/jspdf.plugin.autotable.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/tableExport/html2canvas.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/tableExport/tableExport.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-table/js/extensions/export/bootstrap-table-export.min.js"></script>
<script type="text/javascript">
$.extend($.fn.bootstrapTable.defaults,{	

        exportTypes:[<%=exportType %>],
				buttonsClass: 'btn btn-outline btn-dark',
        iconsPrefix: 'fa', // glyphicon of fa (font awesome)
        icons: {
            refresh: 'fa-refresh',
            columns: 'fa-th-list',
						export: 'fa-share-square-o'
        },
				exportOptions: {
    				fileName: 'CMS-Data-Worksheet',
						worksheetName: 'CMS-Data-Worksheet',
						excelstyles:['border-bottom', 'border-top', 'border-left', 'border-right']
						//,htmlContent: true
				}
});
</script>

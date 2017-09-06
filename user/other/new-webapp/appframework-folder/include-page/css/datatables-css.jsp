<% String appPath=request.getContextPath(); %>
<!-- Datatables -->
<link rel="stylesheet" href="<%=appPath %>/global/vendor/datatables/datatables.min.css" />	
<style type="text/css">
div.dt-button-background {
  background: rgba(0, 0, 0, 0) radial-gradient(ellipse farthest-corner at center center , rgba(0, 0, 0, 0.1) 0%, rgba(0, 0, 0, 0.7) 100%) repeat scroll 0 0;
}

.wd-table-responsive {border: 0;}
.dt-buttons > .dt-all-rows:not(:first-child):not(:last-child):not(.dropdown-toggle) {
    border-bottom-right-radius: 3px;
    border-top-right-radius: 3px;
}
/*
table.dataTable tbody > tr.selected, table.dataTable tbody > tr > .selected {
  background-color: transparent;
}
*/
table.dataTable tbody tr.selected a, table.dataTable tbody th.selected a, table.dataTable tbody td.selected a {
  color: #ffffff;
	background-color: transparent;
}
table.dataTable tbody tr.selected i, table.dataTable tbody th.selected i, table.dataTable tbody td.selected i {
  color: #ffffff;
	background-color: transparent;
}
table.dataTable tbody tr.selected button, table.dataTable tbody th.selected button, table.dataTable tbody td.selected button {
  color: #ffffff;
	background-color: transparent;
} 
table.dataTable tbody > tr.selected, table.dataTable tbody > tr > .selected {
  background-color: #5f5f5f;
}
</style>
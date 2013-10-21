$(document).ready(function(){

	$('.example').on('click', function(event) {
		$("#url").val( $(this).attr("href") );
		event.preventDefault();
		$("#lookup").click();
		return false;
	});	
	
});
var entityMap = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': '&quot;',
    "'": '&#39;',
    "/": '&#x2F;'
  };

  function escapeHtml(string) {
    return String(string).replace(/[&<>"'\/]/g, function (s) {
      return entityMap[s];
    });
  }

$(document).ready(function(){

	$('.example').on('click', function(event) {
		$("#url").val( $(this).attr("href") );
		event.preventDefault();
		$("#lookup").click();
		return false;
	});	
	
	$('.embed').on('click', function(event) {
		$("#embed-modal-link").html(
		  "<pre>" + escapeHtml("<script src='" + $(this).attr("href") + "'></script>") + "</pre>"
        );
		
		$.get( $(this).attr("href"), function(html) {
			$("#embed-modal-html").html(
					"<pre>" + escapeHtml(html) + "</pre>"
            );
			$("#embed-modal").modal("show");
		} );
		event.preventDefault();
		return false;		
	});
	
});
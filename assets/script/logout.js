$(document).ready(function () {
	$("#logOutButton").on("click", function (e) {
                logOutCall();
    });
});
function logOutCall() {
	$.ajax({
		 url:"../cfc/designationCheck.cfc",
		 data: {
			 method : "doLogOut"
		},
		type:"GET",
		success: function(data){
			window.location.replace("login.cfm");

		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
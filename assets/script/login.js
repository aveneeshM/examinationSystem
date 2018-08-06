$(document).ready(function () {
	$("#user").on("blur", function (e) {
        if(checkEmpty("#user")){
        	 var patt = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
        	    if ($("#user").val().match(patt)) {
        	        $("#user").css("border", "1px solid #ccc");
        	        $("#user").text("");
        	        if(!userCheck()){
        	        	return false;
        	        };
        	    }
        	    else {
        	        $("#user").css("border", "1px solid #ff0000");
        	        $("#userError").text("Enter valid email address");
        	        return false;
        	    }
            
            }
        
    });
	$("#password").on("blur", function (e) {
        checkEmpty("#password");
    });
	
	$("#submitButton").on("click", function (e) {
		if(checkEmpty("#user")){
       	 var patt = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
       	    if ($("#user").val().match(patt)) {
       	        $("#user").css("border", "1px solid #ccc");
       	        $("#user").text("");
       	        userCheck();
       	    }
       	    else {
       	        $("#user").css("border", "1px solid #ff0000");
       	        $("#userError").text("Enter valid email address");
       	        return false;
       	    }}
		else{
			return false;
		}
       	 if(!checkEmpty("#password")){
       		
       		 return false;
       	 }
       	if($("#userError").text().length > 0){
       		alert("ga");
      		 return false;
      	 }
	

			doLogin();
		
		
    });
});


function checkEmpty(field){
	
    if($(field).val().length > 0){
        $(field).css("border", "1px solid #ccc");
        $(field+"Error").text("");
        return true;
    }
    else{       
        $(field).css("border", "1px solid #ff0000");
        $(field+"Error").text("Required Field");
        return false;
    }
}
function userCheck() {
	var returnVal = 1;
	$.ajax({
		 url:"../cfc/login.cfc",
		 data: {
			 method : "mailChecker",
			 email : $("#user").val()
		},
		type:"POST",

		success: function(data){
		console.log(data);
		if(data == "false"){
			 $("#user").css("border", "1px solid #ff0000");
		        $("#userError").text("Email Address not listed. SignUp!!");
		        returnVal=0;
		        
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	return returnVal;
}

function doLogin() {

	$.ajax({
		 url:"../cfc/login.cfc",
		 data: {
			 method : "doLogin",
			 email : $("#user").val(),
			 password : $("#password").val()
		},
		async: false,
		type:"POST",
		success: function(data){


		if(data == '"teacher"'){
			window.location = "teacherHome.cfm";
        }
		else if(data == '"student"'){
			window.location = "studentHome.cfm";
			}
		else{
			alert("UserID and Password do not match\n" +
					"Provide Correct Password");
			$("#loginForm")[0].reset();
			return false;
			
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});

}
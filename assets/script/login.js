$(document).ready(function () {
	$("#user").on("blur", function (e) {
        if(checkEmpty("#user")){
            if(!validateMail("#user"));
            
            }
        
    });
	$("#password").on("blur", function (e) {
        if(!checkEmpty("#password")){
        	 $("#passwordError").text("Password can not be empty!");
            }
    
    });
	
    //$("#loginForm").submit(validateForm) ;
	
});
function validateForm(){
var valid =0;

        if(checkEmpty("#user")){
            if(!validateMail("#user")){
            	valid =1;
            } }
            else{
            	$("#user").css("border", "1px solid #ff0000");
                $("#user"+"Error").text("Email address can not be empty");
            	valid = 1;
           
            }

        if(!checkEmpty("#password")){
        	 $("#passwordError").text("Password can not be empty!");
        	 valid = 1;
            }
        if(valid == 1){
        	return false;
        }
        if(!passwordCheck()){
        	return false;
        }
        designationCheck();

}
function checkEmpty(field){
	
    if($(field).val().length > 0){
        $(field).css("border", "1px solid #ccc");
        $(field+"Error").text("");
        return true;
    }
    else{       
        $(field).css("border", "1px solid #ff0000");
        $(field+"Error").text("Email address can not be empty");
        return false;
    }
}
function validateMail(mail) {
    var patt = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
    if ($(mail).val().match(patt)) {
        $(mail).css("border", "1px solid #ccc");
        $(mail+"Error").text("");
        userCheck();
        return true;
    }
    else {
        $(mail).css("border", "1px solid #ff0000");
        $(mail+"Error").text("Enter valid email address");
        return false;
    }
}
function userCheck() {
	$.ajax({
		 url:"../cfc/emailCheck.cfc",
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

		        return false;
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
function passwordCheck() {
	var isPassword =true;
	$.ajax({
		 url:"../cfc/passwordCheck.cfc",
		 data: {
			 method : "passwordChecker",
			 password : $("#password").val(),
			 email : $("#user").val()
		},
		type:"POST",
		async : false,
		success: function(data){
			
		  if(data == "false"){
			 $("#password").css("border", "1px solid #ff0000");
			 if($("#userError").val() == ""){
		        $("#passwordError").text("Incorrect Password");}
		        isPassword = false;
		}},
		error: function(){
			alert("AJAX error");
			return false;
		}
		
	});
	return isPassword;
}

function designationCheck() {
	$.ajax({
		 url:"../cfc/designationCheck.cfc",
		 data: {
			 method : "designationChecker",
			 user : $("#user").val(),
			 password : $("#password").val()
		},
		async: false,
		type:"POST",
		//dataType: 'JSON',
		success: function(data){

		if(data == '"teacher"'){
			$("#loginForm").attr("action", "teacherHome.cfm");
        }
		else if(data == '"student"'){
			$("#loginForm").attr("action", "studentHome.cfm");
			}
		else{
			alert("user Inactive");
			$("#loginForm")[0].reset();
			
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	//return designationCheckVariable;

}
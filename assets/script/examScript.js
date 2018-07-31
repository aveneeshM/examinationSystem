$(document).ready(function () {
	$("#fname").on("blur", function (e) {
        if(checkEmpty("#fname")){
        validateText("#fname");
        }
    });
    $("#mname").on("blur", function (e) {
        if($("#mname").val().length != 0){
            validateText("#mname");
        }
        else{
            $("#mname").css("border","1px solid #ccc");
        }
    });

    $("#lname").on("blur", function (e) {
        if(checkEmpty("#lname")){
        validateText("#lname");
        }
    });
    $("#email").on("blur", function (e) {
        if(checkEmpty("#email")){
            validateMail("#email");
            }
        emailCheck();
    });
    $("#phone").on("blur", function (e) {
        if(checkEmpty("#phone")){
            validatePhNo("#phone");
            }  
    });
    $("#password").on("blur", function (e) {
        if(checkEmpty("#password")){
            if(validatePassword("#password")){
            if($("#cpassword").val().length != 0){
    	        matchPassword(("#password"),("#cpassword"));}}
        }
    });
    $("#cpassword").on("blur", function (e) {
        if(checkEmpty("#cpassword")){
            if(validatePassword("#cpassword")){
            if($("#password").val().length != 0){
    	        matchPassword(("#password"),("#cpassword"));}}
        }
    });

    $("#address").on("blur", function (e) {
        if(checkEmpty("#address")){
            validateAddress("#address");
        }
    });
    $("#city").on("blur", function (e) {
        if(checkEmpty("#city")){
        validateText("#city");
        }
    });
    $("#zip").on("blur", function (e) {
        if(checkEmpty("#zip")){
        validateZip("#zip");
        }
    });
    $("#state").on("blur", function (e) {
        if(checkEmpty("#state")){
        validateText("#state");
        }
    });    
    $("#country").on("blur", function (e) {
        if(checkEmpty("#country")){
            validateText("#country");
            }
        });
    $("#msform").submit(validateForm) ;
    $( "#teacher" ).on( "click", function() {
    	$("#designation").val("teacher");
    	});
    $( "#student" ).on( "click", function() {
    	$("#designation").val("student");
    	});
});
function validateForm(){
	var departmentCheck=0;
	 if(checkEmpty("#fname")){
	     validateText("#fname");
	    }
	 else{
		 alert("Empty fields in the form. Please resubmit with valid entries");
		 return false;
		 }
	    if($("#mname").val().length != 0){
	        validateText("#mname");
	    }
	    else{
	    	$("#mnameError").text("");
	    }
		 
	    if(checkEmpty("#lname")){
	        validateText("#lname");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;
			 }
	    if(checkEmpty("#email")){
	        validateMail("#email");
	    } 
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;
			 }
	    if(checkEmpty("#phone")){
	        validatePhNo("#phone");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;
			 }
	    if(checkEmpty("#password")){
	        if(validatePassword("#password")){
	        if($("#cpassword").val().length != 0){
		        matchPassword(("#password"),("#cpassword"));}}
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;
			 }
	    if(checkEmpty("#cpassword")){
	    	if(validatePassword("#cpassword")){
	    	if($("#password").val().length != 0){
	        matchPassword(("#password"),("#cpassword"));}}
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}
	    if(checkEmpty("#address")){
	        validateAddress("#address");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}
	    if(checkEmpty("#city")){
	        validateText("#city");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}
	    if(checkEmpty("#zip")){
	        validateZip("#zip");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}
	    if(checkEmpty("#state")){
	        validateText("#state");
	    }	    
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}
	    if(checkEmpty("#country")){
	        validateText("#country");
	    }
		 else{
			 alert("Empty fields in the form. Please resubmit with valid entries");
			 return false;}

	    $("#msform span").each(function(index, elem){
	        if( $(this).text() != ""){
	        	alert("Some field(s) have invalid data. Please resubmit with valid data. ");
	        	departmentCheck = 1;
	        	return false;
	        }
	    });
	    if(departmentCheck == 1){
	        return false;
	    }
	  
	    
}

function checkEmpty(field){
	
    if($(field).val().length > 0){
        $(field).css("border", "1px solid rgb(11, 243, 116)");
        $(field+"Error").text("");
        return true;
    }
    else{       
        $(field).css("border", "1px solid #ff0000");
        $(field+"Error").text("Required Field");
        return false;
    }
}
function validateText(text) {
    //var fieldName = $(text).attr('name');
    var patt = /^[a-zA-Z]+$/;
    if ($(text).val().match(patt)) {
            $(text).css("border", "1px solid rgb(11, 243, 116)");
            $(text+"Error").text("");

    }
    else {
            $(text).css("border", "1px solid #ff0000");
            $(text+"Error").text("Please use alphabets only.");
    }
    
}
function validateMail(mail) {
        var patt = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
        if ($(mail).val().match(patt)) {
            $(mail).css("border", "1px solid rgb(11, 243, 116)");
            $(mail+"Error").text("");
        }
        else {
            $(mail).css("border", "1px solid #ff0000");
            $(mail+"Error").text("Enter valid email address");
        }
    }
function validatePhNo(number) {
    var length = $(number).val().length;
        var numbers =/^\d{10}$/;
        if ($(number).val().match(numbers)) {
            $(number).css("border", "1px solid rgb(11, 243, 116)");
            $(number+"Error").text("");
        }
        else {
        	$(number).css("border", "1px solid #ff0000");
        	$(number+"Error").text("Enter 10 digit valid number");
        }
    
}
function validatePassword(password) {
    var length = $(password).val().length;
        var pattern =  /(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}/;
        if ($(password).val().match(pattern) && length >= 8) {
            $(password).css("border", "1px solid rgb(11, 243, 116)");
            $(password+"Error").text("");
            return true;
        }
        else {
            $(password).css("border", "1px solid #ff0000");
            $(password+"Error").text("Password must contain at least one number, a uppercase letter,a lowercase letter and must have at least 8 characters");
            return false;            
        }
}
function matchPassword(password,cpassword){
    if($(password).val() != $(cpassword).val()){
    	$(password+"Error").text("Passwords do not match");
        $(password).css("border","1px solid #ff0000");
        $(cpassword).css("border","1px solid #ff0000");
        return false;
    }
    else{
        $(password).css("border","1px solid rgb(11, 243, 116)");
        $(cpassword).css("border","1px solid rgb(11, 243, 116)");
        $(password+"Error").text("");
        return true;

    }
}

function validateAddress(address){
    var pattern = /[A-Za-z0-9'\.\-\s\,]/;
    if($(address).val().match(pattern))
    {
    $(address).css("border","1px solid rgb(11, 243, 116)");
    $(address+"Error").text("");
    }
    else
    {
    $(address).css("border","1px solid #ff0000");
    $(address+"Error").text("Address may contain words, digits, space and (.)/-");
    }
}
function validateZip(number) {
    var length = $(number).val().length;
    var numbers = /^\d{6}$/;

    if($(number).val().match(numbers) && $(number).val() != 000000) {
            $(number).css("border", "1px solid rgb(11, 243, 116)");
            $(number+"Error").text("");
        }
        else {
            $(number).css("border", "1px solid #ff0000");
            $(number+"Error").text("Enter a six digit valid zip code");
        }
    
}

function emailCheck() {/* 
	$.post("emailCheck.cfc",
        	{
        	email : $(email).val()
        	},
        	function(data,status){ 
        		 alert(status);
        		}).fail(function(err, status,response) {
        			alert(err+"AJAX request has failed!! Please try again.");   
        		});
	
	*/
	var mailvar=$("#email").val();
	$.ajax({
		 url:"../cfc/emailCheck.cfc",
		 data: {
			 method : "mailChecker",
			 email : mailvar
		},
		type:"POST",
		success: function(data){
		console.log(data);
		if(data == "true"){
			 $("#email").css("border", "1px solid #ff0000");
		        $("#emailError").text("Email Address already listed, choose a different email address");
		        return false;
		}
		},
		error: function(){
			alert("ajax error");
			return false;
		}
	});


}

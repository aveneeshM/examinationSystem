
//insert into tests values('test1', '2008-11-11', 2, 25, 9, '2008-11-11', '08:00:00')
//$("#yourdropdownid option:selected").text();
var arrayTime,allTime;
$(document).ready(function () {
    $("#button").on("click", function () {
        if($("#duration").val().length == 0 || $("#datetext").val().length == 0 ||
        		$("#testName").val().length == 0 || $("#timePicker option:selected").text().length == 0 ){
        	alert("All fields are required");
        	return false;
        }
        else{
        	addTest();
        }
    });
    
	$("#duration").on("change", function(){
		$('#datetext').val("");
		$('#timePicker').html("");
	})
	
	$("#duration").on("blur", function (e) {
	     if($("#duration").val().length != 0){
	         validateNumber("#duration");
	         if($('#duration').val() == ""){
	         	$('#datetext').prop('disabled', true);
	         }
	         else{
	         	$('#datetext').prop('disabled', false);
	         }
	     }
	});
	//$('#timePicker').attr('disabled', 'enabled');
	
	$('#datetext').prop('disabled', true);
	
	$(function(){
        $("#datetext").datepicker({
            changeYear: true,
            dateFormat: 'yy/mm/dd',
            maxDate: '1y',
            minDate: '0d',
            yearRange: '-100:+0',
            changeMonth: true,
            inline: true
        });
    });
	
	$("#testName").on("blur", function (e) {
         nameCheck();
            });
	
	$("#datetext").on("change", function (e) {
        if($('#datetext').val() == ""){
        	$('#timePicker').prop('disabled', true);
        }
        else{
        	$('#timePicker').html("");
        	arrayTime = timeCheck();
        	var option = '';
            for(var i = 0; i < arrayTime.length; i++){
                option += '<option value="' + arrayTime[i] + '">' + arrayTime[i] + '</option>';
            }
            $("#timePicker").append(option).prop("selectedIndex", -1);
        	$('#timePicker').prop('disabled', false);
        }
        console.log(arrayTime);
     });
    
});


function nameCheck() {
	
	var patt = /^[a-zA-Z0-9 ]+$/;
    if ($("#testName").val().match(patt)) {
    	$("#testName").css("border", "1px solid #a9a9a9");
    	$(':input[type="button"]').prop('disabled', false);
            
    }
    else if($("#testName").val() == ""){
    	$("#testName").css("border", "1px solid #ff0000");
    	$(':input[type="button"]').prop('disabled', true);
            return false;    	
    }
    else {
    	$("#testName").css("border", "1px solid #ff0000");
    	$(':input[type="button"]').prop('disabled', true);
            alert("Please use alphabets and numbers only.");
            return false;
    }
	
	$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "nameChecker",
			 name : $("#testName").val(),

		},
		async: false,
		type:"POST",
		success: function(data){

		if(data == 'true'){

	        $(testName).css("border","1px solid #a9a9a9");
			 $(':input[type="button"]').prop('disabled', false);
        }
		else{
			alert("Existing test. Choose a different name.");
	        $(testName).css("border","1px solid #ff0000");
			 $(':input[type="button"]').prop('disabled', true);

		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});


}

function timeCheck() {
	var returnTime;
	$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "timeChecker",
			 date :  $("#datetext").val(),

		},

		type:"POST",
		async:false,
		success: function(data){
			console.log(data);
			returnTime=data;
		},
		error: function(e){
			alert(e+"AJAX error");
			return false;
		}
		
	});
	allTime=["00:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00",
		"08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00",
		"15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00",
		"22:00:00","23:00:00"]
	returnTime = allTime.filter( function( el ) {
		  return !returnTime.includes( el );
		});
	return returnTime;

}
/*
function validateTime(){
	if( $("#timePicker option:selected").text().length >0){
	var selectedTime= $("#timePicker option:selected").text();
	var duration =$("#duration").val();
	          if(allTime[allTime.indexOf((allTime.indexOf(selectedTime)+ duration)%(allTime.length+1))] != 
	        	  arrayTime[arrayTime.indexOf((arrayTime.indexOf(selectedTime)+ duration)%(arrayTime.length+1))]){
	        	  alert("Time slot clashing with another test. Choose a different time slot ");
	        	  $("#timePicker").append(option).prop("selectedIndex", -1);
	        	
	        	  
	            		}
	            	}
}
*/
function timeString(string, character, n){
    var count= 0, i=0,temp="";
    while(count<n && (i=string.indexOf(character,i)+1)){
        count++;
    }
    if(count== n){
    	var timeString24 =string.substr(i);
    	var H = +timeString24.substr(0, 2);
    	var h = H % 12 || 12;
    	var ampm = (H < 12 || H === 24) ? "AM" : "PM";
    	timeString24 = h + timeString24.substr(2, 3) + ampm;
    	return string.substr(i);
    }
   
    return NaN;
}

function addTest() {
	$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "addExam",
			 name : $("#testName").val(),
			 startTime : $("#timePicker").val(),
			 startDate : $("#datetext").val(),
			 duration : $("#duration").val(),

		},
		type:"POST",
		success: function(data){
			console.log(data);
            alert("exam added");
            $("#addQuesForm")[0].reset();
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});


}
function validateNumber(number) {
    var length = $(number).val().length;
        var numbers =/^\d{1}$/;
        if ($(number).val().match(numbers) && $(number).val() > 0) {
            $(number).css("border", "1px solid #ccc");
            $(':input[type="button"]').prop('disabled', false);
        }
        else {
        	$(number).css("border", "1px solid #ff0000");
        	$("#duration").val("");
        	alert("test duration can be at max of 9 hours");
        	$(':input[type="button"]').prop('disabled', true);
        }
    
}
String.prototype.replaceAt=function(index, replacement) {
    return this.substr(0, index) + replacement+ this.substr(index + replacement.length);
}

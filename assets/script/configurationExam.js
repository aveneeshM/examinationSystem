//global variable declaration
var returnTime, allTime,testNameCheck;
$(document).ready(function () {
	
	$("#testName").on("blur", function (e) {
        nameCheck();
    });
	
	$("#duration").on("change", function(){
		$('#datetext').val("");
		$('#timePicker').html("");
		validateNumber("#duration");
	})
	
	$('#datetext').prop('disabled', true);
    $("#datetext").datepicker({
            changeYear: true,
            dateFormat: 'yy/mm/dd',
            maxDate: '1y',
            minDate: '0d',
            yearRange: '-100:+0',
            changeMonth: true,
            inline: true
     });
    
    $("#timePicker").on("change", function(){
		validateTime($("#timePicker").val());
	})
	
	$("#datetext").on("change", function (e) {
        if($('#datetext').val() == ""){
        	$('#timePicker').prop('disabled', true);
        }
        else{
        	
        	$('#timePicker').html("");
        	//set returnTime to available time slots

        	timeCheck(timeChecker);
        	
        	var option = '';

            for(var i = 0; i < returnTime.length; i++){
                option += '<option value="' + returnTime[i] + '">' + returnTime[i] + '</option>';
            }
            $("#timePicker").append(option).prop("selectedIndex", -1);
        	$('#timePicker').prop('disabled', false);
        }
     });

//Question selection modal	
	$('#quesSubmit').click(function(e) {
		var checked = [];
        $(':checkbox:checked').each(function(i){
      	  checked[i]=$(this).val();
        
      });
		console.log(checked);
		$.ajax({
			 url:"../cfc/configExam.cfc",
			 data: {
				 method : "addQuestionTest",
				 questionIDs : checked.join()
			},
			type:"POST",
			success: function(data){
			if(data == "true"){
				
				console.log(data);
				$('#myModal').modal('hide');
				$("#testQuesForm")[0].reset();
	        }
			else{
				console.log(data);
				alert("Question selection for exam failed");
				return false;
				
	        }

			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
		
	})
	
	
	
	//Submit button handler: checks if all fields are valid
    $("#button").on("click", function () {
        if($("#duration").val().length == 0 || $("#datetext").val().length == 0 ||
        		$("#testName").val().length == 0 || $("#timePicker").val() == null ){
        	alert("All fields are required");
        	return false;
        }
        if(!nameCheck){

        	return false;
        }
        if(testNameCheck == 0){
        	alert("Existing test. Choose a different name.");
        	return false;
        }
        if(!validateNumber("#duration")){

        	return false;
        }
        
        addTest();
        displayQuestion(addQuestions);
        	
        $("#addQuesForm")[0].reset();
        $("#timePicker").prop("selectedIndex", -1);

    });
        
});//.ready closes

//functon to validate name
function nameCheck() {
	
    
	var patt = /^[a-zA-Z0-9 ]+$/;
    
    if($("#testName").val() == ""){
    	$("#testName").css("border", "1px solid #ff0000");
    	$('#datetext').prop('disabled', true);
            return false;    	
    }
    else if ($("#testName").val().match(patt)) {
    	nameExists(nameChecker);
    	$("#testName").css("border", "1px solid #a9a9a9");
    	$('#datetext').prop('disabled', false);
    	return true;
            
    }
    else {
    	$("#testName").css("border", "1px solid #ff0000");
            alert("Please use alphabets and numbers only.");
            $('#datetext').prop('disabled', true);
            return false;
    }


}
//function to check if name already exixts
function nameExists(callback){

	$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "nameChecker",
			 name : $("#testName").val(),

		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
//callback to nameExists
function nameChecker(data){

if(data == "true"){
    $(testName).css("border","1px solid #a9a9a9");
    testNameCheck = 1;
}
else{
    $(testName).css("border","1px solid #ff0000");
    testNameCheck = 0;
    alert("Existing test. Choose a different name.");

}
}

//get all selected time slots for the date
function timeCheck(callback) {
	
	$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "timeChecker",
			 date :  $("#datetext").val()
		},
		type:"POST",
		async:false,
		success: callback,
		error: function(e){
			alert(e+"AJAX error");
			return false;
		}	
	});
 }

//callback to timeCheck. set available time slots to returnTime
function timeChecker(data){
    returnTime = data;
	var presentTS = new Date();
	var timeIndex;
	var date = $.datepicker.formatDate('yy/mm/dd',presentTS);
	allTime=["00:00:00","01:00:00","02:00:00","03:00:00","04:00:00","05:00:00","06:00:00","07:00:00",
		"08:00:00","09:00:00","10:00:00","11:00:00","12:00:00","13:00:00","14:00:00",
		"15:00:00","16:00:00","17:00:00","18:00:00","19:00:00","20:00:00","21:00:00",
		"22:00:00","23:00:00"];
	
	returnTime = allTime.filter( function( el ) {
		  return !returnTime.includes( el );
		});

	
	if (date == $("#datetext").val()){
		var datetext = presentTS.toTimeString().split(' ')[0];
		
		$.each(returnTime, function( index, value ) {
			  if(value <= datetext){
				  timeIndex =index;
			  }
			});
		returnTime = returnTime.slice(timeIndex+1);
	}
}
//function to add test to database
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
		async : false,
		success: function(data){
			console.log(data);
            alert("exam added");
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});


}
//function to validate duration
function validateNumber(number) {
    var length = $(number).val().length;
        var numbers =/^\d{1}$/;
        if ($(number).val() > 0 && $(number).val().match(numbers)) {
        	$('#datetext').prop('disabled', false);
            $(number).css("border", "1px solid #ccc");
           return true;
        }
        else if($(number).val() > 10){
        	$('#datetext').prop('disabled', true);
        	alert("test duration can be at max of 9 hours");
        	return false;
        }
        else {
        	$('#datetext').prop('disabled', true);
        	$(number).css("border", "1px solid #ff0000");
        	alert("Please enter valid input ");
        	return false;
        }
    
}

function validateTime(selectedTime){
	var duration =$("#duration").val();
	var index=(allTime.indexOf(selectedTime)+(duration-1))%allTime.length;

	   if(returnTime.includes(allTime[index])){
		    return true;
	     }
	   else{
		   alert("Time slot clashing with another test. Choose a different time slot ");
		     $("#timePicker").prop("selectedIndex", -1);
		     return false;
	     }

	}

//get Questions for addQuestion modal
function displayQuestion(callback){
$.ajax({
		 url:"../cfc/configExam.cfc",
		 data: {
			 method : "testQuestion"
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	}); 
}

//function to open modal for question addition to the currently updated test
function addQuestions(data){
	
	   var question = $.parseJSON(data);
	   $("#questionSelectTable > tbody").html("");
	    for(var i=0; i<question.length;i++){
	    	var markup = '<tr><td align="center">' + question[i][1] + 
	    	'</td><td align="center"><input type="checkbox" name="questionSelector[]" value='+
	    	question[i][0]+'></td></tr>';
	    	$("#questionSelectTable tbody").append(markup);
	    	$('#myModal').modal('show'); 
	    }
	    $('#testID').val(question[1][2]);
	    $('#questionSelectTable').DataTable();
	}

//string prototype function to replaceAt given index with given replacement on a string 
String.prototype.replaceAt=function(index, replacement) {
    return this.substr(0, index) + replacement+ this.substr(index + replacement.length);
}

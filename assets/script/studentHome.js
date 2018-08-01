//global variable declaration
var tests;
var currentTestID;
var currentTestRowCount;
var currentTestRow;


$(document).ready(function () {	
	$('#examDisplayTable').DataTable({
		info:false,
		searching: false,
		ordering:false,
		paging:true
	});
	
	/*
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTestStudent"
		},
		async:false,
		type:"POST",
		success: function(data){
	    testID = $.parseJSON(data);
	    console.log(testID);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});       */
//get list of upcoming tests
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTest"
		},
		async:false,
		type:"POST",
		success: function(data){
	    displayTests(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
//start test button response 	 
	 $(".modalOpener").on("click", function(e){
//get selected test ID
	        e.preventDefault();
//Function call to start exam
	        displayExam($(this).val());
	     
	    });
//next question button response
	 $("#examNext").on("click", function(e){
//disable next button for last question
		 if(currentTestRow == currentTestRowCount-1){
				$('#examNext').prop('disabled', true);
		 }
//store user's response for the question
		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':checkbox:checked').each(function(i){
	      	  checked[i]=$(this).val();
	        });
		 currentTestRow+=1;
		 saveResult(questionID,checked.join());
//function call to display next question
		 createTest();
	 });
	 
	 $("#examSubmit").on("click", function(e){
		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':checkbox:checked').each(function(i){
	      	  checked[i]=$(this).val();
	        });
	        saveResult(questionID,checked.join());
//close modal after submit
	        $('#myModal').modal('hide');
//generate calculated result
	        finalResult();
	        
		 
	 });

	 

})
//Function to display test list
function displayTests(data){
	$("#examDisplayTable > tbody").html("");
	var check="";
    tests = $.parseJSON(data);
    console.log(tests);


   	for(var i=0; i<tests.length;i++){

    	var markup = '<tr id="'+tests[i][0]+'"><td align="center">'+ tests[i][1]+
    	'</td><td align="center">'+ tests[i][3]+
    	'</td><td align="center">'+tests[i][4]+
    	'</td><td align="center"><button class= "modalOpener" value='+
    	tests[i][0] +'>Start</button></td></tr>';
    	//'</td><td align="center"><input type="checkbox" name="optionSelector[]" value='+
    	//tests[i][0] +' '+check+' ></td></tr>';
       	$("#examDisplayTable tbody").append(markup);
    	
    } 
    
    
}




//function to start test
function displayExam(ID){
    $("#onlineTestForm").html("");
    currentTestID = ID;
    var testDuration;
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "checkTest",
			 testID : ID
		},
		async:false,
		type:"POST",
		success: function(data){
			if(data == "false"){
				alert("Please start test at mentioned Date");
			}
			else if(data =='"wrong time"'){
				alert("Test can only be started at mentioned Time");
			}
			else{
				currentTestRowCount = $.parseJSON(data);
// error message if there is no question in the selected test
				if(currentTestRowCount == 0){
					alert("Test is presently unavailable!!")
				}
				else{
					$('#examNext').prop('disabled', false);
					currentTestRow=1;
//start test
					setTimeout(function(){
						createTest();
					    },800)
					
					testDuration = duration();
//set timeout and display countdown
					timer(testDuration);	
				}		
			}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}

//function to display test modal
function createTest(){
	$("#onlineTestForm").html("");
	var questionRow;
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "generateQuestion",
			 testID : currentTestID,
			 row : currentTestRow
			 
		},
		async:false,
		type:"POST",
		success: function(data){
		console.log(data);
		questionRow = $.parseJSON(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
    	var markup = '<fieldset class="testFieldset"><input type="hidden" id="questionID" value="'
    	+questionRow[0]+'"><p><i><b>'+questionRow[1]+
    	'</b></i></p><hr><br><input type="checkbox" name="options[]" checked value = 1>'+questionRow[2]+
    	'<br><input type="checkbox" name="options[]" value = 2>'+questionRow[3]+
    	'<br><input type="checkbox" name="options[]" value = 3>'+questionRow[4]+
    	'<br><input type="checkbox" name="options[]" value = 4>'+questionRow[5]+
    	'<br></fieldset>';
    	$("#onlineTestForm").append(markup);
	    $('#myModal').modal('show');
 
}


//function to record users response
function saveResult(questionID,checked){
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "saveResult",
			 questionID : questionID,
		     testID : currentTestID,
		     selectedOption : checked 
		},
		async:false,
		type:"POST",
		success: function(data){
		console.log(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
 
}
//function to calculate result
function finalResult(){
	var correct;
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "finalResult", 
		},
		type:"POST",
		success: function(data){
		console.log(data);
		
		if(data=="false"){
			alert("Submission Time out of bounds");
			return false;
		}
		correct = $.parseJSON(data);
		alert("your score : "+ correct + "/"+currentTestRowCount+"\n"+
				"percentage :" + Math.round(correct/currentTestRowCount).toFixed(2)*100.00+"%" );

		
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
function duration(){
	var currentTestDuration;
	$.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "duration",
			 testID : currentTestID
		},
		type:"POST",
		async:false,
		success: function(data){
		currentTestDuration=$.parseJSON(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	return currentTestDuration;
}
function timer(n){
	
	// Set the time we're counting down to
	var countDownDate =  new Date();
	    countDownDate.setHours(countDownDate.getHours() +n);
	    console.log(countDownDate);

	// Update the count down every 1 second
	setInterval(function() {

	    // Get present date and time
	    var now = new Date().getTime();
	    
	    // Find the distance between now and the count down date
	    var distance = countDownDate - now;
	    
	    // Time calculations for hours, minutes and seconds
	    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
	    
	    // Output the result in an element with id="demo"
	    $("#timer").html(hours + "h "
	    	    + minutes + "m " + seconds + "s ");
	    
	    // If the count down is over, write some text 
	    if (distance < 0) {
	        clearInterval(x);
	        $("#timer").html("EXPIRED");
	        saveResult(questionID,checked.join());
	        $('#myModal').modal('hide');
	        finalResult();
	        
	    }
	}, 1000);
}
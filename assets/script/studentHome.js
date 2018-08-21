//global variable declaration
var tests;
var currentTestID;
var currentTestRowCount;
var currentTestRow;

$(document).ready(function () {	
	
  //get list of selected tests
	selectedTest(getTest); 
	
   //start test button response.button value is test id 
	 $('#examDisplayTable').on('click', '.modalOpener', function(e){
	      //$(".modalOpener").on("click", function(e){
	        e.preventDefault();
          //Function call to start exam
	        startExam($(this).val(),checkTest);
	    });
	 
	 
   //next question button response
	 $("#examNext").on("click", function(e){
		 validateOngoingTest(testSessionCheck);
       //disable next button for last question
		 if(currentTestRow == currentTestRowCount-1){
				$('#examNext').prop('disabled', true);
		 }
       //enable previous button after test start
		 if(currentTestRow == 1){
				$('#examPrevious').prop('disabled', false);
		 }
       //store user's response for the question
		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':radio:checked').each(function(i){
	      	  checked[i]=$(this).val();
	        });
		 currentTestRow+=1;
		 saveResult(questionID,checked.join());
       //function call to display next question
		 createTest(generateQuestion);
	 });
	 

	 
   //previous question button response
	 $("#examPrevious").on("click", function(e){
		 validateOngoingTest(testSessionCheck);
       //disable previous button for first question 
		 if(currentTestRow == 2){
				$('#examPrevious').prop('disabled', true);
		 }
       //enable next button when browsing back from last question
		 if(currentTestRow == currentTestRowCount){
				$('#examNext').prop('disabled', false);
		 }
       //store user's response for the question
		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':radio:checked').each(function(i){
	      	  checked[i]=$(this).val();
	        });
		 currentTestRow-=1;
		 saveResult(questionID,checked.join());
       //function call to display next question
		 createTest(generateQuestion);
	 });
	 
	 $("#examSubmit").on("click", function(e){
		 validateOngoingTest(testSessionCheck);

		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':radio:checked').each(function(i){
	      	  checked[i]=$(this).val();
	        });
	        saveResult(questionID,checked.join());
          //close modal after submit
	        $('#myModal').modal('hide');
          //generate calculated result
	        finalResult(displayResult);
	        
		 
	 });
})
//display list of all selected exams
function selectedTest(callback){
	$.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTest"
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
//callback function for selectedTest function
function getTest(data){
	if(data =="false"){
		window.location ="error.cfm";
		return false;
	}
    displayTests(data);
    
    $('#examDisplayTable').DataTable( {
    		
    		"columnDefs": [
    	        { type: 'date-dd-mmm-yyyy', targets: 1 }
    	      ],
    	      "aaSorting": [[1,'desc'],[2,'desc']]
    });
}

//Function to display test list
function displayTests(data){
	$("#examDisplayTable > tbody").html("");
	var check="";
	var date=new Date();
	var presentTest = "";
	var presentDate, presentTime, parsedDate;
    tests = $.parseJSON(data);
    
  //get present date and time to alert for upcoming test
    presentDate = date.getFullYear() + "-" + getFormattedPartTime(date.getMonth()+1) + 
                  "-" + getFormattedPartTime(date.getDate());

    presentTime = getFormattedPartTime(date.getHours()) + ":" + 
                  getFormattedPartTime(date.getMinutes()) + ":" +
                  getFormattedPartTime(date.getSeconds());
 


   	for(var i=0; i<tests.length;i++){
      //get parsed start date to validate with present date for start test alert
   		parsedDate = new Date(tests[i][3]);
   		parsedDate = parsedDate.getFullYear() + "-" + getFormattedPartTime(parsedDate.getMonth()+1) + 
                     "-" + getFormattedPartTime(parsedDate.getDate());
   		
   		if(presentDate == parsedDate && presentTime >= tests[i][4]){
   		  if((date.getMinutes()-15) <= 0 && tests[i][5] == ''){
   			 presentTest = tests[i][1];
   		  }
   	    }
   		 
    	var markup = '<tr id="'+tests[i][0]+'"><td align="center">'+ tests[i][1]+
    	'</td><td align="center">'+ tests[i][3]+
    	'</td><td align="center">'+tests[i][4]+
    	'</td>';
    	var postMarkup = '';
      //assign start-button/test-result to each test
    	if(tests[i][5] == ''){
    		postMarkup = '<td align="center"><button class= "modalOpener" value='+
        	tests[i][0] +'>Start</button></td></tr>';
    		
    	}
    	else{
    		postMarkup ='<td align="center"><b>'+ 
        	tests[i][5]*100 +'%</b></td></tr>';
    	}
    	markup = markup+postMarkup;
       	$("#examDisplayTable tbody").append(markup);
    	
    }
   	if(presentTest != ""){
   		setTimeout(function(){
   			alert("Time window to start "+presentTest+" is active!")},400);
   	}
   }

//function to validate ongoing test by checking if test session exists
function validateOngoingTest(callback){
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "validateOngoingTest",
			 testID : currentTestID
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	
}
//callback to validateOngoingTest
function testSessionCheck(data){
	console.log(data);
	if(data == "true"){
		return true;
	}
	else{
		$('#myModal').modal('hide');
		alert("Test session expired. Your response has been submitted");
		location.reload();
	}
}

//function to start test
function startExam(ID,callback){
    $("#onlineTestForm").html("");
    currentTestID = ID;

	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "checkTest",
			 testID : ID
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}

//callback to startExam
function checkTest(data){
	console.log(data);
	if(data == "false"){
		alert("Please start test at mentioned Date");
		return false;
	}
	else if(data =='"wrong time"'){
		alert("Test can only be started at mentioned Time");
		return false;
	}
	else if(data == '"empty test"'){
		alert("Test is presently unavailable!!");
		return false;
	}
	else if(data == '"error"'){
		alert("An error has occoured. Please try after some time");
		return false;
	}
	else{
		var recievedData =  $.parseJSON(data);	
		currentTestRowCount = recievedData;
			$('#examNext').prop('disabled', false);
			$('#examPrevious').prop('disabled', true);
			currentTestRow=1;
          //start test
			setTimeout(function(){
				createTest(generateQuestion);
			    },800)
			
            //get duration and set timer for current test
			  duration(getDuration);
				
		}		
	
}


//function to display test modal
function createTest(callback){
	
	$("#onlineTestForm").html("");
	
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "generateQuestion",
			 testID : currentTestID,
			 row : currentTestRow
			 
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
    	
 
}
//callback to createTest
function generateQuestion(data){
	var markup;
	var questionRow;
	if(data == 'false'){
		return false;
	}
	questionRow = $.parseJSON(data);
	markup = '<fieldset class="testFieldset"><input type="hidden" id="questionID" value="'
	+questionRow[0]+'"><p><i><b>'+questionRow[1]+
	'</b></i></p><hr><br><label><input type="radio" name="options" value = 1>'+questionRow[2]+
	'</label><br><label><input type="radio" name="options" value = 2>'+questionRow[3]+
	'</label><br><label><input type="radio" name="options" value = 3>'+questionRow[4]+
	'</label><br><label><input type="radio" name="options" value = 4>'+questionRow[5]+
	'</label><br></fieldset>';
	$("#onlineTestForm").append(markup);
	if(questionRow[6] > 0){
	$("input[name=options][value=" + questionRow[6] + "]").prop('checked', true);
	}
	
	
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
		type:"POST",
		success: function(data){
		console.log(data);
		if(data == false){
			return false;
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
 
}
//function to calculate result
function finalResult(callback){

	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "finalResult", 
			 testID : currentTestID
		},
		type:"POST",

		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	
}
//calback to finalResult
function displayResult(data){
	var correct;
	console.log(data);
	if(data == '"submitted"'){
		return false;
	}
	else if(data=="false"){
		alert("Submission Time out of bounds");
		return false;
	}
	else if(data=='"error"'){
		alert("Submission failed because of an error. We'll notify you soon");
		return false;
	}
	else{
	correct = $.parseJSON(data);
	alert("your score : "+ correct + "/"+currentTestRowCount+"\n"+
			"percentage :" + ((correct/currentTestRowCount)*100).toFixed(2) + "%" );
	 location.reload();
	}}

//function to get duration of selected test to set timer

function duration(callback){
	$.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "duration",
			 testID : currentTestID
		},
		type:"POST",
		success: callback,
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
//callback for duration. Sets timer
function getDuration(data){
	timer($.parseJSON(data));
	}

//function to start timer at test start and implement force submit when duration exceeds

function timer(n){
	
	var dayNow = new Date();
    var minutes = dayNow.getMinutes();
    var scnds = dayNow.getSeconds();
  //Set the time we're counting down to (duration - passed time - 10secs[for submission])
    n= (n*60*60)- (minutes*60)- scnds - 10;
  //Define start counter for timer
    var count =0;
	
	
  //Update the count down every 1 second
	var x = setInterval(function() {


	  //Find the distance between counter and set time
	    var distance =n - count;
	    count = count+1;
	    
	  //Time calculations for hours, minutes and seconds
	    var hours = Math.floor((distance % (60 * 60 * 24)) / (60 * 60));
	    var minutes = Math.floor((distance % (60 * 60)) / 60);
	    var seconds = Math.floor(distance % 60);
	    
	  //Output the result in an element with id="demo"
	    $("#timer").html(hours + "h "
	    	    + minutes + "m " + seconds + "s ");
	    
	  //If the count down is over, write some text 
	    if (distance == 0) {
	        clearInterval(x);
	        $("#timer").html("EXPIRED");
	        var questionID = $("#questionID").val();
			 var checked = [];
		        $(':radio:checked').each(function(i){
		      	  checked[i]=$(this).val();
		        });
		        saveResult(questionID,checked.join());
	          //close modal after submit
		        $('#myModal').modal('hide');
	          //generate calculated result
		        finalResult(displayResult);
	        
	    }
	}, 1000);
}

function getFormattedPartTime(partTime){
    if (partTime<10)
       return "0"+partTime;
    return partTime;
}

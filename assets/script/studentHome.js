//global variable declaration
var tests;
var currentTestID;
var currentTestRowCount;
var currentTestRow;

$(document).ready(function () {	
	
//get list of selected tests
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTest"
		},
		async:false,
		type:"POST",
		success: function(data){
	    displayTests(data);
	    $('#examDisplayTable').DataTable( {
	    		"aaSorting": [[1,'desc'],[2,'desc']]
	    } );
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	 
	 
//start test button response.button value is test id 
	 $('#examDisplayTable').on('click', '.modalOpener', function(e){
	 //$(".modalOpener").on("click", function(e){
	        e.preventDefault();
//Function call to start exam
	        displayExam($(this).val());
	    });
	 
	 
//next question button response
	 $("#examNext").on("click", function(e){
		 validateOngoingTest();
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
		 createTest();
	 });
	 

	 
//previous question button response
	 $("#examPrevious").on("click", function(e){
		 validateOngoingTest();
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
		 createTest();
	 });
	 
	 $("#examSubmit").on("click", function(e){
		 validateOngoingTest();

		 var questionID = $("#questionID").val();
		 var checked = [];
	        $(':radio:checked').each(function(i){
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
    	'</td>';
    	var postMarkup = '';
    	if(tests[i][5] == ''){
    		postMarkup = '<td align="center"><button class= "modalOpener" value='+
        	tests[i][0] +'>Start</button></td></tr>';
    		
    	}
    	else{
    		postMarkup ='<td align="center"><b>'+ 
        	tests[i][5]*100 +'%</b></td></tr>';
    	}
    	markup = markup+postMarkup;
    	
    	
    	
    	
    	
    	
    	//'</td><td align="center"><input type="checkbox" name="optionSelector[]" value='+
    	//tests[i][0] +' '+check+' ></td></tr>';
       	$("#examDisplayTable tbody").append(markup);
    	
    } 
    
    
}


function validateOngoingTest(){
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "validateOngoingTest",
			 testID : currentTestID
		},
		async:false,
		type:"POST",
		success: function(data){
		console.log(data);
		if(data == "true"){
			return true;
		}
		else{
			$('#myModal').modal('hide');
			alert("Test session expired. Your response has been submitted");
			location.reload();
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	
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
				var recievedData =  $.parseJSON(data);	
				currentTestRowCount = recievedData;
// error message if there is no question in the selected test
				if(currentTestRowCount == 0){
					alert("Test is presently unavailable!!");
				}
				else{
					$('#examNext').prop('disabled', false);
					$('#examPrevious').prop('disabled', true);
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
	var markup;
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
		
		questionRow = $.parseJSON(data);
		console.log(questionRow);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
    	markup = '<fieldset class="testFieldset"><input type="hidden" id="questionID" value="'
    	+questionRow[0]+'"><p><i><b>'+questionRow[1]+
    	'</b></i></p><hr><br><input type="radio" name="options" value = 1>'+questionRow[2]+
    	'<br><input type="radio" name="options" value = 2>'+questionRow[3]+
    	'<br><input type="radio" name="options" value = 3>'+questionRow[4]+
    	'<br><input type="radio" name="options" value = 4>'+questionRow[5]+
    	'<br></fieldset>';
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
			 testID : currentTestID
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
				"percentage :" + ((correct/currentTestRowCount)*100).toFixed(2) + "%" );
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
	
	var dayNow = new Date();
    var minutes = dayNow.getMinutes();
    n= (n*60*60*1000)- (minutes*60*1000);
    var count =0;
	
	// Set the time we're counting down to
	//var countDownTime =  new Date(testStartTime);
	    //countDownTime.setHours(countDownTime.getHours() +n);
	   // console.log(countDownTime);

	// Update the count down every 1 second
	var x = setInterval(function() {

	    // Get present date and time
	    //var now = new Date().getTime();
	    
	    // Find the distance between now and the count down date
	    var distance =n - count;
	    count = count+1000;
	    
	    // Time calculations for hours, minutes and seconds
	    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	    var seconds = Math.floor((distance % (1000 * 60)) / 1000);
	    
	    // Output the result in an element with id="demo"
	    $("#timer").html(hours + "h "
	    	    + minutes + "m " + seconds + "s ");
	    
	    // If the count down is over, write some text 
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
		        finalResult();
	        
	    }
	}, 1000);
}

var tests;
var testID;
var testQuestion;
var optionSelector;

$(document).ready(function () {
		
	$('#examDisplayTable').DataTable({
		info:false,
		searching: false,
		ordering:false,
		paging:true
	});
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
	});

	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTest"
		},
		async:false,
		type:"POST",
		success: function(data){
		console.log(data);
	    displayQuestion(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	 $(".modalOpener").on("click", function(e){
	        console.log($(this).val());
	        e.preventDefault();
	        displayExam($(this).val());
	     
	    });
	 
	 $("#examSubmit").on("click", function(e){
		 $('#myModal').modal('hide');
		 
	 });
	 $("#optionNext").on("click", function(e){
		 if(testQuestion.length > optionSelector){
			 optionSelector++;
			 saveQuestion();
			 showQuestions();
			 
		 }
		 
	 });
	 

})

function displayQuestion(data){
	$("#examDisplayTable > tbody").html("");
	var check="";
    tests = $.parseJSON(data);
    console.log(tests);


   	for(var i=0; i<tests.length;i++){
   		//new Date($.now());
   		//tests[i][3]=dateFormat(new Date(tests[i][3]), 'dd/mm/yyyy');
   		//tests[i][3]=tests[i][3].split(' ')[2];
   		//if(testID.indexOf(tests[i][0]) >= 0){
   		//	check = "checked";
   		//}
   	//	else{
   		//	check = "";
   		//}

    	
   		//tempID = i+1;
    	var markup = '<tr id="'+tests[i][0]+'"><td align="center">'+ tests[i][1]+
    	'</td><td align="center">'+ tests[i][3]+
    	'</td><td align="center">'+tests[i][4]+
    	'</td><td align="center"><button class= "modalOpener" value='+
    	tests[i][0] +'>Start</button></td></tr>';
    	//'</td><td align="center"><input type="checkbox" name="optionSelector[]" value='+
    	//tests[i][0] +' '+check+' ></td></tr>';
       	$("#examDisplayTable tbody").append(markup);
    	//$('#myModal').modal('show'); 
    } 
    
    
}





function displayExam(ID){
    $("#onlineTestForm").html("");
   
	 $.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "getTestQuestions",
			 testID : ID
		},
		async:false,
		type:"POST",
		success: function(data){			
			if(data == "false"){
				alert("Please start test at mentioned Date");
			}
			else if(data == "wrong time"){
				alert("Test can only be started at mentioned Time");
			}
			else{
				testQuestion = $.parseJSON(data);
				optionSelector=0;
				showQuestions();
						
			}
		
				
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
    
    
    
   	
    
}
function showQuestions(){
	$("#onlineTestForm").html("");
	//for(var i=0; i<testQuestion.length;i++){
    	var markup = '<fieldset class="testFieldset"><input type="hidden" class="questionID" value="'
    	+testQuestion[optionSelector][0]+'"><p>'+testQuestion[optionSelector][1]+
    	'<p><br><input type="checkbox" name="options[]" checked value = 1>'+testQuestion[optionSelector][2]+
    	'<br><input type="checkbox" name="options[]" value = 2>'+testQuestion[optionSelector][3]+
    	'<br><input type="checkbox" name="options[]" value = 3>'+testQuestion[optionSelector][4]+
    	'<br><input type="checkbox" name="options[]" value = 4>'+testQuestion[optionSelector][5]+
    	'<br></fieldset>';
    	
    	$("#onlineTestForm").append(markup);
      	
      	
    	
   // }


	$('#myModal').modal('show'); 
 
}
function saveQuestion(){
	$.ajax({
		 url:"../cfc/studentHome.cfc",
		 data: {
			 method : "saveOptions",
			 testID : $(".questionID").val()
		},
		async:false,
		type:"POST",
		success: function(data){			
			if(data == "false"){
				alert("Please start test at mentioned Date");
			}
			else if(data == "wrong time"){
				alert("Test can only be started at mentioned Time");
			}
			else{
				testQuestion = $.parseJSON(data);
				optionSelector=0;
				showQuestions();
						
			}
		
				
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
	
	
}


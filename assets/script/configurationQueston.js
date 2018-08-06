//global variables
var optionArray=[];
$(document).ready(function () {
//Handler for submit button		   
	   $("#button").on("click", function () {
	        if($("#question").val().length == 0 || $("#option1").val().length == 0 ||
	        		$("#option2").val().length == 0 || $("#option3").val().length == 0 || $("#option4").val().length == 0){
	        	alert("All fields are required");
	        	return false;
	        }
	        else{
	        	var val = 0;
	          //  $(':checkbox:checked').each(function(i){
	        	$(':radio:checked').each(function(i){
	            	  val=1;
	            	  optionArray[i]=$(this).val();
	              
	            });
		        if(val == 1){
		        	addQuestion(optionArray);
		        }
		        else{
		        	alert("Select answer");
		        	return false;
		        }
	        }
	    });
});
//function to add question 
function addQuestion() {
	$.ajax({
		 url:"../cfc/configQuestion.cfc",
		 data: {
			 method : "addQuestion",
			 question : $("#question").val(),
			 opt1 : $("#option1").val(),
			 opt2 : $("#option2").val(),
			 opt3 : $("#option3").val(),
			 opt4 : $("#option4").val(),
			 level : $("#level").val(),
			 correct : optionArray.join()
		},
		type:"POST",
		success: function(data){
		console.log(data);
		if(data == "true"){
			 alert("Question added successfully");
			 $("#addQuesForm")[0].reset();
		}
		else{
			alert("Data entry failed");
			console.log(data);
			return false;
		}
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
}
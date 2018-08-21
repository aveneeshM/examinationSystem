//global variables
var optionArray=[];
$(document).ready(function () {
//Handler for submit button		   
	   $("#button").on("click", function () {
	        if($.trim($("#question").val()).length == 0 || $.trim($("#option1").val()).length == 0 ||
	        		$.trim($("#option2").val()).length == 0 || $.trim($("#option3").val()).length == 0 ||
	        		$.trim($("#option4").val()).length == 0){
	        	alert("All fields are required");
	        	return false;
	        }
	        
	        else{
	        	var val = 0;
	        	var options = [];
	        	$('input[type=text]').each(function () {
	                options.push($.trim($(this).val()))
	            });
	        	options= options.sort();
	        	for (var i = 0; i < options.length - 1; i++) {
	                if (options[i + 1].toLowerCase() == options[i].toLowerCase()) {
	                    alert("Please enter different value for each option.");
	                    return false;
	                }
	            }

	        	$(':radio:checked').each(function(i){
	            	  val=1;
	            	  optionArray[i]=$(this).val();
	              
	            });
		        if(val == 1){
		        	addQuestion();
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
			 question : $.trim($("#question").val()),
			 opt1 : $.trim($("#option1").val()),
			 opt2 : $.trim($("#option2").val()),
			 opt3 : $.trim($("#option3").val()),
			 opt4 : $.trim($("#option4").val()),
			 level : $.trim($("#level").val()),
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
$(document).ready(function () {

//Add datatable to created exam table	
	$('#examSelectTable').DataTable({
		info:false,
		"aaSorting": [[2,'desc'],[4,'desc']],
		//ordering:false,
		"columnDefs": [
	        {"className": "dt-center", "targets": "_all"},
	        { type: 'date-dd-mmm-yyyy', targets: [2,5] }
	      ],
	      
	});
	
//Add on click event to table rows
	$("#examSelectTable tbody").on('click', 'tr', function () {
	    var extractedID = $(this).find(".examID").text();
	    //extractedID = extractedID.substr(4);
	    $.ajax({
			 url:"../cfc/exams.cfc",
			 data: {
				 method : "testQuestion",
				 testID : extractedID
			},
			type:"POST",
			async:false,
			success: function(data){
			console.log(data);
		    displayQuestion(data);
		    
		    
		    
		    if ( $.fn.dataTable.isDataTable( '#questionSelectTable' ) ) {
		        $('#questionSelectTable').DataTable();
		    }
		    else {
		         		    
				    $('#questionSelectTable').DataTable({
				    	"aaSorting": [0,'desc'],
				    	"ordering": false
				    	  });
		    }
		    
		    
		    

			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
	});
	
//event handler to Question Submit button
	$('#quesSubmit').click(function(e) {
		var checked = [];
        $(':checkbox:checked').each(function(i){
      	  checked[i]=$(this).val();
        
      });
		console.log(checked);
		$.ajax({
			 url:"../cfc/exams.cfc",
			 data: {
				 method : "addQuestionTest",
				 questionIDs : checked.join(),
				 testID : $('#testID').val()
			},
			type:"POST",
			success: function(data){
			if(data == "false"){
				console.log(data);
				alert("Question selection for exam failed");
				return false;
	        }
			else{
				console.log(data);
				$('#myModal').modal('hide');
				$("#testQuesForm")[0].reset();
				
	        }

			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
		
	})
});
//add content to question select modal
function displayQuestion(data){
	
   var question = $.parseJSON(data);
   $("#questionSelectTable > tbody").html("")
    for(var i=0; i<question.length;i++){
    	var markup = '<tr><td align="center">' + question[i][1] + 
    	'</td><td align="center"><input type="checkbox"'+ question[i][3]+' name="questionSelector[]" value='+
    	question[i][0]+'></td></tr>';
    	$("#questionSelectTable tbody").append(markup);
    	
    	$('#myModal').modal('show'); 
    }
    $('#testID').val(question[1][2]);
    
}







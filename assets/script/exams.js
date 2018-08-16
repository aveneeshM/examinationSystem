var table;
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
			if ( $.fn.DataTable.isDataTable('#questionSelectTable') ) {
		    	  $('#questionSelectTable').DataTable().destroy();
		    	}
		    displayQuestion(data);
		    
		    table = $('#questionSelectTable').DataTable({
				    	"columns": [
				            null,
				            { "orderDataType": "dom-checkbox" }
				        ],
				        "aaSorting": [[1,'desc'],[0,'asc']],
				        //"paging":false,
				 	    //"scrollY":"420px",
				 	    //"scrollCollapse": true,

				        });
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
        table.$(':checkbox:checked').each(function(i){
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
   $("#questionSelectTable > tbody").html("");

   
    for(var i=0; i<question.length;i++){
    	var markup = '<tr><td align="center">' + question[i][1] + 
    	'</td><td align="center"><input type="checkbox"'+ question[i][3]+' name="questionSelector[]" value='+
    	question[i][0]+'></td></tr>';
    	$("#questionSelectTable tbody").append(markup);
    	
    }
	$('#myModal').modal('show'); 
    $('#testID').val(question[1][2]);
    
}

$.fn.dataTable.ext.order['dom-checkbox'] = function  ( settings, col ){
    return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
        return $('input', td).prop('checked') ? '1' : '0';
    } );
}





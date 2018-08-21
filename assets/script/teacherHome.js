//global variable declaration
var table;
$(document).ready(function () {
	table = $('#questionSelectTable').DataTable({
		"aaSorting": [1,'desc'],
        //allign column values at centre
		"columnDefs": [
	        {"className": "dt-center", "targets": "_all"}
	      ],
	      dom: 'Bfrtip',
	        buttons: [
	            {
	                extend: 'pdf',
	                title: 'Examination Questions',
	                customize: function(doc) {
	                    doc.styles.title = {
	                      fontSize: '30',
	                      alignment: 'center'
	                    };     
	                  },
	                pageSize: 'LEGAL'
	            }
	        ],
	        //row callback to colour each row that is to be generated for display
	        "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
                if ( aData[0] == "Inactive" )
                {
                    $('td', nRow).css('background-color', '#ff9999');
                }
                else if ( aData[0] == "Active" )
                {
                    $('td', nRow).css('background-color', '#95D48A');
                }
            }
	});
	
	//dataTable for edit option modal
	$('#optionSelectTable').DataTable({
		info:false,
		searching: false,
		ordering:false,
		paging:false
	});
	
	//On select active/inactive/all questions
	$('.questionStatus input[type="radio"]').on('change', function() {
		
		
		   $(this).siblings('input[type="checkbox"]').prop('checked', false);
		   if($(this).val()=="all"){
               table.column(0).search("active")
               .draw();		   
		   }
		   else if($(this).val()=="active"){
			   table.column(0).search("^" + "active" + "$", true, false, true)
               .draw();
		   }
		   else{
			   table.column(0).search("^" + "inactive" + "$", true, false, true)
               .draw();
		   }
		});
	
	//table row on click will extract selected question options and call function to open editing modal 
	$("#questionSelectTable tbody").on('click', 'tr', function () {
	    var extractedID = $(this).find(".questionID").text();
	    $.ajax({
			 url:"../cfc/teacherHome.cfc",
			 data: {
				 method : "getQuestion",
				 questionID : extractedID
			},
			type:"POST",
			success: function(data){
			if(data == '"error"'){
		    	alert("An error has occured. Please try after some time");
		    	return false;
			}
			console.log(data);
		    displayQuestion(data);
			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
	    
	});
	
	//Response to save-changes button 
	$('#optionSubmit').click(function(e) {
		var checked = [], status;
        $('#optionSelectTable :radio:checked').each(function(i){
      	  checked[i]=$(this).val();
        
      });
        if($("#status").prop("checked") == true){
        	status = 1;
        }
        else{
        	status = 0;
        }
		$.ajax({
			 url:"../cfc/teacherHome.cfc",
			 data: {
				 method : "editQuestion",
				 options : checked.join(),
				 questionID : $('#getQuesID').val(),
				 status : status
			},
			type:"POST",
			success: function(data){
			if(data == "false"){
				console.log(data);
				alert("Question editing failed. Please try after sometime");
				return false;
	        }
			else{
				

				$('#myModal').modal('hide');
				setInterval(function(){location.reload(true); }, 400);
				
	        }

			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
		
	})	
});


// function to display edit-question modal
function displayQuestion(data){
	
    var question = $.parseJSON(data),check,tempID;
    $("#optionSelectTable > tbody").html("");
    $(".questionStatement").html("");
    $(".quesID").html("");
    $('#quesID').html("&nbsp;Question "+question[0]+" : &nbsp");
   	$('.questionStatement').html("&nbsp"+question[1]+"<br><br>");
    $("#getQuesID").val(question[0]);
    
    if(question[7] == 1){
        $("#status").prop("checked", true);
    }
    else{
    	$("#status").prop("checked", false);
    }
    //loop through options and add them to table 
   	for(var i=0; i<4;i++){
   		if(question[6].indexOf(++i) >= 0){
   			check = "checked";
   		}
   		else{
   			check = "";
   		}
    	i--;
   		tempID = i+1;
    	var markup = '<tr><td align="center">'+question[i+2]+
    	             '</td><td align="center"> <input type="radio" name="optionSelector" value='+
		             tempID +' '+check+' ></td></tr>';
       	$("#optionSelectTable tbody").append(markup);
    } 
   	$('#myModal').modal('show'); 
    
}


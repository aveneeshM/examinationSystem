$(document).ready(function () {
	$('#questionSelectTable').DataTable({
		title: 'Examination Questions',
		"aaSorting": [1,'desc'],
//allign elements at centre
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
	                pageSize: 'LEGAL',
	                exportOptions: {
	                }
	            }
	        ],
	        "fnRowCallback": function( nRow, aData, iDisplayIndex, iDisplayIndexFull ) {
                if ( aData[0] == "Inactive" )
                {
                    $('td', nRow).css('background-color', 'pink');
                }
                else if ( aData[0] == "Active" )
                {
                    $('td', nRow).css('background-color', 'lightgreen');
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
	
	//select active/inactive/all questions
	$('input[type="checkbox"]').on('change', function() {
		   $(this).siblings('input[type="checkbox"]').prop('checked', false);
		   if($(this).val()=="all"){
			   $(".active").show();
			   $(".inactive").show();			   
		   }
		   else if($(this).val()=="active"){
			   $(".active").show();
			   $(".inactive").hide();		   
		   }
		   else{
			   $(".active").hide();
			   $(".inactive").show();
		   }
		});
	
	//table row on click will will extract selected question options and call function to open editing modal 
	$("#questionSelectTable tbody").on('click', 'tr', function () {
	    var extractedID = $(this).find(".questionID").text();
	    $.ajax({
			 url:"../cfc/teacherHome.cfc",
			 data: {
				 method : "getQuestion",
				 questionID : extractedID
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
	    
	});
	
	
	
	//Response to Save Edit button
	$('#optionSubmit').click(function(e) {
		var checked = [];
        $('#optionSelectTable :radio:checked').each(function(i){
      	  checked[i]=$(this).val();
        
      });
		console.log(checked);
		$.ajax({
			 url:"../cfc/teacherHome.cfc",
			 data: {
				 method : "editQuestion",
				 options : checked.join(),
				 questionID : $('#getQuesID').val()
			},
			type:"POST",
			
			success: function(data){
			if(data == "false"){
				console.log(data);
				alert("Question editing failed");
				return false;
	        }
			else{
				console.log(data);
				
				$('#myModal').modal('hide');
				location.reload(true);
				//$("#testQuesForm")[0].reset();
				
	        }

			},
			error: function(){
				alert("AJAX error");
				return false;
			}
		}); 
		
	})	
});


// function to display edit question modal
function displayQuestion(data){
	
    var question = $.parseJSON(data),check,tempID;
    console.log(question);
    $("#optionSelectTable > tbody").html("");
    $(".questionStatement").html("");
    $(".quesID").html("");
    $('#quesID').html("&nbsp;OES"+question[0]+" : &nbsp");
   	$('.questionStatement').html("&nbsp"+question[1]+"<br><br>");
    $("#getQuesID").val(question[0]);
   	for(var i=0; i<4;i++){
   		if(question[6].indexOf(++i) >= 0){
   			check = "checked";
   		}
   		else{
   			check = "";
   		}
    	i--;
   		tempID = i+1;
    	var markup = '<tr><td align="center"> <input type="radio" name="optionSelector" value='
    		+ tempID +' '+check+' ></td><td align="center">'+question[i+2]+'</td></tr>';
       	$("#optionSelectTable tbody").append(markup);
    	$('#myModal').modal('show'); 
    } 
    
    
}


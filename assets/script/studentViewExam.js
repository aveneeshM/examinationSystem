$(document).ready(function () {	

//display all upcoming tests
	futureTests(generateTests);
	
//start test button response 	 
	$("#examDisplayTable").on("click",".selectTest", function(e){
	        e.preventDefault();
//Function call with testID as argument to start exam
	        addExam($(this).val());
	     
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
    	'</td><td align="center"><button class= "selectTest" value='+
    	tests[i][0] +'>Add Test</button></td></tr>';
       	$("#examDisplayTable tbody").append(markup);
    	
    }  
}


//function to record users response
function addExam(testID){
	 $.ajax({
		 url:"../cfc/studentViewExam.cfc",
		 data: {
			 method : "addTest",
		     testID : testID
		},
		type:"POST",
		success: function(data){
		console.log(data);
		alert("Test added to dashboard");
		location.reload();
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
 
}

function futureTests(callback){
//get list of upcoming tests
$.ajax({
	 url:"../cfc/studentViewExam.cfc",
	 data: {
		 method : "getTest"
	},
	async:false,
	type:"POST",
	success: callback,
	error: function(){
		alert("AJAX error");
		return false;
	}
});
}

//
function generateTests(data){
	console.log(data);
    displayTests(data);
    $('#examDisplayTable').DataTable( {
		   "aaSorting": [[1,'asc'], [2,'asc']],
	       "columnDefs": [
	         {"className": "dt-center", "targets": "_all"},
	         { type: 'date-dd-mmm-yyyy', targets: 1 }
	       ]
	    });
    
}
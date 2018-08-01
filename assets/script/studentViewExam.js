//global variable declaration



$(document).ready(function () {	
	$('#examDisplayTable').DataTable({
		info:false,
		searching: false,
		ordering:false,
		paging:false,
		scrollY:"480px",
		scrollCollapse: true
	});
	

//get list of upcoming tests
	 $.ajax({
		 url:"../cfc/studentViewExam.cfc",
		 data: {
			 method : "getTest"
		},
		async:false,
		type:"POST",
		success: function(data){
	    displayTests(data);
		},
		error: function(){
			alert("AJAX error");
			return false;
		}
	});
//start test button response 	 
	 $(".selectTest").on("click", function(e){
//get selected test ID
	        e.preventDefault();
//Function call to start exam
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
    	//'</td><td align="center"><input type="checkbox" name="optionSelector[]" value='+
    	//tests[i][0] +' '+check+' ></td></tr>';
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

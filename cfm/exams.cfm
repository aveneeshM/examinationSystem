<cfif NOT isUserLoggedIn()>
	<cflocation url="login.cfm" addtoken="no">
</cfif>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/modal.css" media="screen" type="text/css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
<script src="../assets/script/exams.js"> </script>
<!---<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">--->
</head>
<body>
<!--header -->
		<div id="header" >
	<!--logo -->
		    <div class="logo">
		    	<a href="login.cfm">
				<img src="../assets/images/logo2.png" alt="Logo" width="80" height="70" border="0"  id="logo" /></a>
				<b>Online Examination System</b>
			</div>
		<!--logo -->
		<div id="logoutButton"><img src="../assets/images/logout.png" alt="Logout" width="25" height="25" border="0" id="logOutButton"></div>
			<div class="headernav">
                <ul>

                <li><a href="configurationExam.cfm">Configuration</a></li>
	            <li><a id="activepage" href="#home">Exams</a></li>
                <li><a href="teacherHome.cfm">Home</a></li>
                </ul>
			</div>
		</div><br>
<!--header end -->
<!---component object to check if atleast one exam is present and then display all exams--->
<cfset examObj = CreateObject("Component", "examinationSystem.cfc.exams") />
<cfset examObjQuery = examObj.examAll() />
<cfset examObjQuestion = examObj.questionAll() />
<cfif #examObj.examExists()#>

	<div class="examListTable">
		<h3>Tests</h3><br>
			<!---Question display table--->
		<table id="examSelectTable" class="display">
				<thead>
					<tr>
						<th class="hiddenColumn"></th>
						<th>Test ID</th>
						<th>Test Name</th>
						<th>Test Date</th>
                        <th>Duration(hours)</th>
						<th>Start Time</th>
                        <th>Created Date</th>
                    </tr>
               </thead>
               <tbody>
			   <cfloop query="examObjQuery">
					<tr>

					<td class="hiddenColumn"></td>
					<td class="examID"><cfoutput>#testID#</cfoutput></td>
                    <td><cfoutput>#name#</cfoutput></td>
					<td><cfoutput>#dateformat(startDate,"dd-mm-yyyy")#</cfoutput></td>
					<td><cfoutput>#duration#</cfoutput></td>
                    <td><cfoutput>#TimeFormat(startTime, "HH:mm:ss")#</cfoutput></td>
					<td><cfoutput>#dateformat(createdDate,"dd-mm-yyyy")#</cfoutput></td>
               </tr>
			</cfloop>
			</tbody>
          </table>
</div>
<!---Modal to add questions to a test--->
	<div class="modal hide fade" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">Select Questions</h4>
        </div>
        <div class="modal-body">
			<form class="testQuesForm" id="testQuesForm" method="POST">
				<input type="hidden" id="testID">
			<table id="questionSelectTable" class="display">
				<thead>
					<tr>
						<th>Question</th>
						<th>Add to Test</th>
                    </tr>
               </thead>
               <tbody>
			</tbody>
          </table>
		</form>
        </div>
        <div class="modal-footer">
			<button type="button" class="btn btn-default left" id="quesSubmit">Add</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
  </div>
</div>

	<cfelse>
	<p>No Exams to display. Please add exams</p>
</cfif>

</body>
</html>
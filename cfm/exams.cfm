<cfinclude template="loginValidation.cfm">
<cfif session.stLoggedInUser.designation EQ "student">
		<cflocation url="accessDenied.cfm" addtoken="no">
</cfif>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="../assets/script/exams.js"> </script>
<script src="https://cdn.datatables.net/plug-ins/1.10.19/sorting/date-dd-MMM-yyyy.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/modal.css" media="screen" type="text/css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
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
<!---component object to display all exams--->
<cfset examObjQuery = application.examObj.examAll() />
<!---check if exam exists --->
<cfif #examObjQuery.recordCount#>

	<div class="examListTable">
		<h3>Exams</h3><br>
			<!---Question display table--->
		<table id="examSelectTable" class="display">
				<thead>
					<tr>
						<!--- <th class="hiddenColumn"></th> --->
						<th>Test ID</th>
						<th>Test Name</th>
						<th>Test Date</th>
                        <th>Duration(hours)</th>
						<th>Start Time</th>
                        <th>Created Date</th>
                    </tr>
               </thead>
               <tbody>
				<cfoutput>
			   <cfloop query="examObjQuery">
					<tr>

					<!--- <td class="hiddenColumn"></td> --->
					<td class="examID">#testID#</td>
                    <td>#name#</td>
					<td>#dateformat(startDate,"dd-mmm-yyyy")#</td>
					<td>#duration#</td>
                    <td>#TimeFormat(startTime, "HH:mm:ss")#</td>
					<td>#dateformat(createdDate,"dd-mmm-yyyy")#</td>
               </tr>
			</cfloop>
			</cfoutput>
			</tbody>
          </table>
</div>
<!---Modal to add questions to a test--->
	<div class="modal hide fade modalWidth" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">Select Questions</h4>
        </div>
        <div class="modal-body">
			<form class="testQuesForm" id="testQuesForm" method="POST">
				<input type="hidden" id="testID">
			<table id="questionSelectTable" class="display" cellspacing="0">
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
			<button type="button" class="btn btn-default left" id="quesSubmit">Save Changes</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
  </div>
</div>
<!---If no exams are present to display--->
<cfelse>
	<p>No Exams to display. Please add exams</p>
</cfif>

</body>
</html>


<cfif NOT( isUserLoggedIn() AND structKeyExists(session,"stLoggedInUser"))>
	<cflocation url="login.cfm" addtoken="no">
	<cfelse>
	<cfif session.stLoggedInUser.designation EQ "student">
		<cflocation url="accessDenied.cfm" addtoken="no">
	</cfif>
</cfif>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="../assets/script/configurationExam.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.11.4/jquery-ui.css">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="../assets/css/modal.css" media="screen" type="text/css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.js"></script>

</head>
<body>
<!--header -->
		<div id="header" >
	<!--logo -->
		    <div class="logo">
		    	<a href="login.cfc">
				<img src="../assets/images/logo2.png" alt="Logo" width="80" height="70" border="0"  id="logo" /></a>
				<b>Online Examination System</b>
			</div>
		<!--logo -->
		<div id="logoutButton"><img src="../assets/images/logout.png" alt="Logout" width="25"
		height="25" border="0" id="logOutButton"></div>
			<div class="headernav">
                <ul>
	            <li><a id="activepage" href="#about">Add Exams</a></li>
                <li><a href="configurationQuestion.cfm">Add Questions</a></li>
				<li><a href="teacherHome.cfm">Home</a></li>
                </ul>
			</div>
		</div>
<!--header end -->

<!---Add Question --->
<div id="addExamData">
<form class="addQuesForm" id="addQuesForm" method="POST">

	<div class="tableRow smallMargin">
	  <div class="label left">
		  <span>Test Name:&nbsp;</span></div>
		  <span class="left smallMargin"><input type="text" id="testName" size="41" ></span>
		  <div class="label left smallMargin">
		  <span>Test Duration:&nbsp;</span></div>
		  <span class="left smallMargin"><input type="text" id="duration" size="41" placeholder="Hours" ></span>
	</div><br>
<br><br>
	<div class="tableRow smallMargin">
	  <div class="label left">
		  <span>Test Date:&nbsp;</span></div>
		  <span class="left smallMargin"><input type="text" id="datetext" readonly="true" size="41" ></span>
		  <div class="label left smallMargin">
		  <span>Start Time:&nbsp;</span></div>
		  <span class="left smallMargin"><select id="timePicker" readonly="true" <!--->onchange="validateTime()"--->; ></select></span>
	</div>
</div><br>
<input type="button" name="button" id="button" class="login login-submit right addQuestionButton" value="Add Test">
  </form>
<!---Modal to add questions to the created test--->
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

</body>
</html>
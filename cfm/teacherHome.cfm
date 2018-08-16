<cfif NOT isUserLoggedIn()>
	<cflocation url="login.cfm" addtoken="no">
<cfelseif  NOT structKeyExists(session,"stLoggedInUser")>
    <cfset logOutObj = CreateObject("Component", "examinationSystem.cfc.login") />
    <cfset logOutObj.doLogOut() />
	<cflocation url="login.cfm" addtoken="no">
<cfelseif session.stLoggedInUser.designation EQ "student">
		<cflocation url="accessDenied.cfm" addtoken="no">
<cfelse>

<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="../assets/css/modal.css" media="screen" type="text/css" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.18/b-1.5.2/datatables.min.css"/>
<script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.18/b-1.5.2/datatables.min.js"></script>
<!---cdn for data table button--->
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.5.2/css/buttons.dataTables.min.css"/>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.2/js/dataTables.buttons.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/pdfmake.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.36/vfs_fonts.js"></script>
<script type="text/javascript" src="https://cdn.datatables.net/buttons/1.5.2/js/buttons.html5.min.js"></script>
<script src="../assets/script/teacherHome.js"> </script>
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
	            <li><a href="exams.cfm">Exams</a></li>
                <li><a id="activepage" href="#home">Home</a></li>
                </ul>
			</div>
		</div>
<!---header end --->
<div class="questionStatus">
	<h3>Question Type</h3><br>
	<label><input type="radio" class="checkbox1" name="questionSelector" value='active'>&nbsp;Active</label><br>
	<label><input type="radio" class="checkbox1" name="questionSelector" value='inactive'>&nbsp;Inactive</label><br>
	<label><input type="radio" class="checkbox1" name="questionSelector" value='all' checked='true'>&nbsp;All</label><br>
</div>
<div class="questionList">
<cfset teacherObj = CreateObject("Component", "examinationSystem.cfc.teacherHome") />
<cfset teacherObjQuestion = teacherObj.questionAll() />
<!---Check to see if question table has atleast one entry--->
	<cfif #teacherObjQuestion.recordCount#>
		<h3>Questions</h3><br>
			<!---Question display table--->
		<table id="questionSelectTable" class="display">
				<thead>
					<tr>
						<th class="hiddenColumn">Status</th>
						<th>ID</th>
                        <th>Question</th>
						<th>Level</th>
                        <th>1<sup>st</sup>Option</th>
						<th>2<sup>nd</sup>Option</th>
                        <th>3<sup>rd</sup>Option</th>
						<th>4<sup>th</sup>Option</th>
                        <th>Answer</th>
                    </tr>
               </thead>
               <tbody>
				<cfloop query="teacherObjQuestion">
				<cfif #isActive#>
					<tr class="green active">
					<cfelse>
					<tr class="red inactive">
					</cfif>
					<td class="hiddenColumn">
						<cfif #isActive# EQ 0>
						<cfoutput>Inactive</cfoutput></td>
						<cfelse>
						<cfoutput>Active</cfoutput></td>
						</cfif>
					<td class="questionID"><cfoutput>#questionID#</cfoutput></td>
                    <td><cfoutput>#questionDescription#</cfoutput></td>
					<td><cfoutput>#difficultyLevel#</cfoutput></td>
                    <td><cfoutput>#option1#</cfoutput></td>
					<td><cfoutput>#option2#</cfoutput></td>
                    <td><cfoutput>#option3#</cfoutput></td>
					<td><cfoutput>#option4#</cfoutput></td>
					<cfset answer="">
					<cfloop list="#isCorrect#" index="name">
						<cfset answer=ListAppend(answer,"Option #name#",",")>
					</cfloop>
                    <td><cfoutput>#answer#</cfoutput></td>

               </tr>
			</cfloop>
			</tbody>
          </table>
</div>
		<div class="modal hide fade" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!--- Modal content--->
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">Edit Question</h4>
        </div>
        <div class="modal-body">
			<form class="quesOptionForm" id="quesOptionForm" method="POST">
				<h4 id="quesID"></h4><p class="questionStatement"></p>
				<input type="hidden" id="getQuesID">

			<table id="optionSelectTable" class="display">
				<thead>
					<tr>
						<th>Correct</th>
                        <th>Option</th>
                    </tr>
               </thead>
               <tbody>
			</tbody>
          </table>
		<label class="switch">
         <input type="checkbox" id="status">
             <span class="slider round"></span>
         </label>
		</form>
        </div>
        <div class="modal-footer">
		  <button type="button" class="btn btn-default left" id="optionSubmit">Submit Changes</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
  </div>
</div>
<cfelse>
<!---No questions present--->
<br><p>No Questions In the dataSource</p>
</cfif>

</body>
</html>
</cfif>
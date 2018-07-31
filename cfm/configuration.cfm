<cfif NOT isUserLoggedIn()>
	<cflocation url="login.cfm">
</cfif>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
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
		<div id="logoutButton"><img src="../assets/images/logout.png" alt="Logout"
		width="25" height="25" border="0" id="logOutButton"></div>
			<div class="headernav">
                <ul>
	            <li><a href="#about">Add Exams</a></li>
                <li><a id="activepage" href="#home">Add Questions</a></li>
                </ul>
			</div>
		</div>
<!--header end -->
<div id="addQuestions">
<h3>Questions</h3><br>

<!---Question check query--->
<cfquery name="numOfQuestion" datasource="examinationSystem">
          select questionID from questions
	</cfquery>
	<cfif #numOfQuestion.recordcount#>
		<!---Question display table--->
		<cfelse>
		<!---No questions present--->
		<p>No Questions In the dataSource</p>
	</cfif>
</div>
</body>
</html>
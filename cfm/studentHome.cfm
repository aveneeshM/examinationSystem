
<cfif NOT isUserLoggedIn()>
<cflocation url="login.cfm" addtoken="no">
</cfif>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="../assets/script/studentHome.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
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
		    	<a href="login.cfm">
				<img src="../assets/images/logo2.png" alt="Logo" width="80" height="70" border="0"  id="logo" /></a>
				<b>Online Examination System</b>
			</div>
		<!--logo -->
		<div id="logoutButton"><img src="../assets/images/logout.png" alt="Logout" width="25" height="25" border="0" id="logOutButton"></div>

		</div><br>
<!--header end -->
<!---Upcoming Exam Table--->
<h3 class="largeMargin largePadding">Exams:</h3><br>

<div class="examList Display">
	<form class="examDisplayForm" id="examDisplayForm" method="POST">
				<input type="hidden" id="testID">
	<!---	<div id="countdowntimer"><span id="future_date"><span></div>--->
			<table id="examDisplayTable" class="display">
				<thead>
					<tr>
						<th>Test</th>
                        <th>Test Date</th>
						<th>Test Time</th>
						<th>Take Test</th>
                    </tr>
               </thead>
               <tbody>
			</tbody>
          </table>
		</form>
	</div>
<!---Test Modal--->
	<div class="modal hide fade" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title" >Test Window&nbsp;<span id="timer"></span></h4>
        </div>
        <div class="modal-body">
			<form class="onlineTestForm" id="onlineTestForm" method="POST">
			</form>

        </div>
        <div class="modal-footer">
			<button type="button" class="btn btn-default left" id="examNext">Next Question</button>
			<button type="button" class="btn btn-default" id="examSubmit">Submit Test</button>
        </div>
      </div>
  </div>
</div>
</body>
</html>
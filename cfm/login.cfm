

<html>

<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/login.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>

<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
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
			<div class="headernav">
                <ul>
                <li><a href="registration.cfm">Sign Up</a></li>
	            <li><a href="about.cfm">About</a></li>
                <li><a id="activepage" href="#home">Home</a></li>
                </ul>
			</div>
		</div>
<!--header end -->
<!--Log-in area-->

	<cfif structKeyExists(session,"stLoggedInUser")>
		<cfif isUserInRole('teacher')>
			<cflocation url="teacherHome.cfm" addtoken="no">
			<cfelse>
			<cflocation url="studentHome.cfm" addtoken="no">
			</cfif>

	<cfelse>
<div class="login-card">
    <h1>Log-in</h1><br>

  <form class="login-form" id="loginForm"<!---  method="POST" onsubmit="validateForm()" --->>
	<span id="userError"></span>
    <input type="text" name="user" id="user" placeholder="Email ID">
	<span id="passwordError"></span>
    <input type="password" name="pass" id="password" placeholder="Password">
    <input type="button" id="submitButton" name="login" class="login login-submit" value="Login">
  </form>

  <div class="login-help">
    don't have an account? • <a href="registration.cfm">Register</a>
  </div>
</div>

	</cfif>




<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/slidingRegistration.js"> </script>
<script src="../assets/script/examScript.js"> </script>
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
                <li><a id="activepage" href="#about">Sign Up</a></li>
	            <li><a href="about.cfm">About</a></li>
                <li><a href="login.cfm">Home</a></li>
                </ul>
			</div>
		</div>
		<!--header end -->

<!-- multistep form -->
<form id="msform" name="registration" method="POST" action="post.cfm">
  <!-- progressbar -->
  <ul id="progressbar">
    <li class="active">Account Type</li>
    <li>Account Setup</li>
    <li>Personal Details</li>
    <li>Contact Details</li>

  </ul>
  <!-- fieldsets -->
    <fieldset>
    <h2 class="fs-title">Account Type</h2>
    <input type="button" name="teacher" id="teacher" class="next a" value="Teacher" />
    <input type="button" name="student" id="student" class="next a" value="Student" />
	<input type="hidden" id="designation" name="designation"/>
  </fieldset>
  <fieldset>
    <h2 class="fs-title">Create your account</h2>
	<span id="emailError"></span>
    <input type="text" name="email" id="email" placeholder="Email" />
	<span id="passwordError"></span>
    <input type="password" name="pass" id="password" placeholder="Password" />
	<span id="cpasswordError"></span>
    <input type="password" name="cpass" id="cpassword" placeholder="Confirm Password" />
    <input type="button" name="previous" class="previous action-button" value="Previous" />
    <input type="button" name="next" class="next action-button" value="Next" />
  </fieldset>
  <fieldset>
    <h2 class="fs-title">Personal Details</h2>
    <span id="fnameError"></span>
    <input type="text" name="fname" id="fname" placeholder="First Name" />
	<span id="mnameError"></span>
    <input type="text" name="mname" id="mname" placeholder="Middle Name" />
	<span id="lnameError"></span>
    <input type="text" name="lname" id="lname" placeholder="Last Name" />
    <input type="button" name="previous" class="previous action-button" value="Previous" />
    <input type="button" name="next" class="next action-button" value="Next" />

  </fieldset>
    <fieldset>
    <h2 class="fs-title">Contact Details</h2>
    <span id="phoneError"></span>
    <input type="text" name="phone" id="phone" placeholder="Contact Number" />
	<span id="addressError"></span>
    <textarea name="address" id="address" placeholder="Address"></textarea>
	<span id="cityError"></span>
    <input class="halfwidth" type="text" id="city" name="city" placeholder="City" />
	<span id="stateError"></span>
    <input class="halfwidth" type="text" id="state" name="state" placeholder="State" />
	<span id="countryError"></span>
    <input class="halfwidth" type="text" id="country" name="country" placeholder="Country" />
	<span id="zipError"></span>
    <input class="halfwidth" type="text" id="zip" name="zip" placeholder="ZIP Code" />
    <input type="button" name="previous" class="previous action-button" value="Previous" />
    <input type="submit" name="submit" class="submit action-button" value="Submit" />
  </fieldset>
</form>
</body>
</html>


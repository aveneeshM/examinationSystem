<cfif NOT isUserLoggedIn()>
	<cflocation url="login.cfm"  addtoken="no">
</cfif>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="../assets/script/logout.js"> </script>
<script src="../assets/script/configurationQueston.js"> </script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="../assets/css/style.css" media="screen" type="text/css" />
<link rel="stylesheet" href="../assets/css/loggedInStyle.css" media="screen" type="text/css" />
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
		<div id="logoutButton"><img src="../assets/images/logout.png" alt="Logout" width="25" height="25" border="0" id="logOutButton"></div>
			<div class="headernav">
                <ul>
	            <li><a href="configurationExam.cfm">Add Exams</a></li>
                <li><a id="activepage" href="#home">Add Questions</a></li>
				<li><a href="teacherHome.cfm">Home</a></li>
                </ul>
			</div>
		</div>
<!--header end -->
<div id="addQuestions">
<form class="addQuesForm" id="addQuesForm" method="POST">

	<div class="tableRow">
	  <div class="label left">
		  <span>Question:&nbsp;</span></div><textarea rows="2" cols="104" id="question"></textarea>
	</div><br><br><br>
	<div class="tableRow">
	  <div class="label left">
		  <span>1<sup>st</sup> Option:&nbsp;</span>
	  </div><textarea rows="1" cols="50" id="option1"></textarea>
	   <span class="checkBox"><label><input type="radio" name="optionSelector" id="ad_Checkbox1" value="1">Correct</label></span>
	</div><br>
	<div class="tableRow">
	  <div class="label left">
		  <span>2<sup>nd</sup> Option:&nbsp;</span>
	  </div><textarea rows="1" cols="50" id="option2"></textarea>
	   <span class="checkBox"><label><input type="radio" name="optionSelector" id="ad_Checkbox2" value="2">Correct</label></span>
	</div><br>
	<div class="tableRow">
	  <div class="label left">
		  <span>3<sup>rd</sup> Option:&nbsp;</span>
	  </div><textarea rows="1" cols="50" id="option3"></textarea>
	   <span class="checkBox"><label><input type="radio" name="optionSelector" id="ad_Checkbox3" value="3">Correct</label></span>
	</div><br>
	<div class="tableRow">
	  <div class="label left">
		  <span>4<sup>th</sup> Option:&nbsp;</span>
	  </div><textarea rows="1" cols="50" id="option4"></textarea>
	   <span class="checkBox"><label><input type="radio" name="optionSelector" id="ad_Checkbox4" value="4">Correct</label></span>
	</div><br><br><br>
<br>
	<div class="tableRow">
		  <div class="label left">
		  <span>Difficulty Level:&nbsp;</span></div>
		  <span class="left"><select name="level" id="level">
			<option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
			</select></span>
	</div>
</div><br>
<input type="button" name="button" id="button" class="login login-submit right addQuestionButton" value="Add Question">
  </form>

</body>
</html>
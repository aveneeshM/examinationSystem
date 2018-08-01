<!---
  --- studentHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/30/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<!---selects all future tests available--->
		<cffunction name="getTest" access="remote" returnformat="JSON">
			<cftry>
		    <cfquery name="testAllQuery" datasource="examinationSystem">
		      select T.testID,T.name,T.duration,T.startDate,T.startTime,R.result from( tests T
		      inner join testStudent R on T.testID = R.testID)
		      order by T.startDate, T.startTime desc
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cfset message="#cfcatch.cause.message#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		   <cfset testArray = arraynew(1)>
		   <cfloop query="testAllQuery">
		     <CFSET testArray[#currentRow#] =[testAllQuery.testID, testAllQuery.name,
		     testAllQuery.duration, #DATEFORMAT(testAllQuery.startDate,"yyyy-mm-dd")#,
		     #TIMEFORMAT(testAllQuery.startTime,"hh:mm:sstt")#,testAllQuery.result] />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>



<!---selects all chosen test of logged in user--->
	   <cffunction name="getTestStudent" access="remote" returnformat="JSON">
		   <cftry>
		    <cfquery name="testStudentAllQuery" datasource="examinationSystem">
		      select testID,testTakerID from testStudent
		      where testTakerID=<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cfset message="#cfcatch.cause.message#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		   <cfset testArray = arraynew(1)>
		   <cfloop query="testStudentAllQuery">
		     <CFSET testArray[#currentRow#] = #testStudentAllQuery.testID# />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>



<!---starts test if current time is in start time window of 15 mins---->
	   <cffunction name="checkTest" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cftry>
			   <!---Query for time and date validation at test start--->
		   <cfquery name="testQuery" datasource="examinationSystem">
		      select startDate,startTime,duration from tests
		      where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <!---Returns number of questions in the test--->
		   <cfquery name="rowCountQuery" datasource="examinationSystem">
		      select questionID from testQuestions
		      where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">

			<cfset type="#cfcatch.Type#" />
			<cfset message="#cfcatch.cause.message#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" /> --->
		</cfcatch>
		</cftry>

		   <cfif #testQuery.startDate# EQ #DATEFORMAT(NOW(),"yyyy-mm-dd")#>

		      <cfset checkTime= TIMEFORMAT(DateAdd("n",55,testQuery.startTime),"hh:mm:ss")>

		      <cfif TIMEFORMAT(Now(),"hh:mm:ss") LT #checkTime# AND
		          TIMEFORMAT(Now(),"hh:mm:ss") GTE TIMEFORMAT(testQuery.startTime,"hh:mm:ss")>

			        <cfset Session.testData = {'endTestTime' =
			        TIMEFORMAT(DateAdd("h",testQuery.duration,testQuery.startTime),"hh:mm:ss"),
			         'correct' = 0, 'total' = rowCountQuery.recordCount, 'testID' = arguments.testID }>
<!---return date time in a format that can be used as dateTime stamp--->
			        <cfreturn [rowCountQuery.recordCount, testQuery.startDate+' '+testQuery.startTime]><!---Used to disable next question button at client side--->



		      <cfelse>
		          <cfreturn "wrong time">
		      </cfif>
		   <cfelse>
		      <cfreturn false>
		   </cfif>
	   </cffunction>



<!---generate nth question of a test--->
	   <cffunction name="generateQuestion" access="remote" returnformat="JSON">
		   <cfargument name="testID" required="true" >
		   <cfargument name="row" required="true" >
	       <cfquery name="getTestQuestionQuery" datasource="examinationSystem">
		      SELECT TOP 1 R.* FROM
             (select top #arguments.row#
			 Q.questionID, Q.questionDescription,Q.option1,Q.option2,
             Q.option3,Q.option4 from (questions Q inner join testQuestions T on Q.questionID = T.questionID)
             where T.testID =  <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
			 order by questionID asc) as R order by questionID desc
		   </cfquery>
		   <cfset testArray = arraynew(1)>

		    <CFSET testArray = [getTestQuestionQuery.questionID,getTestQuestionQuery.questionDescription,getTestQuestionQuery.option1,getTestQuestionQuery.option2,getTestQuestionQuery.option3,getTestQuestionQuery.option4] />
	        <cfreturn testArray>

		</cffunction>

		<cffunction name="saveResult" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cfargument name="questionID" type="numeric" required="true" >
		   <cfargument name="selectedOption" type="string" required="true" >
		   <cftry>
		   <cfquery name="resultQuery" datasource="examinationSystem">
		      select isCorrect from questions
             where questionID = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cfset message="#cfcatch.cause.message#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		   <cfif arguments.selectedOption eq resultQuery.isCorrect>
			<cfset session.testData.correct = session.testData.correct+1>
		   </cfif>
		   <cfreturn true>
	   </cffunction>



<!---Validation at Submit--->
		<cffunction name="finalResult" access="remote" returnformat="JSON">
			<cfargument name="testID" type="numeric" required="true" >
		   <cfif TIMEFORMAT(Now(),"hh:mm:ss") GTE Session.testData.endTestTime>
			   <cfquery result="saveFaultResultQuery" datasource="examinationSystem">
		      update testStudent set
		      result = 0
		      where testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      and testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
			<cfset structdelete(session,'testData')/>
		    <cfreturn false>
		   </cfif>
		   <cfset var correctTemp = session.testData.correct>
		   <cfset var examScore = session.testData.correct/session.testData.total>
		   <cfquery result="storeResultQuery" datasource="examinationSystem">
		      update testStudent set
		      result = <cfqueryparam value= #examScore# cfsqltype="cf_sql_decimal" />
		      where testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      and testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>

		   <!---store result in teststudent--->
		   <cfset structdelete(session,'testData')/>
			<cfreturn correctTemp>
		</cffunction>


<!---Validation ongoing test--->
		<cffunction name="validateOngoingTest" access="remote" returnformat="JSON">
		   <cfif structKeyExists(session,"testData")>
		    <cfreturn true>
		   </cfif>
			<cfreturn false>
		</cffunction>



<!---get current test duration for coutdown timer--->
        <cffunction name="duration" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cftry>
		   <cfquery name="durationQuery" datasource="examinationSystem">
		      select duration from tests
             where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cfset message="#cfcatch.cause.message#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		   <cfreturn durationQuery.duration>
		</cffunction>


<!---function to save result and end test at page load if ongoing test exists--->
		<cffunction name="submitStopTest" access="public" output="false">

		   <cfquery result="submitStopTestQuery" datasource="examinationSystem">
		      update testStudent set
		      result = <cfqueryparam value= #session.testData.correct/session.testData.total# cfsqltype="cf_sql_decimal" />
		      where testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      and testID = <cfqueryparam value= #session.testData.testID# cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfset structdelete(session,'testData')/>


		</cffunction>

























</cfcomponent>
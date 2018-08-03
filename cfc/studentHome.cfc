<!---
  --- studentHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/30/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<!---selects all marked tests available for  the student--->
		<cffunction name="getTest" access="remote" returnformat="JSON">
			<cftry>
		    <cfquery name="testAllQuery" datasource="examinationSystem">
		      SELECT T.testID,T.name,T.duration,T.startDate,T.startTime,R.result FROM( tests T
		      INNER JOIN testStudent R ON T.testID = R.testID)
		      ORDER BY T.startDate, T.startTime DESC
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		   <cfset testArray = arraynew(1)>
		   <cfloop query="testAllQuery">
			   <cfset var testResult = testAllQuery.result>
			   <cfif #testAllQuery.startDate# EQ #DATEFORMAT(NOW(),"yyyy-mm-dd")#>
			   <cfset var checkTimeWindow= TIMEFORMAT(DateAdd("n",15,testAllQuery.startTime),"hh:mm:ss")>


		      <cfif TIMEFORMAT(Now(),"hh:mm:ss") GT #checkTimeWindow#>
			      <cfquery result="invalidTimeResultQuery" datasource="examinationSystem">
		          UPDATE testStudent SET
		          result = 0
		          WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		          AND testID = <cfqueryparam value="#testAllQuery.testID#" cfsqltype="cf_sql_integer" />
		         </cfquery>
		         <cfset var testResult = 0>
				</cfif>
			  </cfif>
		     <CFSET testArray[#currentRow#] =[testAllQuery.testID, testAllQuery.name,
		     testAllQuery.duration, #DATEFORMAT(testAllQuery.startDate,"yyyy-mm-dd")#,
		     #TIMEFORMAT(testAllQuery.startTime,"hh:mm:sstt")#,testResult] />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>



<!---selects all chosen test of logged in user--->
	   <cffunction name="getTestStudent" access="remote" returnformat="JSON">
		   <cftry>
		    <cfquery name="testStudentAllQuery" datasource="examinationSystem">
		      SELECT testID,testTakerID FROM testStudent
		      WHERE testTakerID=<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
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
		      SELECT startDate,startTime,duration FROM tests
		      WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <!---Returns number of questions in the test--->
		   <cfquery name="rowCountQuery" datasource="examinationSystem">
		      SELECT questionID FROM testQuestions
		      WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">

			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" /> --->
		</cfcatch>
		</cftry>

		   <cfif #testQuery.startDate# EQ #DATEFORMAT(NOW(),"yyyy-mm-dd")#>

		      <cfset checkTime= TIMEFORMAT(DateAdd("n",59,testQuery.startTime),"HH:mm:ss")>

		      <cfif TIMEFORMAT(Now(),"HH:mm:ss") LT #checkTime# AND
		          TIMEFORMAT(Now(),"HH:mm:ss") GTE TIMEFORMAT(testQuery.startTime,"HH:mm:ss")>

			          <cfif  rowCountQuery.recordCount NEQ 0>

			            <cfset Session.testData = {'endTestTime' =
			            TIMEFORMAT(DateAdd("h",testQuery.duration,testQuery.startTime),"HH:mm:ss"),
			            'correct' = 0, 'total' = rowCountQuery.recordCount, 'testID' = arguments.testID,
			            'testResponse' = structNew() }>
			            <cfreturn rowCountQuery.recordCount><!---Used to disable next question button at client side--->
			           <cfelse>
			           <cfreturn "empty test">
			         </cfif>


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
		   <cftry>
	       <cfquery name="getTestQuestionQuery" datasource="examinationSystem">
		      SELECT TOP 1 R.* FROM
             (SELECT TOP #arguments.row#
			 Q.questionID, Q.questionDescription,Q.option1,Q.option2,
             Q.option3,Q.option4 FROM (questions Q INNER JOIN testQuestions T ON Q.questionID = T.questionID)
             WHERE T.testID =  <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
			 ORDER BY questionID ASC) AS R ORDER BY questionID DESC
		   </cfquery>
		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>

		   <cfset var checked = 0>
		   <cfif structKeyExists(session.testData.testResponse, "#getTestQuestionQuery.questionID#")>
		      <cfset var checked = structFind(session.testData.testResponse, "#getTestQuestionQuery.questionID#")>
		   </cfif>

		   <cfset testArray = arraynew(1)>

		    <CFSET testArray = [getTestQuestionQuery.questionID, getTestQuestionQuery.questionDescription,
		    getTestQuestionQuery.option1, getTestQuestionQuery.option2, getTestQuestionQuery.option3,
		    getTestQuestionQuery.option4, checked] />
	        <cfreturn testArray>

		</cffunction>

		<cffunction name="saveResult" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cfargument name="questionID" type="numeric" required="true" >
		   <cfargument name="selectedOption" type="string" required="true" >
		   <cftry>
		   <cfquery name="resultQuery" datasource="examinationSystem">
		      SELECT isCorrect FROM questions
             WHERE questionID = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		</cfcatch>
		</cftry>
		 <cfif NOT structKeyExists(session.testData.testResponse, "#arguments.questionID#")>
		   <cfif arguments.selectedOption eq resultQuery.isCorrect>
			<cfset session.testData.correct = session.testData.correct+1>
		   </cfif>
		   <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",arguments.selectedOption,false)>
		   <cfelse>
		   <cfif ( (arguments.selectedOption eq resultQuery.isCorrect)
		      AND (NOT arguments.selectedOption eq structFind(session.testData.testResponse, "#arguments.questionID#"))
		          )>
			         <cfset session.testData.correct = session.testData.correct+1>
			         <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",
			                arguments.selectedOption,true)>
			</cfif>
			<cfif ( (NOT arguments.selectedOption eq resultQuery.isCorrect)
		      AND (NOT arguments.selectedOption eq structFind(session.testData.testResponse, "#arguments.questionID#"))
		          )>
			         <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",
			                arguments.selectedOption,true)>
			</cfif>

		 </cfif>
		<!--- </cfif> --->
		   <cfreturn true>
	   </cffunction>



<!---Validation at Submit--->
		<cffunction name="finalResult" access="remote" returnformat="JSON">
			<cfargument name="testID" type="numeric" required="true" >
			<cftry>
		    <cfif TIMEFORMAT(Now(),"HH:mm:ss") GT Session.testData.endTestTime>
			   <cfquery result="saveFaultResultQuery" datasource="examinationSystem">
		          UPDATE testStudent SET
		          result = 0
		          WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		          AND testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		       </cfquery>
			   <cfset structdelete(session,'testData')/>
		       <cfreturn false>
		    </cfif>
		    <cfset var correctTemp = session.testData.correct>
		    <cfset var examScore = session.testData.correct/session.testData.total>
		    <cfquery result="storeResultQuery" datasource="examinationSystem">
		      UPDATE testStudent SET
		      result = <cfqueryparam value= #examScore# scale='2' cfsqltype="cf_sql_decimal" />
		      WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      AND testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		    </cfquery>
		    <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		    </cfcatch>
		    </cftry>

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



<!---get current test duration for countdown timer--->
        <cffunction name="duration" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cftry>
		   <cfquery name="durationQuery" datasource="examinationSystem">
		      SELECT duration FROM tests
             WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
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

			<cftry>
		   <cfquery result="submitStopTestQuery" datasource="examinationSystem">
		      UPDATE testStudent SET
		      result = <cfqueryparam value= #session.testData.correct/session.testData.total# cfsqltype="cf_sql_decimal" />
		      WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      AND testID = <cfqueryparam value= #session.testData.testID# cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		   </cfcatch>
		   </cftry>
		   <cfset structdelete(session,'testData')/>


		</cffunction>



</cfcomponent>
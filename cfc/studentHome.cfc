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
		      SELECT tests.testID,
		             tests.name,
		             tests.duration,
		             tests.startDate,
		             tests.startTime,
		             testStudent.result
		      FROM( tests INNER JOIN testStudent ON tests.testID = testStudent.testID)
		      WHERE testStudent.testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      ORDER BY tests.startDate, tests.startTime DESC
		   </cfquery>

		   <cfset testArray = arraynew(1)>

		   <cfloop query="testAllQuery">
			   <cfset var testResult = testAllQuery.result>
			   <cfset var checkTimeWindow= TIMEFORMAT(DateAdd("n",59,testAllQuery.startTime),"HH:mm:ss")>

			   <cfif (DATEFORMAT(#testAllQuery.startDate#,"yyyy-mm-dd") LT DATEFORMAT(NOW(),"yyyy-mm-dd")) OR
			         (DATEFORMAT(#testAllQuery.startDate#,"yyyy-mm-dd") EQ DATEFORMAT(NOW(),"yyyy-mm-dd") AND
			         TIMEFORMAT(Now(),"HH:mm:ss") GT checkTimeWindow)>

			     <cfif NOT len(testAllQuery.result)>
			      <cfquery result="invalidTimeResultQuery" datasource="examinationSystem">
		          UPDATE testStudent SET
		          result = 0
		          WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		          AND testID = <cfqueryparam value="#testAllQuery.testID#" cfsqltype="cf_sql_integer" />
		         </cfquery>
		         <cfset var testResult = 0>
		       </cfif>
		     </cfif>

		     <cfset testArray[#currentRow#] =[testAllQuery.testID,
		                                      testAllQuery.name,
		                                      testAllQuery.duration,
		                                      DATEFORMAT(testAllQuery.startDate,"dd-mmm-yyyy"),
		                                      TIMEFORMAT(testAllQuery.startTime,"HH:mm:ss"),testResult] />
	       </cfloop>
		   <cfreturn testArray>
		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
	   </cffunction>



<!---!!Not used, Delete this!!selects all chosen test of logged in user--->
	   <cffunction name="getTestStudent" access="remote" returnformat="JSON">
		   <cftry>
		    <cfquery name="testStudentAllQuery" datasource="examinationSystem">
		      SELECT testID,
		             testTakerID
		      FROM testStudent
		      WHERE testTakerID=<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		    </cfquery>
		    <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		    </cfcatch>
		  </cftry>
		  <cfset testArray = arraynew(1)>
		  <cfloop query="testStudentAllQuery">
		    <cfset testArray[#currentRow#] = #testStudentAllQuery.testID# />
	      </cfloop>
		  <cfreturn testArray>
	   </cffunction>



<!---starts test if current time is in start time window of 15(59 for now) mins---->
	   <cffunction name="checkTest" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cftry>
			   <!---Query for time and date validation at test start--->
		   <cfquery name="testQuery" datasource="examinationSystem">
		      SELECT startDate,
		             startTime,
		             duration
		      FROM tests
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
				   	  Exception type: #type#" /> --->
		   </cfcatch>
		   </cftry>

		   <cfif DATEFORMAT(testQuery.startDate,"yyyy-mm-dd") EQ DATEFORMAT(NOW(),"yyyy-mm-dd")>

		      <cfset checkTime= TIMEFORMAT(DateAdd("n",59,testQuery.startTime),"HH:mm:ss")>

		      <cfif TIMEFORMAT(Now(),"HH:mm:ss") LTE #checkTime# AND
		          TIMEFORMAT(Now(),"HH:mm:ss") GTE TIMEFORMAT(testQuery.startTime,"HH:mm:ss")>

			          <cfif  rowCountQuery.recordCount NEQ 0>

			            <cfset Session.testData = {'endTestTime' =
			               TIMEFORMAT(DateAdd("h",testQuery.duration,testQuery.startTime),"HH:mm:ss"),
			               'correct' = 0,
			               'total' = rowCountQuery.recordCount,
			               'testID' = arguments.testID,
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
		   <cfif NOT  structKeyExists(session, "testData")>
			   <cfreturn false>
			</cfif>
 		   <cftry>
	       <cfquery name="getTestQuestionQuery" datasource="examinationSystem">
		     SELECT TOP 1 nRows.* FROM
             (SELECT TOP #arguments.row#
			             questions.questionID,
			             questions.questionDescription,
			             questions.option1,
			             questions.option2,
                         questions.option3,
						 questions.option4
			 FROM (questions INNER JOIN testQuestions  ON questions.questionID = testQuestions.questionID)
             WHERE testQuestions.testID =  <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
			 ORDER BY testQuestions.questionID ASC) AS nRows
			 ORDER BY nRows.questionID DESC
		   </cfquery>
		   <cfcatch type = "any">
		        <cfset type="#cfcatch.Type#" />
	            <cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		   </cfcatch>
		   </cftry>
		   <cfset var checked = 0>

		   <cfif structKeyExists(session.testData.testResponse, "#getTestQuestionQuery.questionID#")>
		      <cfset var checked = structFind(session.testData.testResponse, "#getTestQuestionQuery.questionID#")>
		   </cfif>

		   <cfset testArray = arraynew(1)>

		    <cfset testArray = [getTestQuestionQuery.questionID,
		                        getTestQuestionQuery.questionDescription,
		                        getTestQuestionQuery.option1,
		                        getTestQuestionQuery.option2,
		                        getTestQuestionQuery.option3,
		                        getTestQuestionQuery.option4,
		                        checked] />

	        <cfreturn testArray>

		</cffunction>
<!---Save and update ongoing test result in a session variable--->
		<cffunction name="saveResult" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cfargument name="questionID" type="numeric" required="true" >
		   <cfargument name="selectedOption" type="string" required="true" >
		   <cfif NOT  structKeyExists(session, "testData")>
			   <cfreturn false>
			</cfif>
		   <cftry>
		   <cfquery name="resultQuery" datasource="examinationSystem">
		      SELECT isCorrect
		      FROM questions
              WHERE questionID = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		   </cfcatch>
		   </cftry>


		 <!--- If selected question has not been answered before--->
		 <cfif NOT structKeyExists(session.testData.testResponse, "#arguments.questionID#")>
		   <cfif arguments.selectedOption eq resultQuery.isCorrect>
			<cfset session.testData.correct = session.testData.correct + 1>
		   </cfif>
		   <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",arguments.selectedOption,false)>

		   <!--- If selected question has previously been answered --->
		   <cfelse>
		   <!--- If new choice is correct and previous choice was wrong --->
		   <cfif ( (arguments.selectedOption eq resultQuery.isCorrect)
		         AND (NOT resultQuery.isCorrect eq structFind(session.testData.testResponse, "#arguments.questionID#"))
		          )>
			         <cfset session.testData.correct = session.testData.correct + 1>
			         <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",
			                arguments.selectedOption,true)>
			</cfif>

			<!--- If new choice is wrong and previous choice was also wrong --->
			<cfif ( (NOT arguments.selectedOption eq resultQuery.isCorrect)
		          AND (NOT resultQuery.isCorrect eq structFind(session.testData.testResponse, "#arguments.questionID#"))
		          )>
			         <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",
			                arguments.selectedOption,true)>
			</cfif>

			<!--- If new choice is wrong and previous choice was correct --->
			<cfif ( (NOT arguments.selectedOption eq resultQuery.isCorrect)
		          AND (resultQuery.isCorrect eq structFind(session.testData.testResponse, "#arguments.questionID#"))
		          )>
			         <cfset session.testData.correct = session.testData.correct - 1>
			         <cfset temp=StructInsert(session.testData.testResponse,"#arguments.questionID#",
			                arguments.selectedOption,true)>
			</cfif>

		 </cfif>
		   <cfreturn true>
	   </cffunction>

<!---Validation at Submit--->
		<cffunction name="finalResult" access="remote" returnformat="JSON">
			<cfargument name="testID" type="numeric" required="true" >

			<cfif NOT  structKeyExists(session, "testData")>
			   <cfreturn "submitted">
			</cfif>

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
				   	  Exception type: #type#" />
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
		      SELECT duration
		      FROM tests
              WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
		   <cfreturn durationQuery.duration>
		</cffunction>


<!---function to save result and end test at page load if ongoing test exists--->
		<cffunction name="submitStopTest" access="public" output="false">
			<cfset var finalResult = session.testData.correct/session.testData.total>

		   <cftry>
		   <cfquery result="submitStopTestQuery" datasource="examinationSystem">
		      UPDATE testStudent SET
		      result = <cfqueryparam value=#finalResult# scale="2" cfsqltype="cf_sql_decimal" />
		      WHERE testTakerID = <cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		      AND testID = <cfqueryparam value= #session.testData.testID# cfsqltype="cf_sql_integer" />
		   </cfquery>
 		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		   </cfcatch>
		   </cftry>
		   <cfset structdelete(session,'testData')/>
		</cffunction>



</cfcomponent>
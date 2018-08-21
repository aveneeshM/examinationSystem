<!---
  --- exams
  --- -----
  ---
  --- author: aveenesh
  --- date:   7/28/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!---function to get list of all exams--->
<cffunction name="examAll" access="public">
	<cftry>
	<cfquery name="examAllQuery">
          SELECT name,
		         testID,
		         createdDate,
		         startDate,
		         duration,
		         startTime
		  FROM tests
		  ORDER BY createdDate DESC, startTime DESC
	</cfquery>
	<cfreturn #examAllQuery#>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
</cffunction>


<!---function to get list of all questions. Check questions already selected in the test--->
<cffunction name="testQuestion" access="remote" returnformat="JSON">
	<cfargument name="testID" type="numeric" required="true" >
	<cftry>
		<!---Query to get selected questions of a test--->
		<cfquery name="questionSelectedQuery">
		 SELECT questionID
		 FROM testQuestions
		 WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		 </cfquery>

		 <!---Query to get all active questions--->
		<cfquery name="questionAllQuery">
		 SELECT questionDescription,
		        questionID
		 FROM questions
		 WHERE isActive = 1
		 ORDER BY questionID DESC
		 </cfquery>
		 <cfset var questionArr = arraynew(1)>
		 <cfset var selectedQuestionID = ValueList(questionSelectedQuery.questionID)>
		 <cfloop query="questionAllQuery">
			 <cfif ListFind(selectedQuestionID, questionAllQuery.questionID)>
				 <cfset var checked = "checked">
				 <cfelse>
				 <cfset var checked = "">
			</cfif>
			<!---array of all questions where selected questions are checked--->
			 <cfset questionArray[currentRow] =["#questionAllQuery.questionID#", "#questionAllQuery.questionDescription#",
			 "#arguments.testID#",checked] />
		</cfloop>
		 <cfreturn questionArray>
		 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		    <cfreturn false>
		</cfcatch>
		</cftry>
	</cffunction>

<!---Add/update data for testQuestions--->
<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
	<cfargument name="testID" type="string" required="true" >
	<cftry>
	<cfquery result="addQuestionTestQuery">
			DELETE FROM testQuestions WHERE
			testID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.testID#" />
	</cfquery>

	<cfloop list="#arguments.questionIDs#" index="id">
	<cfquery result="addQuestionTestQuery">
			INSERT INTO testQuestions
			(
			questionID,testID
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id#" />,
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.testID#" />

		    )
	</cfquery>
    </cfloop>
    <cfreturn true/>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		    <cfreturn false>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>
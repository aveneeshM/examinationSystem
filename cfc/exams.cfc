<!---
  --- exams
  --- -----
  ---
  --- author: aveenesh
  --- date:   7/28/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<cffunction name="examAll" access="public">
	<cftry>
	<cfquery name="examAllQuery" datasource="examinationSystem">
          SELECT name,
		         testID,
		         createdDate,
		         startDate,
		         duration,
		         startTime
		  FROM tests
		  ORDER BY createdDate DESC, startTime DESC
	</cfquery>
		 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
	<cfreturn #examAllQuery#>

	</cffunction>


<!---get all questions. Check questions already selectd in the test--->
<cffunction name="testQuestion" access="remote" returnformat="JSON">
	<cfargument name="testID" type="numeric" required="true" >
	<cftry>
		<cfquery name="questionSelectedQuery" datasource="examinationSystem">
		 SELECT questionID
		 FROM testQuestions
		 WHERE testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		 </cfquery>
		<cfquery name="questionAllQuery" datasource="examinationSystem">
		 SELECT questionDescription,
		        questionID
		 FROM questions
		 WHERE isActive = 1
		 ORDER BY questionID DESC
		 </cfquery>
		 <cfcatch type = "any">
			 <cfset type="#cfcatch.Type#" />
			 <cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		 </cfcatch>
		 </cftry>
		 <cfset questionArr = arraynew(1)>
		 <cfset myList = ValueList(questionSelectedQuery.questionID)>
		 <cfloop query="questionAllQuery">
			 <cfif ListFind(myList, questionAllQuery.questionID)>
				 <cfset var checked = "checked">
				 <cfelse>
				 <cfset var checked = "">
			</cfif>
			 <cfset questionArray[#currentRow#] =["#questionAllQuery.questionID#", "#questionAllQuery.questionDescription#",
			 "#arguments.testID#",checked] />
		</cfloop>
		 <cfreturn questionArray>
	</cffunction>

<!---Add/update data for testQuestions--->
<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
	<cfargument name="testID" type="string" required="true" >
	<cfquery result="addQuestionTestQuery" datasource="examinationSystem">
			DELETE FROM testQuestions WHERE
			testID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.testID#" />
	</cfquery>

	<cfloop list="#arguments.questionIDs#" index="id">
	<cftry>
	<cfquery result="addQuestionTestQuery" datasource="examinationSystem">
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
		 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
</cfloop>
<cfreturn true/>
	</cffunction>
</cfcomponent>
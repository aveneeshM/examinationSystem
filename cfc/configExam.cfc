<!---
  --- configExam
  --- ----------
  ---
  --- author: aveenesh
  --- date:   7/26/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!---Functionn to check if test name already taken--->
<cffunction name="nameChecker" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="name" type="string" required="true" >
	<cftry>
	<cfquery name="nameCheckQuery">
        SELECT name
		FROM tests
		WHERE name=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	<cfif nameCheckQuery.recordcount>
		<cfreturn false/>
		<cfelse>
		<cfreturn true/>
	</cfif>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
				<cfreturn "error">
		</cfcatch>
		</cftry>
</cffunction>

<!---Return list of time slots already booked for a day--->
<cffunction name="timeChecker" access="remote" returnformat="JSON">
	<cfargument name="date" type="string" required="true" >
	<cftry>
	<cfset  var parsedDate = CREATEODBCDATETIME("#arguments.date#")>

	<cfquery name="timeCheckQuery">
          SELECT duration,
		         startTime
		  FROM tests
		  WHERE startDate=<cfqueryparam cfsqltype="CF_SQL_DATE" value= #parsedDate# />
	</cfquery>

	<cfif timeCheckQuery.recordcount>
		<cfset var myarray=arraynew(1)>
		<cfset var loopingVar = 1>
		<cfloop query = "timeCheckQuery">
		    <!---loop from start time to mentioned duration--->
			<cfloop index = "LoopCount" from = "0" to = "#timeCheckQuery.duration - 1#" step = "1">
            <cfset var endTime = TIMEFormat(DateAdd("h", LoopCount, timeCheckQuery.startTime), "HH:mm:ss")>
			<cfset var myarray[loopingVar]=endTime>
			<cfset var loopingVar+=1>
            </cfloop>
        </cfloop>
		<cfreturn myarray/>
		<cfelse>
		<cfreturn []/>
	</cfif>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		    <cfreturn "error">
		</cfcatch>
		</cftry>
	</cffunction>

<!---Insert created test data--->
	<cffunction name="addExam" access="remote" returntype="string" returnformat="JSON">
		<cfargument name="name" type="string" required="true" >
	    <cfargument name="startTime" type="string" required="true" >
	    <cfargument name="startDate" type="string" required="true" >
	    <cfargument name="duration" type="string" required="true" >
	    <cftry>
	    <cfif NOT structKeyExists(session,"stLoggedInUser")>
		    <cfreturn "does not">
	    </cfif>

	    <cfquery result="insertExam">
			INSERT INTO tests
			(
			name,createdDate,duration,testCreatorID,startDate,startTime
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.name#" />,
		    <cfqueryparam cfsqltype="CF_SQL_DATE" value="#DateFormat(Now(),"yyyy-mm-dd")#" />,
		    <cfqueryparam cfsqltype="CF_SQL_SMALLINT" value="#arguments.duration#" />,
		    <cfqueryparam cfsqltype="CF_SQL_INT" value="#session.stLoggedInUser.userID#" />,
            <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.startDate#" />,
            <cfqueryparam cfsqltype="CF_SQL_TIME" value="#arguments.startTime#" />

		    )
	    </cfquery>
	    <cfset session.presentTestID = insertExam.GENERATEDKEY>
	<cfreturn "inserted"/>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		    <cfreturn "error">
		</cfcatch>
		</cftry>
	</cffunction>

<!---get list of all questions to add in the newly created test--->
	<cffunction name="testQuestion" access="remote" returnformat="JSON">
     <cftry>
     <cfquery name="questionAllQuery">
		SELECT questionDescription, questionID FROM questions
		WHERE isActive = 1
	 </cfquery>
	  <cfset var questionArray = arraynew(1)>
      <cfloop query="questionAllQuery">
          <cfset var questionArray[currentRow] =["#questionAllQuery.questionID#",
		                                        "#questionAllQuery.questionDescription#",
		                                        session.presentTestID] />
	  </cfloop>
	  <cfreturn questionArray>
	  <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
	</cffunction>

<!---Add all selected questions to the test--->
	<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
    <cftry>
	<cfloop list="#arguments.questionIDs#" index="id">

	<cfquery result="addQuestionTestQuery">
			INSERT INTO testQuestions
			(
			questionID,testID
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id#" />,
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value= #INT(session.presentTestID)# />

		    )
	</cfquery>

    </cfloop>
    <cfset StructDelete(session, "presentTestID") />

    <cfreturn true/>
	<cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
    </cffunction>

</cfcomponent>
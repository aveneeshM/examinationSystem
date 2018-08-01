<!---
  --- configExam
  --- ----------
  ---
  --- author: aveenesh
  --- date:   7/26/18
  --->
<!---Check if test name already taken--->
<cfcomponent accessors="true" output="false" persistent="false">
<cffunction name="nameChecker" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="name" type="string" required="true" >
	<cftry>
	<cfquery name="nameCheckQuery" datasource="examinationSystem">
          select name from tests where name=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar" />
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
	<cfif #nameCheckQuery.recordcount#>
		<cfreturn false/>
		<cfelse>
		<cfreturn true/>
	</cfif>
	</cffunction>

<!---Return list of time slots already booked for a day--->
<cffunction name="timeChecker" access="remote" returntype="array" returnformat="JSON">
	<cfargument name="date" type="string" required="true" >
	<CFSET  var parsedDate = #CREATEODBCDATETIME("#arguments.date#")#>
	<cftry>
	<cfquery name="timeCheckQuery" datasource="examinationSystem">
          select duration, startTime from tests where
		  startDate=#parsedDate#
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
	<cfif #timeCheckQuery.recordcount#>
		<cfset  myarray=arraynew(1)>
		<cfset var loopingVar = 1>
		<cfloop query = "timeCheckQuery">

			<cfloop index = "LoopCount" from = "0" to = "#timeCheckQuery.duration - 1#" step = "1">
            <CFSET var endTime = TIMEFormat(#DateAdd("h", #LoopCount#, #timeCheckQuery.startTime#)#, "HH:mm:ss")>
			<cfset myarray[#loopingVar#]=#endTime#>
			<cfset loopingVar+=1>
            </cfloop>
        </cfloop>
		<cfreturn #myarray#/>
		<cfelse>
		<cfreturn []/>
	</cfif>
	</cffunction>

<!---Insert created test data--->
	<cffunction name="addExam" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="name" type="string" required="true" >
	<cfargument name="startTime" type="string" required="true" >
	<cfargument name="startDate" type="string" required="true" >
	<cfargument name="duration" type="string" required="true" >
	<CFSET  var parsedDate = #CREATEODBCDATETIME("#arguments.startDate#")#>
	<cfset date =#DateFormat(parsedDate, "yyyy-mm-dd")#>
	<CFSET  var parsedTime = #CREATEODBCTIME("#arguments.startTime#")#>
	<cfset date =#LSTimeFormat(parsedTime, "hh:mm:ss")# >
	<cfset  myarray=arraynew(1)>
	<cfset myarray[1]=#date#>
	<cfset myarray[2]=#parsedTime#>
	<cfif NOT structKeyExists(session,"stLoggedInUser")>
		<cfreturn "does not">
	</cfif>
	<cftry>
	<cfquery result="insertExam" datasource="examinationSystem">
			insert into tests
			(
			name,createdDate,duration,testCreatorID,startDate,startTime
			)
		    values
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.name#" />,
		    <cfqueryparam cfsqltype="CF_SQL_DATE" value="#DateFormat(Now(),"yyyy-mm-dd")#" />,
		    <cfqueryparam cfsqltype="CF_SQL_SMALLINT" value="#arguments.duration#" />,
		    <cfqueryparam cfsqltype="CF_SQL_INT" value="#session.stLoggedInUser.userID#" />,
            <cfqueryparam cfsqltype="CF_SQL_DATE" value="#arguments.startDate#" />,
            <cfqueryparam cfsqltype="CF_SQL_TIME" value="#arguments.startTime#" />

		    )
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
	<cfreturn "inserted"/>
	</cffunction>


<!---
	<cffunction name="testQuestion" access="remote" returnformat="JSON">
	<cftry>
		<cfquery name="questionAllQuery" datasource="examinationSystem">
		select Q.questionDescription, Q.questionID from questions Q
		 order by Q.questionID desc
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
		 <cfset questionArr = arraynew(1)>
		 <cfloop query="questionAllQuery">
			 <CFSET questionArray[#currentRow#] =["#questionAllQuery.questionID#",
			 "#questionAllQuery.questionDescription#", "#arguments.testID#"] />
		</cfloop>
		 <cfreturn questionArray>
	</cffunction>
	<!---get test id and add questions--->
	<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
	<cfargument name="testName" type="string" required="true" >

	<cfloop list="#arguments.questionIDs#" index="id">
	<cftry>
	<cfquery result="addQuestionTestQuery" datasource="examinationSystem">
			insert into testQuestions
			(
			questionID,testID
			)
		    values
		    (
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#id#" />,
		    <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.testID#" />

		    )
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
</cfloop>
<cfreturn true/>
	</cffunction>
--->

</cfcomponent>
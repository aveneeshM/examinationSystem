<!---
  --- exams
  --- -----
  ---
  --- author: aveenesh
  --- date:   7/28/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<!---><cfset variables.presentTestID = session.stLoggedInUser.testID>--->
<cffunction name="examExists" access="public" returntype="string" returnformat="JSON">
	<cftry>
	<cfquery name="examExistsQuery" datasource="examinationSystem">
          select name from tests
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
	<cfreturn #examExistsQuery.recordcount#>

	</cffunction>


<cffunction name="examAll" access="public">
	<cftry>
	<cfquery name="examAllQuery" datasource="examinationSystem">
          select name, testID, createdDate, startDate, duration, startTime from
		 tests order by createdDate desc, startTime desc
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
	<cfreturn #examAllQuery#>

	</cffunction>



	<cffunction name="testQuestion" access="remote" returnformat="JSON">
	<cfargument name="testID" type="string" required="true" >
	<cftry>
		<cfquery name="questionAllQuery" datasource="examinationSystem">
		select Q.questionDescription, Q.questionID from questions Q where Q.questionID
		not in (select questionID from testQuestions where
		 testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />)
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
			 <CFSET questionArray[#currentRow#] =["#questionAllQuery.questionID#", "#questionAllQuery.questionDescription#", "#arguments.testID#"] />
		</cfloop>
		 <cfreturn questionArray>
	</cffunction>

<cffunction name="questionAll" access="public">

	<!---<cfif #session.stLoggedInUser.testID#>--->
	<cftry>

	<cfquery name="questionAllQuery" datasource="examinationSystem">
		<!---select Q.questionDescription, Q.questionID from questions Q where Q.questionID
		not in (select questionID from testQuestions where
		 testID = <cfqueryparam value="#session.stLoggedInUser.testID#" cfsqltype="cf_sql_integer" />)
		 order by Q.questionID desc--->
		 select Q.questionDescription, Q.questionID from questions Q order by Q.questionID desc
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

	<cfreturn #questionAllQuery#>
	<!---<cfelse>
	<cfreturn false>
	</cfif>--->

	</cffunction>



	<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
	<cfargument name="testID" type="string" required="true" >

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
</cfcomponent>
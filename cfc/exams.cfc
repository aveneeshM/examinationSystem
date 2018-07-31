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
	<cfquery name="examExistsQuery" datasource="examinationSystem">
          select name from tests
	</cfquery>
	<cfreturn #examExistsQuery.recordcount#>

	</cffunction>


<cffunction name="examAll" access="public">
	<cfquery name="examAllQuery" datasource="examinationSystem">
          select name, testID, createdDate, startDate, duration, startTime from tests
	</cfquery>
	<cfreturn #examAllQuery#>

	</cffunction>





	<cffunction name="testQuestion" access="remote" returnformat="JSON">
	<cfargument name="testID" type="string" required="true" >
		<cfquery name="questionAllQuery" datasource="examinationSystem">
		select Q.questionDescription, Q.questionID from questions Q where Q.questionID
		not in (select questionID from testQuestions where
		 testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />)
		 order by Q.questionID desc
		 </cfquery>
		 <cfset questionArr = arraynew(1)>
		 <cfloop query="questionAllQuery">
			 <CFSET questionArray[#currentRow#] =["#questionAllQuery.questionID#", "#questionAllQuery.questionDescription#", "#arguments.testID#"] />
		</cfloop>
		 <cfreturn questionArray>
	</cffunction>

<cffunction name="questionAll" access="public">



	<!---<cfif #session.stLoggedInUser.testID#>--->

	<cfquery name="questionAllQuery" datasource="examinationSystem">
		<!---select Q.questionDescription, Q.questionID from questions Q where Q.questionID
		not in (select questionID from testQuestions where
		 testID = <cfqueryparam value="#session.stLoggedInUser.testID#" cfsqltype="cf_sql_integer" />)
		 order by Q.questionID desc--->
		 select Q.questionDescription, Q.questionID from questions Q order by Q.questionID desc
	</cfquery>

	<cfreturn #questionAllQuery#>
	<!---<cfelse>
	<cfreturn false>
	</cfif>--->

	</cffunction>





	<cffunction name="addQuestionTest" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="questionIDs" type="string" required="true" >
	<cfargument name="testID" type="string" required="true" >

	<cfloop list="#arguments.questionIDs#" index="id">

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
</cfloop>
<cfreturn true/>
	</cffunction>




</cfcomponent>
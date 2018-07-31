<!---
  --- teacherHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/29/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

	<cffunction name="questionExists" access="public" returntype="string" returnformat="JSON">
		<cfquery name="questionExistsQuery" datasource="examinationSystem">
          select top 1 questionID from questions
	    </cfquery>
	    <cfreturn #questionExistsQuery.recordcount#>
	</cffunction>

	<cffunction name="questionAll" access="public">
	    <cfquery name="questionAllQuery" datasource="examinationSystem">
          select questionID,questionDescription,difficultyLevel,option1,
		  option2,option3,option4,isCorrect,isActive from questions
		  order by createdDate desc
	    </cfquery>
        <cfreturn #questionAllQuery#>
	</cffunction>

	<cffunction name="getQuestion" access="remote" returnformat="JSON">
	    <cfargument name="questionID" type="string" required="true" >
		<cfquery name="getQuestionQuery" datasource="examinationSystem">
		  select questionDescription, questionID, option1,option2,option3,option4,isCorrect from questions where questionID
		  = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" /> order by createdDate desc
	    </cfquery>
		<cfset questionArr = arraynew(1)>
		<cfset questionArr =["#getQuestionQuery.questionID#", "#getQuestionQuery.questionDescription#",
			 "#getQuestionQuery.option1#","#getQuestionQuery.option2#", "#getQuestionQuery.option3#", "#getQuestionQuery.option4#",
			 "#getQuestionQuery.isCorrect#"] />
		<cfreturn questionArr>
	</cffunction>


	<cffunction name="editQuestion" access="remote" returntype="string" returnformat="JSON">
	  <cfargument name="questionID" type="string" required="true" >
	  <cfargument name="options" type="string" required="true" >

	  <cfquery result="editQuestionQuery" datasource="examinationSystem">
		UPDATE questions
		set isCorrect = <cfqueryparam cfsqltype="CF_SQL_varchar" value="#arguments.options#" />
        WHERE questionID =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.questionID#" />
	  </cfquery>

      <cfreturn true/>
	</cffunction>


</cfcomponent>
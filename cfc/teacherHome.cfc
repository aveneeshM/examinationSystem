<!---
  --- teacherHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/29/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!---Function to return all questions --->
	<cffunction name="questionAll" access="remote">
		<cftry>
	    <cfquery name="questionAllQuery">
          SELECT questionID,
		         questionDescription,
		         difficultyLevel,
		         option1,
		         option2,
		         option3,
		         option4,
		         isCorrect,
		         isActive
		  FROM questions
		  ORDER BY createdDate DESC
	    </cfquery>
        <cfreturn #questionAllQuery#>
		<cfcatch type = "any">
		<cfset type="#cfcatch.Type#" />
		<cflog type="Error"
			file="examSystemLogs"
			text="Exception error --
				   	 Exception type: #type#
				   	 ,Message:#cfcatch.Message#" />
		</cfcatch>
		</cftry>
	</cffunction>

<!---Function to return selected question --->
	<cffunction name="getQuestion" access="remote" returnformat="JSON">
	    <cfargument name="questionID" type="string" required="true" >
	    <cftry>
		<cfquery name="getQuestionQuery">
		  SELECT questionDescription,
		         questionID,
		         option1,
		         option2,
		         option3,
		         option4,
		         isCorrect,
		         isActive
		  FROM questions
		  WHERE questionID = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" />
	    </cfquery>
		<cfset var questionArr = arraynew(1)>
		<cfset var questionArr =["#getQuestionQuery.questionID#", "#getQuestionQuery.questionDescription#",
			                    "#getQuestionQuery.option1#","#getQuestionQuery.option2#",
			                    "#getQuestionQuery.option3#", "#getQuestionQuery.option4#",
			                    "#getQuestionQuery.isCorrect#","#getQuestionQuery.isActive#"] />
		<cfreturn questionArr>
		<cfcatch type = "any">
		<cfset type="#cfcatch.Type#" />
		<cflog type="Error"
			file="examSystemLogs"
			text="Exception error --
				   	 Exception type: #type#
				   	 ,Message:#cfcatch.Message#" />
		    <cfreturn "error">
		</cfcatch>
		</cftry>
	</cffunction>

<!---Function to save edited changes --->
	<cffunction name="editQuestion" access="remote" returnformat="JSON">
	  <cfargument name="questionID" type="string" required="true" >
	  <cfargument name="options" type="string" required="true" >
	  <cfargument name="status" type="numeric" required="true" >
	  <cftry>
	  <cfquery result="editQuestionQuery">
		UPDATE questions
		SET isCorrect = <cfqueryparam cfsqltype="CF_SQL_varchar" value="#arguments.options#" />,
		    isActive = <cfqueryparam cfsqltype="CF_SQL_bit" value="#arguments.status#" />
        WHERE questionID =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.questionID#" />
	  </cfquery>
      <cfreturn true/>
	<cfcatch type = "any">
		<cfset type="#cfcatch.Type#" />
		<cflog type="Error"
			file="examSystemLogs"
			text="Exception error --
				   	 Exception type: #type#
				   	 ,Message:#cfcatch.Message#" />
		    <cfreturn false>
		</cfcatch>
		</cftry>
	</cffunction>


</cfcomponent>
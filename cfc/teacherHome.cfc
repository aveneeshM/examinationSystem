<!---
  --- teacherHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/29/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<!---Function to check if atleast one question exists in the database--->
<!--- 	<cffunction name="questionExists" access="public" returntype="string" returnformat="JSON">
		<cftry>
		<cfquery name="questionExistsQuery" datasource="examinationSystem">
          SELECT TOP 1 questionID FROM questions
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
	    <cfreturn #questionExistsQuery.recordcount#>
	</cffunction> --->

<!---Function to return all questions --->
	<cffunction name="questionAll" access="remote">
		<cftry>
	    <cfquery name="questionAllQuery" datasource="examinationSystem">
          SELECT questionID,
		         questionDescription,
		         difficultyLevel,
		         option1,
		         option2,
		         option3,
		         option4,
		         isCorrect,
		         isActive FROM questions
		  ORDER BY createdDate DESC
	    </cfquery>
	    	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
        <cfreturn #questionAllQuery#>
	</cffunction>

<!---Function to return all questions --->
	<cffunction name="getQuestion" access="remote" returnformat="JSON">
	    <cfargument name="questionID" type="string" required="true" >
	    <cftry>
		<cfquery name="getQuestionQuery" datasource="examinationSystem">
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
	    	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>
		<cfset questionArr = arraynew(1)>
		<cfset questionArr =["#getQuestionQuery.questionID#", "#getQuestionQuery.questionDescription#",
			                 "#getQuestionQuery.option1#","#getQuestionQuery.option2#",
			                 "#getQuestionQuery.option3#", "#getQuestionQuery.option4#",
			                 "#getQuestionQuery.isCorrect#","#getQuestionQuery.isActive#"] />
		<cfreturn questionArr>
	</cffunction>

<!---Function to save edited changes --->
	<cffunction name="editQuestion" access="remote" returntype="string" returnformat="JSON">
	  <cfargument name="questionID" type="string" required="true" >
	  <cfargument name="options" type="string" required="true" >
	  <cfargument name="status" type="numeric" required="true" >
	  <cftry>
	  <cfquery result="editQuestionQuery" datasource="examinationSystem">
		UPDATE questions
		SET isCorrect = <cfqueryparam cfsqltype="CF_SQL_varchar" value="#arguments.options#" />,
		    isActive = <cfqueryparam cfsqltype="CF_SQL_bit" value="#arguments.status#" />
        WHERE questionID =<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.questionID#" />
	  </cfquery>
	  	 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
		</cftry>

      <cfreturn true/>
	</cffunction>


</cfcomponent>
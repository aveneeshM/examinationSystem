<!---
  --- configQuestion
  --- --------------
  ---
  --- author: aveenesh
  --- date:   7/26/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!---   <cffunction name="testInfo" access="public" returntype="array">
	<cftry>
	<cfquery name="testInfoQuery" datasource="examinationSystem">
          SELECT name FROM tests
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

	<cfset myarray=arraynew(1)>
	<cfloop query = "testInfoQuery">
    <cfset myarray[CurrentRow]=#name#>
    </cfloop>
    <cfreturn #myarray#/>
  </cffunction> --->
<!---add question to  database--->
  <cffunction name="addQuestion" access="remote" returntype="string" returnformat="JSON">
	<cfargument name="question" type="string" required="true" >
	<cfargument name="opt1" type="string" required="true" >
	<cfargument name="opt2" type="string" required="true" >
	<cfargument name="opt3" type="string" required="true" >
	<cfargument name="opt4" type="string" required="true" >
	<cfargument name="level" type="string" required="true" >
	<cfargument name="correct" type="string" required="true" >

	<cfif NOT structKeyExists(session,"stLoggedInUser")>
		<cfreturn "does not">
	</cfif>
	<!---><cfset var correctString = arrayToList(arguments.correct)>--->
	<cftry>
	<cfquery result="insertOptions" datasource="examinationSystem">
			INSERT INTO questions
			(
			questionDescription,difficultyLevel,createdDate,option1,option2,option3,option4,isCorrect
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.question#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.level#" />,
		    <cfqueryparam cfsqltype="CF_SQL_DATE" value="#DateFormat(Now(),"yyyy-mm-dd")#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.opt1#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.opt2#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.opt3#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.opt4#" />,
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.correct#" />
		    )
	</cfquery>
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
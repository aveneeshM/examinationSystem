<!---
  --- passwordCheck
  --- -------------
  ---
  --- author: aveenesh
  --- date:   7/24/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<cffunction name="passwordChecker" access="remote" returntype="string" returnformat="json">
	<cfargument name="password" type="string" required="true" >
	<cfargument name="email" type="string" required="true" >
			<cfset passwordObj = createObject("component","examinationSystem.cfc.hashPassword")/>
	    <cfset passwordHash = passwordObj.hashPassword(arguments.password) />
	    <cftry>
	<cfquery name="passwordCheckQuery" datasource="examinationSystem">
          select password from loginDetails where emailID=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
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
	<cfif #passwordCheckQuery.password# EQ #passwordHash#>
		<cfreturn true/>
		<cfelse>
		<cfreturn false/>
	</cfif>
	</cffunction>
</cfcomponent>
<!---
  --- emailCheck
  --- ----------
  ---
  --- author: aveenesh
  --- date:   7/24/18
  --->
<cfcomponent accessors="true" output="false" >
<cffunction name="mailChecker" access="remote" returntype="string" returnformat="json">
	<cfargument name="email" type="string" required="true" >
	<cftry>
	<cfquery name="mailCheckQuery" datasource="examinationSystem">
          select emailID from loginDetails where emailID=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
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
	<cfif #mailCheckQuery.recordcount#>
		<cfreturn true/>
		<cfelse>
		<cfreturn false/>
	</cfif>
	</cffunction>
</cfcomponent>
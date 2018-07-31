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
	<cfquery name="mailCheckQuery" datasource="examinationSystem">
          select emailID from loginDetails where emailID=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	<cfif #mailCheckQuery.recordcount#>
		<cfreturn true/>
		<cfelse>
		<cfreturn false/>
	</cfif>
	</cffunction>
</cfcomponent>
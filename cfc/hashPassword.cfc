<!---
  --- hashPassword
  --- ------------
  ---
  --- author: aveenesh
  --- date:   7/30/18
  --->
<cfcomponent >

	<cffunction name = "hashPassword" access = "public">
		<cfargument name = "password" required = "true" />
		<cfreturn HASH('#arguments.password#','SHA1') />
	</cffunction>

</cfcomponent>
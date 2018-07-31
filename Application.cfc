<!---
  --- Application
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/25/18
  --->
<cfcomponent accessors="true" displayname="Application" output="false" persistent="false">

    <!--- Set up the application. --->
    <cfset THIS.Name = "examinationSystem" />
    <cfset THIS.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ) />
    <cfset THIS.datasource = "examinationSystem" />
	<cfset THIS.sessionManagement="Yes" />



    <cffunction name="OnApplicationStart" returntype="boolean">
        <cfreturn true />
    </cffunction>




</cfcomponent>
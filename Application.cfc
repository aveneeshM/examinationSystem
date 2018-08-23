<!---
  --- Application
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/25/18
  --->
<cfcomponent accessors="true" displayname="Application" output="false" persistent="false">

    <!--- Set up the application. --->
    <cfset THIS.Name = "myExaminationSystem1" />
    <cfset THIS.ApplicationTimeout = CreateTimeSpan( 1, 0, 0, 0 ) />
    <cfset THIS.datasource = "examinationSystem" />
	<cfset THIS.sessionManagement="Yes" />
	<cfset THIS.sessiontimeout = CreateTimeSpan(0,5,0,0) />

    <cffunction name="OnApplicationStart" returntype="boolean">
		<!--- Set up instance to login component --->
		<cfset application.logOutObj = CreateObject("Component", "cfc.login") />
		<!--- Set up instance to teacherHome component --->
		<cfset application.teacherObj = CreateObject("Component", "cfc.teacherHome") />
		<!--- Set up instance to exams component --->
		<cfset application.examObj = CreateObject("Component", "cfc.exams") />
		<!--- Set up instance to studentHome component --->
		<cfset application.studentObj = CreateObject("Component", "cfc.studentHome") />
        <cfreturn true />
    </cffunction>

	<cffunction name="onError" returnType="void" output="true">
		<cfargument name="Exception" required="true">
	    <cfargument name="Eventname" type="string" required="true">
	    <cfset var errortext = "">
	    <cflog file="examSystemLogs" type="error"
                   text="Event Name: #Arguments.Eventname#" >
		<cflog file="examSystemLogs" type="error"
                   text="Message: #Arguments.Exception.message#">
		<cfoutput><h2>An unexpected error has occurred. Please try after some time.</h2> </cfoutput>
	</cffunction>

	<cffunction name="OnMissingTemplate" returntype="void">
       <cflog type="information"
			file="tryLogs"
			text="MissingTemplate" />
			<cfoutput><h2>Requested page not found</h2></cfoutput>
			<cfreturn />

    </cffunction>


</cfcomponent>
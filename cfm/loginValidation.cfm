<cfif NOT isUserLoggedIn()>
	<cflocation url="login.cfm" addtoken="no">
<cfelseif NOT structKeyExists(session,"stLoggedInUser")>
    <cfset application.logOutObj.doLogOut() />
	<cflocation url="login.cfm" addtoken="no">
</cfif>

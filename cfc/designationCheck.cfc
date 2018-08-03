<!---
  --- designationCheck
  --- ----------------
  ---
  --- author: aveenesh
  --- date:   7/24/18
  --->

<cfcomponent accessors="true" output="false" >
<cffunction name="designationChecker" access="remote" returntype="string" returnformat="json">
	<cfargument name="user" type="string" required="true" >
	<cfargument name="password" type="string" required="true" >
		<cfset passwordObj = createObject("component","examinationSystem.cfc.hashPassword")/>
	    <cfset passwordHash = passwordObj.hashPassword(arguments.password) />


	<cfset var isLoggedIn = false/>
	<cfquery name="getData" datasource="examinationSystem">
          select p.designation, p.firstName, p.middleName, P.lastName, p.loginID, p.personID, p.isActive from (person p inner join loginDetails l on p.loginID = l.loginID) where l.emailID=<cfqueryparam value="#arguments.user#" cfsqltype="cf_sql_varchar" />
	</cfquery>
	<cfif #getData.recordcount# EQ 1>
	<cflogin>
		<cfloginuser name="#getData.firstname# #getData.lastName#" password="#passwordHash#" roles="#getData.designation#">
	</cflogin>
	<cfset session.stLoggedInUser = {'firstName' = getData.firstname, 'lastName' = getData.lastname, 'userID' = getData.personID, 'designation' = getData.designation, 'testID' = 0 }>
	<cfif #getData.isActive#>
	<cfset var isLoggedIn = true/>
	</cfif>
	</cfif>
    <cfif #isLoggedIn#>
		<cfreturn #getData.designation#/>
		<cfelse>
		<cfreturn false>
		</cfif>
</cffunction>
<cffunction name="doLogOut" access="remote" returntype="void" output="false">
    <cfset structdelete(session,'stLoggedInUser')/>
	<cfset structdelete(session,'testData')/>
	<cflogout />
</cffunction>


</cfcomponent>

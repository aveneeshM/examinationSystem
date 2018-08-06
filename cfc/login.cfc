<!---
  --- login
  --- -----
  ---
  --- author: aveenesh
  --- date:   8/5/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">


<cffunction name="mailChecker" access="remote" returntype="string" returnformat="json">
	<cfargument name="email" type="string" required="true" >
	<cftry>
	<cfquery name="mailCheckQuery" datasource="examinationSystem">
          select emailID from loginDetails where emailID=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" />
	</cfquery>
		 <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#" />
		</cfcatch>
	</cftry>
	<cfif #mailCheckQuery.recordcount#>
		<cfreturn true/>
		<cfelse>
		<cfreturn false/>
	</cfif>
</cffunction>


<cffunction name="doLogin" access="remote" returntype="string" returnformat="json">
	<cfargument name="email" type="string" required="true" >
	<cfargument name="password" type="string" required="true" >
	<cfset passwordObj = createObject("component","examinationSystem.cfc.hashPassword")/>
	<cfset passwordHash = passwordObj.hashPassword(arguments.password) />


	<cfquery name="loginQuery" datasource="examinationSystem">
		SELECT person.designation,
		       person.firstName,
		       person.middleName,
		       person.lastName,
		       person.loginID,
		       person.personID,
		       person.isActive
		FROM (person INNER JOIN loginDetails ON person.loginID = loginDetails.loginID)
	    WHERE loginDetails.emailID=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" /> AND
	    loginDetails.password =<cfqueryparam value="#passwordHash#" cfsqltype="cf_sql_varchar" />

	</cfquery>

	<cfif #loginQuery.recordcount# EQ 1>
	<cflogin>
		<cfloginuser name="#loginQuery.firstname# #loginQuery.lastName#" password="#passwordHash#" roles="#loginQuery.designation#">
	</cflogin>
	<cfset session.stLoggedInUser = {'userID' = loginQuery.personID, 'designation' = loginQuery.designation, 'testID' = 0 }>
	<cfreturn #loginQuery.designation#/>
	</cfif>
	<cfreturn #loginQuery.designation#/>

</cffunction>

<cffunction name="doLogOut" access="remote" returntype="void" output="false">
    <cfset structdelete(session,'stLoggedInUser')/>
	<cfset structdelete(session,'testData')/>
	<cflogout />
</cffunction>



</cfcomponent>
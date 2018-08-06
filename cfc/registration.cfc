<!---
  --- registration
  --- ------------
  ---
  --- author: aveenesh
  --- date:   8/6/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<cffunction name="registerUser" access="remote" returntype="string" returnargumentsat="json">
	<cfargument name="email" type="string" required="true" >
	<cfargument name="password" type="string" required="true" >
	<cfargument name="fname" type="string" required="true" >
	<cfargument name="lname" type="string" required="true" >
	<cfargument name="designation" type="string" required="true" >
	<cfargument name="mname" type="string" required="true" >
	<cfargument name="address" type="string" required="true" >
	<cfargument name="city" type="string" required="true" >
	<cfargument name="state" type="string" required="true" >
	<cfargument name="country" type="string" required="true" >
	<cfargument name="zip" type="string" required="true" >




    <cftry>
	<cfset passwordObj = createObject("component","examinationSystem.cfc.hashPassword")/>
    <cfquery result="loginResult" datasource="examinationSystem">
			INSERT INTO loginDetails
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.email#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#passwordObj.hashPassword(arguments.password)#" />
		    )
	</cfquery>

	<cfquery result="personResult" datasource="examinationSystem">
			INSERT INTO person
			(
			firstName,middleName,lastName,contactNumber,isActive,designation,loginID
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.fname#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.mname#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.lname#" />,
            <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#arguments.phone#" />,
            <cfqueryparam cfsqltype="CF_SQL_BIT" value="1" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.designation#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#loginResult.generatedkey#" />
		    )
	</cfquery>

	<cfquery result="addressResult" datasource="examinationSystem">
			INSERT INTO addressDetails
			(
			personID,addressLine,city,state,country,zipCode
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype="CF_SQL_INT" value="#personResult.generatedkey#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.address#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.city#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.state#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.country#" />,
            <cfqueryparam cfsqltype="CF_SQL_INT" value="#arguments.zip#" />

		    )
	</cfquery>

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
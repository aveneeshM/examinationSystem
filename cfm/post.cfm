
<cftry>
	<cfset passwordObj = createObject("component","examinationSystem.cfc.hashPassword")/>
<cfquery result="loginResult" datasource="examinationSystem">
			insert into loginDetails
		    values
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.email#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#passwordObj.hashPassword(form.pass)#" />
		    )
	</cfquery>

	<cfquery result="personResult" datasource="examinationSystem">
			insert into person
			(
			firstName,middleName,lastName,contactNumber,isActive,designation,loginID
			)
		    values
		    (
		    <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.fname#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.mname#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.lname#" />,
            <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#form.phone#" />,
            <cfqueryparam cfsqltype="CF_SQL_BIT" value="1" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.designation#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#loginResult.generatedkey#" />
		    )
	</cfquery>

	<cfquery result="addressResult" datasource="examinationSystem">
			insert into addressDetails
			(
			personID,addressLine,city,state,country,zipCode
			)
		    values
		    (
		    <cfqueryparam cfsqltype="CF_SQL_INT" value="#personResult.generatedkey#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.address#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.city#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.state#" />,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#form.country#" />,
            <cfqueryparam cfsqltype="CF_SQL_INT" value="#form.zip#" />

		    )
	</cfquery>

	<!----<cfoutput><h2>Success!!</h2></cfoutput>---->
	<script>
	alert("Registration Successful");
	window.location = "login.cfm";
</script>
<!----
	<cflocation url="loginRedirect.cfm">--->
	<cfcatch type="any">
		<cfdump var="#cfcatch#">

	</cfcatch>
	</cftry>

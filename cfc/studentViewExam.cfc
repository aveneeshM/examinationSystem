<!---
  --- studentViewHome
  --- ---------------
  ---
  --- author: aveenesh
  --- date:   8/1/18
  --->
<!---
  --- studentHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/30/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">
<!---selects all future tests available--->
		<cffunction name="getTest" access="remote" returnformat="JSON">

		    <cfquery name="testAllQuery" datasource="examinationSystem">
		      select testID,name,duration,startDate,startTime from tests
		      where startDate >= CONVERT(char(10), GetDate(),126) and
		      testID not in(select testID from testStudent where
		      testTakerID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#session.stLoggedInUser.userID#" />)
		      order by startDate, startTime desc
		   </cfquery>


		   <cfset testArray = arraynew(1)>
		   <cfloop query="testAllQuery">
		     <CFSET testArray[#currentRow#] =[testAllQuery.testID, testAllQuery.name,
		     testAllQuery.duration, #DATEFORMAT(testAllQuery.startDate,"yyyy-mm-dd")#,
		     #TIMEFORMAT(testAllQuery.startTime,"hh:mm:sstt")#] />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>


	   <cffunction name="addTest" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true">
			<cftry>
		    <cfquery result="testAddQuery" datasource="examinationSystem">
		      insert into testStudent
			(
			testID,testTakerID
			)
		    values
		    (
		    <cfqueryparam cfsqltype = "CF_SQL_VARCHAR" value = "#arguments.testID#" />,
            <cfqueryparam cfsqltype = "CF_SQL_VARCHAR" value= "#session.stLoggedInUser.userID#" />
		    )
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
	</cffunction>
</cfcomponent>
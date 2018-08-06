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
		 	<cftry>
		    <cfquery name="testAllQuery" datasource="examinationSystem">
		      SELECT testID,
		             name,
		             duration,
		             startDate,
		             startTime
		      FROM tests
		      WHERE startDate >= CONVERT(char(10), GetDate(),126) AND
		      testID NOT IN(SELECT testID FROM testStudent WHERE
		      testTakerID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#session.stLoggedInUser.userID#" />)
		      ORDER BY startDate, startTime DESC
		   </cfquery>
		   <cfcatch type = "any">
			<cfset type="#cfcatch.Type#" />
			<cflog type="Error"
				file="examSystemLogs"
				text="Exception error --
				   	  Exception type: #type#
					  Message: #message#" />
		  </cfcatch>
		  </cftry>


		   <cfset testArray = arraynew(1)>
		   <cfloop query="testAllQuery">


           <cfif NOT ((testAllQuery.startDate EQ DATEFORMAT(NOW(),"yyyy-mm-dd"))
		              AND (testAllQuery.startTime LT TIMEFORMAT(NOW(),"HH:mm:ss")))>
				 <cfset testArray[#currentRow#] =[testAllQuery.testID, testAllQuery.name,
				     testAllQuery.duration, #DATEFORMAT(testAllQuery.startDate,"dd-mmm-yyyy")#,
				     TIMEFORMAT(testAllQuery.startTime,"HH:mm:ss")] />
		   </cfif>
	       </cfloop>
		  <cfreturn testArray>
	   </cffunction>

<!---Add selected test to testStudent table--->
	   <cffunction name="addTest" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true">
			<cftry>
		    <cfquery result="testAddQuery" datasource="examinationSystem">
		      INSERT INTO testStudent
			(
			testID,testTakerID
			)
		    VALUES
		    (
		    <cfqueryparam cfsqltype = "CF_SQL_VARCHAR" value = "#arguments.testID#" />,
            <cfqueryparam cfsqltype = "CF_SQL_VARCHAR" value= "#session.stLoggedInUser.userID#" />
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
<!---
  --- studentHome
  --- -----------
  ---
  --- author: aveenesh
  --- date:   7/30/18
  --->
<cfcomponent accessors="true" output="false" persistent="false">

		<cffunction name="getTest" access="remote" returnformat="JSON">
		    <cfquery name="testAllQuery" datasource="examinationSystem">
		      select testID,name,duration,startDate,startTime from tests
		      where startDate >= CONVERT(char(10), GetDate(),126)
		      order by startDate desc
		   </cfquery>
		   <cfset testArray = arraynew(1)>
		   <cfloop query="testAllQuery">
		     <CFSET testArray[#currentRow#] =[testAllQuery.testID, testAllQuery.name,
		     testAllQuery.duration, #DATEFORMAT(testAllQuery.startDate,"yyyy-mm-dd")#,
		     #TIMEFORMAT(testAllQuery.startTime,"hh:mm:ss")#] />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>

	   <cffunction name="getTestStudent" access="remote" returnformat="JSON">
		    <cfquery name="testStudentAllQuery" datasource="examinationSystem">
		      select testID,testTakerID from testStudent
		      where testTakerID=<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfset testArray = arraynew(1)>
		   <cfloop query="testStudentAllQuery">
		     <CFSET testArray[#currentRow#] = #testStudentAllQuery.testID# />
	       </cfloop>
		   <cfreturn testArray>
	   </cffunction>

	   <cffunction name="getTestQuestions" access="remote" returnformat="JSON">
		   <cfargument name="testID" required="true" >
		    <cfquery name="getTestQuestionsAllQuery" datasource="examinationSystem">
		      select Q.questionID, Q.questionDescription,Q.option1,Q.option2,
		      Q.option3,Q.option4 from (questions Q inner join testQuestions T on Q.questionID = T.questionID)
		      where T.testID=<cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>


		   <cfquery name="testQuery" datasource="examinationSystem">
		      select startDate,startTime,duration from tests
		      where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfset Session.endTestTime = TIMEFORMAT(DateAdd("n",15,Now()),"hh:mm:ss")>
		   <cfif #testQuery.startDate# EQ #DATEFORMAT(NOW(),"yyyy-mm-dd")#>
		   <cfset checkTime= TIMEFORMAT(DateAdd("n",50,testQuery.startTime),"hh:mm:ss")>
		   <cfif TIMEFORMAT(Now(),"hh:mm:ss") LT #checkTime# AND TIMEFORMAT(Now(),"hh:mm:ss") GTE #testQuery.startTime#>

		   <cfset testArray = arraynew(1)>
		   <cfloop query="getTestQuestionsAllQuery">
		     <CFSET testArray[#currentRow#] = [questionID,questionDescription,option1,option2,option3,option4] />
	       </cfloop>
		   <cfreturn testArray>
		   <cfelse>
		   <cfreturn "wrong time">
		   </cfif>
		   <cfelse>
		   <cfreturn false>
		   </cfif>

	   </cffunction>

</cfcomponent>
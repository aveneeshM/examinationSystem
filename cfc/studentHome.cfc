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



<!---selects all chosen test of logged in user--->
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



<!---starts test if current time is in start time window of 15 mins---->
	   <cffunction name="checkTest" access="remote" returnformat="JSON">
		   <cfargument name="testID" required="true" >
		   <cfquery name="testQuery" datasource="examinationSystem">
		      select startDate,startTime,duration from tests
		      where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfquery name="rowCountQuery" datasource="examinationSystem">
		      select questionID from testQuestions
		      where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>

		   <cfif #testQuery.startDate# EQ #DATEFORMAT(NOW(),"yyyy-mm-dd")#>
		   <cfset checkTime= TIMEFORMAT(DateAdd("n",50,testQuery.startTime),"hh:mm:ss")>
		   <cfif TIMEFORMAT(Now(),"hh:mm:ss") LT #checkTime# AND
		   TIMEFORMAT(Now(),"hh:mm:ss") GTE TIMEFORMAT(testQuery.startTime,"hh:mm:ss")>
            <cfset Session.endTestTime = TIMEFORMAT(DateAdd("n",15,Now()),"hh:mm:ss")>
			<cfset Session.correct = 0>
			<cfreturn #rowCountQuery.recordCount#>
		   <cfelse>
		    <cfreturn "wrong time">
		   </cfif>
		   <cfelse>
		    <cfreturn false>
		   </cfif>
	   </cffunction>



<!---generate nth question of a test--->
	   <cffunction name="generateQuestion" access="remote" returnformat="JSON">
		   <cfargument name="testID" required="true" >
		   <cfargument name="row" required="true" >
	       <cfquery name="getTestQuestionQuery" datasource="examinationSystem">
		      SELECT TOP 1 R.* FROM
             (select top #arguments.row#
			 Q.questionID, Q.questionDescription,Q.option1,Q.option2,
             Q.option3,Q.option4 from (questions Q inner join testQuestions T on Q.questionID = T.questionID)
             where T.testID =  <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
			 order by questionID asc) as R order by questionID desc
		   </cfquery>
		   <cfset testArray = arraynew(1)>

		    <CFSET testArray = [getTestQuestionQuery.questionID,getTestQuestionQuery.questionDescription,getTestQuestionQuery.option1,getTestQuestionQuery.option2,getTestQuestionQuery.option3,getTestQuestionQuery.option4] />
	        <cfreturn testArray>

		</cffunction>

		<cffunction name="saveResult" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cfargument name="questionID" type="numeric" required="true" >
		   <cfargument name="selectedOption" type="string" required="true" >

		   <cfquery name="resultQuery" datasource="examinationSystem">
		      select isCorrect from questions
             where questionID = <cfqueryparam value="#arguments.questionID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfif arguments.selectedOption eq resultQuery.isCorrect>
			<cfset session.correct = session.correct+1>
		   </cfif>
		   <cfreturn true>
	   </cffunction>



<!---Validation at Submit--->
		<cffunction name="finalResult" access="remote" returnformat="JSON">
		   <cfif TIMEFORMAT(Now(),"hh:mm:ss") GT Session.endTestTime>
		    <cfreturn false>
		   </cfif>
			<cfreturn session.correct>
		</cffunction>



<!---Validation at Submit--->
        <cffunction name="duration" access="remote" returnformat="JSON">
		   <cfargument name="testID" type="numeric" required="true" >
		   <cfquery name="durationQuery" datasource="examinationSystem">
		      select duration from tests
             where testID = <cfqueryparam value="#arguments.testID#" cfsqltype="cf_sql_integer" />
		   </cfquery>
		   <cfreturn durationQuery.duration>
		</cffunction>
</cfcomponent>

<head>
     <title>PDF</title>
</head>
<body>
<cfset teacherObj = CreateObject("Component", "examinationSystem.cfc.teacherHome") />
<cfset teacherObjQuestion = teacherObj.questionAll() />



<cfdocument format="PDF">
	<cfdocumentitem type="header">
		    <h1 style="text-align:center;margin-top:40pt;font-size:200pt;">Examination Questions</h1>
		</cfdocumentitem>
   <table id="pdfTable" style="width:100%;text-align:center;border: 1px solid black;" cellspacing="0">
	<tr>
		               <th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">ID</th>
                        <th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">Question</th>
						<th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">Level</th>
                        <th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">1<sup>st</sup>Option</th>
						<th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">2<sup>nd</sup>Option</th>
                        <th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">3<sup>rd</sup>Option</th>
						<th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">4<sup>th</sup>Option</th>
                        <th style="border-right: 1px solid black; background-color:lightgray;padding:4px 6px 4px 6px;">Answer</th>
	</tr>
	<cfloop query="teacherObjQuestion">
		<cfoutput>

				<cfif #isActive#>
					<tr style="color:darkgreen;">
					<cfelse>
					<tr style="color:red;">
					</cfif>
					<td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#questionID#</td>
                    <td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#questionDescription#</td>
					<td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#difficultyLevel#</td>
                    <td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#option1#</td>
					<td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#option2#</td>
                    <td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#option3#</td>
					<td style="border-right: 1px solid black;border-top: 1px solid black;padding:4px 6px 4px 6px;">#option4#</td>
					<cfset answer="">
					<cfloop list="#isCorrect#" index="name">
						<cfset answer=ListAppend(answer,"Option #name#",",")>
					</cfloop>
                    <td style="border-top: 1px solid black;padding:4px 6px 4px 6px;">#answer#</td>

               </tr>
		</cfoutput>
	</cfloop>
	</table>
	<cfdocumentitem type="footer">
		    <h3 style="text-align:center;"><cfoutput>Page #cfdocument.currentPageNumber# of #cfdocument.totalPageCount#</cfoutput></h3>
    </cfdocumentitem>

</cfdocument>
</body>
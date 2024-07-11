# R-sample-code

This is the sample code for a data task. The requirements is of this data task are as follows.
My solution to this data task can be found in the R Markdown file [Report.Rmd](https://github.com/Huiyu1999/R-sample-code-/blob/main/Report.Rmd), which can be rendered to a PDF Report.pdf.

## **Study Description**

This study evaluates an education program subsidizing the cost of education through in-kind transfers. The program lasted for three years, from 2010 to 2012. It targeted students enrolled in public schools. For the duration of the program, subsidies were delivered at the start of every school year to the cohort of children enrolled in grade 6 at the onset of the program.

To evaluate the effectiveness of the program, an experiment was designed. It used pairwise randomization to assign schools within a set of districts to a treatment or a control group. All children enrolled in grade 6 in treatment schools received the subsidy for three years, as long as they were still enrolled in school. The primary outcome of interest is school evasion, and secondary outcomes include teen pregnancy and marriage.

To conduct the study, baseline data were collected on the schools and cohort studied. In addition, two follow-up surveys were conducted, one three years after the start of the intervention, after the last year when the subsidy was offered, and another two years later. During these surveys, information was collected on whether the children in the original cohort were still enrolled in school and whether they were married, had any children, or were pregnant at the time of the survey.

## **Report content**

Think of this report as a policy brief to be shared with policymakers who have training on impact evaluation methods and have no previous knowledge of the intervention or the study. *The report must contain* *at least one table and one visualization*, but you may include more exhibits. You should also feel free to describe any additional data or information you would like to use for the study and further research questions you think are relevant or interesting.

Your report should at least answer the following question.

- What were the effects of the intervention on the outcomes of interest after 3 and 5 years?

Make sure to describe the methods you used to answer each of these questions. Describe and explain your choice of regression specification, unit of analysis, controls variables, and post-estimation tests. Making use of graphs and tables to illustrate your answers will be appreciated.

## **Data description**

The materials for this assessment include 4 data tables and a data dictionary describing the fields contained in each of them. They are:

- **schools.csv**: school-level baseline and treatment assignment data
- **school_visits_log.csv:** a log of the dates when each school was visited at each round of follow-up
- **student_baseline.csv:** student-level data with demographic information about all students in the study cohort, observed at baseline
- **student_follow_ups.csv:** student panel measuring outcome values after 3 and 5 years of the start of the program


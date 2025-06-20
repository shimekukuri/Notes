# Clayton Home Inspections Business Rules

## Abstract
•
The Field Chase Multiple Attempts Table is FTMFCMAT. Chase attempt records are stored in this table.•

The Field Chase Memo Header Table is FTMFCMHD. Chase memos such as Chase Attempt Memo, Property Evaluation, and
Property Directions are stored in this table. This table serves are the "parent" table where only the memo type is
stored.

The FTMFCMHD.MHDMEMID will provide a reference to FTMFCMDT.

The Field Chase Memo Detail Table is FTMFCMDT. Chase memos such as Chase Attempt Memo, Property Evaluation, and
Property Directions are stored in this table. Reference MDTMEMID in order to connect to FTMFCMHD.

The Field Chase Status (FPMFCRQ.FCSTAT) is a one-character field in the AS400. There are several possible values:•
○
A = Active/Pending
○
C = Completed
○
K = Cancelled
○
X = Deleted
○
3 = <Invalid Status Code>
Note: There is currently a record in FPMFCRQ with this status code.▪
○
Z = <Invalid Status Code>
Note: There is currently a record in FPMFCRQ with this status code.▪
To complete a field chase in LINK, the property must be marked as Vacant (FTMFCMAT.FCMHVCNT) or Inspection Only
(FTMFCMAT.FCMINSP) or (Chase Address Located (FPMFCRQ.FCCADD) is No and VMF Collateral Located
(FTMFCMAT.FCMHLOC) is No).
○
In order to complete a chase in LINK, there must be at least one chase attempt.
○
Complete Field Chase: FPMFCRQ.FCSTAT = 'C'
○
Code Example: FCMHVCNT = "Y" OR FCMINSP = "Y" OR (FCCADD = "N" AND FCMHLOC = "N")
A follow-up date will be added to a field chase if any of the following things are true:•
○
If the property was NOT marked as Vacant (FTMFCMAT.FCMHVCNT) or Inspection Only (FTMFCMAT.FCMINSP).
○
If a Letter was left (FTMFCMAT.FCMTEML) at the property.
○
If Direct Contact (FTMFCMAT.FCMDIRC) was made.
Follow-up date notes:•
○
Follow-up Date field: FPMFCRQ.FCDFOL
○
Note: The follow-up date is defined as four days after the property was last chased.
A Complete Date will be added to a field chase if the property is marked as Vacant (FTMFCMAT.FCMHVCNT) or Inspection
Only (FTMFCMAT.FCMINSP) or (Chase Address Located (FPMFCRQ.FCCADD) is No and VMF Collateral Located
(FTMFCMAT.FCMHLOC) is No). Otherwise, the complete date is not populated.
○
Complete Date field: FPMFCRQ.FCDCMP
A user should never choose more than one of the following options when updating a chase or completing a chase in LINK:•
○
Home is Vacant (FTMFCMAT.FCMHVCNT)
○
Inspection Only (FTMFCMAT.FCMINSP)
○
Direct Contact Who (FTMFCMAT.FCMDIRC)
○
Left Letter (FTMFCMAT.FCMTEML)
Field Chase Definitions:
○
Pending: A Pending field chase will have a Field Chase Status (FPMFCRQ.FCSTAT) of "A". In addition, Follow-up Date
(FPMFCRQ.FCDFOL) is blank.
Code Example: FCSTAT = "A" AND FCDFOL IS NULL▪
○
Completed: A Completed field chase is more complicated. To the user, there is only one type of Completed field
chase. In the database, a Completed field chase can be defined in three ways:
Field Chase Status (FPMFCRQ.FCSTAT) = "C", or▪
Field Chase Status (FPMFCRQ.FCSTAT) = "A" and Follow-up Date (FPMFCRQ.FCDFOL) has a date value.▪
Field Chase Status (FPMFCRQ.FCSTAT) = "K" and Follow-up Date (FPMFCRQ.FCDFOL) has a date value.▪
Code Example: FCSTAT = "C" OR (FCSTAT = "A" AND FCDFOL > 0) OR (FCSTAT = "K" AND FCDFOL > 0)▪
Field Chase Page 1
○
▪
In order to find the number of days the field chase has been completed, reference the Chase Date
(FPMFCRQ.FCDCHS).
Cancelled: A Cancelled field chase will have a Field Chase Status (FPMFCRQ.FCSTAT) = "K"
Code Example: FCSTAT = "K"▪
▪
In order to find the number of days the field chase has been cancelled, reference the Cancelled Date
(FPMFCRQ.FCDCAN)
Field Chase Page 2
Notes
The Field Chase Mater File is FPMFCRQ. When you are looking at a specific loan and chase
number, you will use FCLOAN, FCTXFR, and FCCNBR.
The Field Chase Multiple Attempts File is FTMFCMAT. When looking at specific attempts for loan
and chase number, you will use FCMLONNB, FCMXFERNB, and FCMNB. The FCMTEMPS field will
contain the chase attempt number.
The Field Chase Memo Header File is FTMFCMHD. All memos have a header and a corresponding
Detail File. When looking at a specific loan and chase number, you will use MHDCHSLN,
MHDCHSTX, and MHDCHSID.
The Field Chase Detail File is FTMFCMDT. There is a relationship between FTMFCMHD (Header
File) and FTMFCMDT (Detail File). Use the Memo ID (FTMFCMHD.MHDMEMID =
FTMFCMDT.MDTMEMID) field as the connector. The purpose of the Header/Detail file is for
Property Evaluations and Field Chase Multiple Attempt Memos.
The Field Chase Multiple Attempt Letter Types File is FTMFCLTR. This is used for populating the
letter type dropdowns.
The Property Directions/Special Instructions File is FPDCHSTXT. When looking at directions for a
specific loan and chase number, use FCLOAN, FCXFER, and FCCHSN.
Each Field Chase Multiple Attempt will add a record in VMPIACT. This is a general comments file.
Only reference VLOAN and ATXFER for a specific loan.
The Condition Report is shared between Remarketing and Field Collections. The code resides
under Remarketing. Specific fields on the Condition Report that correspond to a chase will be
stored in FPMFCRQ.
The Photo Manager is a central system and is used by both Remarketing and Field Collections. If
the Photo Manager is accessed within the Field Collections system, a Chase Number (FCCNBR) will
be "passed". This is a flag that tells the Photo Manager this is a photo for Field Collections.
Otherwise, it will be a Remarketing photo.
There are three database tables that deal with photos: Remarketing.dbo.RemarketingPhotos,
Remarketing.dbo.FCPictures, and Remarketing.dbo.chasePhotoCount. When photos are uploaded
to the Photo Manager, the photos will be stored in Remarketing.dbo.RemarketingPhotos. If it's a
Field Chase, a reference to the photos will be stored in Remarketing.dbo.FCPictures. In addition, a
photo count record will be inserted into Remarketing.dbo.chasePhotoCount. If it's not a Field
Chase photo, the photos will only reside in Remarketing.dbo.RemarketingPhotos.
○
From time to time, the three tables will get out of sync. Meaning, a Field Chase photo was
uploaded in Remarketing.dbo.RemarketingPhotos but a reference was never inserted in
Remarketing.dbo.FCPictures and Remarketing.dbo.chasePhotoCount. There is a scheduled
job (Job_updateFCphotoCount.cfm) that will sync the three tables.
Field Chase Page 3
Scheduled Jobs
There are several scheduled jobs (both ColdFusion and SQL) related to Field Collections. Below is a list:
•
•
SQL Server Scheduled Jobs
○
Remarketing.dbo.PrcUpdateTblAssignList- this is a stored procedure that is scheduled to run every 12 minutes. The purpose is to pull
down the past 90 days of chase data and insert into Remarketing.dbo.assignlist. This table is used by Field Collections in LINK and Desktop
Field Chase.
○
SSIS Package #1 - a scheduled SSIS Package runs daily at 7:17AM to update FieldCollections.dbo.ChaseReportData. The SSIS Package calls
a Stored Procedure on the iSeries called FPMFCRQ_PRC_FIELD_CHASE_LOAD.
○
SSIS Package #2 - a scheduled SSIS Package runs hourly starting at 5:00AM and ending at 9:00PM. The package updates
Remarketing.dbo.reportdata. More specifically, the job runs 18 minutes after the hour and runs daily. The purpose is to populate 2 years
of chase data for reporting and account search.
TO DO- SSIS Package #2 could be replaced by SSIS Package #1 as it's doing the same thing. The SSIS Package #1 only runs once per day but
could be modified to run hourly. In order to make this work, there needs to be a better way of pulling data instead of always looking at
the last 2 years of chase data.
ColdFusion Scheduled Jobs
○
Cancelled Chases with Attempts (getFCCancelledChasesWithAttempts.cfm) - This scheduled job runs on Monday and Thursday at
2:00AM. The purpose is to pull a list of cancelled chases with at least one attempt and have not been completed or followed-up. Field
reps will receive an email notification to correct the issue as soon as possible. Because the job runs on both Monday and Thursday, there
may be some overlap in the data results.
○
Monthly Report Data (getFCMonthlyReportData.cfm)- This scheduled job runs Daily at 7:30AM. The purpose is to use the data in
FieldCollections.dbo.ChaseReportData to run several calculations for the Monthly Report in LINK. The calculated report numbers are
stored in Reports.dbo.FCMonthlyReport as a snapshot. This provides quick access to the report.
IMPORTANT: This scheduled job must run AFTER SSIS Package #1 from above. Otherwise, the calculations done in the scheduled job will
not be using the most up-to-date information in FieldCollections.dbo.ChaseReportData.
A request may be submitted to update the "All" version of the report. This can be executed by running the following URL:▪
http://corpcfjob01/scheduledjobs/getFCMonthlyReportData.cfm?ReportPeriod=All 2016
○
Chase Photo Count (job_updateFCphotoCount.cfm)- This scheduled job runs on Wednesday and Friday at 11:30AM. The purpose is sync
3 tables used by Photo Manager. The tables are Remarketing.dbo.chasePhotoCount, Remarketing.dbo.FCPictures, and
Remarketing.dbo.RemarketingPhotos. In addition to syncing data in the tables, a query is run to find any completed chase that has fewer
than 8 photos uploaded through Photo Manager. An email is sent to the field rep to correct the issue as soon as possible.
○
Delete Old Chase Photos (job_deleteOldPhotos.cfm) - This scheduled job runs Daily at 5:30AM to remove any photos from the file share
and database that are "inactive" or older than 7 years. An email report will be generated at the end of the scheduled job to maintain
record of what photos have been removed.
○
Check Photo Directories (checkPhotoDirectories.cfm) - This scheduled job runs every Monday at 6:00AM. The purpose is run an analysis
on folder shares used by Photo Manager to see if new sub-directories need to be created or not. The scheduled job will send an email
report with details of the current folder structure. If new sub-directories need to be created, the Create Image Share Directories
scheduled job will need to be modified and executed.
○
FC Text Message (fcTextMsg.cfm) - This scheduled job runs every 5 minutes and sends text messages to the field rep for newly assigned
chases. Each text message is logged in the system so that duplicate text messages are not sent. Only pending chases with valid email
addresses are included in the query.
Note - This scheduled job is on the second instance of the scheduled job server.
ColdFusion Scheduled Jobs that need to be run manually•
○
Create Image Share Directions (job_createImageShareDirectories.cfm) - This job will create the necessary file shares that is used by
Photo Manager. If the directories are not created, Photo Manager will not work properly and photos uploaded will not be saved. This is
not necessarily Field Chase but it's related.
Field Chase Page 4
SQL
Select * from openQuery(cmhi,'Select *
From FLMREMKC K join
FPMREMA A ON A.MRES = K.RES
WHERE VMFACT = ''791394''
And memail != '''' ')
Select * from openQuery(cmhi,'Select *
from FPMREMK
WHERE VMFACT = ''387956'' ')
Select * from openQuery(cmhi,'Select *
From FPMREMA
Where MFLGAI = ''A'' AND MNAME like ''%jim%'' ')
//-------------------- Field Chase ----------------------\\
Select * from openQuery(cmhi,'Select *
From FPMFCRQ
Where FCLOAN in (''996148'', ''191213'', ''215442'') ')
Select * from openQuery(cmhi,'Select *
From FTMFCMAT
Where loan_number in (''996148'', ''191213'', ''215442'') ')
Select * from openQuery(cmhi,'Select *
From FTMFCMHD
Where chase_loan in (''996148'', ''191213'', ''215442'') ')
Select * from openQuery(cmh,'Select *
From Clayton.VMPIACT
Where transaction_month = ''6''
and transaction_year = ''13''
Order by transaction_year desc, loan_number')
Select * from openQuery(cmhi,'Select FCLOAN, FCEUSR, FCREP#, FCDREQ
From FPMFCRQ
order by FCDREQ desc')
Select * from openQuery(cmhi,'Select top 100 *
from vmpactl3 order by transaction_year desc')
Select * from openQuery(cmh,'Select *
from Clayton.FLMFCRQ1
Where fcloan in (''225436'')
order by fcloan, fccnbr desc
Fetch first 2 rows only ')
Select * from openQuery(cmhi,'Select fcstat, fcloan, fccnbr, fcmdlr, fcmloc, fcdpic, fcrep# as Rep
from FLMFCRQ1
Where fcdpic = ''20130605'' and fcmloc = ''Y'' and fcrep# = ''0''
order by fcloan, fccnbr desc ')
Field Chase Page 5
order by fcloan, fccnbr desc ')
Select * from openQuery(cmhi,'Select *
from GENLIB.GLMCUST2
order by Tloan desc ')
Select * from openQuery(cmhi,'Select fnpce,fnpdt, flpmce, flpmdt
from FLMFINC2
where floan = ''1047172'' ')
Select * from openQuery(cmhi,'Select *
from FPMFCRQ
where FCPNRDTE <> ''0'' ')
Select * from openQuery(cmhi,'Select *
from VMLMCOLB
where cempno = ''10381'' ')
Select * from openQuery(cmhi,'Select fcontd, fcontc,fnpce,fnpdt
from FLMFINC2
where floan = ''1047172'' ')
Select * from openQuery(cmhi,'Select *
from GENLIB.GLMCUST2
where Tloan = ''1047286'' ')
Select * from openQuery(cmhi,'Select *
from vmpactl3 where action_code = ''027'' ')
Select * from openQuery(cmh,'Select distinct cloan, cctc, cfname, ccomt, clname, caracd, cphone, caddr1, caddr2, ccity, cstate, czip
From GENLIB.GLMCONT2 where cctc = ''h'' OR cctc = ''H'' order by cloan ')
Select * from openQuery(cmhi,'Select *
from FTHCCOMT where vloan = ''913474'' And action_code = ''191''
order by transaction_year desc,transaction_month desc, transaction_day desc')
Select * from openQuery(cmhi,'Select *
from FPMFCMM
Order by cloan desc ')
select * from sysUser
Where loginID = 10689
select * from OPENQUERY(cmh, 'select * from FPMFCRQ where fcloan = 744790')
select * from OPENQUERY(cmh, 'select * from FTMFCMAT where FCMLONNB = 744790')
select * from OPENQUERY(cmh, 'select * from FTMFCMHD where mhdchsln = 744790')
select * from OPENQUERY(cmh, 'select * from FTMFCMDT where MDTMEMID = 233')
select * from OPENQUERY(cmh, 'select * from FPDCHSTXT where fcloan = 744790')
select * from OPENQUERY(cmh, 'select * from VMPIACT where VLOAN = 744790 and action_code = 191')
select * FROM Remarketing.dbo.assignlist where fcloan = 744790
Remaketing
PhotoMai...
FieldChase FMPortfolio
_missingR...
getReps061
92013
iSeries
Open que...
MHEListTyp
e
PendingRe
marktingL...
Selecting
distinct el...
Remarketin
gLongRun...
Bulk Link
allAvailable
Access
Repos Field Chase Page 6
Remaketing
FieldChase FMPortfolio
PhotoMai...
_missingR...
getReps061
92013
iSeries
Open que...
MHEListTyp
e
PendingRe
marktingL...
Selecting
distinct el...
Remarketin
gLongRun...
Bulk Link
Access
allAvailable
Repos
Field Chase Page 7
Access Groups
•
•
•
•
•
Remarketing FC Mgrs (Remarketing Field Chase Managers) – This access group provides full functionality to the Field Collections system in LINK. It
should only be granted to employees on Cheri Freeman’s team. Currently, users with this access group are Field Collections employees and field
supervisors.
Remarketing Reps (Remarketing Field Reps) – This access group is reserved for field reps who are company employees.
Remarketing Reps Contractor (Remarketing Field Rep Contractors) – This access group is reserved for field reps who are NOT company employees. It is
for outside contractors only.
Remarketing FC View Only (Remarketing Field Collections View Only) – This access group was created to give certain people access to the Field
Collections system in LINK without giving them the ability to change/update information. The Remarketing department has this access group in order
to see the Field Collections system in LINK - but they do not need to change any information.
Desktop Field Collections - Controls who has the option to install Desktop Field Chase from LINK
•
The following Access Groups have been disabled as they are no longer used:
FieldCollections Deleted on 12/30/15•
Remarketing Company Contractor Deleted on 12/30/15•
Remarketing FC Deleted 12/31/15•
Remarketing Reps Sales Center Deleted on 12/30/15•
RemarketingFCDocs Deleted on 12/30/15•
Field Chase Page 8
•
•
•
LINK Monthly Report
The Monthly Report in LINK has been recreated to include the new Multiple Attempts functionality in
AS400.
The report is not in real-time and is only updated based on the type of report:
•
Monthly Report – the monthly reports like October 2015 will be updated daily at 7:30AM.
•
Previous Month Report – the previous monthly report like September 2015 will be updated daily
at 7:30AM for first 15 days of the following month. Example: If the current month is October
2015, the September 2015 report will continue to be updated for the first 15 days of October.
•
Q1 Report – the Q1 report will updated April 1st and April 15th of each year.
•
Q2 Report – the Q2 report will updated July 1st and July 15th of each year.
•
Q3 Report – the Q3 report will be updated October 1st and October 15th of each year.
•
Q4 Report – the Q4 report will be updated January 1st and January 15th of each year.
•
Yearly Report – the yearly reports like All 2015 will be updated January 2nd and January 16th of
each year.
An SSIS Package runs every morning at 7:17AM that runs an AS400 Stored Procedure
(FPMFCRQ_PRC_FIELD_CHASE_LOAD). The results of this Stored Procedure and are copied to
FieldCollections.dbo.ChaseReportData. At 7:30AM, a ColdFusion scheduled job kicks off to build reports
based on the information in FieldCollections.dbo.ChaseReportData. The snapshots from the scheduled
job are stored in Reports.dbo.FCMonthlyReport for quick retrieval.
Field Chase Page 9

## Directory

## Useful Links

## Tags

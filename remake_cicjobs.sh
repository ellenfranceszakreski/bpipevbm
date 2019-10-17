#!/bin/sh
# remake_cicjobs.sh <JobName> <optional subject list file>
# e.g. ./remake_cicjobs.sh prepro
# make cic job file for each subject and list of cic jobs (cicjobs/cicjoblist) and test job list
# required: Scripts/subjects.txt
# required: Scripts/<JobName>_job_template.m
# <JobName>_job_template.m must be MATLAB 2012a compatible '.m' script that depends on a variable subx (subject name).

# analysis directory
AnalysisDir=/data/scratch/zakell/bpipevbm #<- make sure this is correct

## validate inputs
if [ "$#" -eq 1 ]; then
	SubjectList=$AnalysisDir/Scripts/subjects.txt
elif [ "$#" -eq 2 ]; then
	SubjectList=$2
else
	echo "error: Incorrect number of inputs."
	echo "usage:  ./remake_cicjobs.sh <JobName> <optional subject list file>"
	echo "e.g.  ./remake_cicjobs.sh smooth09 #(to use default job)"
	echo "e.g.  ./remake_cicjobs.sh smooth09 /data/scratch/zakell/sept19fmri/these_subjects.txt"
	exit 2
fi
# check job name
JobName=$1
# ensure JobName is not ""
if [ ${#JobName} -eq 0 ]; then
	echo "error: Invalid JobName. JobName must have at least 1 character."
	exit 3
fi
# check for bad characters (i.e. not letters, numbers or underscores)
if [ `echo "$JobName" | grep -Eo [^0-9a-zA-Z_] | wc -l` -ne 0  ]; then
	echo "error: Invalid JobName. JobName must contain only letters, numbers or underscores"
	exit 3
fi
# check subject list
if [ ${#SubjectList} -eq 0 ]; then
	echo "error: Invalid SubjectList. SubjectList must have at least 1 character."
	exit 4
elif [ ! -f "$SubjectList" ]; then
	echo "error: could not find subject list $SubjectList"
	exit 5
elif [ `cat $SubjectList | wc -l` -eq 0 ]; then
	echo "error: Subject list $SubjectList is empty."
	exit 6
fi
# job directory
JobDir=$AnalysisDir/cicjobs/$JobName # cic job .m files kept here
if [ -d $JobDir ]; then
  rm -r $JobDir
elif [ ! -d $AnalysisDir/cicjobs ]; then
	# make cic jobs dir
	mkdir $AnalysisDir/cicjobs
fi
# template file for this type of job
TemplateFile=$AnalysisDir/Scripts/$JobName"_job_template.m"
if [ -f $TemplateFile ]; then
	echo "Found job file template at $TemplateFile"
else
	echo "error: Template file $template_file must be in $AnalysisDir/Scripts."
	exit 7
fi
# done checking
echo "Using subject list"$SubjectList

## make new jobs
# make new job directory
mkdir $JobDir
# location of cic job list file
cicjoblistFile=$JobDir/cicjoblist
# job list
touch $cicjoblistFile
# for each subject in subjects.txt
for subx in `cat "$SubjectList"`
do
	# make job file for this subject
	jobfile=$JobDir/$subx"_job.m"
	touch $jobfile
	# prepend code setting variable "subx" to this subject
	echo "subx = '"$subx"';" > $jobfile # note subject names are character vectors (e.g. 'sub2', 'sub10', etc.)
	# add code to job .m file (same for all subjects)
	cat $TemplateFile >> $jobfile
	echo "made "$jobfile
	# append command for starting job for this subject to the job list file
	echo "matlab -nodesktop -nodisplay -nosplash -r \"run('"$jobfile"')\"" >> $cicjoblistFile
done
unset subx

# use job file from last subject to make test job list
test_cicjoblistFile=$JobDir/test_cicjoblist
touch $test_cicjoblistFile
echo "matlab -nodesktop -nodisplay -nosplash -r \"run('"$jobfile"')\"" >> $test_cicjoblistFile

#
echo `cat $cicjoblistFile | wc -l`" jobs were made"

## done
echo "done making cic jobs, cic job list and test cic job list. See "$JobDir
unset template_file cicjob_list JobDir AnalysisDir JobName SubjectList

exit 0
####

#!/bin/sh
# source populate_Input.sh  #use source because minc toolkit module is used to convert minc files to nifti
# for each subject, make folder in Input directory and copy bpipe preprocessed structural scan.
# images are denoised, centered, N4 bias corrected, croped but in native space.
# files are named <subx>_bpipe.nii (e.g. sub9_bpipe.nii)
# Requirements:
#	.../Scripts/subjects.txt (list of subject names)
#	ssh -Y zakell@cicws01
# warning: any subject folders in Input will be deleted before transfer if those subjects are in subject list

AnalysisDir=/data/scratch/zakell/bpipevbm # <- make sure this is correct

SrcDir=/data/chamal/projects/zakell/bpipe_out # where bpipe preprocessed .mnc files are kept
# check subject list
SubjectList=$AnalysisDir/Scripts/subjects.txt 
if [ ! -f $SubjectList ]; then
	printf "error: could not find subject list at\n\t%s\n" $SubjectList
	exit 1
fi
# make Input folder if not already there
test ! -d $AnalysisDir/Input && mkdir $AnalysisDir/Input

# load resources for converting
module load minc-toolkit minc-toolkit-extras
status=$?
if [ $status -ne 0 ]; then
	printf "error: login to cic to access minc module\nssh -Y zakell@cicws01\n"
	exit 2
fi
# copy clean_and_center.n4correct.cutneckapplyautocrop.mnc
for subx in `cat $SubjectList`
do
	# remake directory for this subject
	test -d $AnalysisDir/Input/$subx && rm -r $AnalysisDir/Input/$subx
	mkdir $AnalysisDir/Input/$subx
	# get subjects number e.g. sub9 -> 09, sub36 -> 36
	xx=`echo $subx | sed -e 's/sub//g'`
	if [ $xx -lt 10 ]; then
		xx="0"$xx
	elif [$xx -eq 39 ]; then
	# sub39 has 2 scans, the 2nd is better
		xx="39_2"
	fi
	# copy subject's MINC file to subject's Input folder
	cp -v $SrcDir/"lhs"$xx".clean_and_center.n4correct.cutneckapplyautocrop.mnc" $AnalysisDir/Input/$subx
	unset xx
	# convert copied MINC file to NIfTI file
	mnc2nii $AnalysisDir/Input/$subx/lhs*.mnc $AnalysisDir/Input/$subx/$subx"_bpipe.nii"
	rm $AnalysisDir/Input/$subx/lhs*.mnc
done
unset subx SubjectList SrcDir AnalysisDir
echo "Done populating Input"
### DONE

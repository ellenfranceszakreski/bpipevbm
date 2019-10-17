#!/bin/sh
# source populate_Input.sh
# add subx folder in Input for each subject in subject list get subx_bpipe.nii

AnalysisDir=/data/scratch/zakell/vmbbeast

SrcDir=/data/chamal/projects/zakell/bpipe_out
SubjectList=$AnalysisDir/Scripts/subjects.txt
if [ ! -f $SubjectList ]; then
	echo "error: no $SubjectList "
	exit 1
fi
# make Input folder if not already thee
test ! -d $AnalysisDir/Input && mkdir $AnalysisDir/Input

# load resources
module load minc-toolkit minc-toolkit-extras

# copy clean_and_center.n4correct.cutneckapplyautocrop.mnc
for subx in `cat $SubjectList`
do
	test -d $AnalysisDir/Input/$subx && rm -r $AnalysisDir/Input/$subx
	mkdir $AnalysisDir/Input/$subx
	xx=`echo $subx | sed -e 's/sub//g'`
	if [ $xx -lt 10 ]; then
		xx="0"$xx;
	fi
	cp -v $SrcDir/"lhs"$xx".clean_and_center.n4correct.cutneckapplyautocrop.mnc" $AnalysisDir/Input/$subx
	unset xx
	# convert to nii
	mnc2nii $AnalysisDir/Input/$subx/lhs*.mnc $AnalysisDir/Input/$subx/$subx"_bpipe.nii"
	rm $AnalysisDir/Input/$subx/lhs*.mnc
done
unset subx SubjectList SrcDir AnalysisDir
echo "Done transferring data"

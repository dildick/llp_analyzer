#!/bin/sh

mkdir -p log
mkdir -p submit

echo `pwd`

cd ../
RazorAnalyzerDir=`pwd`
cd -

job_script=${RazorAnalyzerDir}/scripts_condor/runRazorJob_llp_vH.sh

year=16

if [ $year == '16' ]
then
        year=MC_Summer16
        echo "year ${year}"
        samples='WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8'
	filesPerJob=10
elif  [ $year == '17' ]
then
        year=MC_Fall17
        echo "year ${year}"
        samples='WJetsToLNu_TuneCP5_13TeV-madgraphMLM-pythia8'
	filesPerJob=5
elif  [ $year == '18' ]
then
        year=MC_Autumn18
        echo "year ${year}"
        samples='WJetsToLNu_0J_TuneCP5_13TeV-amcatnloFXFX-pythia8 WJetsToLNu_1J_TuneCP5_13TeV-amcatnloFXFX-pythia8 WJetsToLNu_2J_TuneCP5_13TeV-amcatnloFXFX-pythia8'
	filesPerJob=5
else
        echo "year invalid"
        samples=''
fi

samples=DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8
samples=WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8
filesPerJob=10
for sample in ${samples}
do
	echo "Sample " ${sample}
	version=/V1p9/${year}/v1/
	output=/store/group/phys_exotica/delayedjets/displacedJetMuonAnalyzer/csc/${version}/v1/bkg/wH/${sample}
	inputfileDir=/src/llp_analyzer/lists/llpntuple/${version}/sixie/
	inputfilelist=/src/llp_analyzer/lists/llpntuple/${version}/sixie/${sample}.txt
	nfiles=`cat ${CMSSW_BASE}$inputfilelist | wc | awk '{print $1}' `
        maxjob=`python -c "print int($nfiles.0/$filesPerJob)"`
	mod=`python -c "print int($nfiles.0%$filesPerJob)"`
        if [ ${mod} -eq 0 ]
        then
                maxjob=`python -c "print int($nfiles.0/$filesPerJob)-1"`
        fi
	analyzer=llp_vH_MuonSystem
	analyzerTag=Razor2016_80X
	rm -f submit/${analyzer}_${sample}_Job*.jdl
	rm -f log/${analyzer}_${sample}_Job*
	# make tarball
#	rm -r ${sample}.tar
#	tar cvf ${sample}.tar -C ${CMSSW_BASE}/src/llp_analyzer/bin/ Runllp_MuonSystem
#	tar -f ${sample}.tar -r -C $CMSSW_BASE/src/llp_analyzer/data/JEC/ Summer16_23Sep2016V3_MC
#	tar -f ${sample}.tar -r -C ${CMSSW_BASE}/${inputfileDir} ${sample}.txt
#	mv ${sample}.tar tarball/
	for jobnumber in `seq 0 1 ${maxjob}`
	do
		echo "job " ${jobnumber} " out of " ${maxjob}
		jdl_file=submit/${analyzer}_${sample}_Job${jobnumber}_Of_${maxjob}.jdl
		echo "Universe = vanilla" > ${jdl_file}
		echo "Executable = ${job_script}" >> ${jdl_file}
		#echo "Arguments = ${analyzer} ${sample} no 13 ${filesPerJob} ${jobnumber} ${sample}_Job${jobnumber}_Of_${maxjob}.root ${output} ${analyzerTag} ${CMSSW_BASE} ${HOME}/" >> ${jdl_file}
                echo "Arguments = ${analyzer} ${inputfilelist} no 13 ${filesPerJob} ${jobnumber} ${sample}_Job${jobnumber}_Of_${maxjob}.root ${output} ${analyzerTag} ${CMSSW_BASE} ${HOME}/" >> ${jdl_file}
		# option should always be 1, when running condor
		echo "Log = log/${analyzer}_${sample}_Job${jobnumber}_Of_${maxjob}_PC.log" >> ${jdl_file}
		echo "Output = log/${analyzer}_${sample}_Job${jobnumber}_Of_${maxjob}_\$(Cluster).\$(Process).out" >> ${jdl_file}
	        echo "Error = log/${analyzer}_${sample}_Job${jobnumber}_Of_${maxjob}_\$(Cluster).\$(Process).err" >> ${jdl_file}

		#echo "Requirements=TARGET.OpSysAndVer==\"CentOS7\"" >> ${jdl_file}
		echo "Requirements=(TARGET.OpSysAndVer==\"CentOS7\" && regexp(\"blade.*\", TARGET.Machine))" >> ${jdl_file}
		echo "RequestMemory = 2000" >> ${jdl_file}
		echo "RequestCpus = 1" >> ${jdl_file}
		echo "RequestDisk = 4" >> ${jdl_file}
		echo "+RunAsOwner = True" >> ${jdl_file}
		echo "+InteractiveUser = true" >> ${jdl_file}
		echo "+SingularityImage = \"/cvmfs/singularity.opensciencegrid.org/bbockelm/cms:rhel7\"" >> ${jdl_file}
		echo '+SingularityBindCVMFS = True' >> ${jdl_file}
#		echo "transfer_input_files = tarball/${sample}.tar" >> ${jdl_file}
		echo "run_as_owner = True" >> ${jdl_file}
		echo "x509userproxy = ${HOME}/x509_proxy" >> ${jdl_file}
		echo "should_transfer_files = YES" >> ${jdl_file}
		echo "when_to_transfer_output = ON_EXIT" >> ${jdl_file}
		echo "Queue 1" >> ${jdl_file}
		echo "condor_submit ${jdl_file}"
		condor_submit ${jdl_file}
	done
done

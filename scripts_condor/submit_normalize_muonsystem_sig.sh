#!/bin/sh


mkdir -p log
mkdir -p submit

echo `pwd`

cd ../
RazorAnalyzerDir=`pwd`
cd -

job_script=${RazorAnalyzerDir}/scripts_condor/normalize.sh
listSummer16=(
ZH_HToSSTobbbb_ms55_pl10000_ev150000_batch1
ZH_HToSSTobbbb_ms55_pl10000_ev150000_batch3
ZH_HToSSTobbbb_ms55_pl10000_ev150000_batch4
ZH_HToSSTobbbb_ms55_pl1000_ev150000_batch1
ZH_HToSSTobbbb_ms55_pl1000_ev150000_batch3
ZH_HToSSTobbbb_ms55_pl1000_ev150000_batch4
WH_HToSSTobbbb_CSCDecayFilter_ms55_pl100000_ev150000
)
listSummer16=(
ZH_HToSSTobbbb_ms55_pl1000_ev150000
ZH_HToSSTobbbb_ms55_pl10000_ev150000
WH_HToSSTobbbb_CSCDecayFilter_ms55_pl100000_ev150000
)
listFall18=(
WplusH_HToSSTobbbb_ms55_pl10000_ev150000
WminusH_HToSSTobbbb_ms55_pl10000_ev150000
WJetsToLNu_TuneCP5_13TeV-madgraphMLM-pythia8
)
#listFall18=(
#ggH_HToSSTobbbb_ms1_pl1000
#)
for year in \
Summer16 \
Fall18
do
        echo ${year}
        sampleList=list${year}[@]
        for sample in "${!sampleList}"
        do

		inputDir=/store/group/phys_exotica/delayedjets/displacedJetMuonAnalyzer/csc/V1p17/MC_${year}/v1/v4/
		outputDir=${inputDir}normalized
		echo ${inputDir}
		echo "Sample " ${sample}
		analyzer=llp_MuonSystem
		rm -f submit/${analyzer}_normalize_${sample}*.jdl
		rm -f log/${analyzer}_normalize_${sample}*

		jdl_file=submit/${analyzer}_normalize_${sample}.jdl
		echo "Universe = vanilla" > ${jdl_file}
		echo "Executable = ${job_script}" >> ${jdl_file}
		echo "Arguments = bkg no ${sample} ${inputDir} ${outputDir} ${CMSSW_BASE} ${HOME}/"  >> ${jdl_file}

		echo "Log = log/${analyzer}_normalize_${sample}_PC.log" >> ${jdl_file}
		echo "Output = log/${analyzer}_normalize_${sample}_\$(Cluster).\$(Process).out" >> ${jdl_file}
		echo "Error = log/${analyzer}_normalize_${sample}_\$(Cluster).\$(Process).err" >> ${jdl_file}

		#echo "Requirements=TARGET.OpSysAndVer==\"CentOS7\"" >> ${jdl_file}
		echo "Requirements=(TARGET.OpSysAndVer==\"CentOS7\" && regexp(\"blade.*\", TARGET.Machine))" >> ${jdl_file}
		echo "RequestMemory = 2000" >> ${jdl_file}
		echo "RequestCpus = 1" >> ${jdl_file}
		echo "RequestDisk = 4" >> ${jdl_file}

		echo "+RunAsOwner = True" >> ${jdl_file}
		echo "+InteractiveUser = true" >> ${jdl_file}
#		echo "+SingularityImage = \"/cvmfs/singularity.opensciencegrid.org/bbockelm/cms:rhel7\"" >> ${jdl_file}
                echo "+SingularityImage = \"/cvmfs/singularity.opensciencegrid.org/cmssw/cms:rhel7-m202006\"" >> ${jdl_file}
		echo '+SingularityBindCVMFS = True' >> ${jdl_file}
		echo "run_as_owner = True" >> ${jdl_file}
		echo "x509userproxy = ${HOME}/x509_proxy" >> ${jdl_file}
		echo "should_transfer_files = YES" >> ${jdl_file}
		echo "when_to_transfer_output = ON_EXIT" >> ${jdl_file}
		echo "Queue 1" >> ${jdl_file}
		echo "condor_submit ${jdl_file}"
		condor_submit -batch-name ${sample} ${jdl_file} 
	done
done

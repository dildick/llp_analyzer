#!/bin/bash

#######################
#debugging purposes
#######################
voms-proxy-info --all
ls -l

############################
#define input parameters
############################
analysisType=$1
isData=$2
option=$3
jobnumber=$4
outputfile=$5
outputDirectory=$6
cmsswReleaseVersion=$7
year=$8
sampleName=$9

############################
#define exec and setup cmssw
############################
workDir=`pwd`
executable=${analysisType}
echo executable ${analysisType}
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc700
echo Setting up $cmsswReleaseVersion
#tar -zxvf cms_setup.tar.gz
scramv1 project CMSSW $cmsswReleaseVersion

#########################################
#copy input list and exec to cmssw folder
########################################
echo "Copying the input file list"
cp input_list.tgz $cmsswReleaseVersion/src/
cp ${executable} $cmsswReleaseVersion/src/.
mkdir -p $cmsswReleaseVersion/src/llp_analyzer/data/PileupWeights/
#cp llp_analyzer/data/JetHTTriggerEfficiency_2016.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp JetHTTriggerEfficiency_2016.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp llp_analyzer/data/JetHTTriggerEfficiency_2017.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp JetHTTriggerEfficiency_2017.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp llp_analyzer/data/JetHTTriggerEfficiency_2018.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp JetHTTriggerEfficiency_2018.root $cmsswReleaseVersion/src/llp_analyzer/data/
#cp llp_analyzer/data/PileupWeights/PileupWeights.root $cmsswReleaseVersion/src/llp_analyzer/data/PileupWeights/
#cp PileupWeights.root $cmsswReleaseVersion/src/llp_analyzer/data/PileupWeights/

###########################
#get cmssw environment
###########################
echo "get cmssw environment"
cd $cmsswReleaseVersion/src/
eval `scram runtime -sh`
tar vxzf input_list.tgz
inputfilelist=input_list_${jobnumber}.txt

###################################
#copy input files ahead of time
###################################
echo "copy input files ahead of time"
mkdir inputs/
for i in `cat $inputfilelist`
do
echo "Copying Input File: " $i
xrdcp $i ./inputs/
done
ls inputs/* > tmp_input_list.txt

###########################
#run executable
###########################
echo "Executing Analysis executable:"
echo "./${executable} tmp_input_list.txt llp_hnl_analyzer --outputFile=${outputfile}_${jobnumber}.root --optionNumber=${option} --isData=${isData} "
./${executable} tmp_input_list.txt llp_hnl_analyzer --outputFile=${outputfile}_${jobnumber}.root --optionNumber=${option} --isData=${isData} --year=${year} --pileupWeightName=${sampleName}

ls -l
##########################################################
#copy outputfile to /eos space -- define in submitter code
##########################################################
eosmkdir -p ${outputDirectory}
xrdcp -f ${outputfile}_${jobnumber}.root root://cmseos.fnal.gov/${outputDirectory}/${outputfile}_${jobnumber}.root
rm ${outputfile}_${jobnumber}.root
rm inputs -rv

cd -

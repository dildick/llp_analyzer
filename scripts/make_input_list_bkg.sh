#!/bin/bash
version=displacedJetTimingNtuple/V1p13/MC_Summer16/v4/jmao/
root_dir=/mnt/hadoop/store/group/phys_exotica/delayedjets/${version}
list_dir=$CMSSW_BASE/src/llp_analyzer/lists/${version}
echo $list_dir
mkdir -p $list_dir
for sample in \
ZJetsToNuNu_HT-100To200_13TeV-madgraph \
ZJetsToNuNu_HT-1200To2500_13TeV-madgraph \
ZJetsToNuNu_HT-200To400_13TeV-madgraph \
ZJetsToNuNu_HT-2500ToInf_13TeV-madgraph \
ZJetsToNuNu_HT-400To600_13TeV-madgraph \
ZJetsToNuNu_HT-600To800_13TeV-madgraph \
ZJetsToNuNu_HT-800To1200_13TeV-madgraph
do
        echo "${list_dir}${sample}.txt"
        rm -f ${list_dir}${sample}.txt
        find ${root_dir}${sample} -name "*.root" >> ${list_dir}${sample}.txt
        sed -i '/failed/d' ${list_dir}${sample}.txt
        echo "input list created for $sample"

done
#DYJetsToLL_M-50_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8 \
#QCD_HT1000to1500_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT100to200_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT1500to2000_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT2000toInf_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT200to300_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT300to500_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT500to700_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT50to100_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#QCD_HT700to1000_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#TTJets_DiLept_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#TTJets_SingleLeptFromTbar_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#TTJets_SingleLeptFromT_TuneCUETP8M1_13TeV-madgraphMLM-pythia8 \
#WJetsToLNu_TuneCUETP8M1_13TeV-amcatnloFXFX-pythia8
#ZJetsToNuNu_Zpt-200toInf_TuneCUETP8M1_13TeV-madgraphMLM-pythia8


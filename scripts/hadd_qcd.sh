#!/bin/sh

outputRoot=QCD_HT700to1500_TuneCP5_13TeV-madgraphMLM-pythia8_137000pb_weighted.root
dir=/store/group/phys_exotica/delayedjets/displacedJetMuonAnalyzer/csc/V1p17/MC_Fall18/v1/v92/normalized/
eval `scram runtime -sh`

# hadd $outputRoot /mnt/hadoop/$dir/QCD_HT1000to1500_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT100to200_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT1500to2000_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT2000toInf_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT200to300_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT300to500_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT500to700_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT50to100_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root /mnt/hadoop/$dir/QCD_HT700to1000_TuneCUETP8M1_13TeV-madgraphMLM-pythia8_1pb_weighted.root

hadd $outputRoot /mnt/hadoop/$dir/QCD_HT1000to1500_TuneCP5_13TeV-madgraphMLM-pythia8_137000pb_weighted.root /mnt/hadoop/$dir/QCD_HT700to1000_TuneCP5_13TeV-madgraphMLM-pythia8_137000pb_weighted.root

if [ -f $outputRoot ]
then
        echo "hadd done"
fi

eval `scram unsetenv -sh`
LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH

gfal-copy --checksum-mode=both $outputRoot gsiftp://transfer.ultralight.org/${dir}/$outputRoot

if [ -f /mnt/hadoop/$dir/$outputRoot ]
then
	echo "copy succeed"
	rm $outputRoot
fi

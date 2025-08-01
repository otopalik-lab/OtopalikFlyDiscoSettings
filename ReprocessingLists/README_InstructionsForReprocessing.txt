% Instructions for Re-processing data:

1. Make a new RerunList (a .txt file with list of paths to local experiment directories) and save in OtopalikFlyDiscoSettings/ReprocessingLists directory.

2. Commit to main OtopalikFlyDiscoSettings repo and push to origin.

3. Access otopalikrobot using login1 or login2. Open a terminal, then type:

ssh otopalika@login2
ssh otopalikrobot@login2
cd OtopalikFlyDiscoSettings
git pull
cd /misc/local/matlab-2023a/bin
bsub -Is -n1 -W 0:30 /bin/bash
./matlab

4. Now that you're in MATLAB, navigate to make makeToProcessSoftlinks.m, and run for new RerunList:

cd('/groups/otopalik/home/otopalikrobot/OtopalikFlyDiscoSettings')
addpath('ReprocessingLists')
addpath('ReprocessingLists/code')
makeToProcessSoftlinks('RerunList_20250710_VariableDensity.txt'); 

5. Can double-check that soft links these experiment directories on prfs (in otopalikrobot) have made it into the to-process directory in flydisco_data. First get out of MATLAB:

exit  
cd '/groups/otopalik/home/otopalikrobot/flydisco_data/to-process'
ls

You should see the list of experiment directories to be processed overnight. This should include the experiments in your new rerun list.





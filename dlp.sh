#!/bin/zsh
source ~/.zshrc

ksp
# Note: run ksp first
pod=$1
logname=$2
namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
namespace=${namespace:(-4)}
year=$(date "+%Y")
date=$(date "+%Y.%m.%d-%H.%M")
date_no_time=$(date "+%Y.%m.%d")
time=$(date "+%Y.%m.%d")
shipname=$(kubectl config current-context | awk '{print $1}')
savefolder=~/logs/$shipname\-$namespace/$date_no_time/$pod
echo $savefolder
savename=$logname
k cp $backend\:exports/logs/$pod/$logname $savefolder\/$savename

echo "Pod:" $pod "| Logname:" $logname
if [[ "$savename" =~ .*".gz".* ]]; 
then
	gzip -d $savefolder\/$savename
	logname=$(echo $savefolder\/$savename | awk '{ print substr( $0, 1, length($0)-3) }') # remove .gz
else
	logname=$savefolder\/$savename
fi

current_year=$(date "+%Y")
start_time=$(cat $logname | grep "$current_year" | awk '{print $1}' | head -n 1)
ending_time=$(cat $logname | grep "$current_year" | awk '{print $1}' | tail -n 1)

mv $logname $logname\_$start_time\-$ending_time".log"

echo 'Starting time of oldest log:' $start_time
echo 'Ending time of oldest log:' $ending_time 
echo ''

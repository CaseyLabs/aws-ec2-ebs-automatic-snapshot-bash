#!/bin/bash
# Safety feature: exit script if error is returned, or if variables not set.
# Exit if a pipeline results in an error.
set -ue
set -o pipefail

#######################################################################
#
## Automatic EBS Volume Snapshot Creation & Clean-Up Script
#
# Originally written by Star Dot Hosting (www.stardothosting.com)
# http://www.stardothosting.com/blog/2012/05/automated-amazon-ebs-snapshot-backup-script-with-7-day-retention/
#
# Heavily updated by Casey Labs Inc. (www.caseylabs.com)
# Casey Labs - Contact us for all your Amazon Web Services Consulting needs!
#
#######################################################################

## REQUIREMENTS:
# This script requires the AWS CLI tools to be installed.
# Read me about AWS CLI at: https://aws.amazon.com/cli/

# Linux install instructions for AWS CLI:
# - Make sure Python pip is installed (e.g. yum install python-pip)
# - Then run: pip install awscli

# Once the AWS CLI has been installed, you'll need to configure it with the credentials of an IAM user that
# has permission to take and delete snapshots of EBS volumes.
# Configure AWS CLI by running this command: 
#		aws configure

# Copy this script to /opt/aws/ebs-snapshot.sh
# Example crontab job for nightly backups:
# 55 22 * * *     root    /opt/aws/ebs-snapshot.sh > /var/log/ebs-snapshot.log 2>&1


## START SCRIPT

# Constants
instance_id=`wget -q -O- http://169.254.169.254/latest/meta-data/instance-id`
date_7days_ago_in_seconds=`date +%s --date '7 days ago'`

# Grab all volume IDs attached to this instance, and export the IDs to a text file
aws ec2 describe-volumes --output=text --filter Name=attachment.instance-id,Values=$instance_id | grep VOLUME | cut -f7 > /tmp/volume_info.txt 2>&1

# Take a snapshot of all volumes attached to this instance
for volume_id in $(cat /tmp/volume_info.txt)
do
    description="$(hostname)-backup-$(date +%Y-%m-%d)"
    # Next, we're going to take a snapshot of the current volume, and capture the resulting snapshot ID
	snapresult=$(aws ec2 create-snapshot --output=text --description $description --volume-id $volume_id | cut -f4)
	
    echo "New snapshot is $snapresult"
         
    # And then we're going to add a "CreatedBy:AutomatedBackup" tag to the resulting snapshot.
    # Why? Because we only want to purge snapshots taken by the script later, and not delete snapshots manually taken.
    aws ec2 create-tags --resource $snapresult --tags Key=CreatedBy,Value=AutomatedBackup
done

# Get all snapshot IDs associated with each volume attached to this instance
rm /tmp/snapshot_info.txt --force
for vol_id in $(cat /tmp/volume_info.txt)
do
    aws ec2 describe-snapshots --output=text --filters "Name=volume-id,Values=$vol_id" "Name=tag:CreatedBy,Values=AutomatedBackup"| grep SNAPSHOT | cut -f5 | sort | uniq >> /tmp/snapshot_info.txt 2>&1
done

# Purge all instance volume snapshots created by this script that are older than 7 days
for snapshot_id in $(cat /tmp/snapshot_info.txt)
do
    echo "Checking $snapshot_id..."
	snapshot_date=$(aws ec2 describe-snapshots --output=text --snapshot-ids $snapshot_id | grep SNAPSHOT | awk '{print $6}' | awk -F "T" '{printf "%s\n", $1}')
    snapshot_date_in_seconds=`date "--date=$snapshot_date" +%s`

    if (( $snapshot_date_in_seconds <= $date_7days_ago_in_seconds )); then
        echo "Deleting snapshot $snapshot_id ..."
        aws ec2 delete-snapshot --snapshot-id $snapshot_id
    else
        echo "Not deleting snapshot $snapshot_id ..."
    fi
done

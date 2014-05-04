aws-ec2-ebs-automatic-snapshot
==============================

Bash script for Automatic EBS Snapshots and Cleanup on Amazon Web Services (AWS)



Automatic EBS Volume Snapshot Creation & Clean-Up Script

Originally written by Star Dot Hosting (www.stardothosting.com)
http://www.stardothosting.com/blog/2012/05/automated-amazon-ebs-snapshot-backup-script-with-7-day-retention/

Heavily updated by Casey Labs Inc. (www.caseylabs.com)
Casey Labs - Contact us for all your Amazon Web Services Consulting needs!


REQUIREMENTS:
This script requires the AWS CLI tools to be installed.
Read me about AWS CLI at: https://aws.amazon.com/cli/

Linux install instructions for AWS CLI:
 - Make sure Python pip is installed (e.g. yum install python-pip)
 - Then run: pip install awscli

Once the AWS CLI has been installed, you'll need to configure it with the credentials of an IAM user that
has permission to take and delete snapshots of EBS volumes.
 Configure AWS CLI by running this command: 
		aws configure

Copy this script to /opt/aws/ebs-snapshot.sh
Example crontab job for nightly backups:
55 22 * * *     root    /opt/aws/ebs-snapshot.sh > /var/log/ebs-snapshot.log 2>&1


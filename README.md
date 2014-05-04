aws-ec2-ebs-automatic-snapshot-bash
===================================

####Bash script for Automatic EBS Snapshots and Cleanup on Amazon Web Services (AWS)

*Originally written by [Star Dot Hosting] (http://www.stardothosting.com)*

Heavily updated by **[Casey Labs Inc.] (http://www.caseylabs.com)**

*Casey Labs - Contact us for all your Amazon Web Services Consulting needs!*

===================================

**REQUIREMENTS:**
This script requires the AWS CLI tools to be installed.

Read me about AWS CLI at: https://aws.amazon.com/cli/

Linux install instructions for AWS CLI:
 - Make sure Python pip is installed (e.g. yum install python-pip)
 - Then run: 
```
pip install awscli
```
Once the AWS CLI has been installed, you'll need to configure it with the credentials of an IAM user that
has permission to take and delete snapshots of EBS volumes.
 Configure AWS CLI by running this command: 
```
aws configure
```

Then copy this Bash script to /opt/aws/ebs-snapshot.sh and make it executable:
```
chmod +x /opt/aws/ebs-snapshot.sh
```

You should then setup a cron job in order to schedule a nightly backup. Example crontab job:
```
55 22 * * *     root    /opt/aws/ebs-snapshot.sh > /var/log/ebs-snapshot.log 2>&1
```

===================================

**How it works:**
ebs-snapshot.sh will:
- Determine the instance ID of the EC2 server on which the script runs
- Gather a list of all volume IDs attached to that instance
- Take a snapshot of each attached volume
- The script will then delete all associated snapshots taken by the script that are older than 7 days


Pull requests greatly welcomed!

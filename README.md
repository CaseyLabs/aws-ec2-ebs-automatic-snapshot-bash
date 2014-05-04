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

Then copy this Bash script to /opt/aws/ebs-snapshot.sh
```
chmod +x /opt/aws/ebs-snapshot.sh
```

Example crontab job for nightly backups:
```
55 22 * * *     root    /opt/aws/ebs-snapshot.sh > /var/log/ebs-snapshot.log 2>&1
```

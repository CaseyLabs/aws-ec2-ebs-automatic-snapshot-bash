aws-ec2-ebs-automatic-snapshot-bash
===================================

####Bash script for Automatic EBS Snapshots and Cleanup on Amazon Web Services (AWS)

*Originally written by [Star Dot Hosting] (http://www.stardothosting.com)*

Heavily updated by  **[AWS Consultants - Casey Labs Inc.] (http://www.caseylabs.com)**

*Casey Labs - Contact us for all your Amazon Web Services Consulting needs!*

===================================

**How it works:**
ebs-snapshot.sh will:
- Determine the instance ID of the EC2 server on which the script runs
- Gather a list of all volume IDs attached to that instance
- Take a snapshot of each attached volume
- The script will then delete all associated snapshots taken by the script that are older than 7 days


Pull requests greatly welcomed!

===================================

**REQUIREMENTS**

**IAM User:** This script requires that a new user (e.g. ebs-snapshot) be created in the IAM section of AWS.   
Here is a sample IAM policy for AWS permissions that this new user will require:

```
{
  "Statement": [
    {
      "Action": [
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:CreateTags",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshotAttribute",
        "ec2:DescribeSnapshots",
        "ec2:DescribeVolumeAttribute",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeVolumes",
        "ec2:ReportInstanceStatus",
        "ec2:ResetSnapshotAttribute"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
```
<br />

**AWS CLI:** This script requires the AWS CLI tools to be installed.

Linux install instructions for AWS CLI:
 - Make sure Python pip is installed (e.g. yum install python-pip, or apt-get install python-pip)
 - Then run: 
```
pip install awscli
```
Once the AWS CLI has been installed, you'll need to configure it with the credentials of the IAM user created above:

```
aws configure
```

_Access Key & Secret Access Key_: enter in the credentials generated above for the new IAM user.  
_Region Name_: the region that this instance is currently in.  
_Output Format_: enter "text"  


Then copy this Bash script to /opt/aws/ebs-snapshot.sh and make it executable:
```
chmod +x /opt/aws/ebs-snapshot.sh
```

You should then setup a cron job in order to schedule a nightly backup. Example crontab job:
```
55 22 * * *  AWS_CONFIG_FILE="/root/.aws/config" /opt/aws/ebs-snapshot.sh > /var/log/ebs-snapshot.log 2>&1
```

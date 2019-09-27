# central-logging-multi-account-environments

[![Join the chat at https://gitter.im/Zamira-Jaupaj/central-logging-multi-account-environments](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Zamira-Jaupaj/central-logging-multi-account-environments)


![Architecture of Centralize Cross AWS Account](https://raw.githubusercontent.com/zamirajaupaj/central-logging-multi-account-environments/master/architecture/architecture.png)

### Requirements  
* Minimum two AWS Accounts
* Python 3.7
* Terraform 
**[The link below](https://learn.hashicorp.com/terraform/getting-started/install.html)**

### AWS Account 
* if you don't have yet an account on aws, you need an account to deploy lambda function
**[The link below](https://aws.amazon.com/account/)**

### Configuration of AWS CLI

```
[accountDestination]
aws_access_key_id     = aaaaaaaaaaaaaaa
aws_secret_access_key = bbbbbbbbbbbbbbb

[accountSource]
aws_access_key_id     = aaaaaaaaaaaaaaa
aws_secret_access_key = bbbbbbbbbbbbbbb

[default]
aws_access_key_id        = aaaaaaaaaaaaaaa
aws_secret_access_key    = bbbbbbbbbbbbbbb
aws_session_token        = ccccccccccccccc

```
### Quickstart for Centralize Account

```
$ git clone https://github.com/zamirajaupaj/central-logging-multi-account-environments.git
$ cd central-logging-multi-account-environments
$ terraform init
$ terraform plan
$ terraform apply 

```

### Quickstart for Source Account

```
$ git clone https://github.com/zamirajaupaj/central-logging-multi-account-environments/source-account.git
$ cd central-logging-multi-account-environments
$ terraform init
$ terraform plan
$ terraform apply 

```
### Kinesis Firehose
- Amazon Kinesis Data Firehose is a fully managed service for delivering real-time streaming data to destinations such as Amazon Simple Storage Service (Amazon S3), Amazon Redshift, Amazon Elasticsearch Service (Amazon ES)
### ElasticSearch 
- Amazon Elasticsearch Service is a fully managed service that makes it easy for you to deploy, secure, and operate Elasticsearch at scale with zero down time. The service offers open-source Elasticsearch APIs, managed Kibana, and integrations with Logstash and other AWS Services


# central-logging-multi-account-environments

[![Join the chat at https://gitter.im/Zamira-Jaupaj/central-logging-multi-account-environments](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Zamira-Jaupaj/central-logging-multi-account-environments)

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

### Trigger Lambda By Kinesis
```JSON
{
  "invocationId": "invoked123",
  "deliveryStreamArn": "aws:lambda:events",
  "region": "us-west-2",
  "records": [
    {
      "data": "SGVsbG8gV29ybGQ=",
      "recordId": "record1",
      "approximateArrivalTimestamp": 1510772160000,
      "kinesisRecordMetadata": {
        "shardId": "shardId-000000000000",
        "partitionKey": "4d1ad2b9-24f8-4b9d-a088-76e9947c317a",
        "approximateArrivalTimestamp": "2012-04-23T18:25:43.511Z",
        "sequenceNumber": "49546986683135544286507457936321625675700192471156785154",
        "subsequenceNumber": ""
      }
    },
    {
      "data": "SGVsbG8gV29ybGQ=",
      "recordId": "record2",
      "approximateArrivalTimestamp": 151077216000,
      "kinesisRecordMetadata": {
        "shardId": "shardId-000000000001",
        "partitionKey": "4d1ad2b9-24f8-4b9d-a088-76e9947c318a",
        "approximateArrivalTimestamp": "2012-04-23T19:25:43.511Z",
        "sequenceNumber": "49546986683135544286507457936321625675700192471156785155",
        "subsequenceNumber": ""
      }
    }
  ]
}
```

### Kinesis Firehose
- Amazon Kinesis Data Firehose is a fully managed service for delivering real-time streaming data to destinations such as Amazon Simple Storage Service (Amazon S3), Amazon Redshift, Amazon Elasticsearch Service (Amazon ES)
### ElasticSearch 
- Amazon Elasticsearch Service is a fully managed service that makes it easy for you to deploy, secure, and operate Elasticsearch at scale with zero down time. The service offers open-source Elasticsearch APIs, managed Kibana, and integrations with Logstash and other AWS Services


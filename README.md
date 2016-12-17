## sparkleformation-indigo-lambda
This repository contains SparkleFormation templates that launch AWS lambda.

SparkleFormation is a tool that creates CloudFormation templates, which are
static documents declaring resources for AWS to create.

### publish_lambda.sh

Before you can launch the stacks that the templates in this repository
will create, you must create an S3 bucket that holds AWS Lambda 
distribution packages
(see https://github.com/indigobio/sparkleformation-indigo-buckets).

The publish_lambda.sh script will upload distribution packages to
the ascent-`ENV['environment']`-lambda bucket.  Without the packages
in place, CloudFormation will fail:

```
Error occurred while GetObject. S3 Error Code: NoSuchKey. 
S3 Error Message: The specified key does not exist.
```

### Launching a Lambda stack

As an example, here's how to launch the deregister-chef-node stack.
```shell
sfn create -p -I -f deregister_chef_node \
-d -M 7200 $org-$environment-lambda-deregister-chef-node-$AWS_REGION-`date '+%Y%m%d%H%M%S'`
```

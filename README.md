## Aerospike Database Enterprise Edition on the AWS Cloud—Quick Start

For architectural details, step-by-step instructions, and customization options, see the [deployment guide](https://fwd.aws/Pa8Yw?).

To post feedback, submit feature ideas, or report bugs, use the **Issues** section of this GitHub repo. 

To submit code for this Quick Start, see the [AWS Quick Start Contributor's Kit](https://aws-quickstart.github.io/).



### Running tests
``` bash
aws cloudformation create-stack --stack-name pipeline-taskcat --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file:///../github.com/Aerospike-DBaaS/quickstart-aerospike/pipeline-taskcat.yml --parameters ParameterKey=GitHubUser,ParameterValue=YOURGITHUBUSERID ParameterKey=GitHubRepo,ParameterValue=taskcat-example
```


### References
- https://stelligent.com/2019/11/27/run-aws-cloudformation-tests-from-codepipeline-using-taskcat/
- https://github.com/aws-quickstart/quickstart-taskcat-ci
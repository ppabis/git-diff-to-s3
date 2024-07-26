
## Applying the infrastructure
First edit all the variables that you need and set a region.

```bash
$ tofu init
$ tofu apply
```

## How to handle changes to the Docker image?
First taint the image and run apply again.

```bash
$ tofu taint module.ecr.docker_image.ecr_image
$ tofu apply
```

## How to run this manually?
```bash
TERRAFORM_BINARY="tofu"
aws ecs run-task \
 --task-definition $($TERRAFORM_BINARY output -raw task_definition_arn) \
 --region $($TERRAFORM_BINARY output -raw region) \
 --network-configuration \
 'awsvpcConfiguration={subnets=['$($TERRAFORM_BINARY output -raw subnet_id)'],securityGroups=['$($TERRAFORM_BINARY output -raw sg_id)'],assignPublicIp=ENABLED}' \
 --cluster $($TERRAFORM_BINARY output -raw cluster_name) \
 --launch-type FARGATE \
 --overrides '{
    "containerOverrides": [
        {
            "name": "git",
            "environment": [
                {"name": "GIT_REPO", "value": "'$(tofu output -raw repo_name)'"},
                {"name": "PARAMETER_NAME", "value": "/git-diff/repo-123"},
                {"name": "RESULTS_BUCKET", "value": "'$(tofu output -raw bucket_name)'/reporesults"}
            ]
        }
    ]
 }'
```

## What if the repository is empty?
It won't work. `HEAD` is not defined so the whole script will behave weirdly. In
SSM it will put a string of `HEAD` that will prevent further successful
executions of this script.

## What if there are no changes?
The script will just create an empty file in S3.
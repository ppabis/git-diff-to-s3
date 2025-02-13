Daily Git diff in S3
===================
This projects schedules a daily run of ECS task that clones a Git repository and
performs a diff between current HEAD and last run. The diff is then stored in S3
bucket and last commit processed (so current HEAD) in SSM Parameter Store.

More description in the following blog posts:

- [Daily Git diff into S3](https://pabis.eu/blog/2024-07-29-Daily-Git-Diff-Into-S3.html)
- [Daily Git diff into S3 - external Git repository](https://pabis.eu/blog/2024-07-31-Daily-Git-Diff-Into-S3-GitHub.html)

This project by default creates a CodeCommit repository but it shouldn't be
difficult to modify it or add more repositories with several schedules.

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
                {"name": "GIT_REPO", "value": "'$($TERRAFORM_BINARY output -raw repo_name)'"},
                {"name": "PARAMETER_NAME", "value": "/git-diff/repo-123"},
                {"name": "RESULTS_BUCKET", "value": "'$($TERRAFORM_BINARY output -raw bucket_name)'/reporesults"}
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

## Using external Git repository
Set variable "external_repo_url" to match Git clone URL without any credentials.
Then you have to put your `username:password` in SSM Parameter Store.

```bash
$ read -s GIT_HTTP_BASIC_AUTH_CREDENTIALS # type username:password. It won't be shown
$ aws ssm put-parameter --name $(tofu output -raw git_http_auth_name) --value "$GIT_HTTP_BASIC_AUTH_CREDENTIALS" --overwrite --region eu-west-1
$ unset GIT_HTTP_BASIC_AUTH_CREDENTIALS
```
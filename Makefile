SHELL = /bin/bash
SHELLFLAGS = -ex

VERSION ?= $(shell git rev-parse --short HEAD)
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

# Import settings and stage-specific overrides
include ./settings/defaults.conf
ifneq ("$(wildcard ./settings/$(ENVIRONMENT).conf"), "")
-include ./settings/$(ENVIRONMENT).conf
endif

help:  ## get info about available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy-github-oidc: ## deploy oidc provider and IAM role for github actions
	$(eval S3_BUCKET := $(shell aws ssm get-parameter --name $(ARTIFACTS_BUCKET_SSM_PATH) --query Parameter.Value --output text))
	@sam deploy --no-fail-on-empty-changeset \
		--stack-name xplorers-infra-$(GIT_BRANCH)-oidc \
		--capabilities CAPABILITY_NAMED_IAM \
		--tags xplorers-infra:version=$(VERSION) xplorers-infra:branch=$(GIT_BRANCH) \
		--parameter-overrides \
			GitHubOrg=$(GITHUB_ORG) \
		--template-file ./cloudformation/github_oidc.yml \
		--s3-bucket $(S3_BUCKET)

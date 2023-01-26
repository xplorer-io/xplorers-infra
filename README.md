# xplorers-infra
Infrastructure resources for Xplorers

## Resources

### AWS IAM Role and OIDC Provider for Github Actions
* ***Template***: cloudformation/github_oidc.yml
* ***Source***: https://github.com/marketplace/actions/configure-aws-credentials-action-for-github-actions
* Allow Github Actions to assume role in Xplorers Account and deploy resources.
* Once the IAM Role has been deployed to AWS, create a github actions secret `AWS_IAM_ROLE_ARN_FOR_GITHUB_ACTIONS` with the value of AWS IAM Role ARN to allow other repositories' github actions workflow to use the role.

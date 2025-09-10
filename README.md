### Note

Thank you for your interest in the `argocd-sync-app` GitHub Action!

This action helps you automatically sync an application to ArgoCD using build artifacts and a provided application YAML file. It is designed to simplify CI/CD workflows for Kubernetes deployments managed by ArgoCD.

Currently, we are not accepting external contributions to this repository. Our team is focusing on maintaining stability and security for users. You can follow updates and new features on the GitHub public roadmap.

If you have questions or need support:
1. Please use our [Community Discussions area](https://github.com/orgs/community/discussions/categories/actions) for general questions and support.
2. High priority bugs can be reported via Community Discussions or to our support team: https://support.github.com/contact/bug-report.
3. For security issues, please refer to our [SECURITY.md](SECURITY.md).

We will continue to provide security updates and fix major breaking changes. Bug reports are always welcome.

### What's new

Please refer to the [release page](https://github.com/aaronyang0628/argocd-sync-app/releases/latest) for

### Usage
<!-- start usage -->
```yaml
- uses: aaronyang0628/argocd-sync-app@v1.3
  with:
    # 
    # Required: ArgoCD server address (with port)
    argocd-server: '192.168.58.2:30443'

    # Optional: ArgoCD username, default is 'admin'
    argocd-user: 'admin'

    # Required: ArgoCD authentication token, recommended to use secrets
    # ${{ secrets.ARGOCD_TOKEN }}
    argocd-token: 'AdQUx7gQLbzD74iF'

    # Optional: Extra options for connecting to ArgoCD, default is '--insecure'
    insecure-option: '--insecure'

    # Optional: Options for syncing the application, default is '--prune --force'
    sync-option: '--prune --force'

    # Required: Path to the application YAML file
    application-yaml-path: 'sample/sample.nginx.app.yaml'
    
```
<!-- end usage -->

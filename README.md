# Helm GCP Push
![Build](https://github.com/namcxn/helm-gcp-push/workflows/Build/badge.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/namcxn/helm-gcp-push.svg)
![License](https://img.shields.io/github/license/namcxn/helm-gcp-push.svg?style=flat)

Push a chart to a GCP OCI compatible registry with Helm v3

## Usage
Using Token Auth with OCI Registry:
```yaml
steps:
  - id: 'gcloud-auth'
    name: 'Authenticate to Google Cloud'
    uses: 'google-github-actions/auth@62cf5bd3e4211a0a0b51f2c6d6a37129d828611d' #v2.1.5
    with:
      token_format: 'access_token'
      workload_identity_provider: ${{ secrets.GH_ACTIONS_WIP }}
      service_account: ${{ secrets.GH_ACTIONS_SA_GCR }}

  - name: Push Helm chart to OCI compatible registry (GCP)
    uses: namcxn/helm-gcp-push@1.0.0
    with:
      registry-url:  oci://{{LOCATION}}s-docker.pkg.dev/{{project-id}}/{{repository}}/
      username: oauth2accesstoken
      gcp-access-token: ${{ steps.gcloud-auth.outputs.access_token }}
      chart-folder: k8s-service
      gcp-wip-docker: false
      gcp-location: us
```

Using your Docker configuration:
```yaml
steps:
  - id: 'gcloud-auth'
    name: 'Authenticate to Google Cloud'
    uses: 'google-github-actions/auth@62cf5bd3e4211a0a0b51f2c6d6a37129d828611d' #v2.1.5
    with:
      token_format: 'access_token'
      workload_identity_provider: ${{ secrets.GH_ACTIONS_WIP }}
      service_account: ${{ secrets.GH_ACTIONS_SA_GCR }}

  - name: 'Login to Helm Reposistory'
    uses: 'docker/login-action@343f7c4344506bcbf9b4de18042ae17996df046d' #v2.1.0
    with:
      registry: {{LOCATION}}-docker.pkg.dev
      username: oauth2accesstoken
      password: ${{ steps.gcloud-auth.outputs.access_token }}

  - name: Push Helm chart to OCI compatible registry (GCP)
    uses: namcxn/helm-gcp-push@1.0.0
    with:
      registry-url:  oci://{{LOCATION}}-docker.pkg.dev/{{project-id}}/{{repository}}/
      username: oauth2accesstoken
      chart-folder: k8s-service
      gcp-wip-docker: true
      gcp-location: us
```

### Parameters

| Key | Value                                                                                       | Required | Default |
| ------------- |---------------------------------------------------------------------------------------------| ------------- | ------------- |
| `username` | Username for registry                                                                       | **Yes** | "oauth2accesstoken" |
| `registry-url` | Registry url                                                                                | **Yes** | "" |
| `gcp-access-token` | GCP service account access token                                                          | No | "" |
| `chart-folder` | Relative path to chart folder to be published                                               | No | chart |
| `gcp-wip-docker` | Using your Docker configuration login                                                     | **Yes** | "" |
| `gcp-location`|  Artifact Registry stores artifacts in the select location                                   | No| "us" |
| `source-dir` | The local directory you wish to upload                                                        | No | "." |

## License

This project is distributed under the [MIT license](LICENSE.md).

## TODO

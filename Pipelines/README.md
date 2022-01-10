** This folder hosts the various pipelines in YAML format for use within Azure DevOps**

- azure-pipeline.yaml
    -   description: This pipeline will package this entire repository as an artifact and upload it to an Artifact feed of your choice. This Pipeline should be configured to trigger each time a push/merge to main repository is done.
    
    -   Concept: This repository contains core modules and calling code which are used to deploy Azure infrastructure in a subscription. By Nature, this code is "DRY" ( Donot Repeat Yourself), and the actual infrastructure specs are passed via a Tfvars file passed by a customer. The customer will download a copy of artifact version from feed which is certified/vetted and use it either for development or deployment. Feed artifact lifetime should be configured to encourage people to move to newer code and avoid using old/unsecure code.


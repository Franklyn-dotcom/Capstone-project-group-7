#

![Altschool Africa](https://github.com/tuyojr/cloudTasks/blob/main/logos/AltSchool.svg)

## Conduit Real-World Application

This repository contains files used to deploy the Meduim.com clone called Conduit created by [gothinkster](https://github.com/gothinkster/realworld). The implemnetation contained here is a clone of the Django, HTMX, and Alpine implementation by [@danjac](https://github.com/danjac) with some modifications to use a PostgreSQL database in our production environment instead of the dbsqlite3 used for initial development.

## Application Architecture

![conduit_architecture](https://github.com/Franklyn-dotcom/Capstone-project-group-7/blob/feature/test2/images/conduit_architecture.jpg)

## Application Deployment

The application is deployed via a Jenkins pipeline as defined in the [Jenkinsfile](Jenkinsfile). The pipeline is triggered by a push to the main branch of this repository. The pipeline is defined in the Jenkinsfile and it does the following:

1. Builds the application container image from the [Dockerfile](Dockerfile).
2. Pushes the container image to the Docker Container Registry.
3. Builds the infracost container to check our cloud costs.
4. Initializes the terrafrom environment and builds the infrastructure defined in the [terraform](terraform) directory.
5. Deploys the application to the EKS created by terraform and using the manifests in the [kubernetes](k8s) directory.
6. Deploys the monitoring stack to the EKS cluster using the manifests in the [monitoring](monitoring) directory.
7. Takes down the application and destroys the infrastructure created by terraform when no longer needed

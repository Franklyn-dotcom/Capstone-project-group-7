#

![Altschool Africa](https://github.com/tuyojr/cloudTasks/blob/main/logos/AltSchool.svg)

![realworld-dual-mode](https://github.com/gothinkster/realworld/blob/main/media/realworld-dual-mode.png)

## Conduit Real-World Application

This repository contains files used to deploy the Meduim.com clone called Conduit created by [gothinkster](https://github.com/gothinkster/realworld). The implemnetation contained here is a clone of the Django, HTMX, and Alpine implementation by [@danjac](https://github.com/danjac) with some modifications to use a PostgreSQL database in our production environment instead of the dbsqlite3 used for initial development.

## Application Architecture

![conduit_architecture](https://github.com/Franklyn-dotcom/Capstone-project-group-7/blob/feature/test2/images/conduit_architecture.jpg)

## Application Deployment

The Conduit application was live at [django.steveric.me](https://django.steveric.me).

Deployment of the application was done via a Jenkins pipeline defined in the [Jenkinsfile](Jenkinsfile).
The Jenkins server used to manage jobs was provisioned on AWS EC2 using the [bastion](bastion/) directory. The Jenkins server is configured to use the [Jenkinsfile](Jenkinsfile) in this repository as a pipeline.
The pipeline is triggered by a push to the main branch of this repository. The pipeline is defined in the Jenkinsfile and it does the following:

1. Builds the application container image from the [Dockerfile](Dockerfile).
2. Pushes the container image to the Docker Container Registry.
3. Builds the infracost container to check our cloud costs.
4. Initializes the terrafrom environment and builds the infrastructure defined in the [terraform](terraform/) directory.
5. Deploys the application to the EKS created by terraform and using the manifests in the [kubernetes](k8s/) directory.
6. Deploys the monitoring stack to the EKS cluster using the manifests in the [monitoring](monitoring/) directory.
7. Takes down the application and destroys the infrastructure created by terraform when no longer needed

## Active Maintainers

- [Abubakar Mohammed](https://github.com/Mobakar) [Config Management Team] [![Linkedin Badge](https://img.shields.io/badge/-abubakar-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/abubakar-mohammed-86577b1a2/>)
- [Achebe Okechukwu Peter](https://github.com/Okeybukks) (Team Lead) [CI/CD Team] [![Linkedin Badge](https://img.shields.io/badge/-achebe-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/achebe-okechukwu-82a9479a/>)
- [Kinger Stephen Eric](https://github.com/Steveric1) [Config Management Team] [![Linkedin Badge](https://img.shields.io/badge/-stephen-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/steve-eric/>)
- [Mbanugo Ugochukwu](https://github.com/Franklyn-dotcom) [S.R.E. Team] [![Linkedin Badge](https://img.shields.io/badge/-franklin-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/mbanugo-franklyn/>)
- [Miriam Efedhoma](https://github.com/Khessie) [Infrastructure Team] [![Linkedin Badge](https://img.shields.io/badge/-khessie-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/miriamefedhoma/>)
- [Okeke Isaac](https://github.com/isaackees) [S.R.E. Team] [![Linkedin Badge](https://img.shields.io/badge/-isaac-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/isaacokeke/>)
- [Victor Onyekwere](https://github.com/dkckac8989) [CI/CD Team] [![Linkedin Badge](https://img.shields.io/badge/-victor-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/victor-onyekwere-31a8a2270/>)
- [Adedolapo Olutuyo](https://github.com/tuyojr) [Infrastructure Team] [![Linkedin Badge](https://img.shields.io/badge/-tuyo-blue?style=for-the-badge&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/adedolapo-o-968841b6)](<https://www.linkedin.com/in/adedolapo-o-968841b6/>)

> Everyone is part of the FinOps Team.

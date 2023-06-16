def djangoSecretKey = credentials("DJANGO_SECRET_KEY")
def dbName = "postgres"
def dbUser = "postgres"
def dbPassword = credentials("DB_PASSWORD")
def dbPort = 5432
def allowedHosts = credentials("ALLOWED_HOSTS")


def envFilePath = "temp_env.list"
def envFileContent = """
    DJANGO_SECRET_KEY=$djangoSecretKey\n
    DB_NAME=$dbName\n
    DB_USER=$dbUser\n
    DB_PASSWORD=$dbPassword\n
    DB_PORT=$dbPort\n
    POSTGRES_DB=$dbName\n
    POSTGRES_USER=$dbUser\n
    POSTGRES_PASSWORD=$dbPassword\n
    ALLOWED_HOSTS=$allowedHosts
"""
pipeline{
    agent any
    triggers {
        githubPush()
    }
    environment{
        DOCKERHUB_CREDENTIAL = credentials("DOCKER_ID")
        TF_VAR_db_user = 'postgres'
        TF_VAR_db_password = credentials("DB_PASSWORD")
    }
    stages{
        stage("Run Application Test"){
            steps{
                echo 'Run application test'
            }
        }
        stage("Login to Dockerhub"){
            steps{
                sh 'echo $DOCKERHUB_CREDENTIAL_PSW | docker login -u $DOCKERHUB_CREDENTIAL_USR --password-stdin'
            }
        }
        stage("Build and Push Application Image"){
            when {
                expression {

                    return "$GIT_BRANCH == main"; 
                 }
            }
            steps{
                script {
                    writeFile file: envFilePath, text: envFileContent
                    
                    // sh "cat temp_env.list"
                    // sh "docker build -t achebeh/test ."
                    // sh "docker image push achebeh/test "

                    // sh "docker compose --env-file temp_env.list up"

                    // sh "rm ${envFilePath}"

                }
                // sh 'docker compose up -d'
            }

        }
        stage("Initializing Terraform"){
            steps{
                dir('./terraform'){
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS_ID",
                        accessKeyVariable: "AWS_ACCESS_KEY_ID",
                        secretKeyVariable: "AWS_SECRET_ACCESS_KEY"
                    ]]){
                        sh 'terraform init'
                    } 
                }    
            }
        }
        stage("Staging Plan for Infrastructures Job"){
            steps{
                dir("./terraform"){
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS_ID",
                        accessKeyVariable: "AWS_ACCESS_KEY_ID",
                        secretKeyVariable: "AWS_SECRET_ACCESS_KEY"
                    ]]){
                        sh 'terraform plan -out tfplan.binary'
                        
                        archiveArtifacts artifacts: 'tfplan.binary'
                        
                    } 
                }
            }
        }
        stage("Check Financial Expense of Infrastructures Job with Infracost"){
            agent {
                docker {
                    image 'infracost/infracost:ci-latest'
                    args "--user=root --entrypoint=''"
                }
            }
            environment {
               INFRACOST_API_KEY = credentials("INFRACOST_API_KEY")
               INFRACOST_VCS_PROVIDER = 'github'
               INFRACOST_VCS_REPOSITORY_URL = 'https://github.com/Okeybukks/devops-automation'
               INFRACOST_VCS_BASE_BRANCH = 'main'
            }
            steps{
                dir("./terraform") {
                    sh 'echo "This is the financial check job"'
                    copyArtifacts filter: 'plan.json', fingerprintArtifacts: true, projectName: 'test', selector: specific ('${BUILD_NUMBER}')     
                    sh 'infracost breakdown --path . --format json --out-file infracost.json'
                    archiveArtifacts artifacts: 'infracost.json'
                    
                } 
            }
        }
        stage("Post Infracost comment"){
            agent {
                docker {
                    image 'infracost/infracost:ci-latest'
                    args "--user=root --entrypoint=''"
                }
            }
            environment {
               INFRACOST_API_KEY = credentials("INFRACOST_API_KEY")
               INFRACOST_VCS_PROVIDER = 'github'
               INFRACOST_VCS_REPOSITORY_URL = 'https://github.com/Okeybukks/devops-automation'
               INFRACOST_VCS_BASE_BRANCH = 'main'
               GITHUB_TOKEN = credentials("GITHUB_TOKEN")
               GITHUB_REPO = "Okeybukks/devops-automation"
            }
            steps{
                dir('./terraform'){
                    sh 'echo "This is the financial check job"'
                    copyArtifacts filter: 'infracost.json', fingerprintArtifacts: true, projectName: 'test', selector: specific ('${BUILD_NUMBER}')    

                    sh 'infracost comment github --path infracost.json --policy-path infracost-policy.rego \
                    --github-token $GITHUB_TOKEN --repo $GITHUB_REPO --commit $GIT_COMMIT'
                }
            }
        }
        stage("Staging Apply for Infrastructures Job"){
            steps{
                dir('./terraform'){
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS_ID",
                        accessKeyVariable: "AWS_ACCESS_KEY_ID",
                        secretKeyVariable: "AWS_SECRET_ACCESS_KEY"
                    ]]){
                        copyArtifacts filter: 'tfplan.binary', fingerprintArtifacts: true, projectName: 'test', selector: specific ('${BUILD_NUMBER}')
                        sh 'terraform apply -auto-approve tfplan.binary'
                    } 
                }    
            }
        }
        stage("Check for Destroy Infrastructure") {
            steps {
                input "Proceed with the Terraform Destroy Stage?"
            }
        }
        stage("Destroy Infrastructures Job"){
            steps{
                dir('./terraform'){
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS_ID",
                        accessKeyVariable: "AWS_ACCESS_KEY_ID",
                        secretKeyVariable: "AWS_SECRET_ACCESS_KEY"
                    ]]){
                        sh 'terraform destroy -auto-approve'
                    } 
                }    
            }

        }
    }
}

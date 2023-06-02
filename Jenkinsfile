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

                    // echo "Environment file content:\n${envFileContent}"
                    sh "cat temp_env.list"


                    // sh "docker compose --env-file temp_env.list up"

                    // sh "rm ${envFilePath}"

                }
                // sh 'docker compose up -d'
            }
        }
        stage("Staging Plan for Infrastructures Job"){
            steps{
                echo "This is the test stage for terraform staging plan"
            }
        }
        stage("Check Financial Expense of Infrastructures Job"){
            steps{
                echo "This is the financial check job"
            }
        }
        stage("Staging Apply for Infrastructures Job"){
            steps{
                echo "This is the terraform staging apply"
            }
        }
        stage("Production Plan for Infrastructures Job"){
            steps{
                echo "This is the test stage for terraform production plan"
            }
        }
        stage("Production Apply for Infrastructures Job"){
            steps{
                echo "This is the terraform production apply"
            }
        }
        stage("Destroy Infrastructures Job"){
            steps{
                echo "This is the terraform destroy job"
            }

        }
    }
}
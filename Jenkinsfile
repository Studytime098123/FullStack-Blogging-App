
pipeline {
    agent any

    environment {
        ECR_REGISTRY = '047719649994.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPO     = 'apps/boardgame'
        IMAGE_TAG    = "${BUILD_NUMBER}"
    }

    stages {
        stage('Init') {
            steps {
                echo 'Starting EKS Deployment Pipeline '
            }
        }

        stage('Clone Git Repo') {
            steps {
                echo 'Cloning GitHub repo...'
                git branch: 'main', url: 'https://github.com/Studytime098123/FullStack-Blogging-App.git'
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Building project with Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t boardgame:$IMAGE_TAG .'
            }
        }

        stage('Login to ECR') {
            steps {
                echo 'Logging into Amazon ECR...'
                sh '''
                aws ecr get-login-password --region ap-south-1 | \
                docker login --username AWS --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Tag & Push to ECR') {
            steps {
                echo 'Tagging and pushing Docker image to ECR...'
                sh '''
                docker tag boardgame:$IMAGE_TAG ${ECR_REGISTRY}/${ECR_REPO}:$IMAGE_TAG
                docker push ${ECR_REGISTRY}/${ECR_REPO}:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                echo 'Applying Kubernetes manifest...'
                sh 'kubectl apply -f dep.yaml'
            }
        }

        stage('Done') {
            steps {
                echo 'Deployment complete!'
            }
        }
    }
}

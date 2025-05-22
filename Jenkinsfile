pipeline {
    agent any

    environment {
        ECR_REGISTRY = '047719649994.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPO     = 'apps/boardgame'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        FULL_IMAGE   = "${ECR_REGISTRY}/${ECR_REPO}:${BUILD_NUMBER}"
    }

    stages {
        stage('Init') {
            steps {
                echo 'Starting EKS Deployment Pipeline'
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
                echo '🛠Building project with Maven...'
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
                docker tag boardgame:$IMAGE_TAG ${FULL_IMAGE}
                docker push ${FULL_IMAGE}
                '''
            }
        }

        stage('Apply Kubernetes Manifest') {
            steps {
                echo 'Applying base Kubernetes manifest (first-time setup only)...'
 //               sh 'kubectl apply -f dep.yaml || true'
                sh 'kubectl apply -f dep.yaml'
            }
        }

        stage('Update Image in Deployment') {
            steps {
                echo 'Updating image in Kubernetes Deployment...'
                sh '''
                kubectl set image deployment/boardgame boardgame-container=${FULL_IMAGE}
                '''
            }
        }

        stage('Done') {
            steps {
                echo 'Deployment complete!'
            }
        }
    }
}

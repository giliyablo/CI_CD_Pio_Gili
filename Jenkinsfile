pipeline {
    agent any  // Execute on any available agent

    stages {
        stage('Clean Workspace (Optional)') {
            when {
                expression { // Optional stage, uncomment to enable
                    return sh script: 'return $([ -d node_modules ] || [ -d dist ])'  // Check for existing artifacts
                }
            }
            steps {
                sh 'rm -rf node_modules dist ./*coverage*'  // Remove dependencies, built artifacts, and coverage reports
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                   credentialsId: 'your-github-credentials-id',  // Replace with your credentials ID
                   url: 'https://github.com/your-username/your-repo.git'  // Replace with your repo URL
            }
        }

        stage('Copy CI/CD Files') {
            steps {
                script {
                    // Replace 'your-angular-repo' with your actual repository directory
                    dir('your-angular-repo') {
                        // Copy files to the root of the repository
                        sh 'cp ../Dockerfile .'
                        sh 'cp ../Jenkinsfile .'
                        sh 'cp ../docker_and_node_install.yml .'
                    }
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Dev Server (Optional)') {
            when {
                expression {  // Optional stage, uncomment to enable
                    return environment == 'development'  // Run only in development environment (optional)
                }
            }
            steps {
                sh 'npm start'
            }
        }

        stage('Run E2E Tests (Optional)') {
            when {
                expression {  // Optional stage, uncomment to enable
                    return environment == 'test'  // Run only in test environment (optional)
                }
            }
            steps {
                sh 'npm run e2e'  // Replace with your E2E testing command
            }
        }

        stage('Install Docker and Node.js') {
            steps {
                script {
                    // Download and execute your Ansible playbook for Docker and Node.js installation
                    sh 'wget https://raw.githubusercontent.com/your-username/your-repo/master/docker_and_node_install.yml'  // Replace with your playbook URL
                    sh 'ansible-playbook docker_and_node_install.yml'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-angular-app .'  // Replace 'my-angular-app' with your image name
            }
        }

        stage('Deploy Docker Image (Optional)') {
            when {
                expression {  // Optional stage, uncomment to enable
                    return environment == 'production'  // Deploy only in production environment (optional)
                }
            }
            steps {
                script {
                    // Replace with your deployment script for Docker image (e.g., upload to Docker Hub)
                    // This requires additional configuration based on your deployment platform
                    // Use environment variables for sensitive information
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts '**/*.log'  // Archive logs for troubleshooting
            success {
                // Optional success notification (e.g., send email)
            }
            failure {
                // Optional failure notification (e.g., send email)
            }
        }
    }
}

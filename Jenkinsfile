pipeline {
	// Execute on any available agent: 
    agent {
		// Choosing an agent: 
		label 'ci-cd'
	}  

    stages {
        stage('Clean Workspace') {
            steps {
                script {
					// Cleaning Files from workspace: 
					cleanWs()
					
					// Cleaning docker containers: 
					sh 'docker rm -fv pio-app' 
					
					// Cleaning docker images: 
					sh 'docker rmi -f pio-app-image' 
				}
            }
        }

        stage('Checkout Code') {
            steps {
                script {
					// Checking out the Git Repository: 
					git branch: 'main',
					   credentialsId: 'GitHub_SSH_Login', 
					   url: 'git@github.com:giliyablo/Pio_Repo.git'  
				}
            }
        }

        stage('Run Tests') {
            steps {
                script {
					// Building the docker image: 
					
					sh """
						docker build -f Dockerfile.test -t pio-app-test-image:latest . 
						docker run -d -p 80:80 --name pio-app-test pio-app-test-image:latest
					"""
                }
            }
        }

        stage('Build Docker') {
            steps {
                script {
					// Building the docker image: 
					sh 'docker build -t pio-app-image:latest .' 
                }
            }
        }

        stage('Deploy Docker') {
            steps {
                script {
					// Deploying the docker image: 
					sh """
						docker run -d -p 80:80 --name pio-app pio-app-image:latest
					"""
                }
            }
        }

	}
    post {
        always {
			echo "Archive Logs!"
            // archiveArtifacts '**/*.log'  // Archive logs for troubleshooting
        }
    }
}

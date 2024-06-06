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
					sh 'docker rm -fv pio-app pio-app-test pio-app-e2e' 
					
					// Cleaning docker images: 
					sh 'docker rmi -f pio-app-image pio-app-test-image pio-app-e2e-image' 
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
						docker run -d --name pio-app-test pio-app-test-image:latest
						docker logs -f pio-app-test
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

        stage('Run E2E') {
            steps {
                script {
					// Building the docker image: 
					
					sh """
						docker build -f Dockerfile.e2e -t pio-app-e2e-image:latest . 
						docker run -d --name pio-app-e2e pio-app-e2e-image:latest
						docker logs -f pio-app-e2e
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

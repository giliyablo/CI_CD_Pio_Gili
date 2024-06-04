pipeline {
	// Execute on any available agent: 
    agent any  

    stages {
        stage('Clean Workspace') {
            steps {
                script {
					dir(workspace) {
						cleanWs()
					}
				}
            }
        }

        stage('Checkout Code') {
            steps {
                script {
					dir(workspace) {
						git branch: 'main',
						   credentialsId: 'GitHub_SSH_Login', 
						   url: 'git@github.com:giliyablo/Pio_Repo.git'  
					}
				}
            }
        }

        stage('Build Docker') {
            steps {
                script {
                    dir('Pio_Repo') {
						// bat 'wget https://github.com/giliyablo/CI_CD_Pio_Gili/blob/24307ba2ebc98c07d376c94ee89e5c00fd516cc2/Dockerfile' 
						bat 'docker build -t gili/gili-pio-app-image:latest .' 
                    }
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

pipeline {
	// Execute on any available agent: 
    agent {
		label 'ci-cd'
	}  

    stages {
        stage('Clean Workspace') {
            steps {
                script {
					cleanWs()
				}
            }
        }

        stage('Checkout Code') {
            steps {
                script {
					git branch: 'main',
					   credentialsId: 'GitHub_SSH_Login', 
					   url: 'git@github.com:giliyablo/Pio_Repo.git'  
				}
            }
        }

        stage('Build Docker') {
            steps {
                script {
					sh 'docker build -t gili/gili-pio-app-image:latest .' 
                }
            }
        }

        stage('Deploy Docker') {
            steps {
                script {
					sh """
						docker run -p 80:80 -t gili/gili-pio-app-image:latest
					"""
                } //  bash -c "cd /app && ng serve"
            }
        }

	}
    post {
        always {
			echo "Done!"
            // archiveArtifacts '**/*.log'  // Archive logs for troubleshooting
			
            // success {
            //    // Optional success notification (e.g., send email)
            //}
            //failure {
            //    // Optional failure notification (e.g., send email)
            //}
        }
    }
}

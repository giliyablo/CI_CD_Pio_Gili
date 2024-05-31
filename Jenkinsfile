pipeline {
	// Execute on any available agent: 
    agent any  

    stages {
        stage('Clean Workspace') {
            when {
                expression { 
					// Check for existing artifacts: 
                    return sh script: 'return $([ -d node_modules ] || [ -d dist ])'  
                }
            }
            steps {
				// Remove dependencies, built artifacts, and coverage reports: 
                sh 'rm -rf node_modules dist ./*coverage*'  
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

        stage('Install Dependencies') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'npm install'
                    }
                }
            }
        }

        stage('Build Project') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'ng build'
                    }
                }
            }
        }

        stage('Serve Project') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'ng serve'
                    }
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'ng test'
                    }
                }
            }
        }
 
        stage('Run E2E Tests') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'ng e2e'  
                    }
                }
            }
        }

        stage('Install Docker and Node.js') {
            steps {
                script {
                    dir('Pio_Repo') {
						// Download and execute my Ansible playbook for Docker and Node.js installation: 
						sh 'wget https://github.com/giliyablo/CI_CD_Pio_Gili/blob/1e6ac716c9089bbcf1ecdf5e69172555bae6c74e/docker_and_node_install.yml' 
						sh 'ansible-playbook docker_and_node_install.yml'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('Pio_Repo') {
						sh 'wget https://github.com/giliyablo/CI_CD_Pio_Gili/blob/24307ba2ebc98c07d376c94ee89e5c00fd516cc2/Dockerfile' 
						sh 'docker build -t Pio_Repo .' 
                    }
                }
            }
        }

        stage('Deploy Docker Image') {
			steps {
				script {
					// Check if Docker daemon is running on Jenkins master
					sh 'docker ps -q'  // Attempt to list running containers (success indicates Docker is running)
					if (shExitCode == 0) {
						echo 'Docker daemon is running. Deploying image...'
						sh 'docker tag Pio_Repo jenkins/Pio_Repo:latest'  // Tag image for local registry
						sh 'docker push jenkins/Pio_Repo:latest'  // Push image to local Docker registry
						sh 'docker run -d -p 80:80 jenkins/Pio_Repo:latest'  // Run container on port 80
					} else {
						echo 'Docker daemon is not running. Skipping deployment.'
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

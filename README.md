# CI_CD_Pio_Gili
CI_CD_Pio_Gili

1. CI/CD Workflow Explained

CI/CD (Continuous Integration and Continuous Delivery/Deployment) is an automated software development practice that streamlines the process of code changes from development to production. Here's a breakdown of the workflow:

a. Continuous Integration (CI):

Developers frequently commit their code changes to a shared version control system (VCS) like Git.
Upon each commit or merge, an automated build process is triggered.
This build process typically involves:
Fetching the latest code from the VCS.
Compiling or building the code into a deployable artifact.
Running automated tests to ensure code quality and functionality.
Feedback on the build and test results is provided to developers quickly, allowing them to identify and fix issues early.
b. Continuous Delivery/Deployment (CD):

If the automated tests in CI pass successfully, the CD pipeline takes over.
The CD pipeline automates the packaging, delivery, and deployment of the application to different environments (staging, production).
Continuous Delivery (CD): Involves automated delivery of the application to a staging environment, ready for manual deployment to production after approval.
Continuous Deployment (CD): Involves fully automated deployment of the application directly to production, typically used when high levels of confidence and stability exist.
Diagram:

+-------------------+         +-------------------+         +-----------------------+         +--------------------+
| Developer Machine |--------->| Version Control   |--------->| Build Server          |--------->| Deployment Server  |
+-------------------+         | System (e.g., Git) |--------->| (Runs build & tests) |--------->| (Packages & Delivers)|
                             +-------------------+         +-----------------------+         +--------------------+
                                                                      ^ (On successful tests)
                                                                      | (Manual approval for CD)
Benefits of CI/CD:

Faster software delivery cycles
Improved software quality
Reduced manual errors
Increased developer productivity
More efficient collaboration

2. Ansible Script for Docker Deployment

Here's an Ansible script that installs Docker and its dependencies and also Java and Git on a virtual machine:
YAML
---
---
- name: Install and configure Docker
  hosts: all
  become: true

  tasks:
    - name: Update package lists
      yum: update_cache=yes

    - name: Create directory for Docker key
      file:
        path: /etc/yum.repos.d/
        state: directory
        mode: 0755

    - name: Download Docker GPG key
      get_url:
        url: https://download.docker.com/linux/centos/gpg
        dest: /etc/yum.repos.d/docker.asc
        mode: 0644
        
    - name: Add Docker repository
      shell: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
     
    - name: Install Docker package
      yum:
        name: docker-ce
        state: latest
  
    - name: Start and enable Docker service
      service:
        name: docker
        state: started
        enabled: yes

    - name: Add user to docker group 
      user:
        name: centos
        groups: docker
        append: yes
		
    - name: Install Java
      yum:
        name: java-11-openjdk
        state: latest
  
    - name: Install Git
      yum:
        name: git
        state: latest
  
		
		
Explanation:

hosts: all: Specifies that the script should run on all hosts in the inventory.
become: true: Grants the script root privileges for package installation tasks.
The optional user task allows the current user to manage Docker without sudo. 
This requires adding your user to the docker group on the target machine.

Tasks:
	Update package lists: Ensures up-to-date package information.
	For downloading docker package properly: 
    Create directory for Docker key,
    Download Docker GPG key,
    Add Docker repository,
	Install Docker package.
	Add current user to Docker group: Allows the current user to manage Docker without sudo.
	Enable and start Docker service: Enables and starts the Docker service.
	Install Java
	Install Git
	Also installing Java and Git, as I need for the Jenkins build by using the package manager, yum, for CentOS. 

File Architecture:
An inventory file, hosts, to define the virtual machines I want to target, IP addresses or hostnames. 

Running the Script:
Run the command: ansible-playbook centos_docker_install.yml 
(From the directory containing the script and inventory file).

Example Output:
# ansible-playbook centos_docker_install.yml -i hosts

PLAY [Install and configure Docker] **********************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Update package lists] ******************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Create directory for Docker key] *******************************************************************************************
ok: [centos@18.153.72.201]

TASK [Download Docker GPG key] ***************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Add Docker repository] *****************************************************************************************************
changed: [centos@18.153.72.201]

TASK [Install Docker package] ****************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Start and enable Docker service] *******************************************************************************************
ok: [centos@18.153.72.201]

TASK [Add user to docker group] **************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Install Java] **************************************************************************************************************
ok: [centos@18.153.72.201]

TASK [Install Git] ***************************************************************************************************************
ok: [centos@18.153.72.201]

PLAY RECAP ***********************************************************************************************************************
centos@18.153.72.201       : ok=10   changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

3. Jenkinsfile for build and deploy the angular project: 
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
			echo "Done!"
            // archiveArtifacts '**/*.log'  // Archive logs for troubleshooting
        }
    }
}



4. CI/CD Flow Explanation

This CI/CD pipeline automates the process of building and deploying a Docker image for a Pio application, likely stored in a Git repository. It leverages Jenkins, a popular continuous integration and continuous delivery (CI/CD) tool. Here's a breakdown of the stages:

1. Clean Workspace

This stage ensures the workspace is clean before starting the build process.
cleanWs(): Removes any files from the previous build in the workspace.
docker rm -fv pio-app: Stops and removes any running Docker container named "pio-app" if it exists.
docker rmi -f pio-app-image: Removes any Docker image named "pio-app-image" if it exists.
2. Checkout Code

This stage retrieves the latest code from the Git repository.
git branch: 'main', credentialsId: 'GitHub_SSH_Login', url: 'git@github.com:giliyablo/Pio_Repo.git': Checks out the main branch of the Pio_Repo.git repository on GitHub using SSH authentication credentials stored under the ID "GitHub_SSH_Login."
3. Build Docker

This stage builds the Docker image for the Pio application.
docker build -t pio-app-image:latest .: Builds a Docker image using the Dockerfile located in the current directory, tags it as pio-app-image:latest, and builds it in the context of the current directory (.).
4. Deploy Docker

This stage deploys the built Docker image.
docker run -d -p 80:80 --name pio-app pio-app-image:latest: Runs a container from the pio-app-image:latest image in detached mode (-d), maps the container's port 80 to the host's port 80 (-p 80:80), and names the container pio-app. This essentially starts the Pio application within a Docker container and makes it accessible on port 80 of the host machine.
5. Post-Build Actions

The always block within the post section ensures that regardless of the pipeline's success or failure, a message is printed ("Done!").


CI/CD Flow Diagram

+-------------------+         +-------------------+         +-------------------+         +-------------------+
| Clean Workspace   |         | Checkout Code     |         | Build Docker      |         | Deploy Docker     |
+-------------------+         +-------------------+         +-------------------+         +-------------------+
     |                     |          |                     |          |                     |          |                     |
     | Clean files         |          | Git checkout        |          | Build Docker image |          | Run container      |
     | Clean Docker        | ------> | (main branch)       | ------> | (from Dockerfile) | ------> | (port 80 mapping) |
     | containers/images |          | Pio_Repo.git        |          |                     |          | (as pio-app)      |
     |                     |          |                     |          |                     |          |                     |
+-------------------+         +-------------------+         +-------------------+         +-------------------+
                                     | (Success/Failure)                     |
                                     +---------------------------------------+
                                               |
                                               | "Done!" (always)
                                               +------------------
                                                     | (Optional)
                                                     +-----------------
                                                       | Archive logs (*.log)




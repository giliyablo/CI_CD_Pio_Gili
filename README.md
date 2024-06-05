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

PLAY [all] ********************************************************************
ok=1 changed=0 unreachable=0 failed=0

TASK [Gathering Facts] *************************************************************
ok=1 changed=0 unreachable=0 failed=0

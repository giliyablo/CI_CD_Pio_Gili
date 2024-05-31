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

Here's an Ansible script that installs Docker and its dependencies and also nodeJS on a virtual machine:
YAML
---
- hosts: all
  become: true  # Grant root privileges for package installation
  tasks:
    - name: Update package lists
      apt: update_cache=yes cache_valid_time=3600  # For Debian/Ubuntu
      yum: name=* state=latest  # For RedHat/CentOS

    - name: Install Docker dependencies
      package:
        name:
          - docker.ce
          - docker-compose  # Optional for docker-compose management

    - name: Add Docker user group
      group:
        name: docker
        state: present

    - name: Add current user to Docker group (Optional)
      user:
        name: "{{ ansible_user }}"
        groups: docker
        append: yes
        state: present  # Allows managing Docker without sudo (optional)

    - name: Install Node.js and npm
      apt:
        name:
          - nodejs  # Adjust package name for other distributions
        state: present
      # For other distributions, use the appropriate package manager (e.g., yum)

    - name: Enable and start Docker service
      service:
        name: docker
        state: started
        enabled: yes

    - name: Verify Docker and Node.js installations
      debug:
        msg:
          - Docker version is {{ docker_version.version }}
          - Node.js version is {{ node_version.version }}  # Assumes 'node -v' output
      register: version_info  # Register results for verification


Explanation:

hosts: all: Specifies that the script should run on all hosts in the inventory.
become: true: Grants the script root privileges for package installation tasks.
Consider using a dedicated Ansible user with limited privileges for improved security.
The optional user task allows the current user to manage Docker without sudo. 
This requires adding your user to the docker group on the target machine.

Tasks:
	Update package lists: Ensures up-to-date package information.
Install Docker dependencies: Installs Docker and optionally docker-compose.
Add Docker user group: Creates a group named docker.
Add current user to Docker group: Allows the current user to manage Docker without sudo.
Enable and start Docker service: Enables and starts the Docker service.
Verify Docker installation: Prints the Docker version to confirm successful installation.

	Added a task to install Node.js and npm using apt for Debian/Ubuntu systems. Adjust the package name for other distributions (e.g., nodejs on Fedora).
Use the appropriate package manager for your distribution (e.g., yum for RedHat/CentOS).
Modified the verification task to display both Docker and Node.js version information.


File Architecture:
Create an inventory file (e.g., hosts) to define the virtual machines you want to target. 
The format depends on your Ansible setup, but it typically includes IP addresses or hostnames.
These files can be stored in a local directory or within your Ansible project directory on a server.

Running the Script:
Run the command: ansible-playbook docker_and_node_install.yml 
(From the directory containing the script and inventory file).

Example Output:

PLAY [all] ********************************************************************
ok=1 changed=0 unreachable=0 failed=0

TASK [Gathering Facts] *************************************************************
ok=1 changed=0 unreachable=0 failed=0

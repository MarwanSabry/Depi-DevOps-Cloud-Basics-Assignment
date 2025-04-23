# Depi-DevOps-Cloud-Basics-Assignment
## a)	CI/CD Pipeline Setup
#### •	Use a cloud-based CI service (e.g., GitHub Actions, Travis CI) to set up a pipeline that:
##### o Builds the Docker image from Assignment 2 on every code push.
##### o Runs automated tests (if applicable).
##### o Pushes the image to Docker Hub.
## Answer:-
### Jenkins Configuration
#### •	Configure Credentials: In Jenkins, go to "Manage Jenkins" then "Manage Credentials".
##### o Add a "Username with password" credential for Docker Hub (Docker Hub username and password). Give it an ID (dockerhub-credentials).
##### o Add an "AWS Credentials" credential for the IAM user's Access Key ID and Secret Access Key. Give it an ID (aws-credentials).

![006](https://github.com/user-attachments/assets/40b02f4b-f316-4aaa-b274-1824214b5533)

#### •	Create a New Pipeline Job:
##### o Click "New Item".
##### o Enter an item name (my-nginx-webapp-ci-cd).
##### o Select "Pipeline".
##### o Click "OK".

![007](https://github.com/user-attachments/assets/a04d2339-3738-4241-8778-b2a79cc1bade)

#### •	Configure the Pipeline Job:
##### o In the "General" section, you can add a description.
##### o In the "Build Triggers" section, configure SCM webhook (GitHub hook trigger for GITScm polling).
##### o Also need to configure the webhook in the Git repository's settings to point to the Jenkins URL.
##### o In the "Pipeline" section, select "Pipeline script from SCM".
##### o Set "SCM" to "Git".
##### o Enter the Git Repository URL.
##### o Specify the "Branches to build" (*/main).
##### o Set "Script Path" to Jenkinsfile.
---
## b)	Cloud Deployment
#### •	Deploy the Docker image to a cloud platform (e.g., AWS Elastic Beanstalk, Google Cloud Run, or Azure App Services).
#### •	Verify that the application is accessible online, and document the steps you followed.
## Answer:-
### AWS Configuration
#### •	Create an Elastic Beanstalk Application:
##### o Go to the Elastic Beanstalk console.
##### o Click "Create a new application".
##### o Give it a name (ElasticBeanstalkApplication).
#### •	Create an Elastic Beanstalk Environment:
##### o Within the application, click "Create a new environment".
##### o Choose "Web server environment".
##### o Select "Docker" as the Platform.
##### o Choose "Managed platform" and the latest recommended Docker version.
##### o For "Application code", select "Sample application".
##### o Click "Configure more options".
#### •	Configure the Environment Details:
##### o Environment Name: Give it a name (ElasticBeanstalkEnvironment).
##### o Instances: Choose instance types (t2.micro).
##### o Load Balancer: Choose a load balancer (Application Load Balancer).
##### o Security Group: Configure the Security Groups.
##### o Network: Configure VPC, subnets (with public subnets).
#### •	Review and Launch: Review the configuration and launch the environment.
#### •	Verification: After the Jenkins pipeline successfully runs the "Deploy to Elastic Beanstalk" stage, go to the Elastic Beanstalk environment's URL. You should see the "Hello from my DEPI Web" page served by Nginx.
---
## c)	Security in the Cloud:
#### •	Implement security best practices by ensuring that:
##### o Your deployment uses HTTPS.
##### o You have a firewall that restricts access to only essential ports and IP addresses.
## Answer:-
### Implementation (AWS Elastic Beanstalk):
#### •	Ensure the Elastic Beanstalk environment is configured to use a Load Balancer (Application Load Balancer).
#### •	Import an SSL Certificate using AWS Certificate Manager (ACM) for the domain name you will use to access your application.
#### •	Configure the Load Balancer Listener in the Elastic Beanstalk environment settings:
##### o Modify the listener on Port 443 (HTTPS).
##### o Associate the ACM certificate with this listener.
##### o Configure the listener action to Forward traffic to the target group associated with the Elastic Beanstalk instances on their Container Port 8080.
### Verification: Access the application using https://the-eb-environment-url.com.
### Using a firewall to restricts access to only essential ports and IP addresses:
#### •	Implementation (AWS Security Groups): Elastic Beanstalk creates and manages Security Groups.
#### •	Load Balancer Security Group: This Security Group is associated with the ALB.
##### o Inbound Rules: Allow traffic on Port 443 (HTTPS) from the internet (Source: 0.0.0.0/0 for IPv4 and ::/0 for IPv6).
##### o Outbound Rules: Allows all outbound traffic.
#### •	EC2 Instance Security Group: This Security Group is associated with the EC2 instances running the Docker container.
##### o Inbound Rules:
##### - Allow traffic on your Container Port (8080).
##### - Restrict the source of this traffic only to the Load Balancer Security Group. This ensures that only the load balancer can send traffic to the application on port 8080, blocking direct internet access to the instances on this port.
##### o Outbound Rules: Configure based on the application's needs (e.g., allow outbound to Port 443 for external traffic).
### Verification: Use tools like telnet from external networks to confirm that ports other than 443 are not accessible.

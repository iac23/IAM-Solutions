# IAM-Solutions
IAM infrastructure using Terraform

### Project Overview: Automating IAM Identity Center with Terraform

Welcome to my project! I built a complete Infrastructure as Code (IaC) solution to manage users, groups, and permissions in **AWS IAM Identity Center** (formerly AWS SSO) using **Terraform**. My goal was to create a scalable, secure, and fully automated system for a growing company, StartUp.co, so we could move away from manual configurations in the AWS console for good.

This project serves as a powerful template for any organization looking to standardize its AWS access management and enforce a "single source of truth" for identity. It's all built from dynamic variables, which means we can easily scale the solution by just updating a file.

***

### The Step-by-Step Process 🛠️

Here is a breakdown of how this solution was built from the ground up:

#### 1. Project Initialization and Setup
We started by setting up the project with a clean directory structure. The most critical first step was configuring a **remote state backend** using an S3 bucket. This ensures that the Terraform state file—which tracks the deployed infrastructure—is stored securely and can be used for team collaboration.

#### 2. Dynamic Variable Definition
Instead of hardcoding values, I defined all users, groups, and permissions in a `variables.tf` file. This allows for a completely dynamic and reusable template. To add new employees or modify permissions, I only need to update these variables, not the core resource logic.

#### 3. User and Group Management
Using a `for_each` loop, Terraform was instructed to read the list of users and groups from our variables and automatically create them in IAM Identity Center. A separate resource then handled the assignment of each user to their designated group. This is the foundation of our organizational structure.

#### 4. Permission Set Creation and Policy Attachment
Next, all the necessary **Permission Sets** were created dynamically, again using a `for_each` loop. This was followed by a more complex step: attaching multiple AWS managed policies to each permission set. An advanced `for` expression was used here to handle the one-to-many relationship, ensuring each permission set has the correct level of access.

#### 5. Final Account Assignment
The final piece of the puzzle was to assign these newly created permission sets to their corresponding groups within a target AWS account. This step completed the entire workflow, granting the right people the right permissions in the right account.

***

### The Bigger Picture: Why This Matters 📈

Building this solution was a huge learning experience, but the real win is the business value it delivers. This project is a prime example of how IaC impacts more than just the technical team.

* **Scalability:** We now have a **reusable template** that allows StartUp.co to grow its team and infrastructure without the operational headache. Onboarding a new team is as simple as updating a variable file.
* **Security:** By using code, we created a **single source of truth** for all access controls. This eliminates human error and "configuration drift," making our environment far more secure and auditable than a manual setup.
* **Maintainability:** Managing the IAM structure is now effortless. Updating permissions or adding a new group is done with a few simple code changes, freeing up valuable time for more strategic work.

***

### Documents & Tools Used

**Tools:**
* **Terraform:** Our IaC tool of choice.
* **AWS CLI:** Used for authentication with AWS IAM Identity Center via `aws sso configure`.
* **Visual Studio Code:** The primary code editor for writing and managing Terraform files.
* **Git & GitHub:** Used for version control and collaborating on the project.

**Documents:**
* **Terraform Registry:** The official documentation for the Terraform AWS provider and its resources.
* **AWS Documentation:** The official source for all AWS Identity Center and IAM policies.

***

### Let's Connect 🤝

* **LinkedIn:** [https://www.linkedin.com/in/dehan-bekker]
* **Medium Blog:** [https://medium.com/@dehanbekker23]
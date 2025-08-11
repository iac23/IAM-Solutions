# Region that the variable is created in

    variable "aws_region" {
        description = "AWS region"
        type = string
        default = "us-east-1"
}

# Avoid having AWS Account ID hardcoded into IaC

variable "aws_account_id" {
  description = "675769453941"
  type        = string
  default     = "675769453941"
}

# Variable for Group names

    variable "group_names" {
        description = "List of IAM Identity Center Group names to create"
        type = list(string)
        default = ["Operations" ,"Developers" ,"Finance Management" ,"Data Analysts" ]
    }

# Variable for Permission sets for each group

    variable "permission_sets" {
        description = "List of IAM Identity Center Permission sets"
        type = list(string)
        default = ["Data-Analysts" ,"Developers" ,"Finance-Management" ,"Operations" ]
    }

# Variable for Attached policies for each permission sets

    variable "permission_set_policies" {
        description = "Map of permission set names to lists of AWS managed policy ARNs to attach"
        type = map(list(string))

        default = {
            "Data-Analysts" = [
            "arn:aws:iam::aws:policy/ReadOnlyAccess" 
            ],
            "Developers" = [
            "arn:aws:iam::aws:policy/PowerUserAccess"
            ],
            "Finance-Management" = [
            "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
            ],
            "Operations" = [
            "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
            ]
    }
}

# Variable for Permission set being attached to specific Groups
    
    variable "permission_set_group_attachment" {
        description = "Map of Groups and the permission set it requires"
        type = map(string)

            default = {
                "Operations" = "Operations"
                "Developers" = "Developers"
                "Data Analysts" = "Data-Analysts"
                "Finance Management" = "Finance-Management"
    }
}

# Variable for User names

    variable "user_names" {
        description = "Map of user details, keyed by username"
        type = map(object({
            display_name = string
            given_name = string
            family_name = string
            email = string
            group_names = string
        }))
        default = {
            john_doe = {        # <- The name defined here is the KEY
            display_name = "John Doe"
            given_name = "John"       # <- These are the three values inside the OBJECT
            family_name = "Doe"
            email = "john.doe@example.com"
            group_names = "Developers"
            },

            sally_may = {
                display_name = "Sally May"
                given_name = "Sally"
                family_name = "May"
                email = "sally.may@example.com"
                group_names = "Operations"
            },

            jim_evans = {       # Key Value
                display_name = "Jim Evans"
                given_name = "Jim"
                family_name = "Evans"       
                email = "jim.evans@example.com"
                group_names = "Finance Management"
            },

            ian_bekker = {
                display_name = "Ian Bekker"
                given_name = "Ian"
                family_name = "Bekker"
                email = "iacbekker23@gmail.com"
                group_names = "Data Analysts"
            },
        }
    }
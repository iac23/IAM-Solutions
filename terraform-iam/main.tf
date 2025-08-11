terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "s3"    {
        bucket = "db-tf-state-bucket-management"    # new bucket name for management account
        key = "env/dev/terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        use_lockfile = true
        }
    }

# The default provider is authenticated to the Management account
    provider "aws" {
        region = "us-east-1"   # made sure it references the variable region
    }

# ARN of IAM Identity Center Instance (Still uses the default provider)
data "aws_ssoadmin_instances" "default_sso" {
}

# IAM Identity Center Groups (This will use the management provider to create resources)

resource "aws_identitystore_group" "all_groups" {

  for_each = toset(var.group_names) # iterate over all group names defined in var.tf

  display_name      = each.value    # The display name for each group will be the actual string value from the list
  identity_store_id = tolist(data.aws_ssoadmin_instances.default_sso.identity_store_ids)[0]
}

# IAM Identity Center Users

resource "aws_identitystore_user" "all_users" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.default_sso.identity_store_ids)[0]

    for_each = var.user_names   # iterate over all user names defined in var.tf

    user_name = each.key    # Use the value directly
    display_name = each.value.display_name

    name    {
        given_name = each.value.given_name     # The display name for each user will be the string value from the list    
        family_name = each.value.family_name
    }

    emails {     # Needs to be inside own block according to AWS documentation
        value = each.value.email
    } 
}

# Assigning Users to Groups

resource "aws_identitystore_group_membership" "group_members" {     # second string is the name you assign the resource 
  identity_store_id = tolist(data.aws_ssoadmin_instances.default_sso.identity_store_ids)[0]

    for_each = var.user_names      # Reference the users, since we are creating memberships for users to groups

  group_id          = aws_identitystore_group.all_groups[each.value.group_names].group_id     # each.value.group_names is the for_each variable loop type used for group names
  member_id         = aws_identitystore_user.all_users[each.key].user_id     # user_name = each.key is the for-each loop variable type to reference users
}

# Output blocks for debugging previous issue

output "group_map_keys" {
  value = keys(aws_identitystore_group.all_groups)
}

output "user_group_names" {
  value = values(var.user_names)[*].group_names
}


# Permission Set Shell for Identity Center

resource "aws_ssoadmin_permission_set" "permission_sets" {

  for_each = toset(var.permission_sets)

  name             = each.value
  instance_arn     = tolist(data.aws_ssoadmin_instances.default_sso.arns)[0]
}

# Permission Set with AWS Managed Policies Attached to it

resource "aws_ssoadmin_managed_policy_attachment" "permission_set_policies" {

 for_each = {
  for combo in flatten([
    for set_name, policies in var.permission_set_policies : [
      for policy in policies : {
        key        = "${set_name}-${policy}"
        set_name   = set_name
        policy     = policy
      }
    ]
  ]) : combo.key => combo
}

  instance_arn       = tolist(data.aws_ssoadmin_instances.default_sso.arns)[0]  # Make sure to correcly reference the instance in whicb you create the resource
  managed_policy_arn = each.value.policy
  permission_set_arn = aws_ssoadmin_permission_set.permission_sets[each.value.set_name].arn
}

# Assigning Permission sets to Groups

resource "aws_ssoadmin_account_assignment" "permission_set_group_attachment" {

  for_each = var.permission_set_group_attachment

  instance_arn       = tolist(data.aws_ssoadmin_instances.default_sso.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_sets[each.value].arn

  principal_id   = aws_identitystore_group.all_groups[each.key].group_id
  principal_type = "GROUP"

  target_id   = var.aws_account_id
  target_type = "AWS_ACCOUNT"
}
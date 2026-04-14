###################################
## IAM Role for EKS Worker Nodes ##
###################################

resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#################################################
## Attach Policies to the EKS Worker Node Role ##
#################################################

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

#########################################################
## Attach Additional Policies for EKS Worker Nodes #####
#########################################################

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

####################################################################
#### Attach Additional Policies for EKS Worker Nodes (Optional) ####
####################################################################

resource "aws_iam_role_policy_attachment" "registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

##################################################
## Output the IAM Role ARN for EKS Worker Nodes ##
##################################################

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

##################################################
## Output the IAM Role ARN for EKS Worker Nodes ##
##################################################
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

#############################################
## IAM Role for EKS Service Account (IRSA) ##
#############################################

resource "aws_iam_role" "irsa_role" {
  name = "${var.cluster_name}-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
      }
      Action = "sts:AssumeRoleWithWebIdentity"
    }]
  })
}

################################################
## IAM Policy for EKS Service Account (IRSA) ###
################################################

resource "aws_iam_role_policy_attachment" "irsa_attach" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.irsa_policy.arn
}

###########################################################################
## Define a Custom IAM Policy for EKS Service Account for GitHub Actions ##
###########################################################################

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

###########################################################################
## Define a Custom IAM Policy for EKS Service Account for GitHub Actions ##
###########################################################################

resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:harish4bvk/*"
        }
      }
    }]
  })
}

##################################################################
### Attach Administrator Access Policy to GitHub Actions Role  ###
##################################################################   

resource "aws_iam_role_policy_attachment" "github_admin" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}



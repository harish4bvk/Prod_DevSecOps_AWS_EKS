output "node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "github_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

output "irsa_role_arn" {
  value = aws_iam_role.irsa_role.arn
}
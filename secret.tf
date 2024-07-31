// It can be left empty if we don't want to use external repository
resource "aws_ssm_parameter" "git_http_auth" {
  name  = "/git-diff/git-http-auth"
  type  = "SecureString"
  value = "-"
  lifecycle { ignore_changes = [value] }
}

output "git_http_auth_name" {
  value = aws_ssm_parameter.git_http_auth.name
}

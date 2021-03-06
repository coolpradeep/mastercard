output "asg_id" {
  description = "The description of the asg"
  value       = aws_autoscaling_group.masterasg.id
}
resource "aws_security_group" "public_lb_secgroup" {
  vpc_id = module.vpc.vpc_id

  name_prefix = "${local.system_name}-public-lb-sg"
  description = "${local.system_name}-public-lb-sg"

  tags = merge(
    local.commontags,
    {
      "Name" = "${local.system_name}-public-lb-sg"
    }
  )
}

# SecGroup rule from the Internet to the public AWS LB 
resource "aws_security_group_rule" "public_lb_secggroup-ingress-rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.public_lb_secgroup.id
  cidr_blocks       = var.public-lb-secgroup-ipv4cidrs
  ipv6_cidr_blocks  = var.public-lb-secgroup-ipv6cidrs
  description       = "Ingress CIDRS allowed in the public AWS LB"
}

# SecGroup rule from the public AWS LB to the EKS nodes in the private subnets 
resource "aws_security_group_rule" "public_lb_secggroup-egress-rule" {
  type              = "egress"
  from_port         = 30000
  to_port           = 32768
  protocol          = "TCP"
  security_group_id = aws_security_group.public_lb_secgroup.id
  cidr_blocks       = module.vpc.private_subnets_cidr_blocks
  description       = "Egress from AWS LB to EKS nodes"
}

resource "aws_ssm_parameter" "public_lb_secgroup_parameter" {
  name        = "/${local.system_name}/public-lb-secgroup-id"
  description = "ParameterStore param with the SecGroup ID that will be attached to the public AWS LB"
  type        = "String"
  value       = aws_security_group.public_lb_secgroup.id
  depends_on  = [aws_security_group.public_lb_secgroup]
}
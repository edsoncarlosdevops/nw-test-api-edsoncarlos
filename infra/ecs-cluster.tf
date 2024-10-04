resource "aws_ecs_cluster" "ECS" {
  name = "cluster-nw-test-api-edsoncarlos"

  tags = {
    Name = "my-new-cluster"
  }
} 
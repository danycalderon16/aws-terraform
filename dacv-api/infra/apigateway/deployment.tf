resource "aws_api_gateway_deployment" "this" { 
    rest_api_id = aws_api_gateway_rest_api.this.id

    triggers = {
      redeploy = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name = "prod"
}
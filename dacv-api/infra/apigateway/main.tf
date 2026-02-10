resource "aws_api_gateway_rest_api" "this" {
  name = "dacv-rest-api"
  description = "REST API dacv-template"

    endpoint_configuration {
      types = [ "REGIONAL" ]
    }

  body = templatefile("${path.module}/openapi.yaml", {
    region = var.aws_region
    lambda_arn = aws_lambda_function.this.arn
  })
}

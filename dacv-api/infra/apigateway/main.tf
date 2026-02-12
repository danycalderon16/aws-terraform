resource "aws_api_gateway_rest_api" "this" {
  name = var.api_title
  description = "REST API template"

    endpoint_configuration {
      types = [ "REGIONAL" ]
    }

  body = templatefile("${path.module}/openapi.yaml", {
    region = var.aws_region
    lambda_arn = var.lambda_arn
    api_title = var.api_title
  })
}

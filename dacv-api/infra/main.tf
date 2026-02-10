module "apigateway" {
    source = "./apigateway"
    aws_region = var.aws_region  
}

module "lambda" {
    source = "./lambda"
    apigateway_execution_arn = module.apigateway.execution_arn
}
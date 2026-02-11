module "iam" {
    source = "./iam"
}

module "layer" {
    source = "./layer"
}

module "lambda" {
    source = "./lambda"
    apigateway_execution_arn = module.apigateway.execution_arn
    iam_role_arn = module.iam.iam_role_arn
    layer_arn = module.layer.layer_arn
}

module "apigateway" {
    source = "./apigateway"
    aws_region = var.aws_region
    lambda_arn = module.lambda.lambda_arn
}

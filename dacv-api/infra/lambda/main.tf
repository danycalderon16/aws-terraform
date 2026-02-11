resource "aws_lambda_function" "fastapi" {
  function_name = "fastapi-api"
  runtime       = "python3.11"
  handler       = "main.handler"
  role          = var.iam_role_arn

  filename = "${path.module}/../artifacts/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../artifacts/lambda.zip")

    layers = [
        var.layer_arn
    ]

  timeout = 30
  memory_size = 512

}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowApiGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fastapi.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${var.apigateway_execution_arn}/*/*"
}
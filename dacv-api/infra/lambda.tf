resource "aws_lambda_function" "fastapi" {
  function_name = "fastapi-api"
  runtime       = "python3.11"
  handler       = "main.handler"
  role          = aws_iam_role.lambda_role.arn

  filename = "${path.module}/artifacts/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/artifacts/lambda.zip")

    layers = [
        aws_lambda_layer_version.dependencies.arn
    ]

  timeout = 30
  memory_size = 512

}

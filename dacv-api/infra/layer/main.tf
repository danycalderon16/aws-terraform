resource "aws_lambda_layer_version" "dependencies" {
  layer_name = "fastapi-deps"

  filename = "${path.module}/../artifacts/fastapi-layer.zip"
  source_code_hash = filebase64sha256("${path.module}/../artifacts/fastapi-layer.zip")

  compatible_runtimes = ["python3.11"]
}
resource "aws_api_gateway_rest_api" "urlite" {
  name = local.urlite_domain
  description = "API Gateway entrypoint for urlite.cc"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  minimum_compression_size = 10000
  tags = {
    Terraform: true
  }
}

resource "aws_api_gateway_stage" "production" {
  deployment_id = aws_api_gateway_deployment.production.id
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  stage_name = "production"
}

resource "aws_api_gateway_deployment" "production" {
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  description = "Deployment"
  depends_on = [
    aws_api_gateway_integration.redirect_to_website,
    aws_api_gateway_integration_response.redirect_to_website
  ]
}

resource "aws_api_gateway_method" "get_website" {
  authorization = "NONE"
  http_method = "GET"
  resource_id = aws_api_gateway_rest_api.urlite.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  api_key_required = false
}

resource "aws_api_gateway_integration" "redirect_to_website" {
  http_method = aws_api_gateway_method.get_website.http_method
  resource_id = aws_api_gateway_rest_api.urlite.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  type = "MOCK"
}

resource "aws_api_gateway_integration_response" "redirect_to_website" {
  http_method = aws_api_gateway_method.get_website.http_method
  resource_id = aws_api_gateway_rest_api.urlite.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  status_code = aws_api_gateway_method_response.redirect_to_website.status_code

  response_templates = {
    "text/plain": <<EOF

#set($context.responseOverride.header.location = "https://www.urlite.cc/")
EOF
  }
}

resource "aws_api_gateway_method_response" "redirect_to_website" {
  http_method = aws_api_gateway_method.get_website.http_method
  resource_id = aws_api_gateway_rest_api.urlite.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.urlite.id
  status_code = "301"
}

output "apigateway_url" {
  value = aws_api_gateway_stage.production.invoke_url
}

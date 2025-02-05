provider "aws" {
  region = "us-east-1"
}

import {
  to = aws_instance.web
  id = "i-0d1e317e9fd93db12"
}


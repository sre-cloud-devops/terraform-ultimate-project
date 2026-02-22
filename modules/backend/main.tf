provider "aws" {
    region = "us-east-1"
  
}


resource "aws_s3_bucket" "bucket_statefile" {
  bucket = "cloud-devops-terraform-statefile-bucket"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket_statefile
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket_statefile
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_example" {
  bucket = aws_s3_bucket.bucket_statefile

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# resource "aws_dynamodb_table" "dyanmodb_statelock" {
#   name             = "example"
#   hash_key         = "LockID"
#   billing_mode     = "PAY_PER_REQUEST"
#   stream_enabled   = true
#   stream_view_type = "NEW_AND_OLD_IMAGES"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

# }



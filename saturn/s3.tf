resource "aws_s3_bucket" "tf-s3" {
  bucket = "s3-tfstate-6969"
  acl    = "private"
#  region = "us-east-1"
   force_destroy = true

  tags = {
    Name        = "tfstate-bucket"
    Environment = "Dev"
  }
}
# resource "aws_dynamodb_table" "tf-state-lock" {
#   name           = "dynamodb-tfstate-lock"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "LockID"
 
#    attribute {
#     name = "LockID"
#     type = "S"
#   }
# }


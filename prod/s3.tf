resource "aws_s3_bucket" "example" {
  bucket = "my-tf-digitify-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
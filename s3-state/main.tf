resource "aws_kms_key" "kms_prod_enc_key" {
  description         = "KMS key for S3 Encryption at rest"
  enable_key_rotation = true

}

resource "aws_kms_key" "kms_s3_loggin_enc_key" {
  description         = "KMS key for S3 Encryption at rest"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "s3_terraform_state_storage" {
  bucket = "${var.project_name}-terraform-state"
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_s3_terraform_state_storage" {
  bucket = aws_s3_bucket.s3_terraform_state_storage.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_prod_enc_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


resource "aws_s3_bucket_logging" "s3_logging_bucket" {
  bucket = aws_s3_bucket.s3_logging_bucket.id

  target_bucket = aws_s3_bucket.s3_logging_bucket.id
  target_prefix = "tfstate/"
}

resource "aws_s3_bucket_versioning" "state_bucket_versioning" {
  bucket = aws_s3_bucket.s3_terraform_state_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_terraform_state_public_access_block" {
  bucket = aws_s3_bucket.s3_terraform_state_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# logging bucket

resource "aws_s3_bucket" "s3_logging_bucket" {
  bucket = "${var.project_name}-state-logging-bucket"
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_s3_logging_bucket" {
  bucket = aws_s3_bucket.s3_logging_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_s3_loggin_enc_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "logging_bucket_acl" {
  bucket = aws_s3_bucket.s3_logging_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_logging_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "logging_bucket_versioning" {
  bucket = aws_s3_bucket.s3_logging_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_logging_public_access_block" {
  bucket = aws_s3_bucket.s3_logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Dynamo DB configurations


resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "${var.project_name}-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.kms_prod_enc_key.arn
  }
}

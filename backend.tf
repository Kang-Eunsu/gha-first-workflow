variable "region" {
    default = "ap-northeast-2"
}

data "aws_s3_bucket" "example" {
  bucket = "testbucketforskkuding" # give a unique bucket name
}


resource "aws_s3_bucket_website_configuration" "s3" {
    bucket = aws_s3_bucket.example.id 

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }

    routing_rule {
        condition {
            key_prefix_equals = "/"
        }
        redirect {
            replace_key_prefix_with = "/"
        }
    }   
  
}

# s3 static website url

output "website_url" {
    value = aws_s3_bucket_website_configuration.s3.website_endpoint
}

variable "s3_bucket_name" {
    default = "testbucketforskkuding"
}

data "aws_iam_policy_document" "example" {
    statement {
        sid = "PublicReadGetObject"

        actions = [
            "s3:GetObject"
        ]
        resources = [
            "arn:aws:s3:::${var.s3_bucket_name}"
        ]
        condition {
            test     = "StringLike"
            variable = "s3:prefix"

            values = [
                "",
            ]
        }
    }
  
}

resource "aws_iam_policy" "example" {
  name   = "example_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_example_bucket_policy_data.json
}

data "aws_iam_policy_document" "s3_example_bucket_policy_data"{
    
    statement {
        sid = "1"

        actions = ["s3:GetObject"]
        effect =  "Allow"
        resources = [
            "arn:aws:s3:::${var.s3_bucket_name}",
            "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
        principals {
            type = "*"
            identifiers = ["*"]
        }
    }
}

resource "aws_s3_bucket_policy" "s3_example_policy" {
    bucket = aws_s3_bucket.example.id
    policy = data.aws_iam_policy_document.s3_example_bucket_policy_data.json
}



resource "aws_s3_bucket_public_access_block" "example" {
    bucket = aws_s3_bucket.example.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false 
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name_prefix}-${var.data_bucket_name}${local.name_suffix}"
  acl    = "private"
  tags   = "${local.common_tags}"
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.name_prefix}-firehose_test_role${local.name_suffix}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose_role_policy" {
  name = "${var.name_prefix}-firehose_role_policy${local.name_suffix}"
  role = "${aws_iam_role.firehose_role.id}"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "",
           "Effect": "Allow",
           "Action": [
               "s3:AbortMultipartUpload",
               "s3:GetBucketLocation",
               "s3:GetObject",
               "s3:ListBucket",
               "s3:ListBucketMultipartUploads",
               "s3:PutObject"
           ],
           "Resource": [
               "${aws_s3_bucket.bucket.arn}",
               "${aws_s3_bucket.bucket.arn}/*"
           ]
       },
       {
            "Sid": "AllowListCloudWatchLogGroups",
            "Effect": "Allow",
            "Action": "logs:DescribeLogStreams",
            "Resource": "arn:aws:logs:${var.region}:*:*"
        },
        {
            "Sid": "AllowCreatePutLogGroupsStreams",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${var.region}:*:log-group:/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.test_stream.name}",
                "arn:aws:logs:${var.region}:*:log-group:/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.test_stream.name}:log-stream:*"
            ]
        }
   ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "test_stream" {
  name        = "${var.name_prefix}-hab-stream${local.name_suffix}"
  destination = "s3"

  s3_configuration {
    role_arn   = "${aws_iam_role.firehose_role.arn}"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
  }

  tags   = "${local.common_tags}"
}

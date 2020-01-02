resource "aws_key_pair" "example-instance-key" {
    key_name = "example-instance-key-1"
    public_key = file("${var.key_file_path}")
}

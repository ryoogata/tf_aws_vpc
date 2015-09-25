# VPC の作成
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_block}"

  tags {
    Name = "${var.tag}"
  }
}

# Zone 1a に subnet を作成
resource "aws_subnet" "subnet1a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_1a}"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag}"
  }
}

# internet gateway の作成
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag}"
  }
}

# routing table の作成
resource "aws_route_table" "routing" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.tag}"
  }
}

# zone 1a の subnet に routing table を適用
resource "aws_route_table_association" "subnet1a" {
  subnet_id = "${aws_subnet.subnet1a.id}"
  route_table_id = "${aws_route_table.routing.id}"
}

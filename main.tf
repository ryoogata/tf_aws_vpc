# VPC $B$N:n@.(B
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_block}"

  tags {
    Name = "${var.tag}"
  }
}

# Zone 1a $B$K(B subnet $B$r:n@.(B
resource "aws_subnet" "subnet1a" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.vpc_subnet_1a}"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag}"
  }
}

# internet gateway $B$N:n@.(B
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.tag}"
  }
}

# routing table $B$N:n@.(B
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

# zone 1a $B$N(B subnet $B$K(B routing table $B$rE,MQ(B
resource "aws_route_table_association" "subnet1a" {
  subnet_id = "${aws_subnet.subnet1a.id}"
  route_table_id = "${aws_route_table.routing.id}"
}

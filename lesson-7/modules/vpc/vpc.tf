# lesson-7/modules/vpc/vpc.tf

# Створюємо основну VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block   # CIDR блок для нашої VPC (наприклад, 10.0.0.0/16)
  enable_dns_support   = true                 # Вмикає підтримку DNS у VPC
  enable_dns_hostnames = true                 # Вмикає можливість використання DNS-імен для ресурсів у VPC

  tags = {
    Name = "${var.vpc_name}-vpc"              # Додаємо тег, який включає ім'я VPC
  }
}

# Створюємо публічні підмережі
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)   # Створюємо кілька підмереж, кількість визначена довжиною списку public_subnets
  vpc_id                  = aws_vpc.main.id              # Прив'язуємо кожну підмережу до VPC, створеної раніше
  cidr_block              = var.public_subnets[count.index] # CIDR-блок для конкретної підмережі зі списку public_subnets
  availability_zone       = var.availability_zones[count.index] # Визначаємо зони доступності для кожної підмережі
  map_public_ip_on_launch = true                         # Автоматично надає публічні IP-адреси інстансам у підмережі

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"  # Тег з нумерацією підмережі
    # count.index — це індекс циклу "count", який починається з 0.
    # ${count.index + 1} додає +1 до індексу, щоб отримати людське позначення (1, 2, 3 замість 0, 1, 2).
  }
}

# Створюємо приватні підмережі
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)   # Створюємо кілька приватних підмереж, кількість відповідає довжині списку private_subnets
  vpc_id            = aws_vpc.main.id               # Прив'язуємо кожну приватну підмережу до VPC
  cidr_block        = var.private_subnets[count.index] # CIDR-блок для конкретної підмережі зі списку private_subnets
  availability_zone = var.availability_zones[count.index] # Визначаємо зони доступності для підмереж

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"  # Тег для підмережі з нумерацією
    # ${count.index + 1} використовується, щоб нумерація підмереж починалася з 1.
  }
}

# Створюємо Internet Gateway для публічних підмереж
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id   # Прив'язуємо Internet Gateway до VPC для виходу в інтернет

  tags = {
    Name = "${var.vpc_name}-igw"   # Тег для ідентифікації Internet Gateway
  }
}

# -- continue depends of homework --

# Elastic IP for NAT GW

resource "aws_eip" "nat" {
  # vpc = true - застарілий, тому прибраний, але для розуміння залишений та закоментований
  tags = {
    Name = "${var.vpc_name}-nat-eip"   # Тег для ідентифікації Elastic IP для NAT Gateway
  }

  lifecycle {
    prevent_destroy = false # додано для контролю видалення  ElasticIP
  }

}

# nat gateway first public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id   # Використовуємо Elastic IP для NAT Gateway
  subnet_id     = aws_subnet.public[0].id  # Розміщуємо NAT Gateway в першій публічній підмережі

  tags = {
    Name = "${var.vpc_name}-nat-gateway"   # Тег для ідентифікації NAT Gateway
  }

  depends_on = [ aws_internet_gateway.igw ]
}

# way table fo private subnet

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags =  {
    Name = "${var.vpc_name}-private-rt"
  }  
}

# way using NAT GateWay

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id  # Прив'язуємо маршрут до приватної таблиці маршрутів
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# bind private subnet to private table

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)   # Створюємо асоціацію для кожної приватної підмережі
  subnet_id      = aws_subnet.private[count.index].id  # Прив'язуємо кожну приватну підмережу до таблиці маршрутів
  route_table_id = aws_route_table.private.id    # Вказуємо таблицю маршрутів для асоціації
  
}
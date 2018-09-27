provider "aws"{
    region="${var.aws_region}"
    access_key="${var.access_key}"
    secret_key="${var.secret_key}"
}
 
resource "aws_security_group" "default"{
    name="Sesn-sgu"
    description="Created for sesnu installation"
 
    ingress{
        from_port = 22
        to_port = 22
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress{
        from_port = 2380
        to_port = 2380
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress{
        from_port = 3000
        to_port = 3000
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress{
        from_port = 8080
        to_port = 8080
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress{
        from_port = 8081
        to_port = 8081
        protocol= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
}
resource "aws_instance" "Sensu_docker"{
 
    connection={
        user="ec2-user"
        private_key = "${file(var.key_path)}"
    }
	
	
    instance_type="t2.micro"
    ami="${lookup(var.aws_amis, var.aws_region)}"
    key_name = "${var.key_name}"
    security_groups= ["${aws_security_group.default.name}"]
    tags{
        Name="Terraform-EC2"
    }

}

provisioner "remote-exec" {
        inline = [
            "sudo yum install -y docker",
            "sudo service docker start",
            "docker pull sensuapp/sensu-go",
            "docker run -v /var/lib/sensu:/var/lib/sensu -d --name sensu-backend -p 2380:2380 -p 3000:3000 -p 8080:8080 -p 8081:8081 sensuapp/sensu-go:2.0.0-alpha sensu-backend start"
            
        ]
    }
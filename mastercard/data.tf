data "template_file" "userdata" {

  template = file("${path.module}/userdata.sh")
}
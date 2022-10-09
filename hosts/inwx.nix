{ config, lib, pkgs, ... }:
{
  terraform.required_providers.inwx = {
    source = "example.com/myorg/inwx";
    version = "0.1";
  };

  data.sops_file.inwx = {
    source_file = "inwx_secrets.yaml";
  };
  
  provider.inwx = {
    username = ''''${data.sops_file.inwx.data["inwx.username"]}'';
    password = ''''${data.sops_file.inwx.data["inwx.password"]}'';
  };

  resource.inwx_record.mumble = {
    domain = "pek.mk";
    name = "voice";
    type = "A";
    value = "90.147.188.89";
    ttl = 300;
    priority = 10;
  };
}

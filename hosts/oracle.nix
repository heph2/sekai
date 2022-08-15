{ config, lib, pkgs, ... }:
let
  subnetDefaultOci = "ocid1.subnet.oc1.eu-milan-1.aaaaaaaacc3ifofytrjoy4ajyc2c6nwr3iuyl7yk4fqxabemaedryw67zlzq";
  amdFree = "VM.Standard.E2.1.Micro";
  armFree = "VM.Standard.A1.Flex";
in
{

  ## Enable oracle cloud provider
  terraform.required_providers.oci.source = "oracle/oci";
  
  ## oci secrets
  data.sops_file.oci = {
    source_file = "oci_secrets.yaml";
  };

  ## Retrieve availability domain and images
  data.oci_identity_availability_domain.ad = {
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    ad_number = 1;
  };

  data.oci_core_images.ubuntu-20-04-arm = {
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    operating_system = "Canonical Ubuntu";
    operating_system_version = "20.04";
    shape = armFree;
  };

  data.oci_core_images.ol7 = {
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    operating_system = "Oracle Linux";
    operating_system_version = "7.9";
    shape = amdFree;
  };

  data.oci_core_images.ol7_arm = {
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    operating_system = "Oracle Linux";
    operating_system_version = "7.9";
    shape = armFree;
  };
  
  ## Retrieve subnet
  data.oci_core_subnet.default_sub = {
    subnet_id = subnetDefaultOci;
  };

  ###################################
  #         Oracle VMs              #
  ###################################
  
  ## Enable oracle provider
  provider.oci = {
    tenancy_ocid = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    user_ocid = ''''${data.sops_file.oci.data["oci.user"]}'';
    private_key = ''''${data.sops_file.oci.data["oci.private_key"]}'';
    region = "eu-milan-1";
  };

  ## AMD Always free resource 1
  resource.oci_core_instance.free_instance_AMD0 = {
    availability_domain = ''''${data.oci_identity_availability_domain.ad.name}'';
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    display_name = "casper";
    shape = amdFree;

    create_vnic_details = {
      subnet_id = ''''${data.oci_core_subnet.default_sub.id}'';
      display_name = "primaryvnic";
      assign_public_ip = true;
      hostname_label = "freeinstance0";
    };

    source_details = {
      source_type = "image";
      #      source_id = ''''${data.oci_core_images.ol7.images.0.id}'';
      source_id = "ocid1.image.oc1.eu-milan-1.aaaaaaaam2kmk7duocnfopgvypl3kir42hvfe6w3ohfnq7vzppbypfydteuq";
    };

    metadata.ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
    metadata.user_data = ''''${base64encode(file("./hosts/boot-oci.sh"))}'';
  };

  ## AMD Always free resource 2
  resource.oci_core_instance.free_instance_AMD1 = {
    availability_domain = ''''${data.oci_identity_availability_domain.ad.name}'';
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    display_name = "thor";
    shape = amdFree;

    create_vnic_details = {
      subnet_id = ''''${data.oci_core_subnet.default_sub.id}'';
      display_name = "primaryvnic";
      assign_public_ip = true;
      hostname_label = "freeinstance1";
    };

    source_details = {
      source_type = "image";
      #      source_id = ''''${data.oci_core_images.ol7.images.0.id}'';
      source_id = "ocid1.image.oc1.eu-milan-1.aaaaaaaam2kmk7duocnfopgvypl3kir42hvfe6w3ohfnq7vzppbypfydteuq";
    };

    metadata.ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
    metadata.user_data = ''''${base64encode(file("./hosts/boot-oci.sh"))}'';
  };

  resource.oci_core_instance.free_instance_ARM0 = {
    availability_domain = ''''${data.oci_identity_availability_domain.ad.name}'';
    compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
    display_name = "odin";
    shape = armFree;

    shape_config = {
      memory_in_gbs = "24";
      ocpus = "4";
    };

    create_vnic_details = {
      subnet_id = ''''${data.oci_core_subnet.default_sub.id}'';
      display_name = "primaryvnic";
      assign_public_ip = true;
      hostname_label = "freeinstancearm0";
    };

    source_details = {
      source_type = "image";
      source_id = ''''${data.oci_core_images.ubuntu-20-04-arm.images.0.id}'';
     #      source_id = ''''${data.oci_core_images.ol8_arm.images.0.id}'';
     #      source_id = "ocid1.image.oc1.eu-milan-1.aaaaaaaahuqq5jbok3otbmxaum4musc6bezkdh2t6rbucwvj675oyzihm54q";
      boot_volume_size_in_gbs = "95";
    };

    metadata.ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
    #    metadata.user_data = ''''${base64encode(file("./hosts/boot-oci.sh"))}'';
  };
  
  ## ARM Always free resource 1
  # resource.oci_core_instance.free_instance_ARM0 = {
  #   availability_domain = ''''${data.oci_identity_availability_domain.ad.name}'';
  #   compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
  #   display_name = "odin";
  #   shape = armFree;

  #   shape_config = {
  #     memory_in_gbs = "12";
  #     ocpus = "2";
  #   };

  #   create_vnic_details = {
  #     subnet_id = ''''${data.oci_core_subnet.default_sub.id}'';
  #     display_name = "primaryvnic";
  #     assign_public_ip = true;
  #     hostname_label = "freeinstancearm0";
  #   };

  #   source_details = {
  #     source_type = "image";
  #     source_id = ''''${data.oci_core_images.ubuntu-20-04-arm.images.0.id}'';
  #   };

  #   metadata.ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
  #   metadata.user_data = ''''${base64encode(file("./hosts/boot-oci.sh"))}'';
  # };

  # ## ARM Always free resource 2
  # resource.oci_core_instance.free_instance_ARM1 = {
  #   availability_domain = ''''${data.oci_identity_availability_domain.ad.name}'';
  #   compartment_id = ''''${data.sops_file.oci.data["oci.tenancy"]}'';
  #   display_name = "hod";
  #   shape = armFree;

  #   shape_config = {
  #     memory_in_gbs = "12";
  #     ocpus = "2";
  #   };

  #   create_vnic_details = {
  #     subnet_id = ''''${data.oci_core_subnet.default_sub.id}'';
  #     display_name = "primaryvnic";
  #     assign_public_ip = true;
  #     hostname_label = "freeinstancearm1";
  #   };

  #   source_details = {
  #     source_type = "image";
  #     source_id = ''''${data.oci_core_images.ubuntu-20-04-arm.images.0.id}'';
  #   };

  #   metadata.ssh_authorized_keys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCmIz2Selg5eJ77lvpJHgDJiRIOZbucMjDK5zrhTEWK heph@fenrir";
  #   metadata.user_data = ''''${base64encode(file("./hosts/boot-oci.sh"))}'';
  # };
  
}

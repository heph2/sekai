{ pkgs, ... }: {
  home.username = "heph";
  home.homeDirectory = "/home/heph";
  
  programs = {
      home-manager.enable = true;
      git = {
	enable = true;
	aliases = {
	  gm = "git commit -m";
	};
      };
  };

  services.fusuma = {
     enable = true;
     settings = ''
     alo
     '';
  };

  home.packages = [
    pkgs.cowsay
  ];

  home.stateVersion = "22.05";
}

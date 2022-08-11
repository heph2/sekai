{ pkgs, ... }: {
  home.username = "heph";
  home.homeDirectory = "/home/heph";
  
  programs = {
      home-manager.enable = true;
      git = {
	enable = true;
	aliases = {
	  gm = "commit -m";
	};
	userName = "heph";
	userEmail = "srht@mrkeebs.eu";
	extraConfig = {
	  core.editor = "nvim";
	  credential.helper = "cache"; # cache for 15 min
	};
      };

      neovim = {
	enable = true;
      };
      mpv = {
        enable = true;
	config = {
		hwdec = "auto-safe";
                vo = "gpu";
                profile = "gpu-hq";
                gpu-context = "wayland";
	};
      };
      foot = {
	enable = true;
	settings = {
	  main = {
	    term = "xterm-256color";
	    font = "Monospace:size=12";
	    dpi-aware = "auto";
	    pad = "10x5 center";
	  };
	  mouse = { hide-when-typing = "yes"; };
	};
      };
  };

 # wayland.windowManager.sway = {
 #    enable = true;
 #    config = {
 #    };
 # };

  services.fusuma = {
     enable = true;
     settings = {
	threshold = {
	  swipe = 0.1;
	};	
	swipe = {
	  "4" = {
	    up = {
		command = "exec sway fullscreen toggle";
	    };
	    down = {
		command = "exec sway fullscreen off";
	    };
	  };
	};
     };
 };

  home.packages = [
    pkgs.cowsay
  ];

  home.stateVersion = "22.05";
}

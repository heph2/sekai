{ config, pkgs, lib, ... }: 
{
  imports = [
    ./waybar
  ];
  
  home = {
    username = "heph";
    homeDirectory = "/home/heph";
    stateVersion = "22.05";
    packages = [
      pkgs.cowsay
    ];
  };
  
  services = {
    fusuma = {
      enable = true;
      settings = {
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
    
  };
  
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
      }; # git

      neovim = {
	      enable = true;
	      package = pkgs.neovim-nightly;
	      extraPackages = with pkgs; [
		tree-sitter
	      ];
	      plugins = with pkgs.vimPlugins; [
		vim-which-key
	      ];
      }; # neovim

      mpv = {
        enable = true;
	      config = {
		      hwdec = "auto-safe";
          vo = "gpu";
          profile = "gpu-hq";
          gpu-context = "wayland";
	      };
      }; # mpv

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
      }; # foot
  }; # programs

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    config = rec {
      fonts = {
	      names = [ "Inter Nerd Font" ];
	      size = 11.0;
      };
      input = {
        "type:touchpad" = {
          dwt = "enabled";
	        tap = "enabled";
	        middle_emulation = "enabled";
	      };
      };
      window = {
	      #default_border = "pixel";
	      #default_floating_border = "pixel";
	      hideEdgeBorders = "smart";
      };
      startup = [
        {
          command =
            "export $WOBSOCK $XDG_RUNTIME_DIR/wob.sock";
          always = true;
        }
      ];
      modes = {
          "system:  [r]eboot  [p]oweroff  [l]ogout" = {
            r = "exec reboot";
            p = "exec poweroff";
            l = "exit";
            Return = "mode default";
            Escape = "mode default";
          };
      };
      modifier = "Mod4";
      menu = "${pkgs.rofi}/bin/rofi -show run";
      keybindings =
        let
          #          wobsock = "$XDG_RUNTIME_DIR/wob.sock";
          wobsock = "/run/user/1000/wob.sock";
        in
          {
            "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioRaiseVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" =
              "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 10";
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
	          "${modifier}+XF86MonBrightnessUp" = "exec light -A 5 && light -G | cut -d'.' -f1 > $WOBSOCK";
	          "${modifier}+XF86MonBrightnessDown" = "exec light -U 5 && light -G | cut -d'.' -f1 > $WOBSOCK";
            "${modifier}+Left" = "focus left";
	          "${modifier}+Down" = "focus down";
	          "${modifier}+Up" = "focus up";
	          "${modifier}+Right" = "focus right";
            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";
            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";
	          "${modifier}+return" = "exec foot";
	          "${modifier}+d" = "exec ${menu}";
            "${modifier}+Shift+r" = "mode resize";
            "${modifier}+Shift+v" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';
	          "${modifier}+r" = "reload";
	          "${modifier}+l" = "exec screenlock";
	          "${modifier}+q" = "kill";
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";
          };
    };
  };
}

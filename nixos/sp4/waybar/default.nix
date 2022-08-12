{ ... }:

{
  wayland.windowManager.sway.config.bars = [
    { command = "waybar"; }
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = builtins.readFile ./waybar.css;
    settings = [{
      layer = "top";
      position = "bottom";
      height = 30;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        #"wlr/taskbar"
      ];
      modules-right = [ "network" "pulseaudio" "backlight" "cpu" "battery" "tray" "clock" ];
      battery = rec {
        interval = 1;
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-plugged = "" + format;
        format-charging = format-plugged;
        format-icons =  ["" "" "" "" ""];
      };

      clock = {
        interval = 1;
        format = "{:%a  %e %b %y  %H:%M} ";
        tooltip = false;
      };

      cpu = {
        interval = 5;
        states = {
          warning = 70;
          critical = 90;
        };
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["" ""];
        on-scroll-down = "brightnessctl -c backlight set 5%";
        on-scroll-up = "brightnessctl -c backlight set +5%";
      };

      network = {
        interval = 5;
        format-wifi = "直  {essid} "; # Icon: wifi;
        format-ethernet = "  {ifname}: {ipaddr}/{cidr}"; # Icon: ethernet;
        format-disconnected = "睊  Disconnected";
        tooltip-format = "{ifname}: {ipaddr}/{cidr} {signalStrength}%";
      };

      "sway/mode" = {
        format =
          ''<span style="italic"> {}</span>''; # Icon: expand-arrows-alt;
        tooltip = false;
      };

      "sway/workspaces" = {
        all-outputs = false;
        disable-scroll = false;
        enable-bar-scroll = true;
        disable-scroll-wraparonud = true;
        smooth-scrolling-threshold = 1;
        format = "{name}";
        format-icons = {
          urgent = "";
          focused = "";
          default = "";
        };
      };

      pulseaudio = {
        #scroll-step = 1;
        format = "{icon}  {volume}%";
        format-bluetooth = " {icon}  {volume}% ";
        format-muted = "ﱝ";
        format-icons = rec {
          headphones = "";
          handsfree = headphones;
          headset = headphones;
          phone = "";
          portable = "";
          car = "";
          default = ["" ""];
        };
        on-click = "pavucontrol";
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };
    }];
  };
}

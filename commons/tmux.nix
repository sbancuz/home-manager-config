{ config, pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "screen-256color";
    keyMode = "vi";
    escapeTime = 10;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator "█"
          set -g @catppuccin_window_right_separator "█ "
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_middle_separator "  █"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#{pane_current_path}"
          set -g @catppuccin_status_modules "application session date_time"
          set -g @catppuccin_status_left_separator  ""
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "yes"
          set -g @catppuccin_status_fill "all"
          set -g @catppuccin_status_connect_separator "no"
        '';
      }
    ];
    extraConfig = lib.fileContents ../dotfiles/tmux/tmux.conf;
  };
}

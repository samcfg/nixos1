{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Language support
      jnoortheen.nix-ide              # Nix language support
      ms-python.python                # Python
      rust-lang.rust-analyzer         # Rust

      # Utilities
      eamodio.gitlens                 # Git integration
      vscodevim.vim                   # Vim keybindings

      # Themes
      catppuccin.catppuccin-vsc       # Catppuccin theme
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', monospace";
      "editor.tabSize" = 2;
    };
  };
}

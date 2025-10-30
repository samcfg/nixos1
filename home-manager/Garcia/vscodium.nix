{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # Language support
      jnoortheen.nix-ide              # Nix language support
      # ms-python.python              # Python (removed - conflicts with vscodium)
      # rust-lang.rust-analyzer       # Rust (removed - may conflict)

      # Utilities
      # eamodio.gitlens               # Git integration (removed - may conflict)
      # vscodevim.vim                 # Vim keybindings (removed - may conflict)

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

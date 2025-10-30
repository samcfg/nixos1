{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # No extensions - install manually through VSCodium's marketplace
    extensions = [];
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontFamily" = "'JetBrains Mono', monospace";
      "editor.tabSize" = 2;
    };
  };
}

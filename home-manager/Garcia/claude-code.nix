{ pkgs, config, ... }:

{
  # Claude Code CLI configuration
  # This module sets up the environment for Claude Code CLI

  home.sessionVariables = {
    # TEMPORARY: Replace this with your actual API key from console.anthropic.com
    # For production use, consider using sops-nix or environment-specific secrets
    ANTHROPIC_API_KEY = "REPLACE_WITH_YOUR_API_KEY";

    # npm global install directory
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  # Add npm global bin to PATH
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Optional: Create an activation script to install Claude Code CLI
  # This runs when you activate your home-manager configuration
  home.activation.installClaudeCode = ''
    ${pkgs.nodejs}/bin/npm config set prefix '${config.home.homeDirectory}/.npm-global'
    ${pkgs.nodejs}/bin/npm install -g @anthropic-ai/claude-code || true
  '';
}

# Vaultwarden - self-hosted password manager (Bitwarden-compatible)
{ config, pkgs, ... }:

{
  # TODO: Set up Vaultwarden after basic system is working
  # Vaultwarden provides:
  # - Password vault with browser extensions
  # - TOTP (2FA code generator)
  # - Secure notes and file attachments
  # - Compatible with official Bitwarden apps
  # - End-to-end encrypted (even server admin can't read passwords)

  # Lightweight Rust implementation of Bitwarden server
  # Run as Docker container with persistent volume

  # Example docker-compose.yml:
  # services:
  #   vaultwarden:
  #     image: vaultwarden/server:latest
  #     volumes:
  #       - /tank/vaultwarden:/data
  #     environment:
  #       DOMAIN: "https://vault.your-tailscale-name.ts.net"
  #     ports:
  #       - "8080:80"

  # Access via Tailscale URL, no public exposure needed
}

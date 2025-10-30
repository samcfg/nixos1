# Nextcloud - self-hosted cloud storage (Google Drive/Photos replacement)
{ config, pkgs, ... }:

{
  # TODO: Set up Nextcloud after basic system is working
  # Nextcloud provides:
  # - File sync and sharing (like Google Drive)
  # - Photo/video backup from phone (like Google Photos)
  # - Calendar and contacts sync
  # - Web interface for accessing files anywhere
  # - Desktop and mobile apps

  # Will be configured as a Docker container with docker-compose
  # Needs:
  # - PostgreSQL or MariaDB database
  # - Redis for caching
  # - Storage volume on ZFS
  # - Domain name or local hostname
  # - HTTPS certificate (via Caddy or Traefik)

  # Example docker-compose.yml will live in /home/sam/nextcloud/
}

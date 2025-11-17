# Immich - self-hosted photo and video backup (Google Photos replacement)
{ config, pkgs, ... }:

{
  # TODO: Set up Immich after basic system is working
  # Immich provides:
  # - Automatic photo/video backup from mobile devices
  # - AI-powered facial recognition and object detection
  # - Album organization and sharing
  # - Timeline view (like Google Photos)
  # - Web interface and mobile apps (iOS/Android)
  # - RAW photo support
  # - Live photos and video playback
  # - Duplicate detection

  # Runs as multiple Docker containers via docker-compose
  # Needs:
  # - PostgreSQL database (with pgvecto.rs extension for ML)
  # - Redis for background jobs
  # - Immich server container
  # - Immich machine learning container
  # - Storage volume on ZFS for photos/videos
  # - Storage volume for ML models

  # Example docker-compose.yml will live in /home/sam/immich/
  # or /tank/immich/

  # Example docker-compose.yml structure:
  # services:
  #   immich-server:
  #     image: ghcr.io/immich-app/immich-server:release
  #     volumes:
  #       - /tank/immich/upload:/usr/src/app/upload
  #     environment:
  #       DB_HOSTNAME: immich-postgres
  #       REDIS_HOSTNAME: immich-redis
  #     ports:
  #       - "2283:3001"
  #
  #   immich-machine-learning:
  #     image: ghcr.io/immich-app/immich-machine-learning:release
  #     volumes:
  #       - /tank/immich/model-cache:/cache
  #
  #   immich-redis:
  #     image: redis:6.2-alpine
  #
  #   immich-postgres:
  #     image: tensorchord/pgvecto-rs:pg14-v0.2.0
  #     volumes:
  #       - /tank/immich/postgres:/var/lib/postgresql/data

  # Access via http://nas-ip:2283 or Tailscale URL
  # Mobile app connects to server URL for auto-backup
}

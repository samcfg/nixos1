{ pkgs, ... }:

{
  home.packages = with pkgs; [
    p7zip
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    fd
    bear
    eza
    gemini-cli
    lazygit
    bat
    gcc
    vscode
    gh
    taplo
    pyright
    typescript-language-server
    bash-language-server
    docker-language-server
    lldb
    nil
    usbutils
    rdkafka
    cmake
    gnumake

    #nautilus
    gvfs
    ntfs3g
    dosfstools
    gtk3
    gtk4
    adwaita-icon-theme
    gnome-keyring
  ];

  # Git configuration - commented out for now
  # programs.git = {
  #   enable = true;
  #   userName = "omggass";
  #   userEmail = "omggass@gmail.com";
  #   signing = {
  #     signByDefault = true;
  #     key = "AE8CE548611A623A";
  #   };
  #   delta.enable = true;
  #   delta.options = {
  #     "side-by-side" = true;
  #     navigate = true;
  #   };
  # };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      buffer_editor = "hx";
    };
    envFile.text = ''
      $env.PROMPT_COMMAND = { || $"($env.PWD | path basename)" }
      $env.PROMPT_COMMAND_RIGHT = ""
      $env.EDITOR = "hx"
      $env.VISUAL = "hx"
    '';
    shellAliases = {
      la = "ls -la";
      cat = "bat";
      lg = "lazygit";
      mkd = "mkdir";
      zj = "zellij";
    };

    extraEnv = ''
      $env.PATH = ($env.PATH | append $"($env.HOME)/go/bin")
    '';

    extraConfig = ''
      def nixos-update [host: string, user: string] {
          nix flake update;
          sudo nixos-rebuild switch --flake .#($host)
          home-manager switch --flake .#($user)
      }
    '';
  };

  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_hidden = true;
      };
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        cursorline = true;
        end-of-line-diagnostics = "hint";
        indent-heuristic = "tree-sitter";

        lsp = {
          display-inlay-hints = true;
        };

        file-picker = {
          hidden = false;
          git-global = false;
        };

        soft-wrap = {
          enable = true;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          render = true;
        };

        inline-diagnostics = {
          cursor-line = "warning";
        };
      };

      keys = {
        normal = {
          y = "yank_joined_to_clipboard";
          p = [ "paste_clipboard_after" ];
          P = [ "replace_selections_with_clipboard" ];
          d = [
            "yank_joined_to_clipboard"
            "delete_selection"
          ];
          z = "move_next_word_start";
          "C-s" = ":write";
          w = "move_next_sub_word_start";
          b = "move_prev_sub_word_start";
          e = "move_next_sub_word_end";
        };

        select = {
          y = "yank_joined_to_clipboard";
          p = [ "replace_selections_with_clipboard" ];
          P = [ "replace_selections_with_clipboard" ];
          d = [
            "yank_joined_to_clipboard"
            "delete_selection"
          ];
          c = [
            "trim_selections"
            "change_selection"
          ];
          w = "extend_next_sub_word_start";
          b = "extend_prev_sub_word_start";
          e = "extend_next_sub_word_end";
        };

        insert = {
          "C-space" = "completion";
        };
      };
    };

    languages = {
      language-server = {
        discord-rpc = {
          command = "discord-rpc-lsp";
        };
      };

      language = [
        {
          name = "toml";
          formatter = {
            command = "taplo";
            args = [
              "fmt"
              "-"
            ];
          };
          auto-format = true;
        }
        {
          name = "nix";
          formatter = {
            command = "nixfmt";
            args = [ "%sh{pwd}/%{buffer_name}" ];
          };
          auto-format = true;
        }
        {
          name = "go";
          language-servers = [ "discord-rpc" ];
        }
        {
          name = "python";
          language-servers = [ "discord-rpc" ];
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "discord-rpc"
          ];
        }
        {
          name = "typescript";
          language-servers = [ "discord-rpc" ];
        }

      ];
    };

  };
}

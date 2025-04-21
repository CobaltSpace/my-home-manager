{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/mpv) pkgs.emptyDirectory;
    config = {
      stop-screensaver = true;
      save-position-on-quit = true;
      sub-font-size = 30;
      osd-font-size = 30;

      video-sync = "display-resample";
      hwdec = "auto";

      # video-align-y = -1;
      video-unscaled = "downscale-big";

      screenshot-dir = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}/mpv";
      screenshot-template = "%F-$P-%n";
      screenshot-format = "webp";
      screenshot-png-compression = 9;
      screenshot-webp-lossless = true;
      screenshot-webp-quality = 100;
      screenshot-webp-compression = 6;
      screenshot-jxl-distance = 0;
      screenshot-jxl-effort = 9;

      term-title = "\${media-title} - mpv";

      # sf = "scaletempo2";
    };
    profiles = {
      hdr = {
        vo = "gpu-next";
        target-colorspace-hint = "yes";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        fs = true;
      };
      vr = {
        x11-name = "mpv-vr";
        pause = true;
      };
      audioshare = {
        audio-client-name = "mpv-audioshare";
        resume-playback = false;
        pause = true;
        # video = false;
        volume = 50;
        audio-channels = "mono";
      };
      lofi = {
        resume-playback = false;
        video-unscaled = false;
        panscan = 1;
        wayland-app-id = "mpv-bg";
        x11-name = "mpv-bg";
        term-title = "\${media-title} - mpv-bg";
      };
    };
    bindings = {
      "CTRL+1" =
        ''set video-unscaled no ; change-list glsl-shaders set "/usr/share/mpv-shim-default-shaders/shaders/FSRCNNX_x2_8-0-4-1.glsl"'';
      "CTRL+2" =
        ''set video-unscaled no ; change-list glsl-shaders set "/usr/share/mpv-shim-default-shaders/shaders/FSRCNNX_x2_16-0-4-1.glsl"'';
      "CTRL+8" = ''set video-unscaled no ; change-list glsl-shaders set "/usr/share/mpv-shim-default-shaders/shaders/FSR.glsl"'';
      "CTRL+9" = ''set video-unscaled no ; change-list glsl-shaders clr ""'';
      "CTRL+0" = ''change-list glsl-shaders clr "" ; set video-unscaled downscale-big'';
    };
  };
  home.shellAliases = {
    mpvhdr = "ENABLE_HDR_WSI=1 mpv --profile=hdr";

    lofi = "mpv 'ytdl://jfKfPfyJRdk' --profile=lofi";
    asianlofi = "mpv 'ytdl://Na0w3Mz46GA' --profile=lofi";
    sadlofi = "mpv 'ytdl://P6Segk8cr-c' --profile=lofi";

    synthwave = "mpv 'ytdl://4xDzrJKXOOY' --profile=lofi";
    darklofi = "mpv 'ytdl://S_MOd40zlYU' --profile=lofi";

    lofirain = "mpv 'ytdl://-OekvEFm1lo' --profile=lofi --no-vid";

    mpvmic = "mpv --profile=microphone";
  };
  wayland.windowManager.hyprland.settings.plugin.hyprwinwrap.class = [ "mpv-bg" ];
}

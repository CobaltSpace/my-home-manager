{ pkgs, ... }:
{
  xdg.dataFile."cargo/config.toml".source = (pkgs.formats.toml { }).generate "cargo-config.toml" {
    build = {
      rustc-wrapper = "sccache";
      rustflags = [
        "-C"
        "target-cpu=native"
        "-C"
        "link-arg=-fuse-ld=mold"
      ];
    };
    "profile.release".lto = true;
    net.git-fetch-with-cli = true;
  };
}

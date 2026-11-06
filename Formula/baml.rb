class Baml < Formula
  desc "Toolchain manager and launcher for the BAML language"
  homepage "https://github.com/BoundaryML/baml"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.3.1/baml-wrapper-no-self-update-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "c665f7704183cb44caf5c8e989b5e5465e4f703258070e590598cee7c2202d3c"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.3.1/baml-wrapper-no-self-update-0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "971b1df7af08cea82b77138c1f0bfab8d6d6fb8437bd218c8592a0d5a1409c1c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.3.1/baml-wrapper-no-self-update-0.3.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b2427ca6c40979806481eb92bfd5c83989b398b59cb23a04ae90957d967686ce"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.3.1/baml-wrapper-no-self-update-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3f60e6f9d4ef9f96811cf81de57db45f281d4661ea67e4984a8935792c3308c"
    end
  end

  def install
    if (buildpath/"bin/baml").exist?
      bin.install "bin/baml"
    else
      bin.install "baml"
    end
  end

  def caveats
    <<~EOS
      BAML wrapper installed.

      To install and select the current canary language toolchain:
        baml toolchain use --global canary

      To use nightly:
        baml toolchain use --global nightly

      IDE extension setup is explicit:
        baml ide install --cursor
    EOS
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    ENV["BAML_TELEMETRY"] = "off"
    ENV["BAML_WRAPPER_BCS_TELEMETRY"] = "off"
    ENV["BOUNDARY_API_KEY"] = "local"
    ENV["BAML_HOME"] = (testpath/"baml-home").to_s
    ENV["HOME"] = testpath.to_s
    # Version reporting delegates to the selected CLI. Keep this wrapper-only
    # test independent of published language toolchains and network access.
    (testpath/"baml-cli").write <<~SH
      #!/bin/sh
      echo "Homebrew CLI fixture"
    SH
    (testpath/"baml-cli").chmod 0755
    ENV["BAML_TOOLCHAIN"] = (testpath/"baml-cli").to_s

    version_output = shell_output("#{bin}/baml --version")
    assert_match "baml wrapper 0.3.1", version_output
    assert_match "Homebrew CLI fixture", version_output
    assert_match "installed toolchains: (none)",
                 shell_output("#{bin}/baml toolchain list")
    assert_match "self-update is disabled in this build",
                 shell_output("#{bin}/baml self-update 2>&1", 1)
  end
end

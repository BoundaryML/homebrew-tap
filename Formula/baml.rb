class Baml < Formula
  desc "Toolchain manager and launcher for the BAML language"
  homepage "https://github.com/BoundaryML/baml"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.4.0/baml-wrapper-no-self-update-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "d66f34d20f23da02e709c35e560f9933010b30fc7aec092e4a1e4ffde8ca5fa1"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.4.0/baml-wrapper-no-self-update-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "7f2ab1f4b4708cc12699bed221b43c2f356da2bf33471255a0478cba9bfe1e9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.4.0/baml-wrapper-no-self-update-0.4.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3a66650a9f8e6ed31ae17b018448094c9d25c5b31f3ffb915a1f7afeee838173"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.4.0/baml-wrapper-no-self-update-0.4.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ad19f8dea0edfa35dfe7ffd522a91815caa6c872f7e8a72afc5ed9d1c153353e"
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
    assert_match "baml wrapper 0.4.0", version_output
    assert_match "Homebrew CLI fixture", version_output
    assert_match "installed toolchains: (none)",
                 shell_output("#{bin}/baml toolchain list")
    assert_match "baml self update is disabled in this build",
                 shell_output("#{bin}/baml self update 2>&1", 1)
  end
end

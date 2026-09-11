class Baml < Formula
  desc "Toolchain manager and launcher for the BAML language"
  homepage "https://github.com/BoundaryML/baml"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.2.5/baml-wrapper-no-self-update-0.2.5-aarch64-apple-darwin.tar.gz"
      sha256 "d90f159f4147add2e67bf996fba5ec58efb0ca81fde0897bb4be9862286f96b9"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.2.5/baml-wrapper-no-self-update-0.2.5-x86_64-apple-darwin.tar.gz"
      sha256 "bf962ca55c60ab9409fafc23bb25b96a52f7e0ff88ef53877f3dc2f3697d9496"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.2.5/baml-wrapper-no-self-update-0.2.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3b2bec68ace1f9432d1041a49a0a23b035bb1c2c09dacbd2b1ad86498d3ff74c"
    end

    on_intel do
      url "https://github.com/BoundaryML/baml/releases/download/baml-wrapper-0.2.5/baml-wrapper-no-self-update-0.2.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23129e133259c2bb43973827b85567db1c5b5c27ea55b0dc515e8291301dbc1b"
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
        baml toolchain use canary

      To use nightly:
        baml toolchain use nightly

      IDE extension setup is explicit:
        baml ide install --cursor
    EOS
  end

  test do
    ENV["BAML_HOME"] = (testpath/"baml-home").to_s
    ENV["HOME"] = testpath.to_s
    ENV.delete "BAML_VERSION"

    assert_match "baml wrapper 0.2.5",
                 shell_output("#{bin}/baml --version")
    assert_match "installed toolchains: (none)",
                 shell_output("#{bin}/baml toolchain list")
    assert_match "self-update is disabled in this build",
                 shell_output("#{bin}/baml self-update 2>&1", 1)
  end
end

class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.42.0/fonttools-3.42.0.zip"
  sha256 "c00b393b8fb8644acc7a0c7b71d2e70eadc21db494baaa05b32b08148c661670"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccef6063dbd1009a7801cd9b7feb23c9c2c5c1e5fadeb936889070bf26f1d6ef" => :mojave
    sha256 "886cbaf629dcdff21e61d44ab75dacf960fc5d282be51f643145112034f45109" => :high_sierra
    sha256 "c658ec13b72e9ce4b5dfa5b560cf5cbdbd19104ca4e0d050a173e8f11722f94e" => :sierra
    sha256 "f6e6c8c0589ae26797db0bbcfd20d3f227c4cc94695071ca20999febd330d41a" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end

class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.2.2.tar.gz"
  sha256 "117b29c9c719faeafaa1d0591a9e63029988ddb09dbe36d095da98c98c80c2e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "da568035975774ddc3dd1a7befb73d6fd00b6a33cfc98f6518bc35a336800423" => :mojave
    sha256 "54fdd02a0fb7f1455acc513fc4a8d68ee918652b85a993685ccb5f1ab87caa38" => :high_sierra
    sha256 "3e7a41b4dc133266c5b2d7e38bbf04eacc00643997bd53ed2f7d8ff730ba28e8" => :sierra
    sha256 "35de187254d69d1555d3e61da09929975d00ff11a2b3feacd2bb64d624f79c61" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end

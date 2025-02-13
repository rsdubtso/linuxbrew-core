class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2019-06-01.tar.gz"
  version "20190601"
  sha256 "02b7d73126bd18e9fbfe5d6375a8bb13fadaf8e99e48cbb062e4500fc18e8e2e"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "24fcae96249fc8e14b8579d3d916b2c952fe6aea51dcf3a40854a40aca7116f0" => :mojave
    sha256 "c130ece87ddc37102cef26c47e01a4b7c412ae0bdb32d8347e8b073891f362ac" => :high_sierra
    sha256 "650b1a9e3f1da497ca1b0d3942edd26101aca8127f0083b64686a2db210a47ca" => :sierra
    sha256 "fa4d9fb0a9b973192d89e168c1f688ee09750f4b690e897011e574e25b1fa3be" => :x86_64_linux
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib") if OS.mac?
    ext = OS.mac? ? "dylib" : "so"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.0.#{ext}"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.#{ext}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11",
           "test.cpp", "-I#{include}", "-L#{lib}", "-pthread", "-lre2", "-o", "test"
    system "./test"
  end
end

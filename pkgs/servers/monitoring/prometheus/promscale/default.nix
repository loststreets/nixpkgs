{ lib
, buildGoModule
, fetchFromGitHub
, promscale
, testVersion
}:

buildGoModule rec {
  pname = "promscale";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "timescale";
    repo = pname;
    rev = version;
    sha256 = "sha256-h76NHEPY3ABq2NbRQXNR+zSkriBasi550rfSkl3Xdas=";
  };

  patches = [
    ./0001-remove-jaeger-test-dep.patch
  ];

  vendorSha256 = "sha256-PxmTS8fSh21BcLS4PsSfHhKOXWWJLboPR6E8/Jx/UGY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/timescale/promscale/pkg/version.Version=${version}"
    "-X github.com/timescale/promscale/pkg/version.CommitHash=${src.rev}"
  ];

  doCheck = false; # Requires access to a docker daemon

  passthru.tests.version = testVersion {
    package = promscale;
    command = "promscale -version";
  };

  meta = with lib; {
    description = "An open-source analytical platform for Prometheus metrics";
    homepage = "https://github.com/timescale/promscale";
    changelog = "https://github.com/timescale/promscale/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}

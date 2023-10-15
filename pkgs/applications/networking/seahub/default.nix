{ lib
, fetchFromGitHub
, python3
, makeWrapper
, nixosTests
}:
 let python = python3;
in
 python.pkgs.buildPythonApplication rec {
  pname = "seahub";
  version = "11.0.1-pro";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seahub";
    rev = "cf40c5a3f42352ea11ac16282a06111cacb63e93"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "sha256-dxMvbiAdECMZIf+HgA5P2gZYI9l+k+nhmdzfg90037A=";
  };

  dontBuild = true;

  doCheck = false; # disabled because it requires a ccnet environment

  nativeBuildInputs = [
    makeWrapper
  ];

  propagatedBuildInputs = with python.pkgs; [
    django
    future
    django-compressor
    django-statici18n
    django-webpack-loader
    django-simple-captcha
    django-picklefield
    django-formtools
    djangosaml2
    mysqlclient
    pillow
    python-dateutil
    djangorestframework
    openpyxl
    requests
    requests-oauthlib
    chardet
    pyjwt
    pycryptodome
    python-ldap
    pyopenssl
    qrcode
    pysearpc
    seaserv
    gunicorn
    markdown
    bleach
  ];

  installPhase = ''
    cp -dr --no-preserve='ownership' . $out/
    wrapProgram $out/manage.py \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/thirdpart:"
  '';

  passthru = {
    inherit python;
    pythonPath = python.pkgs.makePythonPath propagatedBuildInputs;
    tests = {
      inherit (nixosTests) seafile;
    };
  };

  meta = with lib; {
    description = "The web end of seafile server";
    homepage = "https://github.com/haiwen/seahub";
    license = licenses.asl20;
    maintainers = with maintainers; [ greizgh schmittlauch ];
    platforms = platforms.linux;
  };
}

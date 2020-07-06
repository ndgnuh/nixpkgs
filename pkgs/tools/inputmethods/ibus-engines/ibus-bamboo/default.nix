{ stdenv
, fetchurl
, ibus
, go
, substituteAll
, xorg
}:

stdenv.mkDerivation rec {
	name = "bamboo";
	version = "0.6.5";

	src = fetchurl {
		url = "https://github.com/BambooEngine/ibus-bamboo/archive/v${version}.tar.gz";
		sha256 = "4af96f17ba5069b1125fbefef62b51675e00a09b8d5941d96e3f8ab39de770b9";
	};

	buildInputs = [
		ibus
		go
		xorg.libX11
		xorg.libXtst
		xorg.libXi
	];

	patches = [
		(substituteAll {
		 src = ./prefix.patch;
		 })
	];

	postFixup = ''
		substituteInPlace $out/share/ibus/component/bamboo.xml --replace /usr $out
	'';

	makeFlags = [
		"PREFIX=$(out)"
		"HOME=$NIX_BUILD_TOP"
	];

	meta = with stdenv.lib; {
		isIbusEngine = true;
		description = "Vietnamese input method for ibus";
		homepage = "https://github.com/BambooEngine/ibus-bamboo";
		license = licenses.gpl3;
		platforms = platforms.linux;
		maintainers = with maintainers; [ ndgnuh ];
	};
}

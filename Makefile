BUILD_DIR = build
PKG_DIR   = pkg

BINNAME   = xclicker
TARGET    = build/src/${BINNAME}
DESKFILE  = xclicker.desktop

debpkgdir="./${PKG_DIR}/deb/package"
appimgdir="${PKG_DIR}/AppImage/XClicker.AppDir"

.PHONY: build
build:
	@if test -d "./${BUILD_DIR}"; then echo "Build dir is already made"; else meson build; fi
	meson compile -C build

.PHONY: run
run:
	./${TARGET}
	
.PHONY: all
all: build run

.PHONY: install
install: build
	@sudo install -Dm 755 ./${BUILD_DIR}/src/${BINNAME} /usr/bin/${BINNAME}
	@sudo install -Dm 755 ./${DESKFILE} /usr/share/applications/xclicker.desktop
	@sudo install -Dm 644 ./img/icon.png /usr/share/pixmaps/${BINNAME}.png
	@echo "Installed XClicker"

.PHONY: deb
deb: build
	@rm -rf ${debpkgdir}
	@mkdir -p ${debpkgdir}

	@install -Dm 644 ./${PKG_DIR}/deb/control ${debpkgdir}/DEBIAN/control
	@install -Dm 644 ./${BUILD_DIR}/src/${BINNAME} ${debpkgdir}/usr/bin/${BINNAME}
	@install -Dm 644 ./${DESKFILE} ${debpkgdir}/usr/share/applications/xclicker.desktop
	@install -Dm 644 ./img/icon.png ${debpkgdir}/usr/share/pixmaps/${BINNAME}.png
	@dpkg-deb --build ${debpkgdir}
	@dpkg-name ${PKG_DIR}/deb/package.deb -o

.PHONY: appimg
appimg: build
	@rm -rf ${appimg}
	@mkdir -p ${appimgdir}
	@install -Dm 755 ./${BUILD_DIR}/src/${BINNAME} ${appimgdir}/${BINNAME}
	@install -Dm 755 ./${DESKFILE} ${appimgdir}/xclicker.desktop
	@install -Dm 755 ./${PKG_DIR}/AppImage/AppRun ${appimgdir}/AppRun
	@install -Dm 644 ./img/icon.png ${appimgdir}/${BINNAME}.png
	@cd ${PKG_DIR}/AppImage; appimagetool ./XClicker.AppDir

.PHONY: clean
clean:
	@$(RM) -rv ${BUILD_DIR}

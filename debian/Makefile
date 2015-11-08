# Builds the bash-glory Debian package.

package_basename := bash-glory
package_version := $(shell grep ^Version: control | sed 's/^Version: //')
arch := all
package_name := $(package_basename)_$(package_version)_$(arch)
build := $(shell pwd)/$(package_name)
deploy_dir := /usr/share/lib/bash-glory
package_file := $(shell pwd)/$(package_name).deb

all:
	# Clean up any old build.
	rm -rf $(build)
	
	# Stage Debian-specific package files.
	mkdir -p $(build)/DEBIAN
	cp -p ./control $(build)/DEBIAN/
	cp -p ./conffiles $(build)/DEBIAN/
	cp -p ./postinst $(build)/DEBIAN/
	cp -p ./prerm $(build)/DEBIAN/
	
	# Stage package contents.
	mkdir -p $(build)$(deploy_dir)
	cp -p ../src/*.sh $(build)$(deploy_dir)

	# Build the .deb package.
	fakeroot chown -R root:root $(build)
	fakeroot dpkg-deb -b $(build) $(package_file)

	# Clean up.
	rm -rf $(build)

clean:
	rm -rf $(build)
	rm -f *.deb
	rm -f *.out



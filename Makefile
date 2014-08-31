VERSION := $(shell grep '^Version: ' control/control |cut -d' ' -f2)

all: package

package: binary-armel/tinc_$(VERSION)_armel.deb

control/md5sums:
	cd data; find * -type f |xargs md5sum > ../control/md5sums

control/digsigsums:
	rm -f control/digsigsums
	cd control; for f in postinst postrm prerm; do echo S 15 com.nokia.maemo H 40 `sha1sum "$$f" | cut -c -40` R `expr length "var/lib/dpkg/info/tinc.$$f"` var/lib/dpkg/info/tinc.$$f; done >> digsigsums
	cd data; for f in $$(find * -type f -executable); do echo S 15 com.nokia.maemo H 40 `sha1sum "$$f" | cut -c -40` R `expr length "$$f"` $$f; done >> ../control/digsigsums
	
control.tar.gz: control control/md5sums control/digsigsums
	cd control; tar -zcvf ../control.tar.gz .

data.tar.gz:
	cd data; tar -zcvf ../data.tar.gz .

binary-armel/tinc_$(VERSION)_armel.deb: control.tar.gz data.tar.gz
	ar -rcv binary-armel/tinc_$(VERSION)_armel.deb debian-binary control.tar.gz data.tar.gz _aegis

clean:
	rm -f control.tar.gz data.tar.gz binary-armel/tinc_$(VERSION)_armel.deb

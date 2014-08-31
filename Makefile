VERSION := $(shell grep '^Version: ' control/control |cut -d' ' -f2)

all: package

package: binary-armel/tinc_$(VERSION)_armel.deb

control.tar.gz:
	cd control; tar -zcvf ../control.tar.gz .

data.tar.gz:
	cd data; tar -zcvf ../data.tar.gz .

binary-armel/tinc_$(VERSION)_armel.deb: control.tar.gz data.tar.gz
	rm -f binary-armel/tinc_$(VERSION)_armel.deb
	ar r binary-armel/tinc_$(VERSION)_armel.deb debian-binary control.tar.gz data.tar.gz _aegis

clean:
	rm -f control.tar.gz data.tar.gz binary-armel/tinc_$(VERSION)_armel.deb

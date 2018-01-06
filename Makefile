update:
	crystal build kuve.cr --release
	cp kuve /usr/local/bin/
	cp kuve_conf.json /usr/local/bin
uninstall:
	rm /usr/local/bin/kuve
	rm /usr/local/bin/kuve_conf.json

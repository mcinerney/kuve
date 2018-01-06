update:
	crystal build kuve.cr --release
	cp kuve /usr/local/bin/
uninstall:
	rm /usr/local/bin/kuve

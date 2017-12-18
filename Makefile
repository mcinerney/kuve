update:
	crystal build kuve.cr --release
	cp kuve /usr/local/bin/
	cp kuve_conf /usr/local/bin

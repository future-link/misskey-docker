GITFLAGS = --single-branch

.PHONY: build clone clean up

up: build
	docker-compose up

clean:
	rm -rf misskey-* data

build: clone misskey-web/.build/build.json
	docker-compose build

clone: misskey-web misskey-gen misskey-api misskey-storage
misskey-%:
	git clone $(GITFLAGS) https://github.com/misskey-delta/misskey-$* $@
misskey-web/.build/build.json:
	@mkdir -p misskey-web/.build
	cp ./conf/web.json misskey-web/.build/build.json
misskey-storage:
	git clone $(GITFLAGS) https://github.com/future-link/misskey-storage $@

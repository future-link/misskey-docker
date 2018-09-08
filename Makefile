GITFLAGS = --single-branch

.PHONY: build clone clean up

up: build
	docker-compose up

clean:
	rm -rf misskey-* data

build: clone dockerignore misskey-web/.build/build.json
	docker-compose build

clone: misskey-web misskey-api misskey-storage
misskey-%:
	git clone $(GITFLAGS) https://github.com/misskey-delta/misskey-$* $@
misskey-web/.build/build.json:
	@mkdir -p misskey-web/.build
	cp ./conf/web.json misskey-web/.build/build.json
misskey-storage:
	git clone $(GITFLAGS) https://github.com/future-link/misskey-storage $@

dockerignore: misskey-web/.dockerignore misskey-api/.dockerignore misskey-storage/.dockerignore
misskey-%/.dockerignore:
	cp .dockerignore $@

gen: misskey-gen
	./gen.sh

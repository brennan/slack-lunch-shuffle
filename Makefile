NODE_ENV ?= development

ifeq ($(NODE_ENV),production)
    NPM_FLAGS := --prod
endif

node_modules: package.json
	npm install $(NPM_FLAGS)
	touch node_modules

server: node_modules
	npm run server
.PHONY: server

test: node_modules
	npm run test
.PHONY: test

deploy:
	rsync -avzh --delete --no-owner --no-group --exclude='/.git' --filter="dir-merge,- .gitignore" . lunch-shuffle@162.243.133.80:/home/lunch-shuffle/files/
	ssh lunch-shuffle@162.243.133.80 'cd files; make node_modules NODE_ENV=production; kill $$(systemctl -p MainPID show lunch-shuffle | sed -e "s/MainPID=//")'
.PHONY: deploy

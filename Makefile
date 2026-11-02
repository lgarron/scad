.PHONY: publish
publish:
	npm whoami || npm login
	npm publish

.PHONY: setup
setup:
	bun install --frozen-lockfile

.PHONY: vendor-BOSL2
vendor-BOSL2: setup
	bun run ./script/vendor-BOSL2.ts

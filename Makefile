.PHONY: publish
publish:
	npm publish

.PHONY: vendor-BOSL2
vendor-BOSL2:
	bun run ./script/vendor-BOSL2.ts

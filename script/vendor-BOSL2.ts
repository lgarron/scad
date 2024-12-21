import { mkdir, mkdtemp } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { $, Glob } from "bun";

const { sha } = await (
	await fetch("https://api.github.com/repos/BelfrySCAD/BOSL2/commits/master")
).json();

const tempDir = await mkdtemp(join(tmpdir(), "vendor-BOSL2"));
const tempZipPath = join(tempDir, "BOSL2.zip");
const tempExtractionFolder = join(tempDir, "extracted");
console.log({ tempDir, tempZipPath });
await $`open ${tempDir}`;
await $`curl --location --output ${tempZipPath} "https://github.com/BelfrySCAD/BOSL2/archive/${sha}.zip"`;
await $`unzip -d ${tempExtractionFolder} ${tempZipPath}`;

await $`rm -rf ./vendor/BOSL2`;
await mkdir("./vendor/BOSL2");

for (const fileGlob of ["*.scad", "LICENSE"]) {
	for await (const file of new Glob(`BOSL2-*/${fileGlob}`).scan({
		cwd: tempExtractionFolder,
		absolute: true,
	})) {
		console.log(`Vendoring: ${file}`);
		// TODO: we could `Promise.all(…)` all the copies, but this is fast enough.
		await $`cp ${file} ./vendor/BOSL2/`;
	}
}

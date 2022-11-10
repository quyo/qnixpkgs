import config from "config";
import { NestFactory } from "@nestjs/core";
import type { NestExpressApplication } from "@nestjs/platform-express";
import path from "path";
import url from "url";

import { AppModule } from "./app.module";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const port: number = config.get("backend.server.port");

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  app.useStaticAssets(path.join(__dirname, "../../dist/frontend/public"), {
    prefix: "/",
    extensions: ["html", "htm"],
  });
  app.setBaseViewsDir(path.join(__dirname, "../../dist/frontend/views"));
  app.setViewEngine("ejs");

  await app.listen(port);
}
await bootstrap();

const env = process.env["NODE_ENV"] || "<undefined>";
const label = config.get<string>("env.labelOutput");

console.log(
  "###########################################################################################################"
);
console.log("#");
console.log("#");
console.log(`#     SERVER RUNNING ON http://localhost:${port}`);
console.log("#");
console.log(`#         process.env["NODE_ENV"] = ${env}`);
console.log(`#         config.env.label = ${label}`);
console.log("#");
console.log("#");
console.log(
  "###########################################################################################################"
);

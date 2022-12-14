import compression from "compression";
import config from "config";
import { NestFactory } from "@nestjs/core";
import type { NestExpressApplication } from "@nestjs/platform-express";
import path from "path";

import { AppModule } from "./app.module";

const port: number = config.get("backend.server.port");

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  app.use(compression());
  app.useStaticAssets(path.join(process.cwd(), "dist/frontend/public"), {
    prefix: "/",
    extensions: ["html", "htm"],
    maxAge: 24 * 3600 * 1000,
  });
  app.setBaseViewsDir(path.join(process.cwd(), "dist/frontend/views"));
  app.setViewEngine("ejs");

  await app.listen(port);
}
await bootstrap();

const env = process.env["NODE_ENV"] || "<undefined>";
const label = config.get<string>("env.labelOutput");
const url = config.get<string>("backend.server.fullUrl");

console.log(
  "###########################################################################################################"
);
console.log("#");
console.log("#");
console.log(`#     SERVER RUNNING ON ${url}`);
console.log("#");
console.log(`#         process.env["NODE_ENV"] = ${env}`);
console.log(`#         config.env.label = ${label}`);
console.log("#");
console.log("#");
console.log(
  "###########################################################################################################"
);

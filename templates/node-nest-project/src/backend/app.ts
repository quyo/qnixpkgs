import config from 'config';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import path from 'path';
import url from 'url';

import { AppModule } from './app.module';

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const port: number = config.get('backend.server.port');


async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  app.useStaticAssets(path.join(__dirname, '../frontend/static'), {prefix: '/static'});
  app.setBaseViewsDir(path.join(__dirname, '../frontend/views'));
  app.setViewEngine('ejs');

  await app.listen(port);
}
bootstrap();


console.log('###########################################################################################################');
console.log('#')
console.log('#')
console.log(`#     SERVER RUNNING ON http://localhost:${port}`);
console.log('#')
console.log(`#         process.env['NODE_ENV'] = ${process.env['NODE_ENV']}`);
console.log(`#         config.env.label = ${config.get('env.labelOutput')}`);
console.log('#')
console.log('#')
console.log('###########################################################################################################');

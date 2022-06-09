@echo off
echo "installation start"
set /p projectName="Enter projectName(new-project default): "
IF NOT DEFINED projectName SET "projectName=new-project"
echo %projectName%

set /p nginxVersion="Enter NginxVersion (1.20 default): "
IF NOT DEFINED nginxVersion SET "nginxVersion=1.20"
echo %nginxVersion%

set /p phpVersion="Enter PhpVersion (8.1.4 default): "
IF NOT DEFINED phpVersion SET "phpVersion=8.1.4"
echo %phpVersion%

mkdir %projectName%
cd %projectName%




mkdir docker
mkdir docs
mkdir source

cd source
mkdir prod
mkdir dev
mkdir stage
mkdir frontend
git init


echo .idea > .gitignore
echo .prod >> .gitignore
echo .dev >> .gitignore
echo .stage >> .gitignore
echo .frontend >> .gitignore
echo Readme.md >> .gitignore

git add .
git commit -m "start project"

git checkout -b prod
git checkout master
git worktree add prod prod

git checkout -b stage
git checkout master
git worktree add stage stage

git checkout -b dev
git checkout master
git worktree add dev dev

git checkout -b frontend
git checkout master
git worktree add frontend frontend

cd prod
mkdir public
cd public
echo ^<? phpinfo(); > index.php
cd ../../dev
mkdir public
cd public
echo ^<? phpinfo(); > index.php
cd ../../stage
mkdir public
cd public
echo ^<? phpinfo(); > index.php

cd ../../frontend
mkdir dist
mkdir src

call npm init -y
call npm install laravel-mix --save-dev
call npm install normalize.css

REM npm v8
call npm pkg set scripts.dev="npm run development"
call npm pkg set scripts.watch="mix watch"
call npm pkg set scripts.prod="npm run production"
call npm pkg set scripts.production="mix --production"

echo const mix = require('laravel-mix'); > webpack.mix.js
echo mix.options({ processCssUrls: false }) >> webpack.mix.js
echo mix.js('src/js/app.js', 'dist/js') >> webpack.mix.js
echo     .sass('src/scss/app.scss', 'dist/css'); >> webpack.mix.js


cd src
mkdir js
cd js
copy NUL app.js

cd ../
mkdir scss
cd scss
copy NUL app.scss

cd ../../dist
mkdir img
mkdir fonts
copy NUL index.php

cd ../../../docker

call git clone https://github.com/gelid/docker-php.git .
call git remote remove origin



echo PROJECT_NAME=%projectName% > .env.tmp
echo COMPOSE_PROJECT_NAME=%projectName% >> .env.tmp
echo NGINX_VERSION=%nginxVersion% >> .env.tmp
echo PHP_VERSION=%phpVersion% >> .env.tmp

type .env >> .env.tmp
type .env.tmp > .env
del .env.tmp

docker-compose up -d --build

pause

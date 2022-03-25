echo "test start"
mkdir docker
mkdir docs
mkdir source

cd source
mkdir prod
mkdir dev
mkdir stage
git init

NUL> .gitignore
echo .idea >> .gitignore
echo .prod >> .gitignore
echo .dev >> .gitignore
echo .stage >> .gitignore
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

cd ../
cd docker
git clone https://github.com/gelid/docker-php.git .
git remote remove origin

pause
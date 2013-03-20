#!/bin/sh
# pre-commit
echo "Compiling CSS"
less main.less main.css

echo "Preparing to commit..."
git add .
echo "Committing"
git commit

#post-commit
echo "Pushing FTP"
git ftp push -u chaost@derflatulator.com -p - ftp://derflatulator.com/lucasazzola.com/public_html/fb-friend-analytics

if [$1 == "--github"]; then
	echo "Pushing to GitHub"
   	git push github master
fi

echo "Done."
notify-send "FB Analtics" "Commit completed and uploaded"

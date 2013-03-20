#!/bin/sh
# pre-commit
echo "Compiling CSS"
lessc ./css/main.less ./css/main.css

github=0
commit=0
push=0

while getopts "gcm:" opt; do
    case "$opt" in
    g)  
		github=1
        ;;
    c)  
		commit=1
        ;;
    m)  
		message=$OPTARG
        ;;
    esac
done

if [ $commit = 1 ] ; then
	echo "Preparing to commit..."
	git add .
	echo "Committing"
    if [ $message = 1 ] ; then
		git commit -m $message
	else
		git commit
	fi
fi

#post-commit
if [ $push = 1 ] ; then
	echo "Pushing FTP"
	git ftp push -u chaost@derflatulator.com -p - ftp://derflatulator.com/lucasazzola.com/public_html/fb-friend-analytics
fi

if [ $github = 1 ] ; then
	echo "Pushing to GitHub"
   	git push github master
fi

echo "Done."
sudo notify-send -t 1000 "FB Analytics" "Commit completed and uploaded"

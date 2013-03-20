#!/bin/sh
# pre-commit
echo "Compiling CSS"
lessc ./css/main.less ./css/main.css

github=0
commit=0
push=0
contains_message=0

while getopts "gcm:" opt; do
    case "$opt" in
    g)  
		github=1
        ;;
    c)  
		commit=1
        ;;
    m)  
		contains_message=1
		message=$OPTARG
        ;;
    esac
done

if [ $commit -eq 1 ] ; then
	echo "Preparing to commit..."
	git add .
	echo "Committing"
    if [ $contains_message -eq 1 ] ; then
		#echo "git commit -m $message"
		git commit -m "$message"
	else
		git commit
	fi
fi

#post-commit
if [ $push -eq 1 ] ; then
	echo "Pushing FTP"
	git ftp push -u chaost@derflatulator.com -p - ftp://derflatulator.com/lucasazzola.com/public_html/fb-friend-analytics
fi

if [ $github -eq 1 ] ; then
	echo "Pushing to GitHub"
   	git push github master
fi

echo "Done."
sudo notify-send -t 1000 "FB Analytics" "Commit completed and uploaded"

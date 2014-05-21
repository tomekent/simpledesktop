function simpledesks() {
    useragent='Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.117 Safari/537.36' # Mimic Google Chrome 33.0.1750.117 on 64-bit Windows 8.1
 	print 'hi'
    if [ $# != 1 ]
    then
        echo 'Enter the number of pages you want to scrape as the only argument. Each page has (give or take) 28 images. The total number of pages at this time is 46.'
        return 1
    elif [ $1 -gt 46 ]
    then
        limit=46
    else
        limit=$1
    fi
 
    limit=$1
    counter=1
    
    while [ $counter -le $limit ]
    do
        for url in $(curl -s -A "$useragent" http://simpledesktops.com/browse/$counter/ | grep '<h2><a href="/browse/desktops' | sed 's/\t*<h2><a href="\(.*\)">.*<\/a><\/h2>$/http:\/\/simpledesktops.com\1/')
        do
            name=$(sed 's/^.*\/[0-9][0-9]\/\(.*\)\/$/\1/' <<< $url)
            echo -n Downloading $name...
            if [ $(ls -1 | grep ^$name\....) ]  # If we already have the file, no need to re-download
            then
                :
            else
                # imgurl=$(curl -s $url | grep '<img src="http://static.simpledesktops.com/uploads/desktops/' | awk 'BEGIN{IGNORECASE=1;FS="<img src=| title=";RS=EOF} {print $2}' | sed -e 's/^"//'  -e 's/"$//')
                imgurl=$(curl -s $url | grep '<h2><a href="/download'  | awk 'BEGIN{IGNORECASE=1;FS="<h2><a href=|>";RS=EOF} {print $2}' | sed -e 's/^"//'  -e 's/"$//')
				fullurl=$(echo 'http://simpledesktops.com/download'$imgurl)
				# exttype=$(echo $imgurl | cut -d'.' -f4);
				# curl $imgurl > $name'.'$exttype
				curl -s -L -o temp -A "$useragent" $fullurl
				
				mv temp $name'.png'
				
            fi
            echo ' Done'
        done
        counter=$(($counter + 1))
    done
}

simpledesks 1
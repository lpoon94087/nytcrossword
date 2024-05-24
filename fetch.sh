#!/usr/bin/env bash

# Script to fetch crossword from New York Times
# Requires cookies (authentication) 
# See https://www.reddit.com/r/crossword/comments/dqtnca/my_automatic_nyt_crossword_downloading_script/

cookies=/Users/lpoon/nytcrossword/cookies.txt
dest=/Users/lpoon/nytcrossword/
cd $dest

today=`date +%Y-%m-%d`
longdate=`date`
echo " " 
echo "Today is $longdate" 
echo "Fetching puzzle.json..."
curl -s -b "$cookies" "https://www.nytimes.com/svc/crosswords/v3/36569100/puzzles.json?publish_type=daily&sort_order=desc&sort_by=print_date" --output nytpuzzles.json
puzzid=`cat nytpuzzles.json | /opt/homebrew/bin/jq '.results[0].puzzle_id'`

echo "Found puzzle id for today: $puzzid"

echo "Trying to fetch $puzzid.pdf..."
curl -s -b "$cookies" "https://www.nytimes.com/svc/crosswords/v2/puzzle/$puzzid.pdf"  --output "$today.pdf"
echo "Saved pdf to $today.pdf"


# Set up variables for mail
subject="NYT Crossword for $today"
body="Enjoy from LP"
attachmentPath="/Users/lpoon/nytcrossword/$today.pdf"

# OPTIONALLY, check if today is Sunday, and if so print out crossword
# Get the day of the week (0-6, where 0 is Sunday)
day_of_week=$(date +%w)
# Check if the day of the week is Sunday (0)
if [ "$day_of_week" -eq 0 ]; then
    echo "Today is Sunday."
    # Print out a copy
    lp "$today.pdf"
    # Send fanny a copy
    /usr/bin/osascript /Users/lpoon/nytcrossword/sendmail.scpt
    /usr/bin/osascript /Users/lpoon/nytcrossword/sendmail.scpt "Fanny Poon" "fpoon2008@gmail.com" "$subject" "$body" "$attachmentPath"
else
    echo "Today is not Sunday."
fi
echo "Mailing out pdf"
/usr/bin/osascript /Users/lpoon/nytcrossword/sendmail.scpt "Laurie Poon" "laurie_poon@yahoo.com" "$subject" "$body" "$attachmentPath"

# Save a copy to Dropbox
cp "$today.pdf" /Users/lpoon/Dropbox/NYT_Crosswords

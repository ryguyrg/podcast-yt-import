#!/usr/bin/python
from subprocess import call
import xml.etree.cElementTree as ET
import urllib
import urllib2
import re
import os.path

tree = ET.ElementTree(file=urllib2.urlopen('http://feeds.soundcloud.com/users/soundcloud:users:141739624/sounds.rss'))

root = tree.getroot()
root.tag, root.attrib

for item in root.iter('item'):
  podcast_title = item.find('title').text
  podcast_url = item.find('enclosure').attrib['url']
  match = re.search('([^/]*)$', podcast_url)
  podcast_file = match.group(0)
  match = re.search('(.*) \d\d\:\d\d\:\d\d \+\d*$', item.find('pubDate').text )
  podcast_date = match.group(1)
  podcast_description = "%s by Rik Van Bruggen.  Uploaded on: %s" % (podcast_title, podcast_date)
  
#  print podcast_file
#  print podcast_title, ' @ ', podcast_url
  if (not os.path.isfile("./podcasts/%s" % (podcast_file))):
    urllib.urlretrieve(podcast_url, "./podcasts/%s" % (podcast_file))
    call(['bash', './make_video.sh', "./podcasts/%s" % (podcast_file), podcast_title])
    podcast_video_file = re.sub(r'\.mp3', '-video.mp4', podcast_file)
    call(["python", './upload_youtube.py',"--file","./podcasts/%s" % (podcast_video_file),"--title","%s" % (podcast_title), "--description", "%s" % (podcast_description)])
  else:
    print('Skipping: %s' % (podcast_file))

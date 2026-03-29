#!/usr/bin/python
#-*- coding:utf-8 -*-

import sys, requests

def mywrite():
    img = sys.argv[1]
    botName = sys.argv[2]
    msg = sys.argv[3]
    url = sys.argv[4]

    myobj = {'botIconImage': img , 'botName':botName, 'text': msg}
    x = requests.post(url, json = myobj)

print( sys.argv[1] )
mywrite()

#!/usr/bin/env python3
#-*- coding: utf-8 -*-

import os
import re
import sys

CONF='/etc/asterisk'
TAGFILE='/var/lib/vim/tags'

def parse_conf(filename):
    val = {}
    for line in open(filename):
        reg = re.match(r'\[([^\s]+)\]', line)
        if reg:
            tag = reg.groups()[0]
            if tag.startswith('macro-'):
                tag = tag[len('macro-'):]
            val[tag] = [tag, filename, '/^{0}$/;"'.format(line.strip()), 's']
    return val

def parse_ael(filename):
    val = {}
    for line in open(filename):
        reg = re.match(r'(context|macro) ([^\s({]+)', line)
        if reg:
            tag = reg.groups()[1]
            val[tag] = [tag, filename, '/^{0}$/;"'.format(line.strip()), 's']
    return val


tags = {}
for dirpath, dirnames, filenames in os.walk(CONF, followlinks=True):
    for i in filenames:
        if re.match(r'^(sip|exten|pjsip|queue).*conf$', i):
            tags.update(parse_conf(os.path.join(dirpath,i)))
        elif i.endswith('.ael'):
            tags.update(parse_ael(os.path.join(dirpath,i)))


outfile = open(TAGFILE, 'w')
for k in sorted(tags.keys()):
    outfile.write('\t'.join(tags[k]) + '\n')

outfile.close()

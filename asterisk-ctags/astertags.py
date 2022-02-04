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


tags = {}
for dirpath, dirnames, filenames in os.walk(CONF):
    for i in filenames:
        if re.match(r'(sip|exten).*conf$', i):
            tags.update(parse_conf(os.path.join(CONF,i)))

outfile = open(TAGFILE, 'w')
for k in sorted(tags.keys()):
    outfile.write('\t'.join(tags[k]) + '\n')

outfile.close()

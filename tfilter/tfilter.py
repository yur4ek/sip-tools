#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import re
from textwrap import dedent

if len(sys.argv) != 2:
    print(dedent("""\
    Usage:
    tail -f /var/log/asterisk/full | tfilter.py KEYWORD
    or
    cat /var/log/asterisk/full | tfilter.py KEYWORD"""))
    exit(1)


keyword = sys.argv[1]
call_ids = []
callid = re.compile('(?<=\[)C-[\da-f]{8}')
err_check = re.compile('WARNING|ERROR')
sreg = None
i = 0
counters = {}
stdin = open(sys.stdin.fileno(), errors='ignore')
try:
    for line in stdin:
        if keyword in line:
            try:
                c = callid.search(line).group()
            except:
                continue
            if c not in call_ids:
                call_ids.append(c)
                sreg = re.compile('|'.join(reversed(call_ids)))
                counters[c] = i

        if sreg and sreg.search(line):
            if err_check.search(line):
                print(line.strip())

            counters[callid.search(line).group()] = i
            if i % 10000 == 0:
                t = []
                for k, v in counters.items():
                    if i - v > 10000:
                        t.append(k)
                for k in t:
                    counters.pop(k)
                    call_ids.remove(k)
                sreg = re.compile('|'.join(reversed(call_ids)))
        i += 1
except KeyboardInterrupt:
    pass
except:
    print(line)
    raise

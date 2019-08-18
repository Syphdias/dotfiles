#!/usr/bin/env python3
from json import loads
from subprocess import check_output, call

output = check_output(['i3-msg', '-t', 'get_workspaces'])
workspaces = loads(output)

next_num = next(i for i in range(1, 100) if not [ws for ws in workspaces if ws['num'] == i])

call(['i3-msg', 'move container to workspace number {}; workspace number {}'.format(next_num, next_num)])

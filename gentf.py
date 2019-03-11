#!/usr/bin/env python3
import yaml, os
from pprint import pprint
from jinja2 import Environment, FileSystemLoader

with open("data.yaml") as fh:
    data = yaml.safe_load(fh)

# Capture our current directory
# THIS_DIR = os.path.dirname(os.path.abspath(__file__))
THIS_DIR = os.getcwd()
j2_env = Environment(loader=FileSystemLoader(THIS_DIR), trim_blocks=True)

def redner_tf(tpl, tfo, data):
    # Renders tpl with yamldoc, write output to tfo

    tpl = j2_env.get_template(tpl)
    # Loops on VMs from yaml, and render them one by one
    # appending result to tf_out
    # for item in items:
    tf_out = tpl.render(data)

    with open(tfo, 'w') as tfo:
        tfo.write(tf_out)

redner_tf('main.j2', 'main.tf', data)
redner_tf('vm.j2', 'vm.tf', data)
redner_tf('network.j2', 'network.tf', data)
redner_tf('backup.j2', 'backup.tf', data)
redner_tf('vpn.j2', 'vpn.tf', data)

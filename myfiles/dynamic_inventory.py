#!/usr/bin/env python3
import re
import json
import subprocess

pattern = r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

master_public_ip = re.findall(pattern, subprocess.run(["terraform", "output", "ARM_Master_public_ip"], stdout=subprocess.PIPE).stdout.decode("utf-8"))
node_public_ip = re.findall(pattern, subprocess.run(["terraform", "output", "ARM_Node_public_ip"], stdout=subprocess.PIPE).stdout.decode("utf-8"))
master_private_ip = re.findall(pattern, subprocess.run(["terraform", "output", "ARM_Master_private_ip"], stdout=subprocess.PIPE).stdout.decode("utf-8"))
node_private_ip = re.findall(pattern, subprocess.run(["terraform", "output", "ARM_Node_private_ip"], stdout=subprocess.PIPE).stdout.decode("utf-8"))

master_hosts = [f"master-{i}" for i in range(1, len(master_public_ip)+1)]
node_hosts = [f"node-{i}" for i in range(1, len(node_public_ip)+1)]
hostvars_master = {master_hosts[i]: {"ansible_host": master_public_ip[i], "ip": master_private_ip[i]} for i in range(len(master_public_ip))}
hostvars_node = {node_hosts[i]: {"ansible_host": node_public_ip[i], "ip": node_private_ip[i]} for i in range(len(node_public_ip))}

inventory_pattern = {
        "hosts": master_hosts + node_hosts,
        "kube_control_plane": master_hosts,
        "kube_node": node_hosts,
        "etcd": [master_hosts[-1]],
        "k8s_cluster": master_hosts + node_hosts,
        "_meta": {
          "hostvars": hostvars_master|hostvars_node
                  }
                     }

print(json.dumps(inventory_pattern))

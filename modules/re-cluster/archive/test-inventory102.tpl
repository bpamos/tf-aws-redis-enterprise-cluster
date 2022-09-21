join("\n", [
    for x in range(length(re-node-eip-public-dns)):
        "${re-node-eip-public-dns[x]} internal_ip=${re-node-internal-ips[x]} external_ip=${re-node-eip-ips[x]}"
    ]
)
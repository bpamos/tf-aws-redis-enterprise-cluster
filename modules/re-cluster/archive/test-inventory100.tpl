%{ for ip in split(",", re-data-node-info) ~}
${ip}
%{ endfor ~}

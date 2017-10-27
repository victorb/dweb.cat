*                         
log / /var/log/caddy-access.log "{remote} - {host} - {upstream} - {user} [{when}] \"{method} {uri} {proto}\" {status} {size}"

proxy / ${upstreams} {      
        policy least_conn 
        fail_timeout 10s  
        max_fails 2       
        max_conns 100     
        try_duration 1s   
        try_interval 250ms                          
        health_check /ipfs/QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o                               
        health_check_interval 30s                   
        health_check_timeout 1s                     
        transparent       
}                         

tls {                     
        max_certs 50      
}                         
proxy /ipfs ${upstreams} {  
        policy least_conn 
        fail_timeout 10s  
        max_fails 2       
        max_conns 100     
        try_duration 1s   
        try_interval 250ms                          
        health_check /ipfs/QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o                               
        health_check_interval 30s                   
        health_check_timeout 1s                     
        transparent       
}                         

# TODO should contain resolve for website           

# Everything else than /ipfs should show archive.dweb.cat                                               


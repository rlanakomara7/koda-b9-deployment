1. 
```sh
sudo useradd -m koda
sudo useradd -m dako
sudo groupadd devteam
sudo usermod -aG devteam koda
sudo usermod -aG devteam dako
sudo mkdir -p /srv/projectX

```

2. 
```sh
sudo chown koda:devteam /srv/projectX
```

3. 
```sh
sudo chmod 750 /srv/projectX
```

4. 
```sh
sudo -u koda mkdir -p /srv/projectX/src /srv/projectX/data
sudo -u koda touch /srv/projectX/README.md
sudo -u koda touch /srv/projectX/src/app.sh
sudo -u koda touch /srv/projectX/data/input.txt
```

5. 
```sh
sudo chmod ug+x,o-x /srv/projectX/src/app.sh
```

6. 
```sh
sudo chmod 600 /srv/projectX/data/input.txt
```

7. 
```sh
sudo chmod -R g+rwX /srv/projectX/src
```

8. 
```sh
sudo chown -R koda:devteam /srv/projectX
```

9. 
```sh
sudo chown -R :devteam /srv/projectX
sudo chmod 2775 /srv/projectX
```

10.
```sh
chmod 644 README.md
```

11
```sh
sudo chown dako:devteam -R projectX
```





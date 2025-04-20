# unrealircd-docker

A container image, readily available for use.


## Download

    podman pull quay.io/kareiva/unrealircd:latest


## Use

Create a `compose.yaml`:

	services:
	  ircd:
	    image: quay.io/kareiva/unrealircd:latest
	    ports:
	      - 6667:6667
	      - 6668:6668
	      - 7001:7001
	    volumes:
	      - ./unrealircd.conf:/app/unrealircd/conf/unrealircd.conf
	      - ./tls:/app/unrealircd/conf/tls/
	      - ./data:/app/unrealircd/data/

Run:

    docker compose up -d


## Resources

https://quay.io/repository/kareiva/unrealircd

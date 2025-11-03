![container build status](https://quay.io/repository/kareiva/unrealircd/status)

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

    podman compose up -d

To support dynamic configuration rehashing, mount the unrealircd.conf
file through a separate folder, i.e. `conf.d` or similar path. In such
setup, the changes to the unrealircd.conf file on the host will be
immediately reflected inside the container.

## Resources

https://quay.io/repository/kareiva/unrealircd?tab=tags

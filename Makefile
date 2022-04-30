all: app_container

app_container: base_container app.dockerfile
	docker build -t rss-app -f app.dockerfile .

base_container: systemd.dockerfile
	docker build -t ruby3-systemd -f systemd.dockerfile .

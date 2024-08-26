# Python Dev Environment for Docker

Tutorial: <https://www.youtube.com/watch?v=0H2miBK_gAk>
Repo: <https://github.com/patrickloeber/python-docker-tutorial>
Readme: <https://github.com/patrickloeber/python-docker-tutorial/blob/main/dev-environment/README.md>

## Build

> docker build -t fastapi-image .

## Run

> docker run --name fastapi-container -p 80:80 -d -v $(pwd):/code fastapi-image

## Compose

add `--build` if parameters changed (e.g. `requirements.txt`)

> docker compose up [--build] -d

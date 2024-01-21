# Lighthouse

## base image

[femtopixel/docker-google-lighthouse](https://github.com/femtopixel/docker-google-lighthouse/tree/master)

## build image

```
docker build -t elaine-lighthouse .
```

## run image

```
docker run \
  -e MIN_PERFORMANCE_SCORE=50 \
  -e MIN_ACCESSIBILITY_SCORE=50 \
  -e MIN_BEST_PRACTICES_SCORE=50 \
  -e MIN_SEO_SCORE=50 \
  -e OUTPUT_DIR="/home/chrome/elaine" \
    elaine-lighthouse \
    "https://kim85326.github.io/"
```

```
docker run -it --name lighthouse -v $PWD/reports:/home/chrome/reports elaine-lighthouse /bin/bash
```
```
export MIN_PERFORMANCE_SCORE=80
export MIN_ACCESSIBILITY_SCORE=90
export MIN_BEST_PRACTICES_SCORE=90
export MIN_SEO_SCORE=90
./entrypoint.sh "https://kim85326.github.io/"
```

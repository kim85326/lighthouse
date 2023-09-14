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
    elaine-lighthouse \
    https://kim85326.github.io/
```

#!/bin/sh

LANG=C date > .push-build

git add .push-build && git commit -m 'Force repo building' && git push

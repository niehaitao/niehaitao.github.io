# TL;DR for DEV and OPS

https://niehaitao.github.io/

or

http://127.0.0.1:4000/niehaitao/ by building locally as

```bash

docker run -d --name jekyll-site \                                                                                                                                             ─╯
  -v "$PWD:/site" \
  -p 4000:4000 \
  jekyll/jekyll:3.8 tail -f /dev/null

docker exec -it jekyll-site sh
cd /site
jekyll serve --config _config.yml,_config.dev.yml

# bundle update
# bundle install
# bundle exec jekyll build --config _config.yml,_config.dev.yml
# bundle exec jekyll serve --config _config.yml,_config.dev.yml --port 4444 
```

## References

- [Ruby 101](https://jekyllrb.com/docs/ruby-101/)
- [Setting up a Jekyll site with GitHub Pages](https://jekyllrb.com/docs/github-pages/)
- [Configuring GitHub Metadata](https://github.com/jekyll/github-metadata/blob/master/docs/configuration.md#configuration)
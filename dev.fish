function dev
  docker run -v /Users/mmaddern/git:/home/mmaddern/git \
             -v /Users/mmaddern/nso:/home/mmaddern/nso:delegated \
             -v /Users/mmaddern/.ssh:/home/mmaddern/.ssh \
             -v tme-demo-node-modules:/home/mmaddern/nso/git/tme-demo/packages/tme-demo-ui/src/webui/node_modules \
             -p 80:8080 \
             --hostname maddn-dev \
             --rm -it maddn-dev $argv
end

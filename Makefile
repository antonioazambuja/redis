REDIS_VERSION = 5.0.7
REDIS_MASTER_PASSWORD = password
REDIS_BUILDED_CONTAINER = redis_custom:latest

build : ; docker build \
          --build-arg REDIS_VERSION=$(REDIS_VERSION) \
          --build-arg REDIS_MASTER_PASSWORD=$(REDIS_MASTER_PASSWORD) \
          -t $(REDIS_BUILDED_CONTAINER) .

run : ; docker run -p 6379:6379/tcp -t $(REDIS_BUILDED_CONTAINER)

run_it : ; docker run -p 6379:6379/tcp -it $(REDIS_BUILDED_CONTAINER) sh
BUILD_DIR=build
APPS=front-end quotes newsfeed
LIBS=common-utils
STATIC_BASE=front-end/public
STATIC_PATHS=css
STATIC_ARCHIVE=$(BUILD_DIR)/static.tgz
INSTALL_TARGETS=$(addsuffix .install, $(LIBS))
APP_JARS=$(addprefix $(BUILD_DIR)/, $(addsuffix .jar, $(APPS)))

all: $(BUILD_DIR) $(APP_JARS) $(STATIC_ARCHIVE)

libs: $(INSTALL_TARGETS)

static: $(STATIC_ARCHIVE)

containers: container-front-end container-quotes container-newsfeed container-static-assets

push-containers: push-container-front-end push-container-quotes push-container-newsfeed push-container-static-assets


container-front-end: 
	docker build -t assessment-front-end --target assessment-front-end .

push-container-front-end: 
	docker tag assessment-front-end localhost:32000/assessment-front-end
	docker push localhost:32000/assessment-front-end

container-quotes: 
	docker build -t assessment-quotes --target assessment-quotes .

push-container-quotes: 
	docker tag assessment-quotes localhost:32000/assessment-quotes
	docker push localhost:32000/assessment-quotes

container-newsfeed: 
	docker build -t assessment-newsfeed --target assessment-newsfeed .

push-container-newsfeed: 
	docker tag assessment-newsfeed localhost:32000/assessment-newsfeed
	docker push localhost:32000/assessment-newsfeed

container-static-assets: 
	docker build -t assessment-static-assets --target assessment-static-assets .

push-container-static-assets: 
	docker tag assessment-static-assets localhost:32000/assessment-static-assets
	docker push localhost:32000/assessment-static-assets




%.install:
	cd $* && lein install

test: $(addsuffix .test, $(LIBS) $(APPS))

%.test:
	cd $* && lein midje

clean:
	rm -rf $(BUILD_DIR) $(addsuffix /target, $(APPS))

$(APP_JARS): | $(BUILD_DIR)
	cd $(notdir $(@:.jar=)) && lein uberjar && cp target/uberjar/*-standalone.jar ../$@

$(STATIC_ARCHIVE): | $(BUILD_DIR)
	tar -c -C $(STATIC_BASE) -z -f $(STATIC_ARCHIVE) $(STATIC_PATHS)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

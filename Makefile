SRC_DIR = plugin
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

JS_ENGINE ?= `which node nodejs`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe

BASE_DIRS = `ls ${SRC_DIR}`

DOC_DIR = doc
DOC_LIST = `ls ${DOC_DIR}/md/`

all: clean core doc

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

core: jstatui min lint
	@@echo "jStat UI build complete."

min: jstatui plugin_min

lint: jstatui
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Checking jStat UI against JSHint..."; \
		${JS_ENGINE} ${BUILD_DIR}/jshint-check.js; \
	else \
		echo "You must have NodeJS installed in order to test jStat UI against JSHint."; \
	fi

jstatui: ${DIST_DIR}
	@@echo "DEBUG: ${BASE_DIRS}"
	@@for i in ${BASE_DIRS}; do \
		echo "Building" ${i}; \
		cat ${SRC_DIR}/${i}/*.js > ${DIST_DIR}/${i}.js; \
	done

plugin_min: jstatui
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Minifying jStat UI" ${JS_MIN}; \
		${COMPILER} ${JS} > ${JS_MIN}; \
	else \
		echo "You must have NodeJS installed in order to minify jStat UI."; \
	fi

${DIST_DIR}:
	@@mkdir -p ${DIST_DIR}

doc:
	@@echo 'Generating documentation...'
	@@mkdir -p ${DIST_DIR}/docs/assets
	@@cp ${DOC_DIR}/assets/*.css ${DIST_DIR}/docs/assets/
	@@cp ${DOC_DIR}/assets/*.js ${DIST_DIR}/docs/assets/
	@@for i in ${DOC_LIST}; do \
		${JS_ENGINE} ${BUILD_DIR}/doctool.js ${DOC_DIR}/assets/template.html ${DOC_DIR}/md/$${i} ${DIST_DIR}/docs/$${i%.*}.html; \
	done

.PHONY: all clean core min lint jstatui plugin_min doc

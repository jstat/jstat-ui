SRC_DIR = plugin
BUILD_DIR = build

PREFIX = .
DIST_DIR = ${PREFIX}/dist

JS_ENGINE ?= `which node nodejs`
COMPILER = ${JS_ENGINE} ${BUILD_DIR}/uglify.js --unsafe

FLOT_DIR = ${SRC_DIR}/flot
FLOT_FILES = ${FLOT_DIR}/core.js

DOC_DIR = doc
DOC_LIST = `ls ${DOC_DIR}/md/`

all: clean core doc

clean:
	@@echo "Removing Distribution directory:" ${DIST_DIR}
	@@rm -rf ${DIST_DIR}

core: flot min lint
	@@echo "jStat UI build complete."

min: flot
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Minifying jStat UI" ${JS_MIN}; \
		for X in `ls ${DIST_DIR}/*.js | xargs basename`; do \
			${COMPILER} ${DIST_DIR}/$${X} > ${DIST_DIR}/`echo $${X} | sed 's/\..*//g'`.min.js; \
		done; \
	else \
		echo "You must have NodeJS installed in order to minify jStat UI."; \
	fi

lint: flot
	@@if test ! -z ${JS_ENGINE}; then \
		echo "Checking jStat UI against JSHint..."; \
		${JS_ENGINE} ${BUILD_DIR}/jshint-check.js; \
	else \
		echo "You must have NodeJS installed in order to test jStat UI against JSHint."; \
	fi

flot: ${DIST_DIR}
	@@echo "Building Flot"
	@@cat ${FLOT_FILES} > ${DIST_DIR}/flot.js

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

.PHONY: all clean core min lint flot doc

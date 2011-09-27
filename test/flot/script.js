$(function() {
	$( '#dist-select' ).buttonset();
	$( '#plot-select' ).buttonset();

	var opts = {
		beta : {
			inst : jStat.beta( 3, 4 ),
			pdf : { label : 'PDF' },
			cdf : { label : 'CDF' },
			options : {}
		},
		cauchy : {
			inst : jStat.cauchy( 3, 4 ),
			pdf : { label : 'PDF' },
			cdf : { label : 'CDF' },
			options : {
				start : -20,
				stop : 20
			}
		},
		studentt : {
			inst : jStat.studentt( 4 ),
			pdf : { label : 'PDF' },
			cdf : { label : 'CDF' },
			options : {
				start : -6,
				stop : 6
			}
		},
		flotopts : {
			one : {
				yaxes : [{}]
			},
			both : {
				yaxes : [{}, { position : 'right' }]
			}
		}
	},
	currentPlot = {
		dist : opts.beta,
		data : [ 'pdf' ]
	};

	function rePlot() {
		var data = [],
			i = 0;
		for ( ; i < currentPlot.data.length; i++ ) {
			currentPlot.dist[ currentPlot.data[ i ]].data = currentPlot.dist.inst[ currentPlot.data[ i ]];
			data.push( currentPlot.dist[ currentPlot.data[ i ]]);
			if ( i > 0 ) {
				data[i].yaxis = 2;
			}
		}
		j$.flot( '#ui-graph', data, currentPlot.dist.options );
	}

	$( '#dist-select input' ).click(function() {
		var $this = $( this );
		if ( $this.is( '#dist-beta' )) {
			currentPlot.dist = opts.beta;
		} else if ( $this.is( '#dist-cauchy' )) {
			currentPlot.dist = opts.cauchy;
		} else if ( $this.is( '#dist-studentt' )) {
			currentPlot.dist = opts.studentt;
		}
		rePlot();
	});

	$( '#plot-select input' ).click(function() {
		var $this = $( this );
		if ( $this.is( '#plot-pdf' )) {
			currentPlot.data = [ 'pdf' ];
			currentPlot.options = opts.flotopts.one;
			currentPlot.dist.options.flotopts = opts.flotopts.pdf;
		} else if ( $this.is( '#plot-cdf' )) {
			currentPlot.data = [ 'cdf' ];
			currentPlot.dist.options.flotopts = opts.flotopts.cdf;
		} else if ( $this.is( '#plot-both' )) {
			currentPlot.data = [ 'pdf', 'cdf' ];
			currentPlot.dist.options.flotopts = opts.flotopts.both;
		}
		rePlot();
	});

	$( '#dist-beta' ).click();
	$( '#plot-both' ).click();
});

module.exports = function(grunt) {
	// Load dev dependencies
	require('load-grunt-tasks')(grunt);

	// Time how long tasks take for build time optimizations
	require('time-grunt')(grunt);

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),

		// The actual grunt server settings
		connect: {
			options: {
				port: 9000,
				livereload: 35729,
				// Change this to '0.0.0.0' to access the server from outside
				hostname: 'localhost'
			},
			livereload: {
				options: {
					open: true
				}
			}
		},

		uglify: {
			options: {},
			theater: {
				files: {
					'js/theater.min.js': [ 'js/theater.js' ]
				}
			}
		},

		watch: {
			// Watch javascript files for minifying
			js: {
				files: [ 'js/theater.js' ],
				tasks: ['uglify']
			},
			// Live reload
			reload: {
				options: {
					livereload: '<%= connect.options.livereload %>'
				},
				files: [
					'<%= watch.js.files %>',
					'css/*.css',
					'*.html'
				]
			}
		}
	});

	grunt.registerTask('serve', function () {
		grunt.task.run([
			'connect:livereload',
			'watch'
		]);
	});

	grunt.registerTask('default', ['newer:uglify', 'serve']);
};

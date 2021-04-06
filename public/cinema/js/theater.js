window.open = function() { return null; }; // prevent popups

var theater = {

	VERSION: '1.1.10',

	playerContainer: null,
	playerContent: null,
	// closedCaptions: false,
	// language: "en",
	hdPlayback: false,
	player: null,
	volume: 25,
	syncMaxDiff: 5,

	getPlayerContainer: function() {
		if ( this.playerContainer === null ) {
			this.playerContainer = document.getElementById('player-container') ||
				document.createElement('div');
		}
		return this.playerContainer;
	},

	getPlayerContent: function() {
		if ( this.playerContent === null ) {
			this.playerContent = document.getElementById('content') ||
				document.createElement('div');
		}
		return this.playerContent;
	},

	resetPlayer: function() {
		if ( this.player ) {
			this.player.onRemove();
			delete this.player;
		}
		this.getPlayerContainer().innerHTML = "<div id='player'></div>";
	},

	enablePlayer: function() {
		// Show player
		var player = this.getPlayerContainer();
		player.style.display = "block";

		// Hide content
		var content = this.getPlayerContent();
		content.style.display = "none";
	},

	disablePlayer: function() {
		// Hide player
		var player = this.getPlayerContainer();
		player.style.display = "none";

		this.resetPlayer();

		// Show content
		var content = this.getPlayerContent();
		content.style.display = "block";
	},

	getPlayer: function() {
		return this.player;
	},

	loadVideo: function( type, data, startTime ) {

		if ( ( type === null ) || ( data === null ) ) return;
		
		if ( type === "" ) {
			this.disablePlayer();
			return;
		}

		startTime = Math.max( 0, startTime );

		var player = this.getPlayer();

		// player doesn't exist or is different video type
		if ( (player === null) || (player.getType() != type) ) {

			this.resetPlayer();
			this.enablePlayer();

			var playerObject = getPlayerByType( type );
			if ( playerObject !== null ) {
				this.player = new playerObject();
			} else {
				this.getPlayerContainer().innerText = "Video type not yet implemented.";
				return;
			}

		}

		this.player.setVolume( (this.volume !== null) ? this.volume : 25 );
		this.player.setStartTime( startTime || 0 );
		this.player.setVideo( data );

	},

	setVolume: function( volume ) {
		this.volume = volume;
		if ( this.player !== null ) {
			this.player.setVolume( volume );
		}
	},

	seek: function( seconds ) {
		var player = this.getPlayer();
		if ( player ) {
			player.seek( seconds );
		}
	},

	enableHD: function() {
		this.hdPlayback = true;
	},

	isHDEnabled: function() {
		return this.hdPlayback;
	},

	sync: function( time ) {

		if ( time === null ) return;

		if ( this.player !== null ) {

			var current = this.player.getCurrentTime();
			if ( ( current !== null ) &&
				( Math.abs(time - current) > this.syncMaxDiff ) ) {
				this.player.setStartTime( time );
			}

		}

	},

	toggleControls: function( enabled ) {
		if ( this.player !== null ) {
			this.player.toggleControls( enabled );
		}
	},

	/*
		Google Chromeless player doesn't support closed captions...
		http://code.google.com/p/gdata-issues/issues/detail?id=444
	*/
	
	enableCC: function() {
		this.closedCaptions = true;
	},

	isCCEnabled: function() {
		return this.closedCaptions;
	}

	/*

	setLanguage: function( language ) {
		this.language = language;
	}
	*/

};


var players = [];

function getPlayerByType( type ) {
	return players[ type ];
}

var DefaultVideo = function() {};
DefaultVideo.prototype = {
	player: null,

	lastVideoId: null,
	videoId: null,

	lastVolume: null,
	volume: 0.123,

	currentTime: 0,

	getCurrentTime: function() {
		return null;
	},

	lastStartTime: 0,
	startTime: 0,

	setVolume: function( volume ) {},
	setStartTime: function( seconds ) {},
	seek: function( seconds ) {},
	onRemove: function() {},
	toggleControls: function() {}
};

function registerPlayer( type, object ) {
	object.prototype = new DefaultVideo();
	object.prototype.type = type;
	object.prototype.getType = function() {
		return this.type;
	};

	players[ type ] = object;
}

(function() {

	var YouTubeVideo = function() {

		/*
			Embed Player Object
		*/
		var player;

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastStartTime = null;
			this.lastVideoId = null;
			this.videoId = id;

			if (player) { return; }

			player = new YT.Player('player', {
				height: '100%',
				width: '100%',
				videoId: id,
                host: 'https://www.youtube-nocookie.com', //GDPR Friendly
				playerVars: {
					autoplay: 1,
					controls: 0,
                    showinfo: 0,
                    modestbranding: 1,
                    disablekb: 0,
                    rel: 0,
                    origin: location.origin,
					iv_load_policy: 3, // hide annotations
					cc_load_policy: theater.closedCaptions ? 1 : 0
				},
				events: {
					onReady: onYouTubePlayerReady,
				}
			});
		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume;
		};

		this.setStartTime = function( seconds ) {
			this.lastStartTime = null;
			this.startTime = seconds;
		};

		this.seek = function( seconds ) {
			if ( this.player !== null ) {
				this.player.seekTo( seconds, true );

				// Video isn't playing
				if ( this.player.getPlayerState() != 1 ) {
					this.player.playVideo();
				}
			}
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/
		this.getCurrentTime = function() {
			if ( this.player !== null ) {
				return this.player.getCurrentTime();
			}
		};

		this.think = function() {

			if ( this.player !== null ) {

				if ( this.videoId != this.lastVideoId ) {
					this.player.loadVideoById( this.videoId, this.startTime );
					this.lastVideoId = this.videoId;
					this.lastStartTime = this.startTime;
				}

				if ( this.player.getPlayerState() != -1 ) {

					if ( this.startTime != this.lastStartTime ) {
						this.seek( this.startTime );
						this.lastStartTime = this.startTime;
					}

					if ( this.volume != this.lastVolume ) {
						this.player.setVolume( this.volume );
						this.lastVolume = this.volume;
					}

				}
			}

		};

		this.onReady = function() {
			this.player = player;

			if ( theater.isHDEnabled() ) {
				this.player.setPlaybackQuality("hd720");
			}

			this.interval = setInterval( this.think.bind(this), 100 );
		};

	};
	registerPlayer( "youtube", YouTubeVideo );
	registerPlayer( "youtubelive", YouTubeVideo );

	var TwitchStreamVideo = function() {

		/*
			Embed Player Object
		*/

		var self = this;
		var player;

		/*
			Standard Player Methods
		*/

		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;

			if (player) { return; }

			player = new Twitch.Embed('player', {
				channel: id,
				autoplay: true,
				layout: "video",
				width: window.innerWidth,
				height: window.innerHeight,
			});

			player.addEventListener(Twitch.Embed.VIDEO_READY, () => {
				this.onReady()
			});
		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume;
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/

		this.think = function() {
			if ( this.player !== null ) {

				if ( this.videoId != this.lastVideoId ) {
					player.setChannel(this.videoId);
					this.lastVideoId = this.videoId;
					this.lastStartTime = this.startTime;
				}

				if ( !player.isPaused() ) {

					if ( this.volume != this.lastVolume ) {
						player.setVolume( this.volume / 100 );
						this.lastVolume = this.volume;
					}

				}
			}
		};

		this.onReady = function() {
			this.player = document.getElementById('player');

			if (this.interval) {
				clearInterval(this.interval)
			}
			this.interval = setInterval( this.think.bind(this), 100 );
		};
		this.toggleControls = function( enabled ) {};

	};
	registerPlayer( "twitchstream", TwitchStreamVideo );


	var FileVideo = function() {

		/*
			Embed Player Object
		*/
		var player;

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastStartTime = null;
			this.lastVideoId = null;
			this.videoId = id;

			if (player) { return; }

			this.element = document.getElementById('player');
			player = document.createElement("video");
			player.autoplay = true;
			player.src = id;

			player.style.width = "100%";
			player.style.height = "100%";

			this.element.appendChild(player);

			var self = this; // Why...
			player.onloadedmetadata = function() {
				self.onReady()
			}; 
		}

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume;
		};

		this.setStartTime = function( seconds ) {
			this.lastStartTime = null;
			this.startTime = seconds;
		};

		this.seek = function( seconds ) {
			if ( this.player !== null ) {
				this.player.currentTime = seconds;

				// Video isn't playing
				if ( this.player.paused ) {
					this.player.play();
				}
			}
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/
		this.getCurrentTime = function() {
			if ( this.player !== null ) {
				return this.player.currentTime;
			}
		};

		this.think = function() {

			if ( this.player !== null ) {

				if ( this.videoId != this.lastVideoId ) {
					this.player.src = this.videoId + "#t=" + this.startTime
					this.lastVideoId = this.videoId;
					this.lastStartTime = this.startTime;
				}

				if ( !this.player.paused ) {

					if ( this.startTime != this.lastStartTime ) {
						this.player.currentTime = this.startTime;
						this.lastStartTime = this.startTime;
					}

					if ( this.volume != this.lastVolume ) {
						this.player.volume = this.volume / 100 ;
						this.lastVolume = this.volume;
					}

				}
			}

		};

		this.onReady = function() {
			this.player = player;

			this.interval = setInterval( this.think.bind(this), 100 );
		};

	};
	registerPlayer( "archive", FileVideo );

})();

/*
	API-specific global functions
*/

function onYouTubePlayerReady( playerId ) {
	var player = theater.getPlayer(),
		type = player && player.getType();
	if ( player && ((type == "youtube") || (type == "youtubelive")) ) {
		player.onReady();
	}
}

if (window.onTheaterReady) {
	onTheaterReady();
}

console.log("Loaded theater.js v" + theater.VERSION);
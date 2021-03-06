if (window.swfobject === undefined) window.swfobject = null;
window.open = function() { return null; }; // prevent popups

var theater = {

	VERSION: '1.1.7',

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

	/*clickPlayerCenter: function() {
		var evt = document.createEvent("MouseEvents");

		var player = document.getElementById("player");

		var w = player.clientWidth / 2,
			h = player.clientHeight / 2;

		evt.initMouseEvent("click", true, true, window,
			0, 0, 0, w, h, false, false, false, false, 0, null);

		this.getPlayer().dispatchEvent(evt);
	},

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

/*
	If someone is reading this and trying to figure out how
	I implemented each player API, here's what I did.

	To avoid endlessly searching for API documentations, I
	discovered that by decompiling a swf file, you can simply
	search for "ExternalInterface.addCallback" for finding
	JavaScript binded functions. And by reading the actual 
	source code, things should be much easier.

	This website provides a quick-and-easy way to decompile
	swf code http://www.showmycode.com/

	If you need additional information, you can reach me through
	the following contacts:

	samuelmaddock.com
	samuel.maddock@gmail.com
	http://steamcommunity.com/id/samm5506


	Test Cases

	theater.loadVideo( "youtube", "JVxe5NIABsI", 30 )
	theater.loadVideo( "youtubelive", "0Sdkwsw2Ji0" )
	theater.loadVideo( "vimeo", "55874553", 30 )
	theater.loadVideo( "twitch", "mega64podcast,c4320640", 30*60 )
	theater.loadVideo( "twitch", "cosmowright,c1789194" )
	theater.loadVideo( "twitchstream", "ignproleague" )
	Justin.TV Support removed 8-5-2014
	theater.loadVideo( "blip", "6484826", 60 )
	theater.loadVideo( "html", "<span style='color:red;'>Hello world!</span>", 10 )
	theater.loadVideo( "viooz", "", 0 )

*/
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
				playerVars: {
					autoplay: 1,
					controls: 0,
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

		this.canChangeTime = function() {
			if ( this.player !== null ) {
				//Is loaded and it is not buffering
				return this.player.getVideoBytesTotal() != -1 &&
				this.player.getPlayerState() != 3;
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

	var VimeoVideo = function() {

		var self = this;

		this.froogaloop = null;

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.videoId = id;

			var elem = document.getElementById("player1");
			if (elem) {
				$f(elem).removeEvent('ready');
				this.froogaloop = null;
				elem.parentNode.removeChild(elem);
			}

			var url = "http://player.vimeo.com/video/" + id + "?api=1&player_id=player1";

			var frame = document.createElement('iframe');
			frame.setAttribute('id', 'player1');
			frame.setAttribute('src', url);
			frame.setAttribute('width', '100%');
			frame.setAttribute('height', '100%');
			frame.setAttribute('frameborder', '0');

			document.getElementById('player').appendChild(frame);

			$f(frame).addEvent('ready', this.onReady);
		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume / 100;
		};

		this.setStartTime = function( seconds ) {
			this.lastStartTime = null;

			// Set minimum of 1 seconds due to Awesomium issues causing
			// the Vimeo player not to load.
			this.startTime = Math.max( 1, seconds );
		};

		this.seek = function( seconds ) {
			if ( this.froogaloop !== null && seconds > 1 ) {
				this.froogaloop.api('seekTo', seconds);
			}
		};

		this.onRemove = function() {
			this.froogaloop = null;
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/
		this.think = function() {

			if ( this.froogaloop !== null ) {

				if ( this.volume != this.lastVolume ) {
					this.froogaloop.api('setVolume', this.volume);
					this.lastVolume = this.volume;
				}

				if ( this.startTime != this.lastStartTime ) {
					this.seek( this.startTime );
					this.lastStartTime = this.startTime;
				}

				this.froogaloop.api('getVolume', function(v) {
					self.volume = parseFloat(v);
				});

				this.froogaloop.api('getCurrentTime', function(v) {
					self.currentTime = parseFloat(v);
				});

			}

		};

		this.onReady = function( player_id ) {
			self.lastStartTime = null;
			self.froogaloop = $f(player_id);
			self.froogaloop.api('play');
			self.interval = setInterval( function() { self.think(self); }, 100 );
		};

	};
	registerPlayer( "vimeo", VimeoVideo );

	var TwitchVideo = function() {

		var self = this;

		this.videoInfo = {};

		/*
			Embed Player Object
		*/
		this.embed = function() {

			if ( !this.videoInfo.channel ) return;
			if ( !this.videoInfo.archive_id ) return;

			var flashvars = {
				hostname: "www.twitch.tv",
				channel: this.videoInfo.channel,
				auto_play: true,
				start_volume: (this.videoInfo.volume || theater.volume),
				initial_time: (this.videoInfo.initial_time || 0)
			};

			var id = this.videoInfo.archive_id.slice(1),
				videoType = this.videoInfo.archive_id.substr(0,1);

			flashvars.videoId = videoType + id;

			if (videoType == "c") {
				flashvars.chapter_id = id;
			} else {
				flashvars.archive_id = id;
			}

			var swfurl = "http://www.twitch.tv/swflibs/TwitchPlayer.swf";

			var params = {
				"allowFullScreen": "true",
				"allowNetworking": "all",
				"allowScriptAccess": "always",
				"movie": swfurl,
				"wmode": "opaque",
				"bgcolor": "#000000"
			};

			swfobject.embedSWF(
				swfurl,
				"player",
				"100%",
				"104%",
				"9.0.0",
				false,
				flashvars,
				params
			);

		};

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;

			var info = id.split(',');

			this.videoInfo.channel = info[0];
			this.videoInfo.archive_id = info[1];

			// Wait for player to be ready
			if ( this.player === null ) {
				this.lastVideoId = this.videoId;
				this.embed();

				var i = 0;
				var interval = setInterval( function() {
					var el = document.getElementById("player");
					if(el.mute){
						clearInterval(interval);
						self.onReady();
					}

					i++;
					if (i > 100) {
						console.log("Error waiting for player to load");
						clearInterval(interval);
					}
				}, 33);
			}
		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume;
			this.videoInfo.volume = volume;
		};

		this.setStartTime = function( seconds ) {
			this.lastStartTime = null;
			this.startTime = seconds;
			this.videoInfo.initial_time = seconds;
		};

		this.seek = function( seconds ) {
			this.setStartTime( seconds );
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/
		this.think = function() {

			if ( this.player ) {
				
				if ( this.videoId != this.lastVideoId ) {
					this.embed();
					this.lastVideoId = this.videoId;
				}

				if ( this.startTime != this.lastStartTime ) {
					this.embed();
					this.lastStartTime = this.startTime;
				}

				if ( this.volume != this.lastVolume ) {
					// this.embed(); // volume doesn't change...
					this.lastVolume = this.volume;
				}

			}

		};

		this.onReady = function() {
			this.player = document.getElementById('player');
			this.interval = setInterval( function() { self.think(self); }, 100 );
		};

		this.toggleControls = function( enabled ) {
			this.player.height = enabled ? "100%" : "104%";
		};

	};
	registerPlayer( "twitch", TwitchVideo );

	var TwitchStreamVideo = function() {

		var self = this;

		/*
			Embed Player Object
		*/
		this.embed = function() {

			var flashvars = {
				hostname: "www.twitch.tv",
				hide_chat: true,
				channel: this.videoId,
				embed: 0,
				auto_play: true,
				start_volume: 25 // out of 50
			};

			var swfurl = "http://www.twitch.tv/swflibs/TwitchPlayer.swf";

			var params = {
				"allowFullScreen": "true",
				"allowNetworking": "all",
				"allowScriptAccess": "always",
				"movie": swfurl,
				"wmode": "opaque",
				"bgcolor": "#000000"
			};

			swfobject.embedSWF(
				swfurl,
				"player",
				"100%",
				"104%",
				"9.0.0",
				false,
				flashvars,
				params
			);

		};

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;

			// Wait for player to be ready
			if ( this.player === null ) {
				this.lastVideoId = this.videoId;
				this.embed();

				var i = 0;
				var interval = setInterval( function() {
					var el = document.getElementById("player");
					if(el.mute){
						clearInterval(interval);
						self.onReady();
					}

					i++;
					if (i > 100) {
						console.log("Error waiting for player to load");
						clearInterval(interval);
					}
				}, 33);
			}
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

			if ( this.player ) {

				if ( this.videoId != this.lastVideoId ) {
					this.embed();
					this.lastVideoId = this.videoId;
				}

				 if ( this.volume != this.lastVolume ) {
					// this.embed(); // volume doesn't change...
					this.lastVolume = this.volume;
				}

			}

		};

		this.onReady = function() {
			this.player = document.getElementById('player');
			this.interval = setInterval( function() { self.think(self); }, 100 );
		};

		this.toggleControls = function( enabled ) {
			this.player.height = enabled ? "100%" : "104%";
		};

	};
	registerPlayer( "twitchstream", TwitchStreamVideo );

	var BlipVideo = function() {

		var self = this;

		this.lastState = null;
		this.state = null;

		/*
			Embed Player Object
		*/
		var flashvars = {
			autostart: true,
			noads: true,
			showinfo: false,
			onsite: true,
			nopostroll: true,
			noendcap: true,
			showsharebutton: false,
			removebrandlink: true,
			skin: "BlipClassic",
			backcolor: "0x000000",
			floatcontrols: true,
			fixedcontrols: true,
			largeplaybutton: false,
			controlsalpha: ".0",
			autohideidle: 1000,
			file: "http://blip.tv/rss/flash/123123123123", // bogus url
		};

		var params = {
			"allowFullScreen":"true",
			"allowNetworking":"all",
			"allowScriptAccess":"always",
			"wmode":"opaque",
			"bgcolor":"#000000"
		};

		swfobject.embedSWF(
			// "http://a.blip.tv/scripts/flash/stratos.swf",
			"http://blip.tv/scripts/flash/stratos.swf",
			"player",
			"100%",
			"100%",
			"9.0.0",
			false,
			flashvars,
			params
		);

		/*
			play\n") + "pause\n") + "stop\n") + "next\n") + "previous\n") + "volume\n") + "mute\n") + "seek\n") + "scrub\n") + "fullscreen\n") + "playpause\n") + "toggle_hd\n") + "auto_hide_components\n") + "auto_show_components\n") + "show_endcap"));

			ExternalInterface.addCallback("getAvailableEvents", this.getAvailableStateChanges);
			ExternalInterface.addCallback("sendEvent", this.handleJsStateChangeEvent);
			ExternalInterface.addCallback("setPlayerUpdateTime", this.setUpdateInterval);
			ExternalInterface.addCallback("getAllowedEvents", this.displayAllowedEvents);
			ExternalInterface.addCallback("addJScallback", this.addExternallySpecifiedCallback);
			ExternalInterface.addCallback("getPlaylist", this.sendOutJSONplaylist);
			ExternalInterface.addCallback("getDuration", this.getDuration);
			ExternalInterface.addCallback("getPNG", this.getPNG);
			ExternalInterface.addCallback("getJPEG", this.getJPEG);
			ExternalInterface.addCallback("getCurrentState", this.getCurrentState);
			ExternalInterface.addCallback("getHDAvailable", this.getHDAvailable);
			ExternalInterface.addCallback("getCCAvailable", this.getCCAvailable);
			ExternalInterface.addCallback("getPlayerVersion", this.getPlayerVersion);
			ExternalInterface.addCallback("getEmbedParamValue", this.sendOutEmbedParamValue);
		*/

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;

			// Wait for player to be ready
			if ( this.player === null ) {
				var i = 0;
				var interval = setInterval( function() {
					var el = document.getElementById("player");
					if(el.addJScallback){
						clearInterval(interval);
						self.onReady();
					}

					i++;
					if (i > 100) {
						console.log("Error waiting for player to load");
						clearInterval(interval);
					}
				}, 33);
			} else {
				this.player.sendEvent( 'pause' );
			}

		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume / 100;
		};

		this.setStartTime = function( seconds ) {
			this.lastStartTime = null;
			this.startTime = seconds;
		};

		this.seek = function( seconds ) {
			if ( this.player !== null ) {
				this.player.sendEvent( 'seek', seconds );
			}
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/

		this.think = function() {

			if ( (this.player !== null) ) {

				if ( this.videoId != this.lastVideoId ) {
					this.player.sendEvent( 'newFeed', "http://blip.tv/rss/flash/" + this.videoId );
					this.lastVideoId = this.videoId;
					this.lastVolume = null;
					this.lastStartTime = null;
				}

				if ( this.player.getCurrentState() == "playing" ) {

					if ( this.startTime != this.lastStartTime ) {
						this.seek( this.startTime );
						this.lastStartTime = this.startTime;
					}

					if ( this.volume != this.lastVolume ) {
						this.player.sendEvent( 'volume', this.volume );
						this.lastVolume = this.volume;
					}

				}
			}

		};

		this.onReady = function() {
			this.player = document.getElementById('player');
			this.interval = setInterval( function() { self.think(self); }, 100 );
		};

	};
	registerPlayer( "blip", BlipVideo );

	var UrlVideo = function() {

		var self = this;

		/*
			Embed Player Object
		*/
		this.embed = function() {

			var elem = document.getElementById("player1");
			if (elem) {
				elem.parentNode.removeChild(elem);
			}

			var frame = document.createElement('iframe');
			frame.setAttribute('id', 'player1');
			frame.setAttribute('src', this.videoId);
			frame.setAttribute('width', '100%');
			frame.setAttribute('height', '100%');
			frame.setAttribute('frameborder', '0');

			document.getElementById('player').appendChild(frame);

		};

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;

			// Wait for player to be ready
			if ( this.player === null ) {
				this.lastVideoId = this.videoId;
				this.embed();

				var i = 0;
				var interval = setInterval( function() {
					var el = document.getElementById("player");
					if(el){
						clearInterval(interval);
						self.onReady();
					}

					i++;
					if (i > 100) {
						console.log("Error waiting for player to load");
						clearInterval(interval);
					}
				}, 33);
			}
		};

		this.onRemove = function() {
			clearInterval( this.interval );
		};

		/*
			Player Specific Methods
		*/
		this.think = function() {

			if ( this.player ) {
				
				if ( this.videoId != this.lastVideoId ) {
					this.embed();
					this.lastVideoId = this.videoId;
				}

			}

		};

		this.onReady = function() {
			this.player = document.getElementById('player');
			this.interval = setInterval( function() { self.think(self); }, 100 );
		};

	};
	registerPlayer( "url", UrlVideo );

	// Thanks to WinterPhoenix96 for helping with Livestream support
	var LivestreamVideo = function() {

		var flashvars = {};

		var swfurl = "http://cdn.livestream.com/chromelessPlayer/wrappers/JSPlayer.swf";
		// var swfurl = "http://cdn.livestream.com/chromelessPlayer/v20/playerapi.swf";

		var params = {
			// "allowFullScreen": "true",
			"allowNetworking": "all",
			"allowScriptAccess": "always",
			"movie": swfurl,
			"wmode": "opaque",
			"bgcolor": "#000000"
		};

		swfobject.embedSWF(
			swfurl,
			"player",
			"100%",
			"100%",
			"9.0.0",
			"expressInstall.swf",
			flashvars,
			params
		);

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;
		};

		this.setVolume = function( volume ) {
			this.lastVolume = null;
			this.volume = volume / 100;
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
					this.player.load( this.videoId );
					this.player.startPlayback();
					this.lastVideoId = this.videoId;
				}
				
				if ( this.volume != this.lastVolume ) {
					this.player.setVolume( this.volume );
					this.lastVolume = this.volume;
				}
				
			}

		};
		
		this.onReady = function() {
			this.player = document.getElementById('player');

			var self = this;
			this.interval = setInterval( function() { self.think(self); }, 100 );
			this.player.setVolume( this.volume );
		};
		
	};
	registerPlayer( "livestream", LivestreamVideo );


	var HtmlVideo = function() {

		/*
			Embed Player Object
		*/
		this.embed = function() {

			var elem = document.getElementById("player1");
			if (elem) {
				elem.parentNode.removeChild(elem);
			}

			var content = document.createElement('div');
			content.setAttribute('id', 'player1');
			content.style.width = "100%";
			content.style.height = "100%";
			content.innerHTML = this.videoId;

			document.getElementById('player').appendChild(content);

		};

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastVideoId = null;
			this.videoId = id;
			this.embed();
		};

	};
	registerPlayer( "html", HtmlVideo );


	var VioozVideo = function() {
		// Reference:
		// https://github.com/kcivey/jquery.jwplayer/blob/master/jquery.jwplayer.js

		var flashstream = document.getElementById("flashstream"),
			embed = (flashstream && flashstream.children[4]);
		
		// Make the Player's Div Parent Element accessible
		var flashstream_container = document.getElementById(flashstream.parentNode.id);
		flashstream_container.style.display="initial";
		
		if (embed) {
			// Hide the Banner Ad that overlays the player
			document.getElementById("rhw_footer").style.display="none";
			
			// Force player fullscreen
			document.body.style.setProperty('overflow', 'hidden');
			embed.style.setProperty('z-index', '99999');
			embed.style.setProperty('position', 'fixed');
			embed.style.setProperty('top', '0');
			embed.style.setProperty('left', '0');
			embed.width = "100%";
			embed.height = "105%";

			this.player = embed;
		}

		/*
			Standard Player Methods
		*/
		this.setVideo = function( id ) {
			this.lastStartTime = null;
		};

		this.setVolume = function( volume ) {
			this.lastVolume = volume;
			if ( this.player !== null ) {
				this.player.jwSetVolume(volume);
			}
		};

		this.setStartTime = function( seconds ) {
			this.seek(seconds);
		};

		this.seek = function( seconds ) {
			if ( this.player !== null ) {
				this.player.jwSetVolume( this.lastVolume );

				var state = this.player.jwGetState();

				if ((state !== "BUFFERING") ||
					(this.getBufferedTime() > seconds)) {
					this.player.jwSeek( seconds );
				}

				// Video isn't playing
				if ( state === "IDLE" ) {
					this.player.jwPlay();
				}
			}
		};

		/*
			Player Specific Methods
		*/
		this.getCurrentTime = function() {
			if ( this.player !== null ) {
				return this.player.jwGetPosition();
			}
		};

		this.getBufferedTime = function() {
			return this.player.jwGetDuration() *
				this.player.jwGetBuffer();
		};

		this.toggleControls = function( enabled ) {
			this.player.height = enabled ? "100%" : "105%";
		};

	};
	registerPlayer( "viooz", VioozVideo );

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

function livestreamPlayerCallback( event, data ) {
	if (event == "ready") {
		var player = theater.getPlayer();
		if ( player && (player.getType() == "livestream") ) {
			player.onReady();
		}
	}
}

if (window.onTheaterReady) {
	onTheaterReady();
}

console.log("Loaded theater.js v" + theater.VERSION);

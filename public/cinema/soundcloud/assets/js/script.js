// establish vars
var canvas, ctx, source, context, analyser, fbc_array, rads,
    center_x, center_y, radius, radius_old, deltarad, shockwave,
    bars, bar_x, bar_y, bar_x_term, bar_y_term, bar_width,
    bar_height, react_x, react_y, intensity, rot, inputURL,
    JSONResponse, soundCloudTrackName, audio, pause,
    artist, title, img_url, isSeeking;

var fallback_cover = "./assets/img/placeholder.png";

// give vars an initial real value to validate
bars = 200;
react_x = 0;
react_y = 0;
radius = 0;
deltarad = 0;
shockwave = 0;
rot = 0;
intensity = 0;
pause = 1;
isSeeking = 0;

function initPage() {
    canvas = document.getElementById("visualizer_render");
    ctx = canvas.getContext("2d");

    //resize_canvas();

    document.getElementById("artwork").style.opacity = 0;
    document.getElementById("artwork").onerror = function(){
        this.src = fallback_cover;
    };

    audio = new Audio();
    audio.crossOrigin = "anonymous";
    audio.controls = true;
    audio.loop = false;
    audio.autoplay = false;

    window.cinema_controller = audio;

    context = new AudioContext();
    analyser = context.createAnalyser();
    // route audio playback
    source = context.createMediaElementSource(audio);
    source.connect(analyser);
    analyser.connect(context.destination);

    fbc_array = new Uint8Array(analyser.frequencyBinCount);

    frameLooper();
}

function resize_canvas() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
}

function loadSoundCloudAPI(url, client_id) {
    this.sound = {};
    SC.initialize({
        client_id: client_id
    });
    SC.get('/resolve', {
        url: url
    }, function (sound) {
        if (sound.errors) { } else {
            if (sound.kind == "track") {
                inputURL = sound.stream_url + '?client_id=' + client_id;
                title = sound.title;
                img_url = sound.artwork_url || sound.user.avatar_url || fallback_cover;
                artist = sound.user.username;

                initMp3Player();
            }
        }
    })
}

function initMp3Player() {
    context.resume()

    audio.src = inputURL;

    pause = 0;
    audio.play();

    document.getElementById("artistname").innerText = artist;
    document.getElementById("songname").innerText = title;
    document.getElementById("artwork").src = img_url;

    document.getElementById("artwork").style.opacity = 100;
    document.getElementById("artwork").style.border = "5px solid #f174eb";
    document.getElementById("artwork").style.padding = "1px";

    if (typeof(exTheater) != 'undefined') {
        exTheater.controllerReady();
    }

}

function frameLooper() {
    resize_canvas(); // for some reason i have to resize the canvas every update or else the framerate decreases over time

    var grd = ctx.createLinearGradient(0, 0, 0, canvas.height);
    grd.addColorStop(0, "rgba(180, 140, 230, 1)");
    grd.addColorStop(1, "rgba(102, 102, 255, 1)");

    ctx.fillStyle = grd;
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = "rgba(255, 255, 255, " + (intensity * 0.0000125 - 0.4) + ")";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    rot = rot + intensity * 0.0000001;

    react_x = 0;
    react_y = 0;

    intensity = 0;

    analyser.getByteFrequencyData(fbc_array);

    for (var i = 0; i < bars; i++) {
        rads = Math.PI * 2 / bars;

        bar_x = center_x;
        bar_y = center_y;

        bar_height = Math.min(99999, Math.max((fbc_array[i] * 2.5 - 200), 0));
        bar_width = bar_height * 0.02;

        bar_x_term = center_x + Math.cos(rads * i + rot) * (radius + bar_height);
        bar_y_term = center_y + Math.sin(rads * i + rot) * (radius + bar_height);

        ctx.save();

        var lineColor = "rgb(" + (fbc_array[i]).toString() + ", " + 255 + ", " + 255 + ")";

        ctx.strokeStyle = lineColor;
        ctx.lineWidth = bar_width;
        ctx.beginPath();
        ctx.moveTo(bar_x, bar_y);
        ctx.lineTo(bar_x_term, bar_y_term);
        ctx.stroke();

        react_x += Math.cos(rads * i + rot) * (radius + bar_height);
        react_y += Math.sin(rads * i + rot) * (radius + bar_height);

        intensity += bar_height;
    }

    center_x = canvas.width / 2 - (react_x * 0.007);
    center_y = canvas.height / 2 - (react_y * 0.007);

    radius_old = radius;
    radius = 25 + (intensity * 0.002);
    deltarad = radius - radius_old;

    ctx.fillStyle = "rgb(255, 255, 255)";
    ctx.beginPath();
    ctx.arc(center_x, center_y, radius + 2, 0, Math.PI * 2, false);
    ctx.fill();

    // shockwave effect
    shockwave += 60;

    ctx.lineWidth = 15;
    ctx.strokeStyle = "rgb(255, 255, 255)";
    ctx.beginPath();
    ctx.arc(center_x, center_y, shockwave + radius, 0, Math.PI * 2, false);
    ctx.stroke();


    if (deltarad > 15) {
        shockwave = 0;

        ctx.fillStyle = "rgba(255, 255, 255, 0.7)";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        rot = rot + 0.4;
    }

    window.requestAnimationFrame(frameLooper);
}